import 'dart:typed_data';

import 'package:client/constants.dart';
import 'package:client/cubits/pdf_generation_cubit/pdf_generation_cubit.dart';
import 'package:client/cubits/prediction_cubit/prediction_cubit.dart';
import 'package:client/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AnalysisScreen extends StatefulWidget {
  AnalysisScreen(
      {super.key,
      required this.reportNumber,
      required this.patientId,
      required this.scanDate,
      required this.scanDateText,
      required this.patientAge,
      required this.analysisDate,
      required this.imageType});
  String reportNumber;
  String patientId;
  String scanDate;
  String scanDateText;
  String patientAge;
  String analysisDate;
  String imageType = "MRI - T1, T2 and FLAIR";

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  // Image data
  Uint8List? t1_bytes;
  Uint8List? t2_bytes;
  Uint8List? flair_bytes;

  TextStyle hintStyle = const TextStyle(color: Colors.white38);

  Future<void> _pickImage(
      Uint8List? bytes, Function(Uint8List?) updateBytes, bool removing) async {
    if (removing) {
      updateBytes(null);

      setState(() {});
    } else {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        bytes = await image.readAsBytes();
        updateBytes(bytes);
        setState(() {});
        // print("Image was not picked");
      } else {
        // print("Image was not picked");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Appbar"),
        backgroundColor: const Color.fromARGB(255, 25, 24, 25),
        foregroundColor: text_color,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          color: bg_dark,
          child: Column(
            children: [
              // Data Section ------------------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker left section --------------------------------
                  imagePickers(),

                  // Data loader right section --------------------------------
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // report details ------------
                          const SizedBox(height: 9),
                          reportDetails(),
                          const Divider(
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 9),
                          // prediction details ------------

                          BlocConsumer<PredictionCubit, PredictionState>(
                            listener: (context, state) {
                              if (state is PredictionErrorState) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red[400],
                                ));
                              }
                            },
                            builder: (context, state) {
                              if (state is PredictionProcessingState) {
                                return diagnosisDetails();
                              } else {
                                return diagnosisDetails();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget diagnosisDetails() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prediction_data.isNotEmpty
              ? Text(
                  "Diagnosis",
                  style: TextStyle(color: text_color, fontSize: 21),
                )
              : const SizedBox(),
          const SizedBox(height: 12),
          Column(
            children: [
              // row that contains heatmap and segmentation images with classifications
              prediction_data.isNotEmpty
                  ? Row(
                      children: [
                        const SizedBox(width: 15),
                        // expanded container so it stretches horizontally
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              // container that contains the DIAGONOSIS CLASSIFICATIONS ------------- |
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // first column of classification data --------------------- |
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      reportDetailItem("Name of Pathology",
                                          prediction_data["Pathology"]),
                                      reportDetailItem("Tumor Grade",
                                          prediction_data["Grade"]),
                                      reportDetailItem("IDH Status",
                                          prediction_data["IDH_Type"]),
                                    ],
                                  ),
                                  const SizedBox(width: 30),
                                  // second column of classification data --------------------- |
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      reportDetailItem(
                                          "MGMT", prediction_data["MGMT"]),
                                      reportDetailItem(
                                          "1p/19q Codeletion status",
                                          prediction_data["1p/19q"]),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),

                              // Segmeted Image and title --------------------------------------- |
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Segmented Region of Interest",
                                      style: hintStyle),
                                  Container(
                                    color: Colors.black12,
                                    width: 240,
                                    height: 240,
                                    child: segmented_bytes.isNotEmpty
                                        ? Image.memory(segmented_bytes)
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Heatmap Image and title --------------------------------------- |
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Heatmap (GRADCAM)", style: hintStyle),
                                  Container(
                                    color: Colors.black12,
                                    width: 240,
                                    height: 240,
                                    child: heatMap_bytes.isNotEmpty
                                        ? Image.memory(heatMap_bytes)
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ]))
                      ],
                    )
                  : const SizedBox(),
              // ----------------- | // ----------------- | // ----------------- |
              // ----------------- | // ----------------- | // ----------------- |
              // row that contains rediagnose and generate pdf button ----------------- |
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        // generate diagnosis button ---------------------------------------------- |
                        FloatingActionButton.extended(
                          onPressed: () async {
                            List<Uint8List?> imageBytesList = [
                              flair_bytes,
                              t1_bytes,
                              t2_bytes,
                            ];

                            if (imageBytesList.contains(null)) {
                              showSnackbar(
                                  "Attach all scans to get a diagnosis.",
                                  context,
                                  Colors.red.shade400);
                              return;
                            }

                            await context
                                .read<PredictionCubit>()
                                .loadPredictionData(imageBytesList);
                          },
                          label: BlocBuilder<PredictionCubit, PredictionState>(
                            builder: (context, state) {
                              if (state is PredictionProcessingState) {
                                return const CircularProgressIndicator();
                              } else {
                                return Text(
                                  prediction_data.isEmpty
                                      ? "Genernate Diagnosis"
                                      : "Regenernate Diagnosis",
                                  style: TextStyle(
                                    color: text_color,
                                    fontSize: 15,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w100,
                                  ),
                                );
                              }
                            },
                          ),
                          backgroundColor: Colors.black26,
                          foregroundColor: Colors.white54,
                          focusColor: Colors.black26,
                          splashColor: Colors.black26,
                          hoverColor: Colors.black26,
                        ),

                        //
                        prediction_data.isNotEmpty
                            ? const SizedBox(width: 45)
                            : const SizedBox(),
                        //

                        // generate PDF report button ---------------------------------------------- |
                        prediction_data.isNotEmpty
                            ? FloatingActionButton.extended(
                                onPressed: () async {
                                  List<Uint8List> imageBytesList = [
                                    segmented_bytes,
                                    heatMap_bytes
                                  ];

                                  await context
                                      .read<PdfGenerationCubit>()
                                      .loadGeneratedPDF(
                                          imageBytesList,
                                          context,
                                          widget.reportNumber,
                                          widget.patientId,
                                          widget.scanDate,
                                          widget.patientAge);
                                },
                                label: BlocBuilder<PdfGenerationCubit,
                                    PdfGenerationState>(
                                  builder: (context, state) {
                                    if (state is PredictionProcessingState) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        "Genernate PDF Report",
                                        style: TextStyle(
                                          color: text_color,
                                          fontSize: 15,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w100,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                backgroundColor: Colors.black26,
                                foregroundColor: Colors.white54,
                                focusColor: Colors.black26,
                                splashColor: Colors.black26,
                                hoverColor: Colors.black26,
                              )
                            : const SizedBox(),
                      ]))
                ],
              ),
            ],
          ),
        ]);
  }

  Widget imagePickers() {
    return Container(
      // width: 450,
      // height: 120,
      color: Colors.black26,
      child: Column(children: [
        imagePickerWidget(
          "Flair",
          flair_bytes,
          (newBytes) => flair_bytes = newBytes,
        ),
        imagePickerWidget(
          "T1",
          t1_bytes,
          (newBytes) => t1_bytes = newBytes,
        ),
        imagePickerWidget(
          "T2",
          t2_bytes,
          (newBytes) => t2_bytes = newBytes,
        ),
        const SizedBox(height: 75),
      ]),
    );
  }

  Widget reportDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Report Details",
          style: TextStyle(color: text_color, fontSize: 21),
        ),
        const SizedBox(height: 21),
        Row(
          children: [
            const SizedBox(width: 15),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  reportDetailItem("Report Number", widget.reportNumber),
                  reportDetailItem("Patient ID", widget.patientId),
                  reportDetailItem("Scan Date", widget.scanDateText),
                ]),
            const SizedBox(width: 90),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  reportDetailItem("Patient Age", widget.patientAge),
                  reportDetailItem("Analysis Date", widget.analysisDate),
                  reportDetailItem("Image Type", widget.imageType),
                ]),
          ],
        ),
      ],
    );
  }

  Widget reportDetailItem(String title, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: hintStyle),
        Text(content,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: text_color)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget imagePickerWidget(
      String imageType, Uint8List? bytes, Function(Uint8List?) updateBytes) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: GestureDetector(
            onTap: () {
              if (bytes == null) {
                _pickImage(bytes, updateBytes, false);
              }
            },
            child: Column(
              children: [
                // title text
                bytes != null
                    ? Text(
                        "$imageType image",
                        style: hintStyle,
                      )
                    : const SizedBox(),
                const SizedBox(height: 3),
                // image container
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: Colors.grey.shade800)),
                  child: bytes == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: hintStyle.color,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              "Attach $imageType Image",
                              style: hintStyle,
                            )
                          ],
                        )
                      : Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.memory(bytes)),
                        ),
                ),
              ],
            ),
          ),
        ),
        if (bytes != null)
          Padding(
            padding: const EdgeInsets.only(right: 9),
            child: GestureDetector(
              onTap: () {
                _pickImage(bytes, updateBytes, true);
              },
              child: Container(
                height: 27,
                width: 27,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 25, 24, 25),
                    borderRadius: BorderRadius.circular(3)),
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: text_color,
                ),
              ),
            ),
          )
        else
          SizedBox()
      ],
    );
  }
}
