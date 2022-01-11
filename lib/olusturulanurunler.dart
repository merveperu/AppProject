import 'package:flutter/material.dart';
import 'package:share/share.dart';

class olusturulanurunler extends StatefulWidget {
  const olusturulanurunler({ Key? key }) : super(key: key);

  @override
  _olusturulanurunlerState createState() => _olusturulanurunlerState();
}

class _olusturulanurunlerState extends State<olusturulanurunler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Created Products"),
      ),
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              child: Image.network(
                  "https://images-na.ssl-images-amazon.com/images/I/81u7h7LXvdL.jpg"),
            ),
          ),
          Container(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  //adı ve özelliği
                  Text(                    
                    "Introduction to Automata Theory, Formal Languages and Computation",
                    style: TextStyle(                      
                      fontSize: 16,
                      color: Colors.blue[900],
                    ),
                  ),
                  //fiyatı
                  Text(
                    "\$ 6.00",
                    style: TextStyle(fontSize: 15, color: Colors.blue[900]),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                                                                   
                          IconButton(icon: Icon(Icons.share_outlined) ,onPressed: (){
                          Share.share(" https://play.google.com/store/apps/details?id=com.instructivetech.kidskite");
                        }, 
                        ),                                                                                                 
                    ],
                  ),
                ],
              )
              ),
        ],
      ),
    );
    
  }
}