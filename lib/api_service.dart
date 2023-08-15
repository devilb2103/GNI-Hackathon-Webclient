import 'dart:typed_data';
import 'package:client/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  factory DioSingleton() => _instance;
  DioSingleton._internal();
  final _client = Dio(BaseOptions(
    baseUrl: address,
  ));

  // predict path ---------------------------------------------------------------------------
  Future<Response<dynamic>> getPredictionData(
      List<Uint8List> imageBytesList) async {
    FormData formData = FormData();

    // Add images to FormData
    for (int i = 0; i < imageBytesList.length; i++) {
      Uint8List imageBytes = imageBytesList[i];
      String imageName = 'uploaded_image_$i.jpg';
      formData.files.add(MapEntry('imagefiles',
          MultipartFile.fromBytes(imageBytes, filename: imageName)));
    }

    // Add other data to FormData
    var jsonData = {
      // Add your additional data fields here
      'field1': 'bro lmaoooo',
      'field2': 'value2',
    };

    formData.fields.addAll(jsonData.entries);

    // try {
    final response = await _client.post("/predict",
        data: formData, options: Options(responseType: ResponseType.json));

    return response;
    // if (response.statusCode == 200) {

    // } else {
    //   print(
    //       'Failed to send images and data. Status code: ${response.statusCode}');
    // }
    // } catch (e) {
    //   print('Error sending request: $e');
    // }
  }

  // predict path ---------------------------------------------------------------------------
  // Future<Response<dynamic>> generatePDF(
  Future<void> generatePDF(
      List<Uint8List> imageBytesList, BuildContext context) async {
    FormData formData = FormData();

    // Add images to FormData
    for (int i = 0; i < imageBytesList.length; i++) {
      Uint8List imageBytes = imageBytesList[i];
      String imageName = 'uploaded_image_$i.jpg';
      formData.files.add(MapEntry('imagefiles',
          MultipartFile.fromBytes(imageBytes, filename: imageName)));
    }

    // Add other data to FormData
    var jsonData = {
      // Add your additional data fields here
      'classifications': prediction_data.toString(),
      '<report_number>': '13001369',
      '<patient_id>': '9-11-ak47',
      '<patient_age>': '23',
      '<scan_date>': '12 / 2 / 2004',
    };

    formData.fields.addAll(jsonData.entries);

    try {
      final response = await _client.post("/getPDF",
          data: formData, options: Options(responseType: ResponseType.bytes));
      dynamic pdfData = response.data;
      // print(pdfData.toString());
      // final file = File('../downloaded_pdf.pdf');
      // Uint8List pdfData_filtered = Uint8List.fromList(base64.decode(pdfData));
      // await file.writeAsBytes(pdfData);

      // final _pdfController = PdfController(
      //   document: PdfDocument.openData(pdfData_filtered),
      //   // initialPage: _initialPage,
      // );

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: SfPdfViewer.memory(pdfData),
                )),
      );
    } catch (e) {
      // Handle error.
      print('Error fetching PDF: $e');
    }

    // return response;
  }

  /// All other requests
}
