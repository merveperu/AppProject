import 'package:flutter/material.dart';
import 'package:share/share.dart';


class favorites extends StatefulWidget {
  const favorites({ Key? key }) : super(key: key);

  @override
  _favoritesState createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  Color fav1 = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                      
                      Row(
                        children: [
                           IconButton(icon: Icon(Icons.share_outlined) ,onPressed: (){
                          Share.share(" https://play.google.com/store/apps/details?id=com.instructivetech.kidskite");
                        }, ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Buy"),
                          ),
                          
                        ],
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