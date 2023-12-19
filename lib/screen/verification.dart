import 'package:flutter/material.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff014e78),
          title: Text(
            "Verification",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          )),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Text(
                  "Verify Your Email Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        "Before proceeding, please check your email for a verification link.If you did not receive the email.")),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      ApiServices.verify().then((value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        if (value.status == true) {
                          ApiServices.getLogOut(context).then((value) {});

                          prefs.clear();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => LoginScreen())));

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(value.message.toString()),
                            backgroundColor: Color.fromRGBO(1, 48, 74, 1),
                          ));
                        }
                      });
                    },
                    child: Text(
                      "Click here to request another",
                      style: TextStyle(
                          color: Color(0xff014e78),
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
