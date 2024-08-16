// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:test1/config/config.dart';
import 'package:test1/models/request/CustomersRegisterPostRequest.dart';

import 'package:test1/pages/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
TextEditingController nameCtrl = TextEditingController();
TextEditingController phoneCtrl = TextEditingController();
TextEditingController emailCtrl = TextEditingController();
TextEditingController passCtrl = TextEditingController();
TextEditingController passwordCtrl = TextEditingController();
String url = '';

class _RegisterPageState extends State<RegisterPage> {

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Configuration config = Configuration();
    Configuration.getConfig()
    .then((value){
      log(value['apiEndpoint']);
      url = value['apiEndpoint'];
    }).catchError((err){
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: Container(
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

         const Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('ชื่อนาม-สกุล',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: TextField(
                  controller: nameCtrl,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1)))),
            ),
            //-------
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('หมายเลขโทรศัพท์',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: TextField(
                  controller: phoneCtrl,
                  
                  //obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1)))),
            ),
            //-------
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('อีเมล',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: TextField(
                  controller: emailCtrl,
                  //obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1)))),
            ),
            //-------
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('รหัสผ่าน',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1)))),
            ),
            //-------
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 25,
                width: 200,
                child: Text('ยืนยันรหัสผ่าน',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1)))),
            ),
               Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      'หากมีบัญชีอยู่แล้ว?',
                      style: TextStyle(fontSize: 15),
                  ),
                    TextButton(
                        onPressed:() => register(), child: const Text('เข้าสู่ระบบ')),
                  ],
                ),
              ),
            ],
            
          ),
          
      ),
      
    );
  }

  void login() {
  }

  void meu() {
  }

  void register() {
if (nameCtrl.text.isEmpty ||
      phoneCtrl.text.isEmpty ||
      emailCtrl.text.isEmpty ||
      passCtrl.text.isEmpty ||
      passwordCtrl.text.isEmpty) {
    // Show an error message or a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ข้อมูลไม่ครบ'),
          content: const Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else if (passCtrl.text != passwordCtrl.text) {
    // Show a dialog for password mismatch
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รหัสผ่านไม่ตรงกัน'),
          content: const Text('กรุณายืนยันรหัสผ่านให้ตรงกัน'),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    // Proceed with the registration
    log('match');
    var data = CustomersRegisterPostRequest(
        fullname: nameCtrl.text,
        phone: phoneCtrl.text,
        email: emailCtrl.text,
        image: "$url/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
        password: passCtrl.text);
    http
        .post(Uri.parse('$url/customers'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customersRegisterPostRequestToJson(data))
        .then((value) {
      log('success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  LoginPage()));
    }).catchError((eee) {
      log("insert error " + eee.toString());
    });
  }
  }
}
