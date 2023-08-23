import 'package:client/Screens/analysis_screen.dart';
import 'package:client/Screens/patient_details_screen.dart';
import 'package:flutter/material.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(child: PatientDetailsScreen()),
        // MaterialPage(
        //   child: AnalysisScreen(
        //       reportNumber: "13001369",
        //       patientId: "9-11-ak47",
        //       scanDate: "20/8/2023",
        //       scanDateText: "Sunday, August 20, 2023",
        //       patientAge: "33",
        //       analysisDate: "Sunday, August 20, 2023",
        //       imageType: "MRI - T1, T2 and FLAIR"),
        // ),
      ],
      onPopPage: (route, result) {
        return route.didPop(result);
      },
    );
  }
}
