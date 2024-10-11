import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/getx_controllers/budget_data_fetch_controllers.dart';
import 'package:expense_tracker/getx_controllers/cash_in_data_fetch_controller.dart';
import 'package:expense_tracker/getx_controllers/expense_data_fetch_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> with TickerProviderStateMixin {

  String expenseMonth = 'January';
  String? month = 'January';
  String paymentMethod = 'Cash';
  String categoryExpense = 'Bills';
  String categoryIncome = 'Salary';

  //yes github working

  String incomeTransactionId = FirebaseFirestore.instance.collection('users').doc().id;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  BudgetDataFetchControllers budgetDataFetchControllers = Get.put(BudgetDataFetchControllers());
  IncomeDataController incomeDataController = Get.put(IncomeDataController());
  ExpenseDataController expenseDataController = Get.put(ExpenseDataController());

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.teal, // AppBar color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      controller: tabController,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                      tabs: const [
                        Tab(child: Text('Revenue', style: TextStyle(color: Colors.white))),
                        Tab(child: Text('Expense', style: TextStyle(color: Colors.white))),
                        Tab(child: Text('Budget', style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 700,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      // Revenue Summary Section
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Revenue Summary',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height: 280,
                                  child: Obx(() {
                                    if (incomeDataController.incomeList.isEmpty) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return ListView.builder(
                                        itemCount: incomeDataController.incomeList.length,
                                        itemBuilder: (context, index) {
                                          var data = incomeDataController.incomeList[index];
                                          return ListTile(
                                            leading: const Icon(Icons.arrow_downward, color: Colors.red),
                                            title: Text(data['Category'].toString()),
                                            subtitle: Text('Payment Method: ${data['paymentMethod']}'),
                                            trailing: Text(
                                              'Rs: ${data['Amount']}',
                                              style: const TextStyle(color: Colors.red),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expense Summary Section
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          // const Text('Filter Results'),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // DropdownButton<String>(
                                //   value: expenseMonth,
                                //   items: [
                                //     'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
                                //   ].map((method) {
                                //     return DropdownMenuItem(value: method, child: Text(method));
                                //   }).toList(),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       expenseMonth = value!;
                                //     });
                                //   },
                                // ),
                                // DropdownButton<String>(
                                //   value: categoryExpense,
                                //   elevation: 5,
                                //   items: [
                                //     'Bills', 'Utility', 'Rent', 'Shopping', 'Travel', 'Food', 'Education', 'Other'
                                //   ].map((purpose) {
                                //     return DropdownMenuItem(value: purpose, child: Text(purpose));
                                //   }).toList(),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       categoryExpense = value!;
                                //     });
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Expense Summary',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      height: 280,

                                      child: Obx(() {
                                        if (expenseDataController.expenseList.isEmpty) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount: expenseDataController.expenseList.length,
                                            itemBuilder: (context, index) {
                                              var data = expenseDataController.expenseList[index];
                                              return ListTile(
                                                leading: const Icon(Icons.arrow_downward, color: Colors.red),
                                                title: Text(data['Category'].toString()),
                                                subtitle: Text('Payment Method: ${data['paymentMethod']}'),
                                                trailing: Text(
                                                  'Rs: ${data['Amount']}',
                                                  style: const TextStyle(color: Colors.red),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }),
                                      // child: StreamBuilder<QuerySnapshot>(
                                      //   stream: FirebaseFirestore.instance
                                      //       .collection("users")
                                      //       .doc(currentUserId)
                                      //       .collection('expense')
                                      //       .where('month', isEqualTo: expenseMonth)
                                      //       .snapshots(),
                                      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      //     if (!snapshot.hasData) {
                                      //       return const Center(child: CircularProgressIndicator());
                                      //     }
                                      //
                                      //     var data = snapshot.data!.docs;
                                      //
                                      //     return ListView.builder(
                                      //       itemCount: data.length,
                                      //       itemBuilder: (context, index) {
                                      //         return ListTile(
                                      //           leading: const Icon(Icons.arrow_downward, color: Colors.red),
                                      //           title: Text(data[index]['Category'].toString()),
                                      //           subtitle: Text('Payment Method: ${data[index]['paymentMethod']}'),
                                      //           trailing: Text(
                                      //             'Rs: ${data[index]['Amount']}',
                                      //             style: const TextStyle(color: Colors.red),
                                      //           ),
                                      //         );
                                      //
                                      //
                                      //       },
                                      //     );
                                      //   },
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Budget Summary Section
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Budget Summary',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      height: 500,
                                      child: Obx(() {
                                        if (budgetDataFetchControllers.liabilityList.isEmpty) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount: budgetDataFetchControllers.liabilityList.length,
                                            itemBuilder: (context, index) {
                                              var data = budgetDataFetchControllers.liabilityList[index];

                                              return ExpansionTile(
                                                leading: const Icon(Icons.monetization_on_outlined),
                                                title: Text(data['Product'].toString(),style: const TextStyle(
                                                  color: Colors.green
                                                ),),
                                                    subtitle:Text('Remaining Amount: \$${data['remainingAmount'].toString()}',
                                                        style: const TextStyle(color: Colors.redAccent),),
                                                   children:  [

                                                     Padding(
                                                       padding: const EdgeInsets.symmetric(vertical: 30),
                                                       child: Expanded(
                                                         child: Column(
                                                           children: [

                                                             Row(
                                                               children: [
                                                                 const Text("Seller Name:   ",
                                                                   style: TextStyle(
                                                                     fontSize: 14,
                                                                     color: Colors.grey
                                                                   ),),
                                                                 Expanded(

                                                                   child: Text(data['SellerName'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.blue
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Row(
                                                               children: [
                                                                 const Text("Seller Contact:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['SellerContact'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.blue
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Divider(thickness: 2,indent: 20,endIndent: 20,),
                                                             Row(
                                                               children: [
                                                                 const Text("Buyer Name:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['BuyerName'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.blue
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Row(
                                                               children: [
                                                                 const Text("Buyer Contact:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['BuyerContact'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.blue
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             Divider(thickness: 2,indent: 20,endIndent: 20,),
                                                             Row(
                                                               children: [
                                                                 const Text("Product Price:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['ProductPrice'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.green
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Row(
                                                               children: [
                                                                 const Text("Down Payment:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['DownPayment'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.teal
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Row(
                                                               children: [
                                                                 const Text("Remaining Amount:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['remainingAmount'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.red
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                             SizedBox(height: 10,),
                                                             Divider(thickness: 2,indent: 20,endIndent: 20,),
                                                             Row(
                                                               children: [
                                                                 const Text("Total Instalments:   ",
                                                                   style: TextStyle(
                                                                       fontSize: 14,
                                                                       color: Colors.grey
                                                                   ),),
                                                                 Expanded(
                                                                   child: Text(data['noOfInstallments'].toString(),
                                                                     style: const TextStyle(
                                                                         fontSize: 14,
                                                                         color: Colors.red
                                                                     ),),
                                                                 ),
                                                               ],
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                     ),


                                                     
                                                     ],
                                                 );
                                            },
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



































// StreamBuilder(
//   stream: FirebaseFirestore.instance
//       .collection("users")
//       .doc(currentUserId)
//       .collection("transactions")
//       .doc('income')
//       .collection('month')
//       .doc(Month)
//       .collection('category')
//       .doc(Category)
//       .collection('PaymentMethod')
//       .doc(paymentMethod)
//       .snapshots(),
//   builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//     if (!snapshot.hasData) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     var data = snapshot.data!.data() as Map<String, dynamic>?;
//
//     if (data == null) {
//       return const Text('No data available');
//     }
//
//     // Use the fetched data for display, since it's a single document, not a list.
//     return ListTile(
//       leading: const Icon(Icons.arrow_upward, color: Colors.green),
//       title: Text(data['Category'].toString()),
//       subtitle: Text('Payment Method: ${data['paymentMethod']}'),
//       trailing: Text(
//         'Rs: ${data['IncomeAmount']}',
//         style: const TextStyle(color: Colors.green),
//       ),
//     );
//   },
// ),

// Expense Section
// Card(
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(15),
//   ),
//   elevation: 4,
//   child: Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Expense Summary',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         // StreamBuilder for Expense Total
//         StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(currentUserId)
//               .snapshots(),
//           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             var data = snapshot.data!;
//             return Text(
//               'Total Expense: Rs ${data['totalExpense'] ?? 0}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//
//         const SizedBox(height: 16), // Spacing
//
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SizedBox(height: 280,
//             child: Expanded(
//               child:StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(currentUserId).collection('expense')
//                     .orderBy("time", descending: true)
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   var data = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: const Icon(Icons.arrow_downward, color: Colors.red),
//                         title: Text(data[index]['Category'].toString()),
//                         subtitle: Text('Payment Method: ${data[index]['paymentMethod']}'),
//                         trailing: Text(
//                           'Rs: ${data[index]['Amount']}',
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//
//             ),
//           ),
//         ),
//     ],
//     ),
//   ),
// ),