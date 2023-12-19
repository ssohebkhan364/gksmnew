import 'package:flutter/material.dart';
import 'package:gkms/screen/signup.dart';
import 'login.dart';

class Splace extends StatefulWidget {
  const Splace({super.key});

  @override
  State<Splace> createState() => _SplaceState();
}

class _SplaceState extends State<Splace> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Image.asset(
            "assets/images/splace.png",
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Welcome To GKSM",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color(0xff03467d)),
          ),
          const Text(
            textAlign: TextAlign.center,
            "Create an account and access \n thousands of cool plots",
            style: TextStyle(color: Colors.blueGrey),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: Container(
                height: 52,
                decoration: const BoxDecoration(
                    color: Color(0xff03467d),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: const Center(
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigUpScreen()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color(0xff03467d), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
