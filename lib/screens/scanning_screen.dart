import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';
import '../models.dart';

class ScanStep {
  final String label;
  StepStatus status;

  ScanStep({required this.label, this.status = StepStatus.waiting});
}

enum StepStatus { waiting, active, done }

class ScanningScreen extends StatefulWidget {
  final String fileName;

  const ScanningScreen({super.key, required this.fileName});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _progressController;
  late Animation<double> _progressAnim;

  int _currentStep = 0;

  final List<ScanStep> _steps = [
    ScanStep(label: 'فك ضغط الـ APK'),
    ScanStep(label: 'تحليل AndroidManifest'),
    ScanStep(label: 'البحث عن Hardcoded Secrets'),
    ScanStep(label: 'فحص الـ Permissions'),
    ScanStep(label: 'البحث عن Endpoints'),
    ScanStep(label: 'تحليل الـ Crypto'),
  ];

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() {
        if (i > 0) _steps[i - 1].status = StepStatus.done;
        _steps[i].status = StepStatus.active;
        _currentStep = i;
        _updateProgress((i + 1) / _steps.length);
      });
      await Future.delayed(const Duration(milliseconds: 900));
    }

    if (!mounted) return;
    setState(() {
      _steps.last.status = StepStatus.done;
      _updateProgress(1.0);
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultsScreen(
          result: _mockResult(),
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _updateProgress(double value) {
    _progressAnim = Tween<double>(
      begin: _progressAnim.value,
      end: value,
    ).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressController.forward(from: 0);
  }

  ScanResult _mockResult() {
    return ScanResult(
      fileName: widget.fileName,
      fileSize: '14.2 MB',
      scanDate: DateTime.now(),
      riskScore: 7.8,
      vulnerabilities: const [
        VulnerabilityModel(
          name: 'Hardcoded API Key',
          detail: 'api_key = "AIzaSyD3xK8mP2..."',
          fix: 'استخدم .env أو encrypted storage',
          severity: Severity.critical,
          category: 'Secrets',
        ),
        VulnerabilityModel(
          name: 'No Certificate Pinning',
          detail: 'HTTP traffic قابل للاعتراض عبر proxy',
          fix: 'أضف SSL Pinning في الكود',
          severity: Severity.critical,
          category: 'Network',
        ),
        VulnerabilityModel(
          name: 'Weak Crypto (MD5)',
          detail: 'MessageDigest.getInstance("MD5")',
          fix: 'استخدم SHA-256 أو أعلى',
          severity: Severity.medium,
          category: 'Crypto',
        ),
        VulnerabilityModel(
          name: 'HTTP Endpoint',
          detail: 'http://api.example.com/login',
          fix: 'استخدم HTTPS دايماً',
          severity: Severity.medium,
          category: 'Network',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ringController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جاري الفحص'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildRingAnimation(),
            const SizedBox(height: 28),
            _buildProgressBar(),
            const SizedBox(height: 28),
            _buildStepsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRingAnimation() {
    return Column(
      children: [
        RotationTransition(
          turns: _ringController,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
              gradient: SweepGradient(
                colors: [
                  AppColors.primary.withOpacity(0),
                  AppColors.primary,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 74,
                height: 74,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'جاري تحليل الملف...',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.fileName,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'التقدم',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            AnimatedBuilder(
              animation: _progressAnim,
              builder: (_, __) => Text(
                '${(_progressAnim.value * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedBuilder(
            animation: _progressAnim,
            builder: (_, __) => LinearProgressIndicator(
              value: _progressAnim.value,
              backgroundColor: AppColors.surface,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _steps.length,
        itemBuilder: (_, i) => _buildStepItem(_steps[i], i),
      ),
    );
  }

  Widget _buildStepItem(ScanStep step, int index) {
    Color dotBg, dotFg, textColor;
    Widget dotChild;

    switch (step.status) {
      case StepStatus.done:
        dotBg = AppColors.successBg;
        dotFg = AppColors.success;
        textColor = AppColors.success;
        dotChild = const Icon(Icons.check_rounded, size: 14);
        break;
      case StepStatus.active:
        dotBg = AppColors.primary.withOpacity(0.15);
        dotFg = AppColors.primary;
        textColor = AppColors.textPrimary;
        dotChild = SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(dotFg),
          ),
        );
        break;
      case StepStatus.waiting:
        dotBg = AppColors.surface;
        dotFg = AppColors.textMuted;
        textColor = AppColors.textMuted;
        dotChild = Text(
          '${index + 1}',
          style: TextStyle(color: dotFg, fontSize: 11),
        );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: dotBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: dotFg, size: 14),
                child: dotChild,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            step.label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: step.status == StepStatus.active
                  ? FontWeight.w500
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
