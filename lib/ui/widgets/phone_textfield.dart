import 'package:flutter/material.dart';
import 'package:oiitaxi/ui/theme.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({Key? key,required TextEditingController numberController,}) :_numberController =numberController, super(key: key);
  final TextEditingController _numberController;
  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  bool isFocus = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v){
        setState(() {
          isFocus = v;
        });
      },
      child: TextField(
        controller: widget._numberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: OutlineInputBorder(),
          hintText: 'Enter Phone Number',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CityTheme.cityblue),
          ),
          border: OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(),
          prefix: isFocus
            ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
            child: Text(' '),
          )
              : SizedBox.shrink(),
          prefixIcon: isFocus ? null : Icon(Icons.phone)
        ),
      ),
    );
  }
}
