import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/otp.dart';
import 'package:gkms/screen/dashboard.dart';
import 'package:gkms/screen/forgot.dart';
import 'package:gkms/screen/signup.dart';
import 'package:gkms/screen/verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController Associate = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _focusNode = FocusNode();
  bool passwordVisible = false;
  late Box box1;
  bool isChecked = false;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  var token1;

  @override
  void initState() {
    super.initState();
    createOpenBox();
    passwordVisible = true;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      token1 = '$token';
      print(token1);
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
        } else {}
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void getdata() async {
    if (box1.get('email') != null) {
      emailController.text = box1.get('email');
      isChecked = true;
      setState(() {});
    }
    if (box1.get('pass') != null) {
      passwordController.text = box1.get('pass');
      isChecked = true;
      setState(() {});
    }
  }

  void clearText() {
    emailController.clear();
    passwordController.clear();
  }

  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
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
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Log in Now",
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff03467d)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Please login to continue using our app",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      )),
                ),
                SizedBox(
                  height: 30,
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
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      focusNode: _focusNode,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: "Email",
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(color: Color(0xff03467d))),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: Color(0xff03467d),
                              ))),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Email is Required';
                        }
                        if (!RegExp(
                                r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                            .hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: passwordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color(0xff03467d),
                        ),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: passwordVisible
                              ? const Icon(
                                  Icons.visibility,
                                  color: Color(0xff165a72),
                                )
                              : const Icon(Icons.visibility_off,
                                  color: Color(0xff165a72)),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
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
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(color: Color(0xff03467d))),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(
                              color: Color(0xff03467d),
                            ))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            isChecked = !isChecked;
                            setState(() {});
                          },
                          activeColor: Color(0xff03467d)),
                      Text(
                        "Remember Me",
                        style: TextStyle(
                          color: Color(0xff03467d),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => forgotpassword()));
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Color(0xff03467d),
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigUpScreen()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Map<String, dynamic> map = {
                          'email': emailController.text,
                          'password': passwordController.text,
                          'token': token1.toString(),
                          'user_type': "4"
                        };

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          ApiServices.login(map).then((value) async {
                          
                            if (value.status == true) {
                              login();
                              logout();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await ApiServices.profileGet().then((value) {
                                 prefs.setString(
                                  "verification", value.message.toString());
                                      var verify = prefs.getString("verification");
                                      print("zczc");
                                      print(verify.toString());
                                if (value.message.toString() ==
                                    "notemailverfied") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              Verification())));
                                }

                                if (value.message.toString() ==
                                    "notmobileverfied") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => otpScreen())));
                                }
                                  prefs.setString(
                                    "user_name", value.result!.name as String);
                              
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(value.message.toString()),
                                backgroundColor: Color(0xff03467d),
                              ));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomeScreen()),
                                  (Route<dynamic> route) => false);
                              clearText();
                            } else {
                              setState(() {
                                isLoading = false;
                              });

                              value.message == "Validation not Completed yet."
                                  ? ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                          "Your account is not approved yet."),
                                      backgroundColor: Color(0xff03467d),
                                    ))
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(value.message.toString()),
                                      backgroundColor: Color(0xff03467d),
                                    ));
                            }
                          });
                          checkInternet();
                          startStriming();
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                            color: Color(0xff03467d),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Center(
                          child: Text(
                            "Login ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SigUpScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SigUpScreen()));
                        },
                        child: SizedBox(
                          height: 30,
                          width: 55,
                          child: Center(
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color(0xff03467d),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void login() {
    if (isChecked == true) {
      box1.put('email', emailController.text);
      box1.put('pass', passwordController.text);
    }
  }

  void logout() {
    if (isChecked == false) {
      box1.clear();
    }
  }
}
