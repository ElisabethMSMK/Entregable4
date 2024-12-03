import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // Función para determinar el color de la severidad
    Color getSeverityColor(ReportSeverity severity) {
      switch (severity) {
        case ReportSeverity.info:
          return Colors.blue;
        case ReportSeverity.low:
          return Colors.green;
        case ReportSeverity.medium:
          return Colors.orange;
        case ReportSeverity.high:
          return Colors.red;
        case ReportSeverity.critical:
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    // Función para mostrar el texto del estado
    String getStatusText(ReportStatus status) {
      switch (status) {
        case ReportStatus.open:
          return 'Abierto';
        case ReportStatus.closed:
          return 'Cerrado';
        case ReportStatus.inProgress:
          return 'En progreso';
        default:
          return 'Desconocido';
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del reporte
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción del reporte
            Text(
              report.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Severidad del reporte
            Row(
              children: [
                Icon(
                  Icons.priority_high,
                  color: getSeverityColor(report.severity),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  report.severity.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: getSeverityColor(report.severity),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Estado del reporte
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: report.status == ReportStatus.open
                      ? Colors.green
                      : report.status == ReportStatus.closed
                          ? Colors.grey
                          : Colors.blue,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  getStatusText(report.status),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Fecha del reporte
            Text(
              'Fecha: ${report.date}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
