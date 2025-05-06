import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/color_constants.dart';

class CustomTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool? isObsecure;
  final bool? isDatePicker;
  final TextInputType? keyboardType;

  const CustomTextformfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.isObsecure,
    this.isDatePicker,
    this.keyboardType,
  });

  @override
  State<CustomTextformfield> createState() => _CustomTextformfieldState();
}

class _CustomTextformfieldState extends State<CustomTextformfield> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObsecure ?? false;
  }

  // date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (widget.controller.text.isNotEmpty) {
      try {
        // Parse date in format "day/month/year"
        List<String> dateParts = widget.controller.text.split('/');
        if (dateParts.length == 3) {
          int day = int.parse(dateParts[0]);
          int month = int.parse(dateParts[1]);
          int year = int.parse(dateParts[2]);

          DateTime parsedDate = DateTime(year, month, day);
          if (parsedDate.year >= 1900 && parsedDate.isBefore(DateTime.now())) {
            initialDate = parsedDate;
          }
        }
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    // Show the date picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(primaryColor),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(primaryColor)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      onTap: widget.isDatePicker != null ? () => _selectDate(context) : null,
      readOnly: widget.isDatePicker == true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(fontSize: 16, color: Color(overlayColor)),
        floatingLabelStyle: TextStyle(fontSize: 16, color: Color(primaryColor)),
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 16, color: Color(overlayColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(overlayColor)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(primaryColor)),
        ),
        suffixIcon:
            widget.isObsecure != null
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color:
                        _obscureText
                            ? Color(negativeColor)
                            : Color(positiveColor),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : widget.isDatePicker != null
                ? IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.grey),
                  onPressed: () => _selectDate(context),
                )
                : null,
      ),
    );
  }
}
