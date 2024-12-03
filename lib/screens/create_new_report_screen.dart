import 'package:flutter/material.dart';
import '../models/report_model.dart';

class CreateNewReportScreen extends StatefulWidget {
  const CreateNewReportScreen({super.key});

  @override
  State<CreateNewReportScreen> createState() => _CreateNewReportScreenState();
}

class _CreateNewReportScreenState extends State<CreateNewReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ReportSeverity _selectedSeverity = ReportSeverity.medium;
  ReportStatus _selectedStatus = ReportStatus.inProgress;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Crear Nuevo',
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
                              severity.name[0].toUpperCase() +
                                  severity.name.substring(1),
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
                              : status.name[0].toUpperCase() +
                                  status.name.substring(1);
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
                      onPressed: () {
                        // Crear el reporte utilizando ReportModel
                        if (_titleController.text.isEmpty ||
                            _descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Por favor, complete todos los campos')),
                          );
                          return;
                        }

                        final newReport = ReportModel(
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
                          date:
                              DateTime.now().toIso8601String(), // Fecha actual
                        );

                        // Imprimir para ver en la consola
                        print('Nuevo reporte creado: $newReport');

                        // Regresar el reporte creado a la pantalla anterior
                        Navigator.of(context).pop(newReport);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Crear',
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
                        Navigator.of(context).pop(); // Cancelar
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
