import 'package:flutter/material.dart';
import 'package:practical_assignment/common/app_theme.dart';

class CommonTextFormField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final FormFieldValidator<String> validator;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool ignorePointer;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String prefixText;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final Function onTap;
  final Function onChange;
  final TextInputType textInputType;
  final int maxLength;

  CommonTextFormField(
      {this.hintText,
        this.labelText,
        @required this.textEditingController,
        this.prefixIcon,
        this.suffixIcon,
        this.textInputAction,
        this.focusNode,
        this.validator,
        this.obscureText = false,
        this.ignorePointer = false,
        this.onFieldSubmitted,
        this.textInputType,
        this.onTap,
        this.prefixText,
        this.onChange,
        this.maxLength});
  @override
  _CommonTextFormFieldState createState() => _CommonTextFormFieldState(this.textEditingController);
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {

  TextEditingController _textEditingController1;

  _CommonTextFormFieldState(this._textEditingController1);

  @override
  void initState() {
    // TODO: implement initState
    widget.focusNode.addListener(() {
      print("Has focus: ${widget.focusNode.hasFocus}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextFormField(
          controller: _textEditingController1,
          validator: widget.validator,
          onSaved: (val) => _textEditingController1.text = val,
          obscureText: widget.obscureText,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          cursorColor: AppTheme.primaryColor,
          style: TextStyle(
            color: AppTheme.blackColor,
            // fontWeight: FontWeight.w200,
          ),
          decoration: InputDecoration(
            prefixText: widget.prefixText,
            contentPadding: EdgeInsets.only(left: 12,top: 10),
            fillColor:AppTheme.whiteColor,
            filled: true,
            counterText: "",
            // border: InputBorder.none,
            border: getOutlineInputBorder(),
            focusedBorder: getOutlineInputBorder(),
            focusedErrorBorder: getOutlineInputBorder(),
            enabledBorder: getOutlineInputBorder(),
            errorBorder: getOutlineInputBorder(),
            disabledBorder: getOutlineInputBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppTheme.GreyColor,
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: AppTheme.blackColor,
            ),
            suffixIcon: widget.suffixIcon,
          ),
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.textInputType,
          textAlignVertical: TextAlignVertical.center,
          onTap: widget.onTap,
        ),
      ),
    );
  }

  OutlineInputBorder getOutlineInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.whiteColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0));
  }
}
