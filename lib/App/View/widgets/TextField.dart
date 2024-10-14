import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool _isPasswordVisible = false; // Variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the TextField
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium, // Use subtitle style for the label
        ),
        const SizedBox(height: 8), // Add space between label and text field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                style: TextStyle(color: Colors.black),
                obscureText: widget.isPassword && !_isPasswordVisible,
                decoration: InputDecoration(
                  suffix: widget.isPassword
                      ? InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 4),
                            child: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context)
                                  .primaryColor, // Use theme color for icons
                              size: 16,
                            ),
                          ),
                        )
                      : Container(
                          width: 0,
                          height: 15,
                        ),
                  hintText: widget.hint,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    ).paddingAll(value: 10); // Add padding around the entire widget
  }
}
