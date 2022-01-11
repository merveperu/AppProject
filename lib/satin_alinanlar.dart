import 'package:flutter/material.dart';

class satin_alinanlar extends StatefulWidget {
  const satin_alinanlar({ Key? key }) : super(key: key);

  @override
  _satin_alinanlarState createState() => _satin_alinanlarState();
}

class _satin_alinanlarState extends State<satin_alinanlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchased Products"),
      ),
       body:  Column(
        children: [
          Container(
            width: 200,
            height: 200,
            child: Image.network(
                "https://cdn.cimri.io/image/1200x1200/ceptelefonufiyatlar_178954840.jpg"),
          ),
          Container(
              width: 200,
              height: 200,
              child: Column(
                children: [
                  //adı ve özelliği
                  Text(                    
                    "Samsung Galaxy A32 128 Gb Smart Phone Black",
                    style: TextStyle(                      
                      fontSize: 16,
                      color: Colors.blue[900],
                    ),
                  ),
                  //fiyatı
                  Text(
                    "\$ 320.07",
                    style: TextStyle(fontSize: 15, color: Colors.blue[900]),
                  ),                 
                ],
              )
              ),
        ],
      ),
    );
  }
}