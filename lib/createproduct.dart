import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'mainpage.dart';


class createproduct extends StatefulWidget {
  const createproduct({ Key? key }) : super(key: key);

  @override
  _createproductState createState() => _createproductState();
}


class _createproductState extends State<createproduct> {

File? image;

  Future pickImage(ImageSource source) async{
    try{

    final image = await ImagePicker().pickImage(source: source);
    if(image==null) return;

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
  Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Product"),
      ),
      body: Container(
        child: ListView(
          children:[
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Column(
                children: [
                  image != null ? Image.file(
                  image!,
                  width: 180,
                  height: 180,
                )
                   : Image.network("https://icon-library.com/images/no-image-icon/no-image-icon-0.jpg",width: 180,
                  height: 180,)
                ],                          
              ),              
            ),

            const SizedBox(
              height: 15.0,
            ),
             
             
             Padding(
               padding: const EdgeInsets.all(8.0),               
               child: Center(
                 child: MaterialButton(                 
                          color: Colors.blue,                  
                          child: Text("Upload Photo",
                          style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold),                        
                          ),
                          onPressed: () {
                            _choose(context);
                          },                      
            ),
               ),
             ),
                              
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: new TextField(
              decoration: new InputDecoration(
                hintText: "Product Name",
              ),
          ),
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: new ListTile(
                leading: const Icon(Icons.sell),
                title: 
                
                TextField(                  
                  keyboardType: TextInputType.number,
                decoration: InputDecoration(                  
                hintText: "Price (\$)",                                              
            ),            
          ),                            
            ),                                
             ),                         
            
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                 child: MaterialButton(
                      color: Colors.blue,                  
                      child: 
                      Text("Sell",style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),                        
                      ),
                      onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage()),);
                      },
                    ),
               ),
             ),
                
          ],
        ),
      ),
    );
  }

  void _choose(BuildContext context) {
    showDialog(
      context: context, 
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:<Widget> [
          ListTile(
            title: Text("Pick Gallery"),
            onTap: (){
              pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            title: Text("Pick Camera"),
            onTap: (){
              pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    ),
    );
  }
  
}