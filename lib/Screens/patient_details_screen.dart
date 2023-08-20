import 'package:client/Screens/analysis_screen.dart';
import 'package:client/Widgets/custom_date_picker.dart';
import 'package:client/Widgets/custom_text_field.dart';
import 'package:client/constants.dart';
import 'package:client/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PatientDetailsScreen extends StatelessWidget {
  PatientDetailsScreen({super.key});

  TextEditingController reportNumber = TextEditingController();
  TextEditingController patientId = TextEditingController();
  TextEditingController scanDate = TextEditingController();
  TextEditingController scanDateText = TextEditingController();
  TextEditingController patientAge = TextEditingController();
  String analysisDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  String imageType = "MRI - T1, T2 and FLAIR";

  @override
  Widget build(BuildContext context) {
    void showAnalysisPage() {
      if (reportNumber.text.isNotEmpty &&
          patientId.text.isNotEmpty &&
          scanDate.text.isNotEmpty &&
          scanDateText.text.isNotEmpty &&
          patientAge.text.isNotEmpty) {
        Navigator.push(
            context,
            customSlideTransitionDown(AnalysisScreen(
                reportNumber: reportNumber.text,
                patientId: patientId.text,
                scanDate: scanDate.text,
                scanDateText: scanDateText.text,
                patientAge: patientAge.text,
                analysisDate: analysisDate,
                imageType: imageType)));
      } else {
        showSnackbar(
            "Enter all details to proceed", context, Colors.red.shade400);
      }
    }

    return Scaffold(
      body: Container(
        color: bg_dark,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 270,
                      child: CustomTextField(
                        title: "Report Number",
                        controller: reportNumber,
                        hintText: "Report No",
                        maxLines: 1,
                        formatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9\-\_]+'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 270,
                      child: CustomTextField(
                        title: "Patient ID",
                        controller: patientId,
                        hintText: "Patient ID",
                        maxLines: 1,
                        formatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9\-\_]+'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                        width: 270,
                        child: CustomDatePicker(
                            controller: scanDate,
                            controllerText: scanDateText,
                            title: "Scan Date",
                            hintText: "Pick Date")),
                  ],
                ),
                const SizedBox(width: 9),
                const SizedBox(
                    height: 390,
                    child: VerticalDivider(
                      thickness: 0.09,
                    )),
                const SizedBox(width: 9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: CustomTextField(
                        controller: patientAge,
                        title: "Patient Age",
                        // hintText: "ID",
                        maxLines: 1,

                        isCounter: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 270,
                      child: CustomTextField.defaultController(
                        title: "Analysis Date",
                        hintText: analysisDate,
                        maxLines: 1,
                        isEnabled: false,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 270,
                      child: CustomTextField.defaultController(
                        title: "Image Type",
                        hintText: imageType,
                        maxLines: 1,
                        isEnabled: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 45),
            FloatingActionButton(
              onPressed: showAnalysisPage,
              backgroundColor: Colors.black26,
              foregroundColor: Colors.white54,
              focusColor: Colors.black26,
              splashColor: Colors.black26,
              hoverColor: Colors.black26,
              child: const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
