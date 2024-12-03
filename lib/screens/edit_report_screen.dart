import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

class EditReportScreen extends StatefulWidget {
  final ReportModel report;

  const EditReportScreen({Key? key, required this.report}) : super(key: key);

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late ReportSeverity _selectedSeverity;
  late ReportStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report.title);
    _descriptionController =
        TextEditingController(text: widget.report.description);
    _selectedSeverity = widget.report.severity;
    _selectedStatus = widget.report.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Convierte el texto de severidad en el enum correspondiente
  ReportSeverity _mapSeverity(String severity) {
    switch (severity) {
      case 'critical':
        return ReportSeverity.critical;
      case 'high':
        return ReportSeverity.high;
      case 'medium':
        return ReportSeverity.medium;
      case 'low':
        return ReportSeverity.low;
      case 'info':
      default:
        return ReportSeverity.info;
    }
  }

  // Convierte el texto de estado en el enum correspondiente
  ReportStatus _mapStatus(String status) {
    switch (status) {
      case 'open':
        return ReportStatus.open;
      case 'inProgress':
        return ReportStatus.inProgress;
      case 'closed':
      default:
        return ReportStatus.closed;
    }
  }

  // Convierte el enum de severidad a su valor de texto
  String _severityToString(ReportSeverity severity) {
    return severity.toString().split('.').last;
  }

  // Convierte el enum de estado a su valor de texto
  String _statusToString(ReportStatus status) {
    return status.toString().split('.').last;
  }

  Future<void> _saveReport() async {
    final updatedReport = ReportModel(
      id: widget.report.id,
      title: _titleController.text,
      description: _descriptionController.text,
      severity: ReportSeverity.values.firstWhere((e) =>
          e.toString().split('.').last ==
          _selectedSeverity
              .toString()
              .split('.')
              .last), // Ahora usas el ReportSeverity correcto
      status: ReportStatus.values.firstWhere((e) =>
          e.toString().split('.').last ==
          _selectedStatus.toString().split('.').last),
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );

    await DatabaseHelper.instance.updateReport(updatedReport);

    Navigator.of(context).pop(); // Cerrar la pantalla y regresar al HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Editar Reporte'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Editar Reporte',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título CVE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: DropdownButton<ReportSeverity>(
                        value: _selectedSeverity,
                        isExpanded: true,
                        underline: Container(),
                        items: ReportSeverity.values.map((severity) {
                          return DropdownMenuItem(
                            value: severity,
                            child: Text(
                              severity.toString().split('.').last.toUpperCase(),
                              style: const TextStyle(color: Colors.orange),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedSeverity = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: DropdownButton<ReportStatus>(
                        value: _selectedStatus,
                        isExpanded: true,
                        underline: Container(),
                        items: ReportStatus.values.map((status) {
                          String displayText = status == ReportStatus.inProgress
                              ? 'En progreso'
                              : status.toString().split('.').last.toUpperCase();
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              displayText,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStatus = value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
