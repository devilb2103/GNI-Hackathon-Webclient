import 'dart:html' as html;
import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatelessWidget {
  const PDFScreen({super.key});

  void savePDFReport() {
    final blob = html.Blob([pdfData_bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'TumorReport.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Appbar"),
        backgroundColor: const Color.fromARGB(255, 25, 24, 25),
        foregroundColor: text_color,
        scrolledUnderElevation: 0,
      ),
      body: Row(children: [
        Expanded(
            child: Container(
          color: bg_dark,
          height: double.maxFinite,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 120, top: 12, right: 12, bottom: 12),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 480,
                  height: 600,
                  child: SfPdfViewer.memory(pdfData_bytes!),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    onPressed: savePDFReport,
                    label: Text(
                      "Download Report",
                      style: TextStyle(
                        color: text_color,
                        fontSize: 15,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    backgroundColor: Colors.black26,
                    foregroundColor: Colors.white54,
                    focusColor: Colors.black26,
                    splashColor: Colors.black26,
                    hoverColor: Colors.black26,
                  ),
                ],
              ),
            )
          ]),
        ))
      ]),
    );
  }
}

      // body: Center(
      //     child: pdfData_bytes != null
      //         ? SfPdfViewer.memory(pdfData_bytes!)
      //         : const SizedBox()),