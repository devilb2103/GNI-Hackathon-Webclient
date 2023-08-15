import 'dart:html' as html;
import 'package:client/api_service.dart';
import 'package:client/constants.dart';
import 'package:client/cubits/prediction_cubit/prediction_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? t1_bytes;
  Uint8List? t2_bytes;
  Uint8List? flair_bytes;

  // final _picker = ImagePicker();
  Future<void> _pickImage(int type) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (type == 1) {
        t1_bytes = await image.readAsBytes();
      } else if (type == 2) {
        t2_bytes = await image.readAsBytes();
      } else if (type == 3) {
        flair_bytes = await image.readAsBytes();
      }
      setState(() {});
    } else {
      print("No image was picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                style: TextStyle(color: Colors.grey.shade300),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imagePick(1),
                  SizedBox(width: 6),
                  imagePick(2),
                  SizedBox(width: 6),
                  imagePick(3),
                ],
              ),
              SizedBox(height: 10),
              FloatingActionButton.extended(
                  onPressed: () async {
                    List<Uint8List> imageBytesList = [
                      t1_bytes!,
                      t2_bytes!,
                      flair_bytes!
                    ];

                    await context
                        .read<PredictionCubit>()
                        .loadPredictionData(imageBytesList);
                  },
                  label: BlocConsumer<PredictionCubit, PredictionState>(
                    listener: (context, state) {
                      if (state is PredictionErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red[400],
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state is PredictionProcessingState) {
                        return CircularProgressIndicator(color: Colors.black);
                      } else {
                        return Text("Send images");
                      }
                    },
                  )),
              SizedBox(height: 10),
              BlocBuilder<PredictionCubit, PredictionState>(
                builder: (context, state) {
                  // print("ui refreshed!");
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (segmented_bytes.isNotEmpty)
                              ? Image.memory(segmented_bytes)
                              : const SizedBox(),
                          const SizedBox(width: 6),
                          (heatMap_bytes.isNotEmpty)
                              ? Image.memory(heatMap_bytes)
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(height: 10),
                      segmented_bytes.isNotEmpty
                          ? FloatingActionButton.extended(
                              onPressed: () async {
                                List<Uint8List> imageBytesList = [
                                  segmented_bytes,
                                  heatMap_bytes
                                ];
                                await context
                                    .read<PredictionCubit>()
                                    .loadGeneratedPDF(imageBytesList, context);
                              },
                              label: Text("Generate PDF"))
                          : SizedBox(),
                    ],
                  );
                  // if (segmented_bytes.isNotEmpty) {
                  //   // print(segmented_bytes.toString());
                  //   return Image.memory(heatMap_bytes);
                  // } else {
                  //   return const SizedBox();
                  // }
                },
              )
            ]),
      ),
    );
  }

  Widget imagePick(int type) {
    Uint8List? image_bytes =
        type == 1 ? t1_bytes : (type == 2 ? t2_bytes : flair_bytes);
    return image_bytes == null
        ? FloatingActionButton.extended(
            onPressed: () async {
              await _pickImage(type);
            },
            label: Text("Pick Image"))
        : Center(
            child: Container(
              child: Image.memory(image_bytes),
              height: 100,
              width: 100,
            ),
          );
  }
}
