import 'dart:typed_data';

String address = "http://127.0.0.1:5000";
String prediction = "/predict";

Uint8List segmented_bytes = Uint8List(0);
Uint8List heatMap_bytes = Uint8List(0);
Map<String, dynamic> prediction_data = {};
// Uint8List imageBytes1 = response.headers['image1'];
