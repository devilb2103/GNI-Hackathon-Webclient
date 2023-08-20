import 'package:client/app_navigator.dart';
import 'package:client/cubits/pdf_generation_cubit/pdf_generation_cubit.dart';
import 'package:client/cubits/prediction_cubit/prediction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PredictionCubit(),
          ),
          BlocProvider(
            create: (context) => PdfGenerationCubit(),
          ),
        ],
        child: const AppNavigator(),
      ),
    );
  }
}
