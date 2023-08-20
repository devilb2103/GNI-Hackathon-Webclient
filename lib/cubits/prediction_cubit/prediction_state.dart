part of 'prediction_cubit.dart';

abstract class PredictionState {
  const PredictionState();
}

class PredictionInitialState extends PredictionState {
  const PredictionInitialState();
}

class PredictionProcessingState extends PredictionState {
  const PredictionProcessingState();
}

class PredictionErrorState extends PredictionState {
  final String message;
  const PredictionErrorState(this.message);
}
