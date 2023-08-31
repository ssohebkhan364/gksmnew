// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, depend_on_referenced_packages, unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class otpScreen extends StatefulWidget {
  
 
  otpScreen(
{
    super.key,
    
  });

  @override
  _otpScreenState createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  // OtpFieldController otpController = OtpFieldController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "OTP Verification",
          ),
          backgroundColor:   Color(
                                                  0xff014E78),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "we will auto detect the otp sent to your mobile",
                        style:
                            TextStyle(color:   Color(
                                                  0xff014E78), fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinCodeTextField(
                    appContext: context,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    length: 6,
                    enableActiveFill: true,
                    textStyle: TextStyle(color: Colors.white),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor:   Color(
                                                  0xff014E78),
                      activeColor:  Color(
                                                  0xff014E78),
                      inactiveFillColor:  Color(
                                                  0xff014E78),
                      inactiveColor:  Color(
                                                  0xff014E78),
                      selectedColor:  Color(
                                                  0xff014E78),
                      selectedFillColor:  Color(
                                                  0xff014E78),
                    ),
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    validator: (v) {
                        //  if (v.toString().isEmpty || v!.length != 6) {
                      if (v.toString().isEmpty ) {
                        return "Please enter valid pincode";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                  ),
                )),
                SizedBox(
                  height: 50,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // otpApi(context);
                        },
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:  Color(
                                                  0xff014E78), // foreground
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Did not get OTP ? "),
                    GestureDetector(
                      onTap: () {
                        // resendApi(context,widget.email);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ResendPassword()
                              
                              
                        //       ),
                        // );
                      },
                      child: Text(
                        "Resend ?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                Center(
                    child: isLoading != true
                        ? null
                        : const CircularProgressIndicator(
                            color: Color(0xff1b434d),
                          ))
              ],
            ),
          ),
        ));
  }
}
//   void otpApi(
//     BuildContext context,
//   ) async {
//     if (_formKey.currentState!.validate()) {
//     setState(() {
//       isLoading = true;
//     });
//     var url = 'https://clouddocs.mydevpartner.website/home/user-verify-email/';
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var id = prefs.getInt('id');
//     SharedPreferences prefs2 = await SharedPreferences.getInstance();
//     var isToken = prefs2.getString('isToken');

//     print("skp");
//     print(isToken);
//     print(id);
//     print(otpController.toString());

//     Map data = {
//       'user_id': id.toString(),
//       'otp': textEditingController.text,
//     };
//     var response = await http.post(
//       Uri.parse(url),
//       body: data,
//       headers: {
//         HttpHeaders.authorizationHeader: 'Token $isToken',
//       },
//     );
//     print(response.statusCode);
//     print(response.body);

//     if (response.statusCode == 200) {
//       setState(() {
//         isLoading = false;
//       });
//       await customDialog(context,
//           message: "User Resister sccessfully " ?? "-", title: "Success");
//       Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (context) => Login()), (routes) => false);
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       customDialog(context,
//           message: " Otp field Does Not match " ?? "-", title: "Faild");
//     }
//   }

//   }


//    void resendApi(BuildContext context,email) async {
//     print("data");
   
//       var url = 'https://clouddocs.mydevpartner.website/home/resend_otp_api/';

//       List<LoginList> loginList;
//       // SharedPreferences prefs2 = await SharedPreferences.getInstance();
//       // var isToken = prefs2.getString('isToken');

//       Map data = {'email': email};

//       setState(() {
//         isLoading = true;
//       });

//       var response = await http.post(
//         Uri.parse(url),
//         body: data,
//         // headers: {
//         //   HttpHeaders.authorizationHeader: 'Token $isToken',
//         // },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           isLoading = false;
//         });
//     const snackdemo = SnackBar(
//             content: Text('OTP will be send registered your email address'),
//             backgroundColor: Color(0xff1b434d),
//             elevation: 10,
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.all(5),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snackdemo);
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(builder: (context) =>  otpScreen()),
//         // );
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         customDialog(context,
//             message: "User Details Does Not match " ?? "-", title: "Faild");
//       }
//     }
//   }

// // }
