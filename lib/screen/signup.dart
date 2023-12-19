import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/model/teamdata.dart';
import 'package:gkms/screen/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class SigUpScreen extends StatefulWidget {
  const SigUpScreen({super.key});

  @override
  State<SigUpScreen> createState() => _SigUpScreenState();
}

class _SigUpScreenState extends State<SigUpScreen> {
  bool passwordVisible = false;
  bool isLoading = false;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  @override
  void initState() {
    teamDataGet();
    passwordVisible = true;
    super.initState();
  }

  TextEditingController associateName = TextEditingController();
  TextEditingController associateContact = TextEditingController();
  TextEditingController reraNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController uplinerName = TextEditingController();
  TextEditingController uplinerReraNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController _teamController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var dropdownvalue;
  List<Teamdta> getList = [];
  List<Teamdta> tempGetList = [];

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
                      //                   scrollController.addListener(scrollPagination);
                      // schemsList(context, page);
                      // _foundUsers = _posts;
                      // data();
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

  void teamDataGet() async {
    var response = await http.get(
      Uri.parse(UrlHelper.TeamData),
    );

    if (response.statusCode == 200) {
      List<DropdownList> droplist = [];

      droplist.add(DropdownList.fromJson(jsonDecode(response.body)));

      DropdownList userResponse = droplist[0];

      if (userResponse.status == true) {
        if (userResponse.result!.teamdta != null) {
          var data = userResponse.result!.teamdta;

          List<Teamdta> getList = [];

          for (var e in data!) {
            getList.add(e);
          }
          setState(() {
            tempGetList = getList;
          });
        }
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body:
                // SingleChildScrollView(
                // child:
                Form(
          key: _formKey,
          child: Stack(children: [
            Center(
                child: isLoading
                    ? SpinKitCircle(
                        color: Color(0xff03467d),
                        size: 50,
                      )
                    : null),
            SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Sign Up As Associate",
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff03467d)),
                ),
                const Text("Please fill the details and create account",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: associateName,
                    decoration: InputDecoration(
                        labelText: 'Associate Name',
                        labelStyle: const TextStyle(
                          color: Color(0xff03467d),
                        ),
                        hintText: "Associate Name",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                      if (value!.isEmpty) {
                        return "The associate name field is required.";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: associateContact,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        labelText: 'Associate Contact Number',
                        labelStyle: TextStyle(
                          color: Color(0xff03467d),
                        ),
                        hintText: "Associate Contact Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xff03467d),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Color(0xff03467d))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Color(0xff03467d))),
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
                      if (value!.isEmpty) {
                        return "The associate contact number field is required.";
                      }
                    },
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: reraNumber,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'Associate Rera Number',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: "Associate Rera Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
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
                        if (value!.isEmpty) {
                          return "The associate rera number field is required.";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: "Associate Email",
                            labelText: 'Associate Email',
                            labelStyle: TextStyle(
                              color: Color(0xff03467d),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xff03467d),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 90, 110, 127))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide:
                                    const BorderSide(color: Color(0xff03467d))),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xff03467d),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide:
                                    BorderSide(color: Color(0xff03467d))),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide(
                                  color: Color(0xff03467d),
                                ))),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'The Email is Required';
                          }
                          if (!RegExp(
                                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                              .hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        }),
                  ),
                ),
                SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: uplinerName,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'Immediate Uplinner Name',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: "Immediate Uplinner Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
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
                        if (value!.isEmpty) {
                          return "The Uplinner name field is required.";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: uplinerReraNumber,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          labelText: 'Immediate Uplinner Rera Number',
                          labelStyle: TextStyle(
                            color: Color(0xff03467d),
                          ),
                          hintText: "Immediate Uplinner Rera Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
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
                        if (value!.isEmpty) {
                          return "The Uplinner rera number field is required.";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: passwordVisible,
                      controller: password,
                      decoration: InputDecoration(
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
                          hintText: "Password",
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Color(0xff03467d),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Color(0xff03467d),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Color(0xff03467d))),
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
                        if (value!.isEmpty) {
                          return "The password field is required.";
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    // isDense: true,
                    // isExpanded: true,
                    focusColor: Colors.transparent,
                    elevation: 1,
                    hint: const Text(
                      'Select Team',
                      style: TextStyle(color: Color(0xff03467d)),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xff03467d)),
                        labelText: 'Select Team',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xff03467d),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Color(0xff03467d))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Color(0xff03467d))),
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
                    items: tempGetList.map((item) {
                      return DropdownMenuItem(
                        value: item.publicId.toString(),
                        child: Text(
                          item.teamName.toString(),
                          style: TextStyle(color: Color(0xff03467d)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownvalue = value;
                        _teamController.text = dropdownvalue;
                      });
                    },
                    value: dropdownvalue,
                    validator: (value) {
                      if (value == null) {
                        return 'The team field is required.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
               InkWell(
                  onTap: () {
                    Map<String, dynamic> map = {
                      "associate_name": associateName.text,
                      "email": email.text,
                      "mobile_number": associateContact.text,
                      "password": password.text,
                      "associate_rera_number": reraNumber.text,
                      "applier_rera_number": uplinerReraNumber.text,
                      "applier_name": uplinerName.text,
                      "team": dropdownvalue
                    };

                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      ApiServices.signUpPost(map).then((value) async {
           
                        setState(() {});
                        if (value.status == true) {
                        
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.message.toString()),
                            backgroundColor: Color(0xff03467d),
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {

                            isLoading = false;
                        
                                  if(value.errors!.mobileNumber![0]!="null"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.errors!.mobileNumber![0]),
                            backgroundColor: Color(0xff03467d),
                          ));
                               }

                                      if(value.errors!.email![0]!="null"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.errors!.email![0]),
                            backgroundColor: Color(0xff03467d),
                          ));
                               }
                                  if(value.errors!.associateReraNumber![0]!="null"){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.errors!.associateReraNumber![0]),
                            backgroundColor: Color(0xff03467d),
                          ));
                               }
                          
                          });
                     
                        }
                      });
                      checkInternet();
                      startStriming();
                      setState(() {});
                    }
                    ;
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
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SigUpScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do have an account? "),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SigUpScreen()));
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const SizedBox(
                            height: 30,
                            width: 40,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Color(0xff03467d),
                                    fontWeight: FontWeight.bold),
                              ),
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
              ]),
            ),
          ]),
        )));
    // );
  }
}
