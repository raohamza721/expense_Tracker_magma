import 'dart:core';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/cash_in_form.dart';
import 'package:expense_tracker/cash_out_Form.dart';
import 'package:expense_tracker/expense_details.dart';
import 'package:expense_tracker/liabilities_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}
class _ExpenseScreenState extends State<ExpenseScreen> {

  String selectIncomeExpense = 'expense';

  // String selectedExpense = 'expense';

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child:  Text("Expense Tracker",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text("Current Balance",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blue),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            } else {
                              var data = snapshot.data!;
                              return Text(
                                "Rs: ${data['currentBalance']!.toString()}",
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                              );
                            }
                          },
                        ),
          
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 10,
                      shadowColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: SizedBox(
                        height: 100,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_upward_outlined, color: Colors.green, size: 36),
                            const SizedBox(height: 8),
                            const Text('Cash In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('0');
                                }
                                var data = snapshot.data!;
                                return Text(data['totalIncome'].toString(), style: const TextStyle(fontSize: 16));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      shadowColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: SizedBox(
                        height: 100,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red, size: 36),
                            const SizedBox(height: 8),
                            const Text('Cash Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('0');
                                }
                                var data = snapshot.data!;
                                return Text(data['totalExpense'].toString(), style: const TextStyle(fontSize: 16));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          
          
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(height: 280,
                    child: Expanded(
                      child:StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUserId)
                            .collection(selectIncomeExpense)
                            .orderBy("time", descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
          
                          var data = snapshot.data!.docs;
          
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.monetization_on, color: Colors.blue),
                                title: Text(data[index]['Category'].toString()),
                                subtitle: Text('Payment Method: ${data[index]['paymentMethod']}'),
                                trailing: Text(
                                  'Rs: ${data[index]['Amount']}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CashInForm()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: Colors.teal,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const
                      Text('Cash In', style: TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(height: 20),
          
                    ElevatedButton(
          
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CashOutForm()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shadowColor: Colors.redAccent,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cash Out', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
          
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetForm()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.blue,
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Purchase Budget', style: TextStyle(fontSize: 14)),
                  ),
                ),
          
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseDetails()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.blue,
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Transactions', style: TextStyle(fontSize: 14)),
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

































// class ExpenseScreen extends StatefulWidget {
//   const ExpenseScreen({super.key});
//
//   @override
//   State<ExpenseScreen> createState() => _ExpenseScreenState();
// }
//
// class _ExpenseScreenState extends State<ExpenseScreen> {
//
//
//   String? _selectedItems ;
//   List<String> items = ['Salary', 'Others','Grocery','Utility','Entertainment','Rent',];
//
//  // final TextEditingController _expenseAndIncomeController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _expenseController = TextEditingController();
//
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   Future<void> _AddExpensesAndAmount() async {
//     //String expenseIncomeName = _expenseAndIncomeController.text.trim();
//     String amount = _amountController.text..toString().trim();
//     String expense = _expenseController.text.trim();
//
//
//     if (amount.isNotEmpty && expense.isNotEmpty) {
//       DocumentReference docRef = firestore.collection('expenseTrack').doc();
//       await docRef.set({
//         'expensesAndIncome': _selectedItems,
//         'ExpenseId': docRef.id,
//         'amount': amount,
//        'expense' : expense,
//         'created_at': Timestamp.now(),
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Expense/Amount Added')),
//       );
//       // _expenseAndIncomeController.clear();
//      _amountController.clear();
//      // _expenseController.clear();
//
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please Enter Your Data')),
//       );
//     }
//   }
//
//   Map<String, double> calculateTotals(List<QueryDocumentSnapshot> data) {
//     double totalIncome = 0.0;
//     double totalExpense = 0.0;
//
//     for (var doc in data) {
//       double amount = double.tryParse(doc['amount']) ?? 0.0;
//
//       (amount > 0) ? totalIncome += amount : totalExpense += amount;
//     }
//     return {
//       'totalIncome': totalIncome,
//       'totalExpense': totalExpense,
//       'balance': totalIncome + totalExpense,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               const Text(
//                 "Expense Tracker",
//                 style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               const SizedBox(height: 20),
//               const Text("Your Balance",style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black54),
//               ),
//               const SizedBox(height: 10),
//               StreamBuilder<QuerySnapshot>(
//                 stream: firestore.collection('expenseTrack').orderBy('created_at', descending: false).snapshots(),
//                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   var data = snapshot.data!.docs;
//                   var totals = calculateTotals(data);
//
//                   return Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(20.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade300,
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Rs: ",
//                                   style: TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                                 Text(
//                                   totals['balance']!.toStringAsFixed(2),
//                                   style: const TextStyle(
//                                     fontSize: 36,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           buildSummaryCard(
//                             label: 'Income',
//                             amount: totals['totalIncome']!.toStringAsFixed(2),
//                             icon: Icons.arrow_upward_outlined,
//                             iconColor: Colors.green,
//                           ),
//                           buildSummaryCard(
//                             label: 'Expense',
//                             amount: totals['totalExpense']!.toStringAsFixed(2),
//                             icon: Icons.arrow_downward_outlined,
//                             iconColor: Colors.red,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 40),
//
//                       const Card(elevation: 10,color: Colors.white,
//                         child: ListTile(
//
//                           leading: Icon(Icons.monetization_on_sharp),
//                           title: Text('Expense/Income'),
//                           trailing: Row(
//
//                             mainAxisSize: MainAxisSize.min,
//
//                             children: <Widget>[
//                               Icon(Icons.arrow_upward_outlined,color: Colors.greenAccent,),
//                               SizedBox(width: 40,),
//                               Icon(Icons.arrow_downward_outlined,color: Colors.red)
//
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 250,
//                         child: Card(
//                           elevation: 3,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//
//
//                           child: ListView.builder(
//                             itemCount: data.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return ListTile(
//                                 leading: const Icon(Icons.monetization_on_rounded, color: Colors.blueGrey),
//                                 title: Text(data[index]['expensesAndIncome'], style: const TextStyle(fontSize: 16)),
//                                 trailing:Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget> [
//                                     Text(
//                                       ' ${data[index]['amount']}',
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         color: Colors.green
//                                          ),
//                                     ),
//
//                                     const SizedBox(width: 70,),
//                                      Text('${data[index]['expense']}',
//
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.red
//                                     ),
//                                     )],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//               const Text('Add New Transaction',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
//               ),
//               const SizedBox(height: 20),
//
//               DropdownButton<String?>(
//                 value: _selectedItems,
//                 hint: const Text('Expense/Income?'),  // Placeholder text
//                 items: items.map((String item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item,style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal
//                     ),),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedItems = newValue;
//                   });
//                 },
//               ),
//               // buildTextField(_expenseAndIncomeController, 'EXPENSE/INCOME NAME'),
//                const SizedBox(height: 10),
//               buildTextField(_amountController, 'Income'),
//               const SizedBox(height: 10),
//               buildTextField(_expenseController, 'Expense'),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _AddExpensesAndAmount,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 8,
//                     shadowColor: Colors.black54,
//                   ),
//                   child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build summary cards for Income and Expense
//   Widget buildSummaryCard({required String label, required String amount, required IconData icon, required Color iconColor}) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: SizedBox(
//         height: 100,
//         width: 150,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: iconColor, size: 28),
//             const SizedBox(height: 5),
//             Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//             Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build TextField with consistent style
//   Widget buildTextField(TextEditingController controller, String label) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.black87, fontSize: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.all(16),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: const BorderSide(color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }





//
// String? _selectedExpenseItems = 'Expense';
// String? _selectedIncomeItems = 'Income';

// List<String> itemsExpenseName = ['Expense','Grocery', 'Utility', 'Entertainment', 'Rent', 'Education', ];
// List<String> itemsIncomeName= ['Income','Salary', 'Other' ];


// showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return SizedBox(
//         height: 350,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 "Cash Out",
//                 style: TextStyle(fontSize: 24),
//               ),
//               // TextField(
//               //   controller: _transactionNameController,
//               //   decoration: InputDecoration(
//               //     labelText: 'Name',
//               //     border: OutlineInputBorder(
//               //       borderRadius: BorderRadius.circular(12.0),
//               //     ),
//               //   ),
//               // ),
//
//               // DropdownButton<String?>(
//               //   value: _selectedExpenseItems,
//               //   hint: const SizedBox(width: 300,
//               //       child: Text('Choose Expense',style: TextStyle(color: Colors.deepOrangeAccent),)), // Placeholder text
//               //   items: itemsExpenseName.map((String item) {
//               //     return DropdownMenuItem<String>(value: item,
//               //       child: Text(item, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
//               //       ),
//               //     );
//               //   }).toList(),
//               //   onChanged: (String? newValue) {
//               //     setState(() {
//               //       _selectedExpenseItems = newValue!;
//               //     });
//               //   },
//               // ),
//
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _cashOutController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Cash Out',
//                   border: OutlineInputBorder(
//                     borderRadius:
//                         BorderRadius.circular(12.0),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//
//               ElevatedButton(
//                 onPressed: () {
//                   storeData();
//                    // setState(() {
//                    //   _selectedIncomeItems = '';
//                    //  // _amountController.clear();
//                    // });
//
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15, horizontal: 60),
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text('Cash Out',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12)),
//               ),
//             ],
//           ),
//         ),
//       );
//     });