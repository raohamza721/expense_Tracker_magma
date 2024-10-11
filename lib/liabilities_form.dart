import 'package:expense_tracker/getx_controllers/budgetController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';



class BudgetForm extends StatefulWidget {
  const BudgetForm({super.key});

  @override
  BudgetFormState createState() => BudgetFormState();
}

class BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();

  budgetController formbudgetController = Get.put(budgetController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Seller Details Section
                const Text('Seller Details', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),

                TextFormField(
                  controller: formbudgetController.sellerNameController,
                  decoration: const InputDecoration(labelText: 'Seller Name',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the seller\'s name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10,),



                TextFormField(
                  controller: formbudgetController.sellerContactController,
                  decoration: const InputDecoration(labelText: 'Seller Contact', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the seller\'s contact number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                 const Text('Buyer Details', style: TextStyle(
                   fontSize: 18,
                     fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),

                TextFormField(
                  controller: formbudgetController.buyerNameController,
                  decoration: const InputDecoration(labelText: 'Buyer Name',border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the buyer\'s name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),

                TextFormField(
                  controller: formbudgetController.buyerContactController,
                  decoration: const InputDecoration(labelText: 'Buyer Contact',border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the buyer\'s contact number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                 const Text('Product Details',style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 18,
                 ),),

                const SizedBox(height: 10,),


                TextFormField(
                  controller: formbudgetController.priceController,
                  decoration: const InputDecoration(labelText: 'Product Price',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the  price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),

                TextFormField(
                  controller: formbudgetController.downPaymentController,
                  decoration: const InputDecoration(labelText: 'Down Payment',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the down payment';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    formbudgetController.calculateRemainingAmount();
                  },
                ),
                const SizedBox(height: 20),


                Obx(()=>Text(
                  'Remaining Amount: \$${formbudgetController.remainingAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),),


                const SizedBox(height: 20),

                // Installment Section
                TextFormField(
                  controller: formbudgetController.installmentController,
                  decoration: const InputDecoration(labelText: 'Number of Installments',border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter installment ';

                    }
                    return null;
                  },
                  onChanged: (value) {
                      int installmentCount = int.tryParse(value) ?? 0;
                      formbudgetController.installmentDates.value = List<DateTime>.generate(installmentCount, (index) => DateTime.now());
                  },
                ),
                const SizedBox(height: 20),
                const Text('Installment Dates', style: TextStyle(fontWeight: FontWeight.bold)),

                Obx(()=>

                    SizedBox(
                      height: 150,  // Fixed height for the list view
                      child: ListView.builder(
                        itemCount: formbudgetController.installmentDates.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                            Text(
                              formbudgetController.installmentDates[index]!=null ?
                              'Installment ${index + 1}: ${DateFormat('yyyy-MM-dd').format(formbudgetController.installmentDates[index])}'
                                  : 'Installment ${index + 1}: Select a Date',
                            ),
                            trailing: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => formbudgetController.selectDate(context, index)
                            ),
                          );

                        },
                      ),
                    ),

                ),



                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => formbudgetController.submitForm(_formKey , context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red ),
                    child: const SizedBox(width: 150, height: 20,
                        child: Center(child: Text('Submit'))),
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
