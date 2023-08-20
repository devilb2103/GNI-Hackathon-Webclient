import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  final String title;
  final String hintText;
  final int maxLines;
  final bool isEnabled;
  final bool isCounter;
  final List<TextInputFormatter>? formatter;

  // Named constructor with a default value for the controller
  CustomTextField.defaultController({
    Key? key,
    this.title = "",
    this.hintText = "",
    required this.maxLines,
    this.isEnabled = true,
    this.isCounter = false,
    this.formatter,
  })  : controller = TextEditingController(),
        super(key: key);

  CustomTextField({
    super.key,
    this.title = "",
    required this.controller,
    this.hintText = "",
    required this.maxLines,
    this.isEnabled = true,
    this.isCounter = false,
    this.formatter,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextStyle hintStyle = const TextStyle(color: Colors.white38);
  TextStyle textStyle = TextStyle(color: text_color);
  TextStyle titleStyle = TextStyle(
    color: text_color,
    fontSize: 15,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w100,
  );

  List<TextInputFormatter> intOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];

  int counter = 1;
  int max_counter = 120;
  late FocusNode _focusNode;

  void incrementAge() {
    if (counter >= 120) {
      return;
    }
    setState(() {
      counter++;
      widget.controller.text = counter.toString();
    });
  }

  void decrementAge() {
    if (counter <= 1) {
      return;
    }
    setState(() {
      counter--;
      widget.controller.text = counter.toString();
    });
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.isCounter) {
      updateCounterOnEntry(widget.controller.text);
    }
  }

  void updateCounterOnEntry(String value) {
    if (value.isNotEmpty) {
      final parsedValue = int.tryParse(value);
      if (parsedValue != null) {
        if (parsedValue > max_counter) {
          setState(() {
            counter = max_counter;
            widget.controller.text = counter.toString();
          });
        } else {
          counter = parsedValue;
        }
      } else {
        counter = 1;
      }
    } else {
      setState(() {
        counter = 1;
        widget.controller.text = counter.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    if (widget.isCounter) {
      widget.controller.text = counter.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
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
              TextFormField(
                enabled: widget.isEnabled,
                maxLines: widget.maxLines,
                controller: widget.controller,
                onChanged: (value) {
                  widget.isCounter ? updateCounterOnEntry(value) : null;
                },
                focusNode: _focusNode,
                style: textStyle,
                inputFormatters: widget.isCounter ? intOnly : widget.formatter,
                cursorHeight: 21,
                // showCursor: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(21)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  border: const OutlineInputBorder(),
                  hintText: widget.hintText,
                  hintStyle: hintStyle,
                  filled: true,
                  fillColor: Colors.black26,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: widget.isCounter ? 3 : 0),
        if (widget.isCounter)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SizedBox(
              width: 36,
              height: 54,
              // color: Colors.amber,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        incrementAge();
                      },
                      child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(Icons.add, color: text_color),
                      ),
                    ),
                    // SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        decrementAge();
                      },
                      child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(Icons.remove, color: text_color),
                      ),
                    ),
                  ]),
            ),
          )
        else
          const SizedBox()
      ],
    );
  }
}
