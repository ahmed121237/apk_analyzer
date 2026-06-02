import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import 'scanning_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _recentScans = [
    RecentScan(
      fileName: 'banking_app.apk',
      timeAgo: 'منذ ساعتين',
      worstSeverity: Severity.critical,
    ),
    RecentScan(
      fileName: 'shopping_v2.apk',
      timeAgo: 'أمس',
      worstSeverity: Severity.medium,
    ),
    RecentScan(
      fileName: 'notes_app.apk',
      timeAgo: 'منذ 3 أيام',
      worstSeverity: Severity.low,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APK Analyzer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildUploadCard(context),
            const SizedBox(height: 28),
            _buildRecentScans(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختبر أمان\nتطبيقك الآن',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'اكتشف الثغرات الأمنية في أي APK',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _onUploadTap(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.upload_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ارفع ملف APK',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'اضغط لاختيار الملف • حد أقصى 100MB',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _onUploadTap(context),
                icon: const Icon(Icons.shield_outlined, size: 18),
                label: const Text(
                  'ابدأ الفحص',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScans(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'آخر الفحوصات',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._recentScans.map((scan) => _buildRecentItem(scan, context)),
      ],
    );
  }

  Widget _buildRecentItem(RecentScan scan, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.android_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.fileName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scan.timeAgo,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _buildSeverityBadge(scan.worstSeverity),
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

  void _onUploadTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ScanningScreen(fileName: 'banking_app.apk'),
      ),
    );
  }
}
