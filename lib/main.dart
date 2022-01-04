
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LOGIN_SCREEN.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({ Key? key }) : super(key: key);

    Future testData() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('product_details').get();
    var details = data.docs.toList();
    details.forEach((item) {
      print(item.id);
      });          
  }

  @override
  Widget build(BuildContext context) {
    testData();
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue), 
        home: LoginPage()
        );
  }
}