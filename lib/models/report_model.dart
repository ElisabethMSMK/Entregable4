enum ReportSeverity { info, low, medium, high, critical }

enum ReportStatus { open, closed, inProgress }

class ReportModel {
  final int? id;
  final String title;
  final String description;
  final ReportSeverity severity; // Usamos el enum para severity
  final ReportStatus status; // Usamos el enum para status
  final String date;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.date,
  });

  // Convierte el ReportModel en un Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity':
          severity.toString().split('.').last, // Convierte el enum a String
      'status': status.toString().split('.').last, // Convierte el enum a String
      'date': date,
    };
  }

  // Convierte el Map de SQLite en un ReportModel
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      severity: ReportSeverity.values.firstWhere(
        (e) => e.toString().split('.').last == map['severity'],
        orElse: () => ReportSeverity.info,
      ),
      status: ReportStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => ReportStatus.open,
      ),
      date: map['date'],
    );
  }
}
