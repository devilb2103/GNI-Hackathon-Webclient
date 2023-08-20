import 'dart:typed_data';

import 'package:flutter/material.dart';

String address = "http://127.0.0.1:5000";
String prediction = "/predict";

Uint8List segmented_bytes = Uint8List(0);
Uint8List heatMap_bytes = Uint8List(0);
Map<String, dynamic> prediction_data = {};
Uint8List? pdfData_bytes = Uint8List(0);
// Uint8List imageBytes1 = response.headers['image1'];

// Colors ----------------------------------------
Color bg_dark = Colors.black87;
Color text_color = Colors.white60;
