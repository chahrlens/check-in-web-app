import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor de PDF')),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) {
          // Puedes mostrar un diálogo o snackbar si falla la carga
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar PDF: ${details.description}')),
          );
        },
      ),
    );
  }
}
