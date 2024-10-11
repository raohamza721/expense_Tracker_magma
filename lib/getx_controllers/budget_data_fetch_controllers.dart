
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BudgetDataFetchControllers extends GetxController {

  RxList<QueryDocumentSnapshot> liabilityList = <QueryDocumentSnapshot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBudgetData();
  }

  fetchBudgetData() {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      print('User not logged in');
      return; // Exit if the user is not logged in
    }

    FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('liability')
        .snapshots()
        .listen((snapshot) {
      liabilityList.value = snapshot.docs;
    }, onError: (error) {
      print('Error fetching data: $error'); // Handle error
    });
  }
}
