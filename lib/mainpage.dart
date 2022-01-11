
// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'product_details.dart';
import 'package:share/share.dart';
import 'LOGIN_SCREEN.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'product_details.dart';
import 'package:firebase_storage/firebase_storage.dart';

class mainpage extends StatefulWidget {
  const mainpage({ Key? key }) : super(key: key);

  @override
  _mainpageState createState() => _mainpageState();
}
 class Product {
   String productname;
   String productdesc;
   String productimage;

   Product({required this.productname, required this.productdesc, required this.productimage});
}

class _mainpageState extends State<mainpage> with SingleTickerProviderStateMixin { 
   

  User? user = FirebaseAuth.instance.currentUser;      
  Map<String, Color> fav = {};

  File? image;    
  String? url;   //product image url
 
  final _firestore = FirebaseFirestore.instance;

  TextEditingController productnameController = TextEditingController();
  TextEditingController productdescController = TextEditingController();
  TextEditingController productpriceController = TextEditingController();

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

    return DefaultTabController(
      
      length: 5,  // 5 tane tabBar var
      child: Scaffold(
        appBar: AppBar(
           
           actions: [          
             IconButton(
              onPressed: (){
                logout(context);
                  },
               icon: Icon(Icons.logout), color: Colors.red,iconSize: 25,),
    ],
          automaticallyImplyLeading: false,  // appBar'dan back butonunu kaldırır
        
        bottom: menu(),
      ),

      body: TabBarView(
      
        children: [       
          ListView(  // 1. tabBar 
            // burası ana sayfa, yani ürünlerin gösterildiği yer                       
            children: [
          Divider(thickness: 0.1,),
 
           StreamBuilder(
              stream: FirebaseFirestore.instance
              .collection("all_products")                          
             .where('uid', isNotEqualTo: user!.uid)
              .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){                   

                 if(snapshot.hasError){
                   return Center(child: Text('hata oluştu'));
                 } else{

                      if(snapshot.hasData){ 
                        
                        return ListView.builder(
                          
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,

                        itemBuilder: (context,index){  

      Color favorite_color = fav[  snapshot.data!.docs[index]['productname']+" "+snapshot.data!.docs[index]['productdesc']  ] ?? Colors.grey;
                      ////// SHARE 

                  void share(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                             final RenderObject? box = context.findRenderObject();
                             final String text = "${snapshot.data!.docs[index]['productname']} + ${snapshot.data!.docs[index]['productdesc']}";
                             Share.share( 
                               text,
                               subject: snapshot.data!.docs[index]['productname'],   
                              );
                              
                   } 
                  
                          return Card(                                                      
                        color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.blueGrey),  
                  ),

                            child: ListTile(     
                                                                                                           
                            trailing: RaisedButton(
                              color: Colors.green[200],
                              child: const Text('Buy'),
          ///// buy butonu indexinin olduğu yerdeki verileri purchased_products'a aktar, products'dan sil
           onPressed: () async{                                                    
                     await _firestore.collection("users").doc(user!.uid).collection("purchased_products").add({
                          'productimage':snapshot.data!.docs[index]['productimage'],
                          'productname':snapshot.data!.docs[index]['productname'],
                          'productdesc':snapshot.data!.docs[index]['productdesc'],
                          'productprice': snapshot.data!.docs[index]['productprice'],
                        });

                     Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage()),);

                     /// sil 
                  // dokumanreferansı.delete()
                  await snapshot.data!.docs[index].reference.delete();                  

                      },          
        ),        

                 onTap: (){
               
                Navigator.push(context, MaterialPageRoute(builder: (context) => product_details(
                  productimage:snapshot.data!.docs[index]['productimage'],
                  productname:snapshot.data!.docs[index]['productname'],
                  productdesc:snapshot.data!.docs[index]['productdesc'],                
                                   
                  )
                  ));
              },
                
                       leading: Image.network('${snapshot.data!.docs[index]['productimage']}'),

                              title:  Text(                           
                              '${snapshot.data!.docs[index]['productname']}',
                            style: TextStyle(fontSize: 18,)),
                          
                            subtitle:  Row(
                              children: [
                                Text(
                                  '${snapshot.data!.docs[index]['productprice']}' ' ' 'TL',
                                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
      
                      IconButton(                       
                        icon: Icon(Icons.share_outlined),
                        onPressed: (){
                            share(context, snapshot);
                        }, 
                        ),
                     IconButton(
                       icon: Icon(Icons.favorite),
                      color:favorite_color,
                       onPressed: ()  async {                       

                           setState(()  {

                          if (favorite_color==Colors.grey) {
                               fav[  snapshot.data!.docs[index]['productname']+" "+snapshot.data!.docs[index]['productdesc']  ] = Colors.red;     

                                _firestore.collection("users").doc(user!.uid).collection("favorites").doc(snapshot.data!.docs[index]['productname']+" "+snapshot.data!.docs[index]['productdesc'] ).set({
                                       'productname':snapshot.data!.docs[index]['productname'],    
                                       'productdesc':snapshot.data!.docs[index]['productdesc'], 
                                       'productprice':snapshot.data!.docs[index]['productprice'], 
                                       'productimage':snapshot.data!.docs[index]['productimage'],                   
                        });     
                          } 
                        else {
                        
                        fav[snapshot.data!.docs[index]['productname']+" "+snapshot.data!.docs[index]['productdesc']] = Colors.grey;
                                                 
                         _firestore.collection("users")
                           .doc(user!.uid)
                           .collection("favorites")
                           .doc(snapshot.data!.docs[index]['productname']+" "+snapshot.data!.docs[index]['productdesc'])
                           .delete();      
                           
                        }
                           });

                        },
                        
                          ),                              
                              ],
                            ),                                                        
                            ),
                          );                        
                        },
                      );
                      } else  {
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

                        if(productnameController.text=='' || productdescController.text == '' || productpriceController.text==''){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar( 
                            content: Text("Please fill out all the fields"))
                            );                        
                        } else{

                          String imageId = Uuid().v4();
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref = storage.ref().child("test/" + imageId+".jpeg");
                          await ref.putFile(File(image!.path));
                          url=await ref.getDownloadURL();
                       
                        await _firestore.collection("users").doc(user!.uid).collection("product_details").add({
                           'productname':productnameController.text,
                          'productdesc':productdescController.text,
                          'productprice':double.parse(productpriceController.text),
                          'productimage':url,
                        });
                           await _firestore.collection("all_products").add({
                           'productname':productnameController.text,
                          'productdesc':productdescController.text,
                          'productprice':double.parse(productpriceController.text),
                          'productimage':url,
                          'uid' : user!.uid
                        });

                     Navigator.push(context, MaterialPageRoute(builder: (context)=>mainpage()),);                                                          

                      }
                      },
                    ),
               ),
             ),
                
          ],
          ),

          // satın alınan ürünler tabBar (purchased product)
             ListView(                                        
            children: [
            Divider(thickness: 0.1,),

             StreamBuilder(
              stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .collection("purchased_products")
              .snapshots(),
              builder: 
               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){                   

                 gett(){   // to calculate total money spent by user
                   FirebaseFirestore.instance
                   .collection('users')
                   .doc(user!.uid)
                   .collection("purchased_products")
                   .get();
                   double total = 0.0;
                   
                   for (int i = 0; i < snapshot.data!.docs.length; i++) {
                     total += snapshot.data!.docs[i]['productprice'];
                     print("-------------------");
                     print(total);
                   }         
                        return total; 
                  }
 

                 if(snapshot.hasError){
                   return Center(child: Text('hata oluştu'));
                 } else{

                      if(snapshot.hasData){

                        return ListView.builder(

                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){             
                                                   
                          return Card(                          
                            color: Colors.white24,
                            child: ListTile(
                              onTap: (){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar( 
                                  content: Text( "Total money you spent :" + " ${gett()} ")));    
                        },
                              leading: Image.network('${snapshot.data!.docs[index]['productimage']}'),
                              title:  Text(                           
                             '${snapshot.data!.docs[index]['productname']}',
                            style: TextStyle(fontSize: 18)),
                            subtitle:  Text(
                             '${snapshot.data!.docs[index]['productprice']}',                            
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
            children: [
              
            Divider(thickness: 0.1,),
              
             StreamBuilder(

              stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .collection("favorites")
              .snapshots(),
              
              builder: 
               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                 if(snapshot.hasError){
                   return Center(child: Text('hata oluştu'));
                 } else{

                      if(snapshot.hasData){

                        return ListView.builder(
                           shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){             

                          return Card(                          
                            color: Colors.white24,
                            child: ListTile(
                         onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => product_details(
                                   productimage:snapshot.data!.docs[index]['productimage'],
                                   productname:snapshot.data!.docs[index]['productname'],
                                   productdesc:snapshot.data!.docs[index]['productdesc'],                                                   
                        )
                     ));
                     },
                //// favoriler 
                             leading: Icon(Icons.star, color: Colors.pink,),
                              title:  Text(                           
                             '${snapshot.data!.docs[index]['productname']}',
                            style: TextStyle(fontSize: 18)),
                            
                            subtitle: Row(
                              children: [
                                Text(
                                  '${snapshot.data!.docs[index]['productprice']}' ' ' 'TL',
                                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),                                                      
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

            //created products tabBar
            ListView(      
              shrinkWrap: true,  
              physics: ClampingScrollPhysics(),
              children: [
                
                Divider(thickness: 0.1,),

            Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection("users")   
                  .where('uid', isEqualTo: user!.uid)          
                  .snapshots(),
                  builder:
                   (BuildContext context, AsyncSnapshot<QuerySnapshot> qsnapshot){                             
                  // profile sayfasında kullanıcının username'ini gösterir
                          if(qsnapshot.hasData){                      
                          List<DocumentSnapshot> listOfDocumentSnap = qsnapshot.data!.docs;                                     

                             return ListView.builder(
                               shrinkWrap: true,
                            itemCount: qsnapshot.data!.docs.length,
                            itemBuilder: (context,index){    

                              return Align(
                                alignment: Alignment.center,
                                child: Text(                                                            
                                    '${listOfDocumentSnap[index].get('username')}',                                  
                                  style: TextStyle(fontSize: 18, )),
                              );
                                                    
                            },
                          );
                          } else{
                            return Center(child: CircularProgressIndicator());
                          }
                                                                                               
                  },
                ),
                Divider(color: Colors.black),
                // created products'ları gösterir
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("product_details")
                  .snapshots(),
                  builder:
                   (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){                             

                     if(snapshot.hasError){
                       return Center(child: Text('hata oluştu'));
                     } else{

                          if(snapshot.hasData){                      

                             return ListView.builder(
                               shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context,index){    

                          List<DocumentSnapshot> listOfDocumentSnap = snapshot.data!.docs;                                     

                              return Card(                                                                                      
                                color: Colors.white24,
                                elevation: 1,
                                shadowColor: Colors.amber,                            
                                child: ListTile(                                         
                                  leading: Image.network('${snapshot.data!.docs[index]['productimage']}'),
                                  title:  Text(                           
                                  '${snapshot.data!.docs[index]['productname']}'                                                            
                                  ,
                                style: TextStyle(fontSize: 18,)),
                              
                                subtitle:  Row(
                                  children: [
                                    Text(
                                      '${snapshot.data!.docs[index]['productprice']}' ' ' 'TL',
                                    style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
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
                ),
                   
              ],
            )
            ],
            
            ),
      ]),
      ),
    );
  }

// sell product kısmındaki fotoğraf yüklemek için 
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

// logout function
 Future<void> logout(BuildContext context)async {
   await FirebaseAuth.instance.signOut();
   Navigator.of(context).pushReplacement(
     MaterialPageRoute(builder: (context) => LoginPage()));
 }

 // tabBar'ların adları ve icon'ları
     menu() {
      return TabBar(        
        tabs: [
          Tab(
            text: "Home",
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "Sell",
            icon: Icon(Icons.sell),
          ),
          Tab(
            text: "Bought",
            icon: Icon(Icons.shopping_bag),
            
          ),
          Tab(
            text: "Favorites",
            icon: Icon(Icons.favorite),
          ),
           Tab(
            text: "Profile",            
            icon: Icon(Icons.person),
          ),
        ],
      );
    }


}