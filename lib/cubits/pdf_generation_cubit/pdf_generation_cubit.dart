import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:client/Screens/pdf_screen.dart';
import 'package:client/api_service.dart';
import 'package:client/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

part 'pdf_generation_state.dart';

class PdfGenerationCubit extends Cubit<PdfGenerationState> {
  PdfGenerationCubit() : super(const PdfGenerationInitialState());
  bool _canTriggerActions = true;

  Future<void> loadGeneratedPDF(
    List<Uint8List> imageBytesList,
    BuildContext context,
    String reportNumber,
    String patientId,
    String scanDate,
    String patientAge,
  ) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const PdfGenerationProcessingState());

    try {
      Response<dynamic> response = await DioSingleton().generatePDF(
          imageBytesList, reportNumber, patientId, scanDate, patientAge);
      //   print(response.statusMessage);print(response.statusMessage);
      if (response.statusCode == 200) {
        pdfData_bytes = response.data;
        if (pdfData_bytes!.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const PDFScreen()));
        } else {
          String message = "Response PDF bytes are corrupted";
          print(response.data[message].toString());
          emit(PdfGenerationErrorState(message));
        }
      } else {
        print(response.data["message"].toString());
        emit(PdfGenerationErrorState(response.data["message"]));
      }
    } catch (e) {
      print(e.toString());
      emit(PdfGenerationErrorState(e.toString()));
    }
    emit(const PdfGenerationInitialState());
    _canTriggerActions = true;
  }
}
