import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNS Changer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'DNS Changer Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DnsStatus {
  final int ping;
  final bool isReachable;

  static const Color unreachableColor = Color(0xFF800000); // قرمز تیره
  static const Color bestPingColor = Color(0xFF4CAF50); // سبز
  static const Color mediumPingColor = Color(0xFFFFC107); // زرد
  static const Color badPingColor = Color(0xFFF44336); // قرمز

  DnsStatus(this.ping, this.isReachable);

  Color get backgroundColor {
    if (!isReachable) return unreachableColor;

    if (ping < 0) return Colors.grey;

    // اگر پینگ کمتر از 100ms باشد، از سبز به زرد
    if (ping <= 100) {
      return Color.lerp(bestPingColor, mediumPingColor, ping / 100) ??
          bestPingColor;
    }
    // اگر پینگ بین 100ms تا 300ms باشد، از زرد به قرمز
    else if (ping <= 300) {
      return Color.lerp(mediumPingColor, badPingColor, (ping - 100) / 200) ??
          mediumPingColor;
    }
    // اگر پینگ بیشتر از 300ms باشد، قرمز
    else {
      return badPingColor;
    }
  }

  String get displayText {
    if (!isReachable) return 'ناموجود';
    if (ping < 0) return '--';
    return '$ping ms';
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool vpnActive = false;
  bool serviceRunning = false;
  int downloadBytes = 0;
  int uploadBytes = 0;
  Timer? _pingTimer;
  bool _autoPingEnabled = false; // وضعیت پینگ اتوماتیک - پیشفرض خاموش

  DnsStatus? dns1Status;
  DnsStatus? dns2Status;
  Map<String, dynamic>? _googleTestResult;

  static const platform = MethodChannel('com.example.dnschanger/dns');
  static const EventChannel vpnStatusChannel = EventChannel(
    'com.example.dnschanger/vpnStatus',
  );
  static const EventChannel dataUsageChannel = EventChannel(
    'com.example.dnschanger/dataUsage',
  );

  final TextEditingController dns1Controller = TextEditingController(
    text: '178.22.122.100', // Shecan DNS
  );
  final TextEditingController dns2Controller = TextEditingController(
    text: '1.1.1.1', // Cloudflare DNS
  );

  Future<DnsStatus> _getPingStatus(String dns) async {
    try {
      debugPrint('Getting ping status for DNS: $dns');
      final result = await platform.invokeMethod('testDns', {'dns': dns});
      debugPrint('Raw ping result: $result');

      if (result is Map) {
        final ping = (result['ping'] as int?) ?? -1;
        final isReachable = (result['isReachable'] as bool?) ?? false;
        debugPrint(
          'Parsed ping result - ping: $ping, isReachable: $isReachable',
        );
        return DnsStatus(ping, isReachable);
      }

      debugPrint('Invalid result format: $result');
      return DnsStatus(-1, false);
    } catch (e) {
      debugPrint('Error getting ping status: $e');
      return DnsStatus(-1, false);
    }
  }

  void _startPingTimer() {
    if (!_autoPingEnabled) return;
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _updatePingStatus(),
    );
    // Get initial status
    _updatePingStatus();
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _toggleAutoPing() {
    setState(() {
      _autoPingEnabled = !_autoPingEnabled;
      if (_autoPingEnabled) {
        _startPingTimer();
      } else {
        _stopPingTimer();
      }
    });
  }

  Future<void> _updatePingStatus() async {
    if (!mounted) return;

    final dns1 = dns1Controller.text.trim();
    final dns2 = dns2Controller.text.trim();

    await Future.wait([
      if (isValidDns(dns1)) _pingSingleDns(dns1, true),
      if (isValidDns(dns2)) _pingSingleDns(dns2, false),
    ]);
  }

  Future<void> _pingNow() async {
    await _updatePingStatus();
  }

  Future<void> _pingSingleDns(String dns, bool isFirstDns) async {
    if (isValidDns(dns)) {
      final status = await _getPingStatus(dns);
      if (mounted) {
        setState(() {
          if (isFirstDns) {
            dns1Status = status;
          } else {
            dns2Status = status;
          }
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App resumed, checking auto-ping status');
        if (_autoPingEnabled) {
          debugPrint('Auto-ping is enabled, starting timer');
          _startPingTimer();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        debugPrint('App inactive/paused/detached, stopping timer');
        _stopPingTimer();
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing app state');
    WidgetsBinding.instance.addObserver(this);
    _listenVpnStatus();
    _listenDataUsage();
    _checkInitialVpnStatus();
    if (_autoPingEnabled) {
      _startPingTimer();
    }
  }

  void _listenVpnStatus() {
    debugPrint('Listening to VPN status');
    vpnStatusChannel.receiveBroadcastStream().listen(
      (status) {
        debugPrint('Received VPN status: $status');
        setState(() {
          vpnActive = status == "VPN_STARTED";
          serviceRunning = status == "VPN_STARTED";
        });
      },
      onError: (e) {
        debugPrint('Error listening to VPN status: $e');
      },
    );
  }

  void _listenDataUsage() {
    debugPrint('Listening to data usage');
    dataUsageChannel.receiveBroadcastStream().listen(
      (data) {
        if (data is Map) {
          debugPrint('Received data usage update: $data');
          setState(() {
            downloadBytes = (data['download'] ?? 0) as int;
            uploadBytes = (data['upload'] ?? 0) as int;
          });
        }
      },
      onError: (e) {
        debugPrint('Error listening to data usage: $e');
      },
    );
  }

  Future<void> _checkInitialVpnStatus() async {
    try {
      debugPrint('Checking initial VPN status');
      final status = await platform.invokeMethod('getServiceStatus');
      debugPrint('Initial VPN status: $status');
      setState(() {
        vpnActive = status == true;
        serviceRunning = status == true;
      });
    } catch (e) {
      debugPrint('Error checking initial VPN status: $e');
    }
  }

  Future<void> stopDnsVpn() async {
    debugPrint('stopDnsVpn called');
    debugPrint(
      'Current state before stopping: vpnActive=$vpnActive, serviceRunning=$serviceRunning',
    );
    if (!vpnActive && !serviceRunning) {
      debugPrint('stopDnsVpn: VPN is already stopped, skipping.');
      return;
    }
    try {
      debugPrint('stopDnsVpn: Invoking platform method stopDnsVpn');
      final result = await platform.invokeMethod('stopDnsVpn');
      debugPrint('stopDnsVpn: platform.invokeMethod returned: $result');
      // Check VPN status after stopping
      final status = await platform.invokeMethod('getServiceStatus');
      debugPrint('stopDnsVpn: getServiceStatus after stopDnsVpn: $status');
      setState(() {
        vpnActive = status == true ? true : false;
        serviceRunning = status == true ? true : false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('VPN غیرفعال شد.')));
    } on PlatformException catch (e) {
      debugPrint('stopDnsVpn: PlatformException: ${e.message}');
      try {
        final status = await platform.invokeMethod('getServiceStatus');
        debugPrint('stopDnsVpn: getServiceStatus after exception: $status');
        setState(() {
          vpnActive = status == true ? true : false;
          serviceRunning = status == true ? true : false;
        });
      } catch (ex) {
        debugPrint(
          'stopDnsVpn: Exception when checking status after error: $ex',
        );
        setState(() {
          vpnActive = false;
          serviceRunning = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در غیرفعال‌سازی VPN: ${e.message}')),
      );
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing resources');
    _stopPingTimer();
    WidgetsBinding.instance.removeObserver(this);
    dns1Controller.dispose();
    dns2Controller.dispose();
    super.dispose();
  }

  bool isValidDns(String value) {
    final regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    return regex.hasMatch(value);
  }

  Future<bool> testDns(String dns) async {
    try {
      debugPrint('Testing DNS: $dns');
      final status = await _getPingStatus(dns);
      debugPrint(
        'DNS test result: isReachable=${status.isReachable}, ping=${status.ping}ms',
      );
      return status.isReachable;
    } on PlatformException catch (e) {
      debugPrint('Error testing DNS: ${e.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطا در تست DNS: ${e.message}')));
      return false;
    }
  }

  Future<bool> changeDns(String dns1, String dns2) async {
    try {
      // First test both DNS servers
      final dns1Status = await _getPingStatus(dns1);
      if (!dns1Status.isReachable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'DNS اول در دسترس نیست (پینگ: ${dns1Status.displayText})',
            ),
          ),
        );
        return false;
      }

      final dns2Status = await _getPingStatus(dns2);
      if (!dns2Status.isReachable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'DNS دوم در دسترس نیست (پینگ: ${dns2Status.displayText})',
            ),
          ),
        );
        return false;
      }

      // If both DNS servers are reachable, proceed with changing DNS
      await platform.invokeMethod('setDns', {'dns1': dns1, 'dns2': dns2});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('DNS با موفقیت تغییر کرد')));
      return true;
    } on PlatformException catch (e) {
      debugPrint('Error changing DNS: ${e.message}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطا در تغییر DNS: ${e.message}')));
      return false;
    }
  }

  Future<void> _testGoogleConnectivity() async {
    try {
      debugPrint('Testing Google connectivity...');
      final result = await platform.invokeMethod('testGoogleConnectivity');
      debugPrint('Google connectivity test result: $result');

      if (result is Map) {
        setState(() {
          _googleTestResult = Map<String, dynamic>.from(result);
        });

        final overallStatus = _googleTestResult!['overallStatus'] == true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              overallStatus
                  ? 'Google connectivity test passed! ✅'
                  : 'Google connectivity test failed! ❌',
            ),
            backgroundColor: overallStatus ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error testing Google connectivity: $e');
      setState(() {
        _googleTestResult = {
          'overallStatus': false,
          'message': 'Error testing connectivity: $e',
          'googlePing': false,
          'dnsResolution': false,
          'httpsConnectivity': false,
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error testing Google connectivity: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building UI');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dns1Controller,
                      decoration: const InputDecoration(
                        labelText: 'DNS 1',
                        hintText: '178.22.122.100',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onTap: () {
                        dns1Controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: dns1Controller.text.length,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPingBox(
                    dns1Status,
                    () => _pingSingleDns(dns1Controller.text.trim(), true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dns2Controller,
                      decoration: const InputDecoration(
                        labelText: 'DNS 2',
                        hintText: '1.1.1.1',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onTap: () {
                        dns2Controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: dns2Controller.text.length,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPingBox(
                    dns2Status,
                    () => _pingSingleDns(dns2Controller.text.trim(), false),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pingNow,
                    icon: const Icon(Icons.refresh),
                    label: const Text('پینگ هر دو'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _toggleAutoPing,
                    icon: Icon(
                      _autoPingEnabled ? Icons.timer : Icons.timer_off,
                    ),
                    label: Text(
                      _autoPingEnabled
                          ? 'پینگ خودکار: روشن'
                          : 'پینگ خودکار: خاموش',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _autoPingEnabled
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: vpnActive,
                    onChanged: (value) async {
                      debugPrint('Switch changed: $value');
                      if (value) {
                        // روشن کردن VPN
                        final dns1 = dns1Controller.text.trim();
                        final dns2 = dns2Controller.text.trim();
                        if (!isValidDns(dns1)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'لطفاً DNS اول را به‌درستی وارد کنید.',
                              ),
                            ),
                          );
                          return;
                        }
                        if (dns2.isNotEmpty && !isValidDns(dns2)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('فرمت DNS دوم صحیح نیست.'),
                            ),
                          );
                          return;
                        }
                        debugPrint('Calling changeDns with $dns1, $dns2');
                        final success = await changeDns(dns1, dns2);
                        debugPrint('changeDns result: $success');
                        if (success) {
                          setState(() {
                            vpnActive = true;
                            serviceRunning = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'DNS با موفقیت تغییر یافت و VPN فعال شد.',
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            vpnActive = false;
                            serviceRunning = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تغییر DNS با خطا مواجه شد یا توسط سیستم پشتیبانی نمی‌شود.',
                              ),
                            ),
                          );
                        }
                      } else {
                        // خاموش کردن VPN
                        debugPrint('Switch turned off, calling stopDnsVpn');
                        await stopDnsVpn();
                        debugPrint(
                          'Switch: stopDnsVpn completed, checking status...',
                        );
                        try {
                          final status = await platform.invokeMethod(
                            'getServiceStatus',
                          );
                          debugPrint(
                            'Switch: getServiceStatus after stopDnsVpn: $status',
                          );
                          setState(() {
                            vpnActive = status == true ? true : false;
                            serviceRunning = status == true ? true : false;
                          });
                        } catch (e) {
                          debugPrint(
                            'Switch: Exception when checking status after stopDnsVpn: $e',
                          );
                          setState(() {
                            vpnActive = false;
                            serviceRunning = false;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    vpnActive ? 'VPN روشن است' : 'VPN خاموش است',
                    style: TextStyle(
                      color: vpnActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Google Connectivity Test Section
              if (vpnActive) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'تست اتصال Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _testGoogleConnectivity,
                        icon: const Icon(Icons.search),
                        label: const Text('تست Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      if (_googleTestResult != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _googleTestResult!['overallStatus'] == true
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _googleTestResult!['message'] ?? '',
                                style: TextStyle(
                                  color:
                                      _googleTestResult!['overallStatus'] ==
                                          true
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Google Ping: ${_googleTestResult!['googlePing'] == true ? "✅" : "❌"}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'DNS Resolution: ${_googleTestResult!['dnsResolution'] == true ? "✅" : "❌"}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'HTTPS Connectivity: ${_googleTestResult!['httpsConnectivity'] == true ? "✅" : "❌"}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward, color: Colors.blue),
                  Text(' ${_formatBytes(downloadBytes)}  '),
                  Icon(Icons.arrow_upward, color: Colors.orange),
                  Text(' ${_formatBytes(uploadBytes)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Widget _buildPingBox(DnsStatus? status, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: status?.backgroundColor ?? Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            status?.displayText ?? '--',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: status?.isReachable == true ? 14 : 12,
            ),
          ),
        ),
      ),
    );
  }
}
