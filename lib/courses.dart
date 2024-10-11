import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  final List<String> courses = ['English', 'Math', 'Urdu', 'Computer'];

  final List<IconData> courseIcons = [Icons.text_fields, Icons.calculate, Icons.ac_unit, Icons.computer];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final icon = courseIcons[index]; // Get the corresponding icon
                  return Card(elevation: 5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),color: Colors.white,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.white10,
                            child:
                        Icon(icon,color: Colors.lightBlue,)), // Pass the specific IconData
                        title: Text(course,style: const TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold),),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 8),
                              child: Text('Quiz', style: TextStyle(color: Colors.blue),),
                            ),
                            // SizedBox(height:4,),
                            LinearProgressIndicator(
                              color: Colors.lightBlue,
                              backgroundColor: Colors.lightBlue,),

                          ],
                        ),
                        trailing: const Icon(Icons.navigate_next,color: Colors.teal,),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
