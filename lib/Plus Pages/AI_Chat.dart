import 'package:flutter/material.dart';

import '../Home.dart';
import '../main.dart';

class AI_Chat extends StatefulWidget{
  const AI_Chat ({super.key});
  @override
  State<AI_Chat> createState() => _AIChatState();
}

class _AIChatState extends State<AI_Chat>{
  final TextEditingController _userInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  Home()),
            );
          },
        ),
        title: Text('المحاكاة الذكيّة',
          style: TextStyle(
              fontFamily: 'PlaypenSansArabic',
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

    );
  }
  
}