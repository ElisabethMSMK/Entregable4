import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/report_model.dart';

class ReportProvider extends ChangeNotifier {
  List<ReportModel> _reports = [];
  bool _isLoading = false;

  List<ReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  // Cargar todos los reportes desde la base de datos
  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<ReportModel> fetchedReports =
          await DatabaseHelper.instance.readAllReports();

      // Asegúrate de que los enums 'severity' y 'status' se conviertan correctamente
      _reports = fetchedReports.map((report) {
        return ReportModel(
          id: report.id,
          title: report.title,
          description: report.description,
          severity: ReportSeverity.values.firstWhere(
              (e) => e.toString().split('.').last == report.severity),
          status: ReportStatus.values
              .firstWhere((e) => e.toString().split('.').last == report.status),
          date: report.date,
        );
      }).toList();
    } catch (e) {
      print("Error al cargar reportes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar un nuevo reporte
  Future<void> addReport(ReportModel report) async {
    try {
      // Convierte los enums 'severity' y 'status' a String para insertarlos
      final newReport = ReportModel(
        title: report.title,
        description: report.description,
        severity: report.severity,
        status: report.status,
        date: report.date,
      );
      await DatabaseHelper.instance.createReport(newReport);
      _reports.add(newReport);
      notifyListeners();
    } catch (e) {
      print("Error al agregar reporte: $e");
    }
  }

  // Actualizar un reporte existente
  Future<void> updateReport(ReportModel report) async {
    try {
      // Convierte los enums 'severity' y 'status' a String para actualizar
      await DatabaseHelper.instance.updateReport(report);
      final index = _reports.indexWhere((r) => r.id == report.id);
      if (index != -1) {
        _reports[index] = report;
        notifyListeners();
      }
    } catch (e) {
      print("Error al actualizar reporte: $e");
    }
  }

  // Eliminar un reporte
  Future<void> deleteReport(int id) async {
    try {
      await DatabaseHelper.instance.deleteReport(id);
      _reports.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      print("Error al eliminar reporte: $e");
    }
  }
}
