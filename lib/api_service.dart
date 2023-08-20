import 'dart:typed_data';
import 'package:client/constants.dart';
import 'package:dio/dio.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  factory DioSingleton() => _instance;
  DioSingleton._internal();
  final _client = Dio(BaseOptions(
    baseUrl: address,
  ));

  // predict path ---------------------------------------------------------------------------
  Future<Response<dynamic>> getPredictionData(
    List<Uint8List?> imageBytesList,
  ) async {
    FormData formData = FormData();

    // Add images to FormData
    for (int i = 0; i < imageBytesList.length; i++) {
      Uint8List imageBytes = imageBytesList[i]!;
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
  }

  // predict path ---------------------------------------------------------------------------
  // Future<Response<dynamic>> generatePDF(
  Future<Response<dynamic>> generatePDF(
    List<Uint8List?> imageBytesList,
    String reportNumber,
    String patientId,
    String scanDate,
    String patientAge,
  ) async {
    FormData formData = FormData();

    // Add images to FormData
    for (int i = 0; i < imageBytesList.length; i++) {
      Uint8List imageBytes = imageBytesList[i]!;
      String imageName = 'uploaded_image_$i.jpg';
      formData.files.add(MapEntry('imagefiles',
          MultipartFile.fromBytes(imageBytes, filename: imageName)));
    }

    // Add other data to FormData
    var jsonData = {
      // Add your additional data fields here
      'classifications': prediction_data.toString(),
      '<report_number>': reportNumber,
      '<patient_id>': patientId,
      '<patient_age>': patientAge,
      '<scan_date>': scanDate,
    };

    formData.fields.addAll(jsonData.entries);

    final response = await _client.post("/getPDF",
        data: formData, options: Options(responseType: ResponseType.bytes));
    dynamic pdfData = response;
    return pdfData;
  }

  /// All other requests
}
