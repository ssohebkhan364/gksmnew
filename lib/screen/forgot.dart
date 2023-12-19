import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/login.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  bool isLoading = false;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  var _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  void clearText() {
    emailController.clear();
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isLoading = false;
      isConnected = false;
      showDialogBox();
    }
    setState(() {
      ;
    });
  }

  showDialogBox() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              actions: [
                CupertinoButton(
                    child: Text("Retry"),
                    onPressed: () {
                      Navigator.pop(context);
                      checkInternet();
                      setState(() {});
                    })
              ],
              title: Text("No internet"),
              content: Text("Please check your internet connection"),
            ));
  }

  startStriming() async {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
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
          body: Form(
            key: _formKey,
            child: Stack(children: [
              Center(
                  child: isLoading
                      ? SpinKitCircle(
                          color: Color(0xff03467d),
                          size: 50,
                        )
                      : null),
              Column(children: [
                const SizedBox(
                  height: 200,
                ),
                const Text(
                  " Forgot Password",
                  style: TextStyle(
                      color: Color(0xff03467d),
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Forgot Password Page !",
                        style:
                            TextStyle(color: Color(0xff03467d), fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 48,
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff03467d),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Text(
                                "Associate",
                                style: TextStyle(
                                    color: Color(0xff03467d),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color(0xff03467d),
                        ),
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Color(0xff165a72),
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
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(color: Color(0xff03467d))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xff03467d),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: Color(0xff03467d),
                            ))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
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
                      "user_type": "4",
                      "email": emailController.text,
                    };
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      ApiServices.forgotpassword(map).then((value) async {
                        setState(() {
                          isLoading = false;
                        });

                        if (value.status == true) {
                          clearText();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("OTP will be sent your registered email and contact number!"),
                            backgroundColor: Color(0xff03467d),
                          ));
                        } else {
                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("please enter valid email !"),
                            backgroundColor: Color(0xff03467d),
                          ));
                        }
                      });
                      checkInternet();
                      startStriming();
                      setState(() {});
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff03467d),
                        ),
                        child: Center(
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
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff03467d),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
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
              ]),
            ]),
          )),
    );
  }
}
