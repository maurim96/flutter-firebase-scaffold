import 'package:flutter/material.dart';
import 'package:scaffold/ui/theme/custom_colors.dart';

class RegularTextFieldWidget extends StatefulWidget {
  final String label;
  final TextCapitalization textCapitalization;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final AutovalidateMode? autovalidateMode;
  final String? helperText;
  final bool? readOnly;
  final FormFieldValidator<String>? validator;

  const RegularTextFieldWidget({
    required this.label,
    required this.textCapitalization,
    required this.textEditingController,
    required this.textInputType,
    this.autovalidateMode,
    this.helperText,
    this.readOnly = false,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<RegularTextFieldWidget> createState() => _RegularTextFieldWidgetState();
}

class _RegularTextFieldWidgetState extends State<RegularTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly!,
      enabled: !widget.readOnly!,
      controller: widget.textEditingController,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      textCapitalization: widget.textCapitalization,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: placeholderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primary600),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: const TextStyle(
          color: placeholder,
        ),
        labelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color =
                states.contains(MaterialState.error) ? error : placeholder;
            return TextStyle(color: color);
          },
        ),
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color =
                states.contains(MaterialState.error) ? error : primary600;
            return TextStyle(color: color);
          },
        ),
      ),
    );
  }
}
