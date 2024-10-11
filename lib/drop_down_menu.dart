import 'package:flutter/material.dart';

class dropDown extends StatefulWidget{

  @override
  State<dropDown> createState() => _dropDownState();
}

class _dropDownState extends State<dropDown> {
  String? _selectedItems ;
  List<String> items = ['Salary', 'Others'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body :Center(
        child: DropdownButton<String>(
          value: _selectedItems,
          hint: Text('Select an option'),  // Placeholder text
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedItems = newValue;
            });
          },
        ),
      ),
    );
  }
}