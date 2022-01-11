// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, prefer_const_constructors, duplicate_ignore, file_names, deprecated_member_use, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'signup.dart';
import 'mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//giriş sayfası-giriş yap fonksiyonu
  Future<void> girisyap() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((kullanici) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => mainpage()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Alert(
          context: context,
          type: AlertType.error,
          title: " WARNING",
          desc: "User not found!\nPlease sign up.",
          buttons: [
            DialogButton(
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => signup())),
              width: 120,
            )
          ],
        ).show();
      } else if (e.code == 'wrong-password') {
        Alert(
          context: context,
          type: AlertType.error,
          title: "WARNING!",
          desc: "Wrong password!",
          buttons: [
            DialogButton(
              child: Text(
                "GO BACK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
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
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Divider(),
                Divider(),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: (){
                              girisyap();
                            },
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Don\'t have an account?'),
                    FlatButton(
                      textColor: Colors.white70,
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signup()),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}