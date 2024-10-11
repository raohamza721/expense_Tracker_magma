

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class  IncomeDataController extends GetxController{

  RxList<QueryDocumentSnapshot> incomeList= <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    fetchBudgetData();
    super.onInit();
  }

  void fetchBudgetData() async {

    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;


     firebaseFirestore.collection('users').doc(currentUserId).collection('income').snapshots().listen((snapshot){
      incomeList.value = snapshot.docs;
    });
  }
}