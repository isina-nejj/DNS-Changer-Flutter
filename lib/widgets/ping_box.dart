import 'package:flutter/material.dart';
import '../models/dns_status.dart';

/// ویجت نمایش وضعیت پینگ
class PingBox extends StatelessWidget {
  final DnsStatus? status;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isLoading;

  const PingBox({
    Key? key,
    this.status,
    this.onTap,
    this.width = 80,
    this.height = 40,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
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
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                )
              : Text(
                  _getDisplayText(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: _getFontSize(),
                  ),
                ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isLoading) return Colors.grey.shade400;
    return status?.backgroundColor ?? Colors.grey.shade300;
  }

  String _getDisplayText() {
    if (isLoading) return '...';
    return status?.displayText ?? '--';
  }

  double _getFontSize() {
    if (status?.isReachable == true) return 14;
    return 12;
  }
}

/// ویجت نمایش وضعیت پینگ با label
class LabeledPingBox extends StatelessWidget {
  final String label;
  final DnsStatus? status;
  final VoidCallback? onTap;
  final bool isLoading;

  const LabeledPingBox({
    Key? key,
    required this.label,
    this.status,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        PingBox(status: status, onTap: onTap, isLoading: isLoading),
      ],
    );
  }
}

/// ویجت نمایش آمار پینگ
class PingStatsWidget extends StatelessWidget {
  final List<DnsStatus> pingHistory;
  final String dnsAddress;

  const PingStatsWidget({
    Key? key,
    required this.pingHistory,
    required this.dnsAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pingHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final reachablePings = pingHistory.where((p) => p.isReachable).toList();
    final averagePing = reachablePings.isNotEmpty
        ? reachablePings.map((p) => p.ping).reduce((a, b) => a + b) /
              reachablePings.length
        : 0.0;

    final minPing = reachablePings.isNotEmpty
        ? reachablePings.map((p) => p.ping).reduce((a, b) => a < b ? a : b)
        : 0;

    final maxPing = reachablePings.isNotEmpty
        ? reachablePings.map((p) => p.ping).reduce((a, b) => a > b ? a : b)
        : 0;

    final successRate = pingHistory.isNotEmpty
        ? (reachablePings.length / pingHistory.length) * 100
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آمار پینگ: $dnsAddress',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('میانگین', '${averagePing.toStringAsFixed(1)} ms'),
              _buildStatItem('حداقل', '$minPing ms'),
              _buildStatItem('حداکثر', '$maxPing ms'),
              _buildStatItem('موفقیت', '${successRate.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
