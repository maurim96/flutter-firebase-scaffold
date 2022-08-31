import 'package:flutter/material.dart';
import 'package:scaffold/ui/theme/custom_colors.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController textEditingController;
  final FormFieldValidator<String> validator;
  final AutovalidateMode? autovalidateMode;
  final String? errorMsg;
  final String? helperText;

  const PasswordTextFieldWidget({
    required this.label,
    required this.textEditingController,
    required this.validator,
    this.autovalidateMode,
    this.errorMsg,
    this.helperText,
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      validator: widget.validator,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      autovalidateMode: widget.autovalidateMode,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        errorText: widget.errorMsg,
        errorMaxLines: 2,
        labelText: widget.label,
        helperText: widget.helperText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: placeholderLight),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primary600),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: placeholder),
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
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: placeholder,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }
}
