// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:developer';

import 'package:test1/models/response/profile_get_res.dart';
import 'package:test1/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:test1/config/config.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 
  late ProfileGetResponse customer;
  late Future<void> loadData;

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController pictureCtl = TextEditingController();
  String url = '';
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
                log(value);
                if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                  children: [
                    const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'ยืนยันการยกเลิกสมาชิก?',
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                        Navigator.pop(context);
                        },
                        child: const Text('ปิด')),
                      FilledButton(
                        onPressed: delete , child: const Text('ยืนยัน'))
                    ],
                    ),
                  ],
                  ),
                );
                }
              },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadData,
          builder: (context,snapshot){
             if(snapshot.connectionState != ConnectionState.done){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            fullnameCtl.text = customer.fullname;
            emailCtl.text = customer.email;
            phoneCtl.text = customer.phone;
            pictureCtl.text = customer.image;

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(width: 200,
                    child: Image.network(customer.image),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ชื่อ-นามสกุล'),
                        TextField(
                          controller: fullnameCtl,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('เบอร์โทรศัพท์'),
                        TextField(
                          controller:phoneCtl,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('อีเมลล์'),
                        TextField(
                          controller: emailCtl,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('รูปโปรไฟล์'),
                        TextField(
                          controller:pictureCtl,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FilledButton(
                      onPressed: update,
                      child:  const Text('บันทึกข้อมูล'),)
                    ),
                  )
                  
                ],
              ),
            );
          }
          ,
        ),
      )
    );
  }

  void update() async{
    //ส่งแบบไม่สร้าง model
    //ทำลบได้
    log('here');
    var json = {
      "fullname": fullnameCtl.text,
      "email": emailCtl.text,
      "phone": phoneCtl.text,
      "image": pictureCtl.text
    };
    
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    try{

      var data = await http.put(Uri.parse('$url/customers/${widget.idx}'),
      headers: {"Content-Type":"application/json; charset=utf-8"},
      body: jsonEncode(json));
      log(data.body);
      log(customer.image);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );

    }catch(err){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
    
  }

  Future<void> loadDataAsync() async{
    //load data from api (async function)
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];

    var data = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(data.body);
    customer = profileGetResponseFromJson(data.body);
    log(customer.fullname);
    log(customer.image);
  }
  //id to show trip  then show trip to profile

  void delete() async{
    var config = await Configuration.getConfig();
	  var url = config['apiEndpoint'];
	
	  var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
	  log(res.statusCode.toString());

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text('ปิด'))
          ],
        ),
      ).then((s) {
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }
  }
}