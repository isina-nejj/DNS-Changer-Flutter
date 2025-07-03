import 'package:flutter/material.dart';
import 'dart:async';
import '../models/dns_status.dart';
import '../models/google_connectivity_result.dart';
import '../services/dns_service.dart';
import '../services/vpn_status_service.dart';
import '../services/auto_ping_service.dart';
import '../widgets/dns_input_widget.dart';
import '../widgets/ping_box.dart';
import '../widgets/google_connectivity_widget.dart';
import '../widgets/data_usage_widget.dart';
import '../constants/dns_constants.dart';

/// صفحه اصلی برنامه DNS Changer
class DnsChangerHomePage extends StatefulWidget {
  final String title;

  const DnsChangerHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<DnsChangerHomePage> createState() => _DnsChangerHomePageState();
}

class _DnsChangerHomePageState extends State<DnsChangerHomePage>
    with WidgetsBindingObserver {
  // Controllers
  late final TextEditingController _dns1Controller;
  late final TextEditingController _dns2Controller;

  // State variables
  bool _vpnActive = false;
  int _downloadBytes = 0;
  int _uploadBytes = 0;
  bool _autoPingEnabled = false;
  bool _isTestingConnectivity = false;
  bool _isPinging = false;

  // DNS Status
  DnsStatus? _dns1Status;
  DnsStatus? _dns2Status;
  GoogleConnectivityResult? _googleTestResult;

  // Stream subscriptions
  StreamSubscription<bool>? _vpnStatusSubscription;
  StreamSubscription<Map<String, int>>? _dataUsageSubscription;
  StreamSubscription<Map<String, DnsStatus>>? _pingResultSubscription;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeObserver();
    _initializeServices();
    _checkInitialStatus();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeObserver();
    _disposeServices();
    super.dispose();
  }

  void _initializeControllers() {
    _dns1Controller = TextEditingController(
      text: DnsConstants.defaultPrimaryDns,
    );
    _dns2Controller = TextEditingController(
      text: DnsConstants.defaultSecondaryDns,
    );
  }

  void _initializeObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeServices() {
    // شروع listening به وضعیت VPN
    VpnStatusService.startListening();

    // اشتراک در stream ها
    _vpnStatusSubscription = VpnStatusService.vpnStatusStream.listen((
      isActive,
    ) {
      if (mounted) {
        setState(() {
          _vpnActive = isActive;
        });
      }
    });

    _dataUsageSubscription = VpnStatusService.dataUsageStream.listen((usage) {
      if (mounted) {
        setState(() {
          _downloadBytes = usage['download'] ?? 0;
          _uploadBytes = usage['upload'] ?? 0;
        });
      }
    });

    _pingResultSubscription = AutoPingService.pingResultStream.listen((
      results,
    ) {
      if (mounted) {
        setState(() {
          _dns1Status = results[_dns1Controller.text.trim()];
          _dns2Status = results[_dns2Controller.text.trim()];
          _isPinging = false;
        });
      }
    });
  }

  void _disposeControllers() {
    _dns1Controller.dispose();
    _dns2Controller.dispose();
  }

  void _disposeObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _disposeServices() {
    _vpnStatusSubscription?.cancel();
    _dataUsageSubscription?.cancel();
    _pingResultSubscription?.cancel();
    VpnStatusService.stopListening();
    AutoPingService.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_autoPingEnabled) {
          _startAutoPing();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        AutoPingService.stop();
        break;
      default:
        break;
    }
  }

  Future<void> _checkInitialStatus() async {
    try {
      final status = await DnsService.getServiceStatus();
      if (mounted) {
        setState(() {
          _vpnActive = status;
        });
      }
    } catch (e) {
      debugPrint('Error checking initial status: $e');
    }
  }

  void _startAutoPing() {
    AutoPingService.start(
      dns1: _dns1Controller.text.trim(),
      dns2: _dns2Controller.text.trim(),
    );
  }

  void _toggleAutoPing() {
    setState(() {
      _autoPingEnabled = !_autoPingEnabled;
      if (_autoPingEnabled) {
        _startAutoPing();
      } else {
        AutoPingService.stop();
      }
    });
  }

  Future<void> _performManualPing() async {
    if (_isPinging) return;

    setState(() {
      _isPinging = true;
    });

    try {
      await AutoPingService.performManualPing(
        _dns1Controller.text.trim(),
        _dns2Controller.text.trim(),
      );
    } catch (e) {
      debugPrint('Error performing manual ping: $e');
      setState(() {
        _isPinging = false;
      });
    }
  }

  Future<void> _toggleVpn(bool value) async {
    if (value) {
      await _activateVpn();
    } else {
      await _deactivateVpn();
    }
  }

  Future<void> _activateVpn() async {
    final dns1 = _dns1Controller.text.trim();
    final dns2 = _dns2Controller.text.trim();

    try {
      final success = await DnsService.changeDns(dns1, dns2);
      if (success) {
        _showSuccessMessage(DnsConstants.errorMessages['vpnActivated']!);
      } else {
        _showErrorMessage(DnsConstants.errorMessages['vpnActivationError']!);
      }
    } catch (e) {
      _showErrorMessage('خطا در فعال‌سازی VPN: $e');
    }
  }

  Future<void> _deactivateVpn() async {
    try {
      final success = await DnsService.stopVpn();
      if (success) {
        _showSuccessMessage(DnsConstants.errorMessages['vpnDisabled']!);
      } else {
        _showErrorMessage(DnsConstants.errorMessages['vpnDisableError']!);
      }
    } catch (e) {
      _showErrorMessage('خطا در غیرفعال‌سازی VPN: $e');
    }
  }

  Future<void> _testGoogleConnectivity() async {
    if (_isTestingConnectivity) return;

    setState(() {
      _isTestingConnectivity = true;
    });

    try {
      final result = await DnsService.testGoogleConnectivity();
      if (mounted) {
        setState(() {
          _googleTestResult = result;
          _isTestingConnectivity = false;
        });

        _showConnectivityResult(result);
      }
    } catch (e) {
      setState(() {
        _isTestingConnectivity = false;
      });
      _showErrorMessage('خطا در تست اتصال: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showConnectivityResult(GoogleConnectivityResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.overallStatus
              ? DnsConstants.errorMessages['connectivityTestPassed']!
              : DnsConstants.errorMessages['connectivityTestFailed']!,
        ),
        backgroundColor: result.overallStatus ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بخش تنظیمات DNS
            _buildDnsSettingsSection(),

            const SizedBox(height: 24),

            // بخش کنترل پینگ
            _buildPingControlSection(),

            const SizedBox(height: 24),

            // بخش کنترل VPN
            _buildVpnControlSection(),

            const SizedBox(height: 24),

            // بخش تست اتصال Google
            if (_vpnActive) ...[
              _buildGoogleConnectivitySection(),
              const SizedBox(height: 24),
            ],

            // بخش مصرف داده
            _buildDataUsageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDnsSettingsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تنظیمات DNS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DnsInputWidget(
                    label: DnsConstants.uiTexts['dns1Label']!,
                    hint: DnsConstants.defaultPrimaryDns,
                    controller: _dns1Controller,
                    enabled: !_vpnActive,
                  ),
                ),
                const SizedBox(width: 8),
                PingBox(
                  status: _dns1Status,
                  onTap: () => _performManualPing(),
                  isLoading: _isPinging,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DnsInputWidget(
                    label: DnsConstants.uiTexts['dns2Label']!,
                    hint: DnsConstants.defaultSecondaryDns,
                    controller: _dns2Controller,
                    enabled: !_vpnActive,
                  ),
                ),
                const SizedBox(width: 8),
                PingBox(
                  status: _dns2Status,
                  onTap: () => _performManualPing(),
                  isLoading: _isPinging,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPingControlSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'کنترل پینگ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isPinging ? null : _performManualPing,
                    icon: _isPinging
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      _isPinging
                          ? 'در حال پینگ...'
                          : DnsConstants.uiTexts['pingBothButton']!,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleAutoPing,
                    icon: Icon(
                      _autoPingEnabled ? Icons.timer : Icons.timer_off,
                    ),
                    label: Text(
                      _autoPingEnabled
                          ? DnsConstants.uiTexts['autoPingOn']!
                          : DnsConstants.uiTexts['autoPingOff']!,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _autoPingEnabled
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVpnControlSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'کنترل VPN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(value: _vpnActive, onChanged: _toggleVpn),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _vpnActive
                        ? DnsConstants.uiTexts['vpnActive']!
                        : DnsConstants.uiTexts['vpnInactive']!,
                    style: TextStyle(
                      color: _vpnActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleConnectivitySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GoogleConnectivityWidget(
          result: _googleTestResult,
          onTest: _testGoogleConnectivity,
          isLoading: _isTestingConnectivity,
        ),
      ),
    );
  }

  Widget _buildDataUsageSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مصرف داده',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DataUsageWidget(
              downloadBytes: _downloadBytes,
              uploadBytes: _uploadBytes,
              showDetails: true,
            ),
          ],
        ),
      ),
    );
  }
}
