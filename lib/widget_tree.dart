import 'package:gestion_user/Pages/AddEmployee.dart';

import 'auth.dart';
import 'package:gestion_user/Pages/home_page.dart';
import 'package:gestion_user/Pages/login.dart';
import 'package:flutter/material.dart';


class WidgetTree extends StatefulWidget{
  const WidgetTree ({Key? key}) : super(key : key);

  @override
  State<WidgetTree> createState()=> _WidgetTreeState();
  
  
  
}

class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStatechanges,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomePage();
          }else {
            return const LoginPage();
          }
        },
    );
  }
  
}