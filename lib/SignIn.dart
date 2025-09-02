import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazroo3atkom/Home.dart';
import 'SignUp.dart';

class SignIn extends StatelessWidget{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignIn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/plant.png',
              width: 150,
              height: 150,
              ),
              const SizedBox(height: 10,),
              Text(
                'مزروعاتي',
                style: TextStyle(
                  fontFamily: 'PlaypenSansArabic',
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 25,),
              TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  //fillColor: Color(0xFFF2EEEE),

                    fillColor: Color(0xFFF2EEEE),
                  hintText: 'البريد الإلكتروني',
                  //hintStyle: TextStyle(color: Color(0xFF989595)),
                  hintStyle: TextStyle(color: Color(0xFF989595)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  //fillColor: Color(0xFFE2EEDE),
                  fillColor: Color(0xFFF2EEEE),
                  hintText: 'كلمة السر',
                  //hintStyle: TextStyle(color: Color(0xFF989595)),
                  hintStyle: TextStyle(color: Color(0xFF989595)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    'إنشاء حساب؟',
                    style: TextStyle(
                      color: Colors.green[200],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textDirection: TextDirection.rtl,
                  ),

                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>SignUp())
                    );
                  },

                ),
              ),
          const SizedBox(height: 160),
          ElevatedButton(
          onPressed: () => _signInWithEmailAndPassword(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[300],
              foregroundColor: Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              child: Text('دخول'),
            ),
          ),


            ],
          ),
        ),
      ),
     ) ,
    );
  }
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Login failed: ${e.toString()}');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
