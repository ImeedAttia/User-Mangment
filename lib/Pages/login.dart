import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_user/auth.dart';
import 'register.dart';
class LoginPage extends StatefulWidget{
  const LoginPage ({Key? key}) : super(key : key);

  @override
  State<LoginPage> createState()=> _LoginPageState();



}

class _LoginPageState extends State<LoginPage>{
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try{
      errorMessage =_controllerEmail.text;
      await Auth().signInwithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text
      );
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
        _errorMessage();
      });
    }
  }
  Future<void> createUserWithEmailAndPassword() async {
    try{
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Widget _title(){
    return const Text('Welcome to User Management App',style: TextStyle(color: Colors.white, fontSize: 33));
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){

    return TextField(
      controller : controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }

  void _errorMessage(){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(errorMessage == '' ? '' : 'Humm ? $errorMessage',style: TextStyle(color: Colors.white)),
      ),
    );  }
  
  Widget _submitButton(){
        return ElevatedButton(
        onPressed:signInWithEmailAndPassword,
        style:ElevatedButton.styleFrom(primary: Color(0xff4c505b),alignment: Alignment.center),
        child: const Text('Login')
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 37, top: 150),
                child: _title()
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: <Widget>[
                          _entryField('Email', _controllerEmail),
                          const SizedBox(
                            height: 30,
                          ),
                          _entryField('Password', _controllerPassword),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget> [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              _submitButton()
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyRegister()));
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}