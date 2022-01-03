
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'LOGIN_SCREEN.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class mainpage extends StatefulWidget {
  const mainpage({ Key? key }) : super(key: key);

  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
   Color _icon1Color = Colors.black;
  Color _icon2Color = Colors.black;
  Color _icon3Color = Colors.black;
  
  File? image;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController productnameController = TextEditingController();
  TextEditingController productdescController = TextEditingController();
  TextEditingController productpriceController = TextEditingController();
  TextEditingController productimageController = TextEditingController();

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
    CollectionReference productRef = _firestore.collection('product_details');
    //var babaRef = productRef.doc('Baba');

    return DefaultTabController(
      
      length: 5,  // 5 tane tabBar var
      child: Scaffold(
        appBar: AppBar(
           actions: [                          
             IconButton(
              onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
               icon: Icon(Icons.logout), color: Colors.red),
    ],
          automaticallyImplyLeading: false,  // appBar'dan back butonunu kaldırır
          title: Center(child: Text(""),),
          bottom: TabBar(
            tabs: [  //tabBar başlıkları
            Icon(Icons.home),
            Text("Sell"),  //bu 2 başlığa ikon şimdilik eklemedim karışıklık olmasın diye
            Text("Purchased"),  
            Icon(Icons.favorite),
            Icon(Icons.person)                    
          ]),
      ),
      
      body: TabBarView(
        children: [
          ListView(  // 1. tabBar 
            // burası ana sayfa, yani ürünlerin gösterildiği yer 
            children: [
             


            ],
          ),
          //  ürün satma form oluşturma yeri başlangıç  (sell product tabBar)
          ListView(            
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
               padding: const EdgeInsets.all(2.0),               
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
              padding: const EdgeInsets.all(2.0),
              child: new ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: new TextField(
                  controller: productnameController,
              decoration: new InputDecoration(
                hintText: "Product Name",
              ),
          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: new ListTile(
                leading: const Icon(Icons.description_sharp),
                title: new TextField(
                  controller: productdescController,
              decoration: new InputDecoration(
                hintText: "Product Description",
              ),
          ),
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(2.0),
               child: new ListTile(
                leading: const Icon(Icons.sell),
                title: 
                
                TextField(   
                  controller: productpriceController,               
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
                      onPressed: () async{
                        Map<String, dynamic> productData={                         
                          'productname':productnameController.text,
                          'productdesc':productdescController.text,
                          'productprice':productpriceController.text
                          };
                        await productRef.doc(Uuid().v1()).set(productData);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage()),);                                                          

                      },
                    ),
               ),
             ),
                
          ],
          ),
          // satın alınan ürünler tabBar (purchased product)
             ListView(                                        
            
            ),

            // favorite products
             ListView(            
              
            
            ),

            //created products
            ListView(            
              
            
            ),
      ]),
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