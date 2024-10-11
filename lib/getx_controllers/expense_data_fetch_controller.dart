




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExpenseDataController extends GetxController{

  RxList<QueryDocumentSnapshot> expenseList = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    fetchExpenseData();
    super.onInit();
  }

  void fetchExpenseData() async {

    String currentUserId =  FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('expense').snapshots().listen((snapshot){

      expenseList.value = snapshot.docs;
    });
  }
}