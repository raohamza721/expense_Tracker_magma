import 'package:expense_tracker/getx_controllers/cash_in_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashInForm extends StatefulWidget {
  const CashInForm({super.key});

  @override
  _CashInFormState createState() => _CashInFormState();
}

class _CashInFormState extends State<CashInForm> {
  final _formKey = GlobalKey<FormState>();

  CashInController cashInController = Get.put(CashInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Cash In Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Cash Source
              DropdownButtonFormField<String>(
                value: cashInController.cashSource.value,
                decoration: const InputDecoration(labelText: 'Cash Source'),
                items: ['Salary', 'Freelance', 'Business', 'Gift', 'Investment']
                    .map((source) {
                  return DropdownMenuItem(value: source, child: Text(source));
                }).toList(),
                onChanged: (value) {
                  cashInController.cashSource.value = value!;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: cashInController.amountController,
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
                title: Obx(() {
                  return Text(
                      "Date: ${cashInController.selectedDate.value.toLocal().toString().split(' ')[0]}"
                  );
                }),
                subtitle: Obx(() {
                  return Text(
                      cashInController.selectedDate.value.toLocal().toString().split(' ')[0]
                  );
                }),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => cashInController.selectDate(context),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: cashInController.Month.value,
                decoration: const InputDecoration(
                    labelText: 'Select The Month '),
                items: ['January','February','March','April','May','June','July','August','September','October','November',
                  'December'
                ]
                    .map((method) {
                  return
                    DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                    cashInController.Month.value = value!;
                },
              ),
              const SizedBox(height: 16),

              // Payment Method
              DropdownButtonFormField<String>(
                value: cashInController.paymentMethod.value,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: [
                  'Cash',
                  'Bank Transfer',
                  'Jazz Cash',
                  'easyPaisa',
                  'Cheque',
                  'Mobile Wallet'
                ]
                    .map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  cashInController.paymentMethod.value = value!;
                },
              ),

              DropdownButtonFormField<String>(
                value: cashInController.accountType.value,
                decoration: const InputDecoration(labelText: 'AccountType'),
                items: ['Revenue', 'liability', 'Asset']
                    .map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  cashInController.accountType.value = value!;
                },
              ),
              const SizedBox(height: 20),


              const Text('Payer Details', style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),),

              const SizedBox(height: 20,),

              TextFormField(
                controller: cashInController.payerNameController,
                decoration: const InputDecoration(labelText: 'Payer Name'),
                maxLines: 3,
              ),

              TextFormField(
                controller: cashInController.payerAccountNumberController,
                decoration: const InputDecoration(
                    labelText: 'Payer Account Number'),
                maxLines: 3,
              ),
              TextFormField(
                controller: cashInController.payerDetailsController,
                decoration: const InputDecoration(labelText: 'Payer Details'),
                maxLines: 3,
              ),

              TextFormField(
                controller: cashInController.notesController,
                decoration: const InputDecoration(labelText: 'Remarks'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () => cashInController.submitForm(_formKey, context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red),
                child: const SizedBox(width: 150, height: 20,
                    child: Center(child: Text('Submit'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  // Date Picker Function
//   _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
// }



// String cashSource = 'Salary';
// String paymentMethod = 'Cash';
// String Month = 'January';
// String accountType = 'Revenue';
//
// DateTime selectedDate = DateTime.now();
//
// final TextEditingController notesController = TextEditingController();
// final TextEditingController _amountController = TextEditingController();
// final TextEditingController payerDetailsController = TextEditingController();
// final TextEditingController payerNameController = TextEditingController();
// final TextEditingController payerAccountNumberController = TextEditingController();
//
//
// String currentUserId = FirebaseAuth.instance.currentUser!.uid;
// double? currentBalance;
// double? totalExpense;
// double? totalIncome;
//
//
// storeData() async {
//
//   double amountIn = double.tryParse(_amountController.text.toString().trim()) ?? 0;
//
//   String TransactionId = FirebaseFirestore.instance.collection('users').doc().id;
//   final query = FirebaseFirestore.instance.collection("users").doc(currentUserId);
//
//   var data = await query.get();
//   currentBalance = data['currentBalance'].toDouble() ?? 0;
//   totalExpense = data['totalExpense'].toDouble() ?? 0;
//   totalIncome = data['totalIncome'].toDouble() ?? 0;
//
//   double newBalance = currentBalance! + amountIn;
//
//
//
//
//   await Future.wait([
//     query.update({
//       "currentBalance": newBalance,
//       "totalExpense": totalExpense!,
//       "totalIncome": totalIncome! + amountIn,
//     }),
//     query.collection('income').doc(TransactionId).set({
//       'Category' : cashSource,
//       'Amount': amountIn,
//       'time': DateTime.now(),
//       'month': Month,
//       'monthAndTime': DateTime.now().month,
//       'paymentMethod' : paymentMethod,
//       'PayerDetails': payerDetailsController.text.toString(),
//       'Comments': notesController.text,
//       'type' : accountType,
//       'payerName' : payerNameController.text,
//       'payerAccountNumber' : payerAccountNumberController.text,
//
//
//     }),
//   ]);
//
//   setState(() {
//     _amountController.clear();
//     notesController.clear();
//
//   });
// }