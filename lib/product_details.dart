import 'package:flutter/material.dart';

class product_details extends StatefulWidget {
  String productname,productdesc,productprice;
   product_details({required this.productname,required this.productdesc,required this.productprice});  

  @override
  _product_detailsState createState() => _product_detailsState();
}

class _product_detailsState extends State<product_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios)  //back button
        ),
         title: Center(
        child: Padding(
          padding: const EdgeInsets.only(right:50.0),
          child: Text(
            widget.productname
            ),
        ),
      )
      ),
      body: Column(
        children: [
              Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: CircleAvatar(
                  backgroundImage: NetworkImage("https://www.kindpng.com/picc/m/78-786207_user-avatar-png-user-avatar-iconpng-transparent.png"),
                  radius: 95,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [              
                     Text("Product Description: ", style: TextStyle(fontWeight: FontWeight.bold)),              
                     Text(widget.productdesc)
                ],
              ),
            ),
          ),
          Padding(
                      padding: const EdgeInsets.only(left: 27.0),
                      child: Row(
                        children: [                        
                            Text("Product Price: ", style: TextStyle(fontWeight: FontWeight.bold)),                        
                            Text(widget.productprice),
                        ],
                      ),
                    ),
      ],),
    );
  }
}