import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';
// import '../models/report_model.dart';
import 'create_new_report_screen.dart';
import 'edit_report_screen.dart';
import 'delete_confirmation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar reportes al iniciar
    Future.delayed(Duration.zero, () {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewReportScreen(),
                ),
              ).then((_) {
                // Cuando se regresa, se refrescan los reportes
                reportProvider.fetchReports();
              });
            },
          ),
        ],
      ),
      body: reportProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reportProvider.reports.isEmpty
              ? const Center(child: Text('No hay reportes disponibles.'))
              : ListView.builder(
                  itemCount: reportProvider.reports.length,
                  itemBuilder: (context, index) {
                    final report = reportProvider.reports[index];
                    return ListTile(
                      title: Text(report.title),
                      subtitle: Text(report.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditReportScreen(report: report),
                                ),
                              ).then((_) {
                                // Refrescar después de editar
                                reportProvider.fetchReports();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (report.id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Error: El ID del reporte es nulo')),
                                );
                                return;
                              }

                              final bool? confirmDelete = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteConfirmationScreen(
                                    report: report,
                                  ),
                                ),
                              );

                              if (confirmDelete == true) {
                                await reportProvider.deleteReport(report.id!);
                                // Se actualizan los reportes tras la eliminación
                                reportProvider.fetchReports();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
