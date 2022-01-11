import 'package:flutter/material.dart';
import 'LOGIN_SCREEN.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class signup extends StatefulWidget {
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Center(
          child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.medipol.edu.tr/medium/GalleryImage-Image-2016.vsf'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Center(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Sign Up',
                                style:
                                    TextStyle(fontSize: 30, color: Colors.blue),
                              ),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                        ),
                      ),
                      Container(
                        //kenar konumları
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          //sifre gizlenecek mi? gizlenmeyecek mi?
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Divider(
                        height: 40,
                      ),
                      Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text('Create Account'),
                            onPressed: () async {
                              try {
                                var user = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.user!.uid)
                                    .set({
                                  'email': emailController.text,
                                  'psw': passwordController.text,
                                  'username': nameController.text,
                                  'uid': user.user!.uid,
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                                Alert(
                                  context: context,
                                  title: "",
                                  desc: "User signed in succesfully.",
                                  image: Image.network(
                                    "https://cdn.pixabay.com/photo/2016/03/31/14/37/check-mark-1292787_1280.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OKAY",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                      radius: BorderRadius.circular(0.0),
                                    ),
                                  ],
                                ).show();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: " WARNING",
                                    desc: "Weak Password!\nPlease add more.",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "GO BACK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                } else if (e.code == 'email-already-in-use') {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "WARNING!",
                                    desc:
                                        "This user is already exist! Change your e-mail adress.",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "GO BACK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                          )),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                    ],
                  ),
                ),
              )),
        ));
  }
}
