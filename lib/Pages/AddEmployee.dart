
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_user/Model/Employee.dart';
import 'package:gestion_user/Pages/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}


class _AddEmployeeState extends State<AddEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String firstName = "";
  String lastName = "";
  String Email = "";
  String Cin = "";
  String PhoneNumber = "";
  String Salaire = "";
  String Adresse = "";
  var Status;
  String Dpt="";
  String img ="";


  Future createUser() async {
    final docUser = FirebaseFirestore.instance.collection('Employees').doc();
    final user = Employees(
        docUser.id,
        firstName,
        lastName,
        Email,
        Cin,
        PhoneNumber,
        Salaire,
        Adresse,
        Status == 1 ? "Employée" : "Responsable",
        img
    );
    final json = user.toJson();
    await docUser.set(json);
  }



  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('Your information has been submitted'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Full name:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("$firstName $lastName"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Adress et salaire et num et cin et status",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "$Adresse et $Salaire et $PhoneNumber et $Cin et $Status "),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('Go to profile'),
                  onPressed: () async {
                    FocusScope.of(context)
                        .unfocus(); // unfocus last selected input field
                    Navigator.pop(context);
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage())) // Open my profile
                        .then((_) => _formKey.currentState
                            ?.reset()); // Empty the form fields
                    setState(() {});
                  }, // so the alert dialog is closed when navigating back to main page
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    _formKey.currentState?.reset();
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));// Empty the form fields
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.grey.shade900,
        // appbar color.
        foregroundColor: Colors.white,
        title: const Text("Ajout Employée"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Enter Vous Données",
                      style: TextStyle(
                        fontSize: 24,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                    onPressed: ()async{
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file =await imagePicker.pickImage(source: ImageSource.camera);//gallery
                      print('${file?.path}');
                      if(file == null)return;
                      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference refereceImageToUpload = referenceRoot.child(uniqueName);
                      try{
                        await refereceImageToUpload.putFile(File(file!.path));
                        img = await refereceImageToUpload.getDownloadURL();
                      }catch(error){

                      }
                    },
                    icon: Icon(Icons.camera_alt)),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                    onPressed: ()async{
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file =await imagePicker.pickImage(source: ImageSource.gallery);//gallery
                      print('${file?.path}');
                      if(file == null)return;
                      String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference refereceImageToUpload = referenceRoot.child(uniqueName);
                      try{
                        await refereceImageToUpload.putFile(File(file!.path));
                        img = await refereceImageToUpload.getDownloadURL();
                      }catch(error){

                      }
                    },
                    icon: FaIcon(FontAwesomeIcons.photoVideo)),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Firstname
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'First Name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {
                          setState(() {
                            firstName = value.capitalize();
                            // firstNameList.add(firstName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            firstName = value.capitalize();
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'First Name must contain at least 3 characters';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'First Name cannot contain special characters';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //LastName
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Last Name',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Last Name must contain at least 3 characters';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Last Name cannot contain special characters';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            lastName = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            lastName = value.capitalize();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Email
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              !value.contains(RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'))) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            Email = value.capitalize();
                            // lastNameList.add(lastName);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            Email = value.capitalize();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Phone number
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                            return 'Use only numbers!';
                          }
                          if(value.length < 7){
                            return 'Phone numer must be more then 7 numbers!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            PhoneNumber = value;
                            // bodyTempList.add(bodyTemp);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            PhoneNumber = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Addresse
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Addresse',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            return 'Addresse must contain at least 3 characters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            Adresse = value.capitalize();
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            Adresse = value.capitalize();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Cin
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'CIN',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                            return 'Use only numbers!';
                          }
                          if(value.length < 7){
                            return 'Cin must be more then 7 numbers!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            Cin = value;
                            // bodyTempList.add(bodyTemp);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            Cin = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Salaire
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Salaire',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                            return 'Use only numbers!';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            Salaire = value;
                            // bodyTempList.add(bodyTemp);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            Salaire = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Status
                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text("Employée"),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text("Responsable"),
                            )
                          ],
                          hint: const Text("Select item"),
                          onChanged: (value) {
                            setState(() {
                              Status = value;
                              // measureList.add(measure);
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              Status = value;
                            });
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade900,
                            minimumSize: const Size.fromHeight(60)),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            _submit();
                            createUser();
                          }
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
