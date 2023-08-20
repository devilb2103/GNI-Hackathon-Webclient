import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:client/api_service.dart';
import 'package:client/constants.dart';
import 'package:dio/dio.dart';

part 'prediction_state.dart';

class PredictionCubit extends Cubit<PredictionState> {
  PredictionCubit() : super(const PredictionInitialState());
  bool _canTriggerActions = true;

  Future<void> loadPredictionData(List<Uint8List?> imageBytesList) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const PredictionProcessingState());

    try {
      Response<dynamic> response =
          await DioSingleton().getPredictionData(imageBytesList);
      print(response.statusMessage);
      if (response.statusCode == 200) {
        if (response.data["status"] == 200) {
          // classification dict
          Map<String, dynamic> classifications =
              response.data["message"]["classifications"];

          // imageBytesList
          List<String> encodedImages = List.castFrom<dynamic, String>(
              response.data['message']['imageBytes']);

          // store the classification data
          prediction_data = classifications;
          print(prediction_data);
          // print(classifications.toString());

          // write those bytes to variable and store for making images
          segmented_bytes = Uint8List.fromList(
              base64.decode(encodedImages[0].replaceAll(RegExp(r'\s+'), '')));
          heatMap_bytes = Uint8List.fromList(
              base64.decode(encodedImages[1].replaceAll(RegExp(r'\s+'), '')));

          // print(classifications.toString());
        } else {
          print(response.data["message"].toString());
          emit(PredictionErrorState(response.data["message"]));
        }
      } else {
        print(response.data["message"].toString());
        emit(PredictionErrorState(response.data["message"]));
      }
    } catch (e) {
      print(e.toString());
      emit(PredictionErrorState(e.toString()));
    }
    emit(const PredictionInitialState());
    _canTriggerActions = true;
  }
}
