import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/expense_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CashOutForm extends StatefulWidget {
  const CashOutForm({super.key});

  @override
  _CashOutFormState createState() => _CashOutFormState();
}

class _CashOutFormState extends State<CashOutForm> {
  final _formKey = GlobalKey<FormState>();
  String cashOutPurpose = 'Bills';
  String paymentMethod = 'Cash';
  String Month = 'January';
  DateTime selectedDate = DateTime.now();
  final TextEditingController _amountController = TextEditingController();
  TextEditingController payeeController = TextEditingController();
  TextEditingController notesController = TextEditingController();


  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  double? currentBalance;
  double? totalExpense;
  double? totalIncome;

  storeData() async {
    double amountOut = double.tryParse(_amountController.text.toString().trim()) ?? 0;

    String TransactionId = FirebaseFirestore.instance.collection('users').doc().id;
    final query = FirebaseFirestore.instance.collection("users").doc(currentUserId);
    var data = await query.get();
    currentBalance = data['currentBalance'].toDouble() ?? 0;
    totalExpense = data['totalExpense'].toDouble() ?? 0;
    totalIncome = data['totalIncome'].toDouble() ?? 0;

    if (amountOut > currentBalance!) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You do not have enough balance!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double newBalance = currentBalance! - amountOut;

    await Future.wait([
      query.update({
        "currentBalance": newBalance,
        "totalExpense": totalExpense! + amountOut,
        "totalIncome": totalIncome! ,
      }),


      query.collection("expense").doc(TransactionId)
          .set({
        'Category' : cashOutPurpose,
        'Amount': amountOut,
        'time': DateTime.now(),
        'month': Month,
        'paymentMethod' : paymentMethod,
        'PayeeName' : payeeController.text,
        'Comments': notesController.text,
        'type' : 'expense'

      }),

    ]);

    setState(() {
      _amountController.clear();
      notesController.clear();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Cash Out Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Cash Out Purpose
              DropdownButtonFormField<String>(
                value: cashOutPurpose,
                decoration: const InputDecoration(labelText: 'Purpose of Cash Out'),
                items: ['Bills','Utility', 'Rent', 'Shopping', 'Travel', 'Food','Education','Other'].map((purpose) {
                  return DropdownMenuItem(value: purpose, child: Text(purpose));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    cashOutPurpose = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: Text("Date ${selectedDate.toLocal()}".split(' ')[0].toString()),
                subtitle: Text("${selectedDate.toLocal()}".split(' ')[0].toString()),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Payment Method
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['Cash', 'Bank Transfer', 'Credit Card', 'Mobile Wallet', 'Cheque']
                    .map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<String>(
                value: Month,
                decoration: const InputDecoration(labelText: 'Select The Month '),
                items: ['January', 'February', 'March', 'April', 'May','June' ,'July', 'August','September','October','November','December']
                    .map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    Month = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Payee Name
              TextFormField(
                controller: payeeController,
                decoration: const InputDecoration(labelText: 'Payee Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the payee name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes/Description
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                    storeData();

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                        content:
                    Text('Expense Successfully Added', style: TextStyle(color: Colors.white),)),);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseScreen()));

                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content:
                        Text('Please fill required fields', style: TextStyle(color: Colors.white),)),);

                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date Picker Function
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
