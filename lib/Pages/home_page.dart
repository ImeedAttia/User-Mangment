import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gestion_user/Pages/ProfilePage.dart';
import 'package:gestion_user/auth.dart';
import 'package:gestion_user/Model/Employee.dart';
import 'AddEmployee.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return _userId();
  }

  Widget _userId() {
    return Text(user?.email ?? 'User Email');
  }

  Widget _signOutButton() {
    return IconButton(
        icon: const Icon(Icons.logout, size: 32.0),
        tooltip: 'Profile',
        onPressed: signOut);
  }

  Stream<List<Employees>> readUsers() => FirebaseFirestore.instance
      .collection("Employees")
      .snapshots()
      .map((snapshot) =>
           snapshot.docs.map((event) => Employees.fromJson(event.data())).toList());

  delete(String id) {
    final docUser = FirebaseFirestore.instance.collection("Employees").doc(id);
    docUser.delete();
  }


  List<Employees> _foundedUsers = [];
  List<Employees> _users = [];

  relod(){
     _foundedUsers = _users.toList();
  }

  onSearch(String search) {
    setState(() {
      _foundedUsers = _users.where((user) => user.FirstName.toLowerCase().contains(search)).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          actions: <Widget>[_signOutButton()],
          title: Container(
            height: 38,
            child: TextField(
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500,),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none
                  ),
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500
                  ),
                  hintText: "Search users"
              ),
            ),
          ),
      ),
      body:
      StreamBuilder<List<Employees>>(
           stream: readUsers(),
           builder: (context, snapshot)  {
             if (snapshot.hasError) {
               return Text("Something is wrong! ${snapshot.error}");
             }
             if (snapshot.hasData) {
               _users = snapshot.data!;
               if(_foundedUsers.isNotEmpty){
                 return
                   Container(
                     color: Colors.grey.shade900,
                     child: _foundedUsers.isNotEmpty
                         ? ListView.builder(
                         itemCount: _foundedUsers.length,
                         itemBuilder: (context, index) {
                           return Slidable(
                             actionPane: const SlidableDrawerActionPane(),
                             actionExtentRatio: 0.25,
                             secondaryActions: <Widget>[
                               IconSlideAction(
                                 caption: 'Delete',
                                 color: Colors.transparent,
                                 icon: Icons.delete,
                                 onTap: () => delete(_foundedUsers[index].uid),
                               ),
                             ],
                             child: GestureDetector(
                                 behavior: HitTestBehavior.opaque,
                                 onLongPress: () {
                                   _modifier(user: _foundedUsers[index]);
                                 },
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                         builder: (context) => Profile(user: _foundedUsers[index]),
                                       ));
                                 },
                                 child: userComponent(user: _foundedUsers[index])),
                           );
                         })
                         : const Center(
                         child: Text(
                           "No users found",
                           style: TextStyle(color: Colors.white),
                         )),
                   );
               }
               return
                 Container(
                   color: Colors.grey.shade900,
                   child: _users.isNotEmpty
                       ? ListView.builder(
                       itemCount: _users.length,
                       itemBuilder: (context, index) {
                         return Slidable(
                           actionPane: const SlidableDrawerActionPane(),
                           actionExtentRatio: 0.25,
                           secondaryActions: <Widget>[
                             IconSlideAction(
                               caption: 'Delete',
                               color: Colors.transparent,
                               icon: Icons.delete,
                               onTap: () => delete(_users[index].uid),
                             ),
                           ],
                           child: GestureDetector(
                               behavior: HitTestBehavior.opaque,
                               onLongPress: () {
                                 _modifier(user: _users[index]);
                               },
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => Profile(user: _users[index]),
                                     ));
                               },
                               child: userComponent(user: _users[index])),
                         );
                       })
                       : const Center(
                       child: Text(
                         "No users found",
                         style: TextStyle(color: Colors.white),
                       )),
                 );
             }
             else {
               return const Center(child: CircularProgressIndicator());
             }
           },
         ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _profile();
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.supervised_user_circle_sharp),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEmployee(),
                      ));
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        )
    );
  }

  userComponent({required Employees user}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(children: [
        SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(user.img),
            )),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${user.FirstName} ${user.LastName}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          Text("Email : ${user.Email}",
              style: TextStyle(color: Colors.grey[500])),
        ]),
      ]),
    );
  }


  //List Manipulation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _modifier({required Employees user}) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier ${user.FirstName + user.LastName}"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: TextEditingController(text: user.FirstName),
                    decoration: const InputDecoration(
                      hintText: 'Enter  First Name',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.FirstName = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.FirstName = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.LastName),
                    decoration: const InputDecoration(
                      hintText: 'Enter Last Name',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.LastName = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.LastName = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: user.Salaire),
                    decoration: const InputDecoration(
                      hintText: 'Enter Salaire',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.Salaire = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.Salaire = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                          user.Status = value == 1 ? "Employée" : "Responsable";
                          // measureList.add(measure);
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          user.Status = value == 1 ? "Employée" : "Responsable";
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder(),backgroundColor: Colors.greenAccent,),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final docUser = FirebaseFirestore.instance
                            .collection("Employees")
                            .doc(user.uid);
                        docUser.update({
                          "FirstName": user.FirstName,
                          "LastName": user.LastName,
                          "Salaire": user.Salaire,
                          "Status": user.Status
                        }).then((value) => {
                        Navigator.of(context).pop() // Close the dialog
                        });
                      }
                    },
                    child: const Text('Modifier'),
                  ),
                ],
              ),
            ),
          ),
          actions:[
                Center(
                  child:
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey.shade900,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                      child: const Text('Fermer'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        FocusScope.of(context)
                            .unfocus(); // Unfocus the last selected input field
                        _formKey.currentState?.reset();
                      },
                    )
                )
              ],
            );
        },
      );
   }



  void _profile() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text('User Logged in Information'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Email:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: _title(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

}
