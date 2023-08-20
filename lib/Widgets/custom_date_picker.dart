import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  TextEditingController controller;
  TextEditingController controllerText;
  final String title;
  final String hintText;

  // Named constructor with a default value for the controller
  CustomDatePicker.defaultController({
    Key? key,
    this.title = "",
    this.hintText = "",
  })  : controller = TextEditingController(),
        controllerText = TextEditingController(),
        super(key: key);

  CustomDatePicker({
    super.key,
    this.title = "",
    this.hintText = "",
    required this.controller,
    required this.controllerText,
  });

  @override
  State<CustomDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<CustomDatePicker> {
  TextStyle hintStyle = const TextStyle(color: Colors.white38, fontSize: 16);
  // TextStyle textStyle = TextStyle(color: text_color);
  TextStyle titleStyle = TextStyle(
    color: text_color,
    fontSize: 15,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w100,
  );

  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.red, // Header and selected day color

            colorScheme: ColorScheme.dark(
              primary: text_color, // OK button color
              onPrimary: Colors.black, // OK button text color
              surface: const Color.fromARGB(
                  255, 12, 12, 12), // Unselected day background color
              onSurface: text_color, // Unselected day text color
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.controller.text =
            formatDate(selectedDate!); // Format and store the date
        widget.controllerText.text = formatDateText(selectedDate!);
      });
    }
  }

  String formatDate(DateTime date) {
    // Customize the date formatting according to your needs
    // return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return DateFormat('d/M/y').format(date);
  }

  String formatDateText(DateTime date) {
    // Customize the date formatting according to your needs
    // return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return DateFormat.yMMMMEEEEd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title ----------------------------------------------------
        Padding(
          padding: const EdgeInsets.only(left: 10.5),
          child: Text(widget.title, style: titleStyle),
        ),
        const SizedBox(height: 4.5),
        // ----------------------------------------------------
        // Text Input Field
        //
        // sizedbox for defining button dimensions
        SizedBox(
          height: 47,
          width: 360,
          child: FloatingActionButton.extended(
            elevation: 4,
            backgroundColor: Colors.black26,
            focusColor: Colors.black26,
            hoverColor: Colors.black26,
            splashColor: Colors.black26,
            foregroundColor: Colors.black26,
            onPressed: _selectDate,
            hoverElevation: 8,

            // another sizedbox for defining the stretching of inner content to
            //fit the button width so it can align to the left
            label: SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: hintStyle.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.controllerText.text.isEmpty
                            ? widget.hintText
                            : widget.controllerText.text,
                        style: hintStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
