
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/product_details.dart';
import 'package:share/share.dart';
import 'LOGIN_SCREEN.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'product_details.dart';

class mainpage extends StatefulWidget {
  const mainpage({ Key? key }) : super(key: key);

  @override
  _mainpageState createState() => _mainpageState();
}
 class Product {
   String productname;
   String productdesc;
   String productprice;
   String productimage;

   Product({required this.productname, required this.productdesc, required this.productprice, required this.productimage});
}

class _mainpageState extends State<mainpage> {  
    int selectedIndex = -1;
    int buttonIndex = -1;
    int favIndex = 1;
  bool _hasBeenPressed = false;

 Color icon1Color = Colors.black;
 
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
    CollectionReference purchasedRef = _firestore.collection('purchased_products');

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
              Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              )),
            StreamBuilder<QuerySnapshot>(
              stream: productRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                 if(asyncSnapshot.hasError){
                   return Center(child: Text('hata oluştu'));
                 } else{

                      if(asyncSnapshot.hasData){
                        List<DocumentSnapshot> listOfDocumentSnap = asyncSnapshot.data.docs;

                         return ListView.builder(
                           shrinkWrap: true,
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context,index){         

                          return Card(                                                      
                            color: Colors.white24,
                            elevation: 1,
                            shadowColor: Colors.amber,                            
                            child: ListTile(     
                                                                                                                 
                              trailing: RaisedButton(
         color: Colors.green,
          child: const Text('Buy'),
          ///// buy butonu indexinin olduğu yerdeki verileri purchased_products'a aktar                  
           onPressed: () async{
             setState(() {
               buttonIndex=index;
             });
                        Map<String, dynamic> productData={                         
                          'productname':listOfDocumentSnap[buttonIndex].get('productname'),
                          'productdesc':listOfDocumentSnap[buttonIndex].get('productdesc'),
                          'productprice':listOfDocumentSnap[buttonIndex].get('productprice'),
                          };
                        await purchasedRef.doc(Uuid().v1()).set(productData);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage()),);
                      },          
        ),        
                          onTap: (){
                setState(() {
                  selectedIndex=index;                                                        
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => product_details(
                  productname:listOfDocumentSnap[selectedIndex].get('productname'),
                  productdesc: listOfDocumentSnap[selectedIndex].get('productdesc'),
                  productprice:listOfDocumentSnap[selectedIndex].get('productprice'),
                                   
                  )
                  ));
              },
                
                              leading: Icon(Icons.shop, size: 29),
                              title:  Text(                           
                              '${listOfDocumentSnap[index].get('productname')}',
                            style: TextStyle(fontSize: 18,)),
                          
                            subtitle:  Row(
                              children: [
                                Text(
                                  '${listOfDocumentSnap[index].get('productprice')}' ' ' 'TL',
                                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
      
                      IconButton(
                        icon: Icon(Icons.share_outlined),
                        onPressed: (){
                          Share.share(" https://play.google.com/store/apps/details?id=com.instructivetech.kidskite");
                        }, 
                        ),
                     IconButton(
                       onPressed: () {
                         setState(() {
                           _hasBeenPressed = !_hasBeenPressed;
                         });   
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: _hasBeenPressed ? Colors.pink : Colors.black,  ),
                          ),                              
                              ],
                            ),                                                        
                            ),
                          );                        
                        },
                      );
                      } else{
                        return Center(child: CircularProgressIndicator());
                      }
                 }                                                                           
              },
            )
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
                hintText: "Price (\TL)",                                              
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
            children: [
              Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Purchased Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              )),
            StreamBuilder<QuerySnapshot>(
              stream: purchasedRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                 if(asyncSnapshot.hasError){
                   return Center(child: Text('hata oluştu'));
                 } else{
                      if(asyncSnapshot.hasData){
                        List<DocumentSnapshot> listOfDocumentSnap = asyncSnapshot.data.docs;
                         return ListView.builder(
                           shrinkWrap: true,
                        itemCount: listOfDocumentSnap.length,
                        itemBuilder: (context,index){         

                          return Card(                          
                            color: Colors.white24,
                            child: ListTile(
                         
                
                              leading: Icon(Icons.check, size: 50, color: Colors.green,),
                              title:  Text(                           
                              '${listOfDocumentSnap[index].get('productname')}',
                            style: TextStyle(fontSize: 18)),
                            subtitle:  Text(
                              '${listOfDocumentSnap[index].get('productprice')}' ' ' 'TL',
                            style: TextStyle(fontSize: 16, color: Colors.red)),
                            ),
                          );
                        
                        },
                      );
                      } else{
                        return Center(child: CircularProgressIndicator());
                      }
                 }                                                                           
              },
            )
            ],
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