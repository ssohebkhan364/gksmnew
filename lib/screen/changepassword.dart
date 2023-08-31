import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
class changepassword extends StatefulWidget {
  const changepassword({super.key});

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;
  bool oldpasswordVisible = false;
  bool newpasswordVisible = false;
  late ConnectivityResult result;
late StreamSubscription subscription;
var isConnected=false;
  @override
  void initState() {
    super.initState();
    oldpasswordVisible = true;
    newpasswordVisible = true;
  }


checkInternet() async {
    result = await Connectivity().checkConnectivity();
    print("jjjjj");
    print(result);
 
       
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isLoading=false;
      isConnected = false;
        showDialogBox();
      

    }
       setState(() {    ;});
 
  }

  showDialogBox()async {
   await Future.delayed(Duration(milliseconds: 50));
         showDialog(
          barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              actions: [
                CupertinoButton(child: Text("Retry"), onPressed: () {

                  Navigator.pop(context);
                  checkInternet();
                  setState(() {
                    
                  });
                })
              ],
              title: Text("No internet"),
              content: Text("Please check your internet connection"),
            ));
  }

  startStriming()async {

    subscription = Connectivity().onConnectivityChanged.listen((event) async{
      checkInternet();
   
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff014E78),
            title: Text("Change Password"),
          ),
          body: Form(
            key: _formKey,
            child: Stack(children: [
              Center(child: isLoading ?SpinKitCircle(
                  color: Color(
                                                    0xff014E78),
                size: 50,
                ) : null),
              Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Change Password",
                        style: TextStyle(
                            color: Color(0xff014E78),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: oldpasswordVisible,
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'Old Password',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: "Old Password",
                          suffixIcon: IconButton(
                            icon: oldpasswordVisible
                                ? const Icon(
                                    Icons.visibility,
                                    color: Color(0xff165a72),
                                  )
                                : const Icon(Icons.visibility_off,
                                    color: Color(0xff165a72)),
                            onPressed: () {
                              setState(() {
                                oldpasswordVisible = !oldpasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: Color(0xff03467d),
                              ))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter old password';
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: newpasswordVisible,
                      controller: newPasswordController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: " New Password",
                          suffixIcon: IconButton(
                            icon: newpasswordVisible
                                ? const Icon(
                                    Icons.visibility,
                                    color: Color(0xff165a72),
                                  )
                                : const Icon(Icons.visibility_off,
                                    color: Color(0xff165a72)),
                            onPressed: () {
                              setState(() {
                                newpasswordVisible = !newpasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: Color(0xff03467d),
                              ))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Map<String, dynamic> map = {
                        "old_password": oldPasswordController.text,
                        "password": newPasswordController.text,
                      };
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        ApiServices.chngaePassword(map).then(
                          (value) async {
                            setState(() {
                              isLoading = false;
                            });

                            if (value.status == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Password Updated..!!"),
                                backgroundColor: Color.fromRGBO(1, 48, 74, 1),
                              ));
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            } else {
                              setState(() {
                                isLoading = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Please enter valid password!"),
                                backgroundColor: Color.fromRGBO(1, 48, 74, 1),
                              ));
                            }
                          },
                        );
                          checkInternet();
     startStriming();
     setState(() {
       
     });
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xff014E78),
                          ),
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              selectionColor: Colors.white,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ]),
          )),
    );
  }
}
