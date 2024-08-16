import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test1/config/config.dart';
import 'package:test1/config/internal_config.dart';
import 'package:test1/models/request/CustomerLoginPostRequest.dart';
import 'package:test1/models/response/CustomersLoginPostResponse.dart';
// import 'package:test1/models/response/customersLoginPostResponse';
import 'package:test1/pages/register.dart';
import 'package:test1/pages/showTrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
    int count = 0;
    String phoneNo='';
    String password='';

    TextEditingController phoneCtl = TextEditingController();
    TextEditingController passCtl = TextEditingController();
   
   String url= '';
    //initState คือ ดfuntion ที่ทำงานเมื่อเปิดหน้านี้
    //1.
    //2.
    //3. มันไมสามารถทำงานเป็น 
 
@override
void initState() {
 super.initState();
    //Configuration config = Configuration();
    Configuration.getConfig().then((value){
      log(value['apiEndpoint']);
      url = value['apiEndpoint'];
    }).catchError((err){
      log(err.toString());
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: (){
                  log('kia tew');
                },
                child: Image.asset('assets/image/logo.png')),
              const Padding(
              padding: EdgeInsets.only(left:15 ),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('หมายเลขโทรศัพท์',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15 ,right: 15,top: 5),
              child: TextField(
                // onChanged: (value) {
                //   log(value);
                //   phoneNum = value;
                // },
                controller: phoneCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                border:
                OutlineInputBorder(borderSide: BorderSide(width: 1)))),
            ),
            const Padding(
              padding: EdgeInsets.only(left:15,top: 15),
              child: SizedBox(
                height: 25,
                      width: 200,
                child: Text('รหัสผ่าน',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15 ,right: 15,bottom: 10,top: 5),
              child: TextField(
                controller: passCtl,
                obscureText: true,
                decoration: const InputDecoration(
                border:
                OutlineInputBorder(borderSide: BorderSide(width: 1)))),
            ),
              // ignore: prefer_const_constructors
              Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    TextButton(
                        onPressed: Register, child: const Text('ลงทะเบียนใหม่')),
                    FilledButton(
                        onPressed: login, child: const Text('เข้าสู่ระบบ')),
                  ],
                ),
              ),
             Text(text)
            ],
          ),
        ));
  }

  void Register() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage(),
                ), ); 

                      }

  void login() async{
    

    //call login api
    // CustomersLoginPostRequest data =CustomersLoginPostRequest(phone: phoneNoCtl.text,password: );
    

    // http.post(Uri.parse('http://10.160.72.145:3000/customers/login'),headers: {"Content-Type":"application/json; charset=utf-8"},
    // body: customersLoginPostRequestFromJson()).then(
    //   (value){

    //     // CustomersLoginPostResponse customer = customersLoginPostResponseFromJson(value.body);
    //     // log(customer.customer.email);

    //   //  var jsonRes = jsonDecode(value.body);
    //   // log(jsonRes['customer']['email']);
    //   },
    // ).catchError((eee){
    //   log(eee.toString());
    // });
      
    
  //   count++;
  // String phoneN ='0812345678';
  // String passwordset='1234';
  // //   setState(() {
  // //  text = 'Login time: $count';
	  
  // //   });
  // //    log('login succesfull');
  //   log(phoneNo);
  //   if(phoneNo==phoneN&&password==passwordset){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowTripPage(),
  //               ), ); 
  //   }
  //   else{
  //     setState(() {
  //  text = 'phone no or password incorrect';
	  
  //   });
  //   }
             var data = CustomersLoginPostRequest(phone: phoneCtl.text ,password:passCtl.text);
                  
                  http.post(Uri.parse('$API_ENDPOINT/customers/login'),
                  headers: {"Content-Type":"application/json; charset=utf-8"}, 
                  body: customersLoginPostRequestToJson(data))
                  .then(
                      (value){
                        CustomersLoginPostResponse customer = customersLoginPostResponseFromJson(value.body);
                        log(customer.customer.fullname);
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ShowtripsPage(idx : customer.customer.idx)
                          ));
                      
                      },
                  ).catchError((eee){
                    setState(() {
                            text = 'phonenumber and password not match';
                          });
                      log(eee.toString());
                    });
   
  }
}