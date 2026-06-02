import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models.dart';

class ResultsScreen extends StatelessWidget {
  final ScanResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج الفحص'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileInfo(),
            const SizedBox(height: 16),
            _buildRiskCard(),
            const SizedBox(height: 16),
            _buildStatsSummary(),
            const SizedBox(height: 24),
            _buildVulnHeader(),
            const SizedBox(height: 12),
            ...result.vulnerabilities.map((v) => _buildVulnCard(v)),
            const SizedBox(height: 20),
            _buildExportButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.android_rounded,
              color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.fileName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${result.fileSize} • ${_formatDate(result.scanDate)}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskCard() {
    final isHigh = result.riskScore >= 7;
    final color = isHigh ? AppColors.danger : AppColors.warning;
    final bgColor = isHigh ? AppColors.dangerBg : AppColors.warningBg;
    final label = isHigh ? 'مستوى الخطر: عالي' : 'مستوى الخطر: متوسط';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  result.riskScore.toStringAsFixed(1),
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                Text(
                  '/10',
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تم اكتشاف ${result.vulnerabilities.length} ثغرة • ${result.criticalCount} حرجة',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Row(
      children: [
        _buildStatBox('حرجة', result.criticalCount, AppColors.danger,
            AppColors.dangerBg),
        const SizedBox(width: 10),
        _buildStatBox(
            'متوسطة', result.mediumCount, AppColors.warning, AppColors.warningBg),
        const SizedBox(width: 10),
        _buildStatBox(
            'منخفضة', result.lowCount, AppColors.success, AppColors.successBg),
      ],
    );
  }

  Widget _buildStatBox(String label, int count, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVulnHeader() {
    return const Text(
      'الثغرات المكتشفة',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildVulnCard(VulnerabilityModel vuln) {
    final color = _severityColor(vuln.severity);
    final icon = _categoryIcon(vuln.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  vuln.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildSeverityBadge(vuln.severity),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.codeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vuln.detail,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  vuln.fix,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(Severity severity) {
    Color bg, text;
    String label;

    switch (severity) {
      case Severity.critical:
        bg = AppColors.dangerBg;
        text = AppColors.danger;
        label = 'حرج';
        break;
      case Severity.high:
        bg = AppColors.dangerBg;
        text = AppColors.danger;
        label = 'عالي';
        break;
      case Severity.medium:
        bg = AppColors.warningBg;
        text = AppColors.warning;
        label = 'متوسط';
        break;
      case Severity.low:
        bg = AppColors.successBg;
        text = AppColors.success;
        label = 'منخفض';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.picture_as_pdf_outlined,
            color: AppColors.primary, size: 18),
        label: const Text(
          'تصدير PDF Report',
          style: TextStyle(color: AppColors.primary, fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Color _severityColor(Severity s) {
    switch (s) {
      case Severity.critical:
      case Severity.high:
        return AppColors.danger;
      case Severity.medium:
        return AppColors.warning;
      case Severity.low:
        return AppColors.success;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Secrets':
        return Icons.key_outlined;
      case 'Network':
        return Icons.lock_open_outlined;
      case 'Crypto':
        return Icons.warning_amber_outlined;
      default:
        return Icons.bug_report_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
