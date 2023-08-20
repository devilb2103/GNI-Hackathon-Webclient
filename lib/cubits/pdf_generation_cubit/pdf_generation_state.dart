part of 'pdf_generation_cubit.dart';

abstract class PdfGenerationState {
  const PdfGenerationState();
}

class PdfGenerationInitialState extends PdfGenerationState {
  const PdfGenerationInitialState();
}

class PdfGenerationProcessingState extends PdfGenerationState {
  const PdfGenerationProcessingState();
}

class PdfGenerationErrorState extends PdfGenerationState {
  final String message;
  const PdfGenerationErrorState(this.message);
}
