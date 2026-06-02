enum Severity { critical, high, medium, low }

class VulnerabilityModel {
  final String name;
  final String detail;
  final String fix;
  final Severity severity;
  final String category;

  const VulnerabilityModel({
    required this.name,
    required this.detail,
    required this.fix,
    required this.severity,
    required this.category,
  });
}

class ScanResult {
  final String fileName;
  final String fileSize;
  final DateTime scanDate;
  final double riskScore;
  final List<VulnerabilityModel> vulnerabilities;

  const ScanResult({
    required this.fileName,
    required this.fileSize,
    required this.scanDate,
    required this.riskScore,
    required this.vulnerabilities,
  });

  int get criticalCount =>
      vulnerabilities.where((v) => v.severity == Severity.critical).length;
  int get highCount =>
      vulnerabilities.where((v) => v.severity == Severity.high).length;
  int get mediumCount =>
      vulnerabilities.where((v) => v.severity == Severity.medium).length;
  int get lowCount =>
      vulnerabilities.where((v) => v.severity == Severity.low).length;
}

class RecentScan {
  final String fileName;
  final String timeAgo;
  final Severity worstSeverity;

  const RecentScan({
    required this.fileName,
    required this.timeAgo,
    required this.worstSeverity,
  });
}
