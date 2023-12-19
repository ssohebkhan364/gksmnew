import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/dashboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class otpScreen extends StatefulWidget {
  otpScreen({
    super.key,
  });

  @override
  _otpScreenState createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
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
          backgroundColor: Color(0xff03467d),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            child: Stack(children: [
              Center(
                  child: isLoading
                      ? SpinKitCircle(
                          color: Color(0xff03467d),
                          size: 50,
                        )
                      : Text("")),
              Column(
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
                           "Please Enter the OTP sent to your mobile",
                          style:
                              TextStyle(color: Color(0xff03467d), fontSize: 15),
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
                        activeFillColor: Color(0xff03467d),
                        activeColor: Color(0xff03467d),
                        inactiveFillColor: Color(0xff03467d),
                        inactiveColor: Color(0xff03467d),
                        selectedColor: Color(0xff03467d),
                        selectedFillColor: Color(0xff03467d),
                      ),
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      validator: (v) {
                        if (v.toString().isEmpty) {
                          return "Please enter valid pincode";
                        }
                        if (v.toString().length != 6) {
                          return "Please enter all number";
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
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              ApiServices.otpVerify(textEditingController.text)
                                  .then((value) async{
                                      SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                                if (value.status == true) {
                                     await ApiServices.profileGet().then((value) {
                                  prefs.setString(
                                    "user_name", value.result!.name as String);});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(value.message.toString()),
                                          backgroundColor: Color(0xff03467d)));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              HomeScreen())));
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(value.message.toString()),
                                          backgroundColor: Color(0xff03467d)));
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                            }
                          },
                          child: const Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xff03467d),
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
                          setState(() {
                            isLoading = true;
                          });
                          ApiServices.otpReVerify().then((value) {
                            if (value.status == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(value.message.toString()),
                                      backgroundColor: Color(0xff03467d)));
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(value.message.toString()),
                                      backgroundColor: Color(0xff03467d)));

                              setState(() {
                                isLoading = false;
                              });
                            }
                          });
                        },
                        child: Text(
                          "Resend ?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
