import 'package:flutter/material.dart';

class product_details extends StatefulWidget {

  String productname, productdesc, productimage;

   product_details({required this.productname,required this.productdesc, required this.productimage});

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
          Expanded(
            child: ListView(
              children: [
                          Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.network(widget.productimage, height: 350, width: 280)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [              
                    // flexible is for prevent overflowing
                           Flexible(child: Text("Product Description: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),       
                           Flexible(child: Text(widget.productdesc, style: TextStyle(fontSize: 15),))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}