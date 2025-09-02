import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home.dart';

class SignUp extends StatefulWidget{
  const SignUp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState()=> SignUpState();

}

class SignUpState extends State<SignUp>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: ()=> Navigator.pop(context),
          icon:Icon(Icons.arrow_back_ios),
        ),
      ),

      body:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Center(
        child: Image.asset(
          'assets/plant.png',
          height: 120,
        ),
      ),
      ),
          //const SizedBox(height: 5),
          Text(
            'مزروعاتي',
            style: TextStyle(
              fontFamily: 'PlaypenSansArabic',
              fontWeight: FontWeight.w500,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTextFormField('اسم المستخدم', _usernameController),
                  const SizedBox(height: 20),
                  buildTextFormField('البريد الإلكتروني', _emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  buildTextFormField('كلمة السّر', _passwordController, isObscure: true),
                  const SizedBox(height: 20),
                  buildTextFormField('تأكيد كلمة السّر', _confirmPasswordController, isObscure: true),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      child: Text('تسجيل'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTextFormField(String labelText, TextEditingController controller, {bool isObscure = false, TextInputType keyboardType = TextInputType.text}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2EEEE),
            hintText: labelText,
            hintStyle: TextStyle(color: Color(0xFF989595)),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_passwordController.text.length <6){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password length less than 6',style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.green[100],
          )
      );
      return;
    }
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Store additional user data in Firestore
        FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
        });
        // Navigate to the Home Page after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  Home()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        }
        else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      print('Passwords do not match');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}



