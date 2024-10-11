


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/expense_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashInController extends GetxController{

  RxString cashSource = 'Salary'.obs;
  RxString paymentMethod = 'Cash'.obs;
  RxString Month = 'January'.obs;
  RxString accountType = 'Revenue'.obs;

  var selectedDate = DateTime.now().obs;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController payerDetailsController = TextEditingController();
  final TextEditingController payerNameController = TextEditingController();
  final TextEditingController payerAccountNumberController = TextEditingController();


  String currentUserId = FirebaseAuth.instance.currentUser!.uid;


  RxDouble? currentBalance = 0.0.obs;
  RxDouble? totalExpense = 0.0.obs;
  RxDouble? totalIncome = 0.0.obs;




 void storeData() async {

    double amountIn = double.tryParse(amountController.text.toString().trim()) ?? 0;

    String TransactionId = FirebaseFirestore.instance.collection('users').doc().id;
    final query = FirebaseFirestore.instance.collection("users").doc(currentUserId);

    var data = await query.get();
    currentBalance!.value = data['currentBalance'].toDouble() ?? 0;
    totalExpense!.value = data['totalExpense'].toDouble() ?? 0;
    totalIncome!.value = data['totalIncome'].toDouble() ?? 0;

    double newBalance = currentBalance!.value + amountIn;


    await Future.wait([
      query.update({
        "currentBalance": newBalance,
        "totalExpense": totalExpense!.value,
        "totalIncome": totalIncome!.value + amountIn,
      }),
      query.collection('income').doc(TransactionId).set({
        'Category': cashSource.value,
        'Amount': amountIn,
        'time': DateTime.now(),
        'month': Month.value,
        'monthAndTime': DateTime.now().month,
        'paymentMethod': paymentMethod.value,
        'PayerDetails': payerDetailsController.text.toString(),
        'Comments': notesController.text,
        'type': accountType.value,
        'payerName': payerNameController.text,
        'payerAccountNumber': payerAccountNumberController.text,


      }),
    ]);

  }

  void submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      storeData();
      Get.snackbar('Success', 'Successfully Added', backgroundColor: Colors.green, colorText: Colors.white);
      Get.to(ExpenseScreen());

    } else {
      Get.snackbar('Error', 'Please fill required fields', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
    }
  }
}
