import 'package:expense_tracker/expense_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class budgetController extends GetxController{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for form fields
  final TextEditingController priceController = TextEditingController();
  final TextEditingController downPaymentController = TextEditingController();
  final TextEditingController installmentController = TextEditingController();

  final TextEditingController sellerNameController = TextEditingController();
  final TextEditingController sellerContactController = TextEditingController();

  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController buyerContactController = TextEditingController();

  String? currentUserId;
  RxList<DateTime> installmentDates = <DateTime>[].obs;
  RxDouble remainingAmount = 0.0.obs;

  RxDouble? currentBalance = 0.0.obs;
  RxDouble? totalExpense = 0.0.obs;
  RxDouble? totalIncome = 0.0.obs;

  @override
  void onInit() {
    currentUserId = _auth.currentUser?.uid;
    super.onInit();
  }

  // Function to calculate remaining amount
  void calculateRemainingAmount() {
    double price = double.tryParse(priceController.text) ?? 0;
    double downPayment = double.tryParse(downPaymentController.text) ?? 0;
    remainingAmount.value = price - downPayment;
  }

  // Function to store liability data in Firestore
  Future<void> storeDataLiability() async {
    if (currentUserId == null) return;

    String transactionId = _firestore.collection('users').doc().id;
    final query = _firestore.collection("users").doc(currentUserId);

    var data = await query.get();
    currentBalance!.value = data['currentBalance'].toDouble() ?? 0;
    totalExpense!.value = data['totalExpense'].toDouble() ?? 0;
    totalIncome!.value = data['totalIncome'].toDouble() ?? 0;

    await Future.wait([
      query.update({
        "currentBalance": currentBalance!.value,
        "totalExpense": totalExpense!.value,
        "totalIncome": totalIncome!.value,
      }),
      query.collection('liability').doc(transactionId).set({
        'BuyerName': buyerNameController.text,
        'BuyerContact': buyerContactController.text,
        'time': DateTime.now(),
        'monthAndTime': DateTime.now().month,
        'SellerName': sellerNameController.text,
        'SellerContact': sellerContactController.text,
        'ProductPrice': priceController.text,
        'DownPayment': downPaymentController.text,
        'remainingAmount': remainingAmount.value,
        'noOfInstallments': installmentController.text,
        'DatesOfInstallments': installmentDates.map((date) => date.toIso8601String()).toList(),
      }),
    ]);
  }

  // Function to select installment date
  Future<void> selectDate(BuildContext context, int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      installmentDates[index] = pickedDate;
    }
  }

  // Function to handle form submission
  void submitForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      storeDataLiability();
      Get.snackbar('Success', 'Successfully Added', backgroundColor: Colors.green, colorText: Colors.white);
      Get.to(ExpenseScreen());

    } else {
      Get.snackbar('Error', 'Please fill required fields', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    priceController.dispose();
    downPaymentController.dispose();
    installmentController.dispose();
    sellerNameController.dispose();
    sellerContactController.dispose();
    buyerNameController.dispose();
    buyerContactController.dispose();
    super.dispose();
  }
}