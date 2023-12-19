import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/model/payment_model.dart';
import 'package:gkms/screen/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  final id;
  Payment(this.id, {super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late ConnectivityResult results;
  late StreamSubscription subscription;
  int index = 0;
  bool isSelected = false;
  TextEditingController payment_details = TextEditingController();
  TextEditingController image = TextEditingController();
  bool isLoadingAllScreen = false;
  bool Loading = false;
  XFile? add_image3;
  var add_panCard;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? filename;
  PlatformFile? pickedFile;
  File? document;
  FilePickerResult? result;
  var isLoading = false;
  var isConnected = false;
  final _formKey = GlobalKey<FormState>();
  var idddd;
  ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    get();
  }

  void get() {
    setState(() {
      isLoadingAllScreen = true;
    });
    ApiServices.payment(
      context,
      widget.id,
    ).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
          "payment_id", value.result!.propertyDetails!.id.toString());
      var payment_id = prefs.getString('payment_id');

      idddd = payment_id;
      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (value.status == true) {
            prefs.clear();
          }
        });

        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
    setState(() {
      isLoadingAllScreen = false;
    });
  }

  Picker3(BuildContext Context) {
    showModalBottomSheet(
        context: Context,
        builder: (builder) {
          return Card(
            child: Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 30.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        add_file3(Context);
                        Navigator.pop(Context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 30.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        add_imgFromCamera3(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  add_imgFromCamera3(BuildContext Context) async {
    add_image3 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      add_panCard = add_image3!.path.split('-').last;
    });
  }

  void add_file3(BuildContext Context) async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    {
      if (result == null) {
      } else {
        setState(() {
          filename = result!.files.first.name;
          pickedFile = result!.files.first;
          var img = File(pickedFile!.path.toString());

          String file = img.path.split('.').last;

          imageCache.clear();

          add_image3 = XFile(pickedFile!.path.toString());

          setState(() {
            add_panCard = add_image3!.path.split('/').last;
          });
        });
      }
    }
  }

  checkInternet() async {
    results = await Connectivity().checkConnectivity();

    if (results != ConnectivityResult.none) {
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
                      // scrollController.addListener(scrollPagination);
                      // viewSchems(context, page, widget.get_id);
                      get();
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

  void _onRefresh() async {
    //  page = 1;
    get();
    _refreshController.refreshCompleted();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: Color(0xff03467d),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(children: <Widget>[
                const SizedBox(width: 15),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      // size: 30,
                    )),
                const SizedBox(width: 10),
                const Text(
                  "Payment Proof Form",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ]),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(children: [
          Center(
            child: isLoading
                ? SpinKitCircle(
                    color: Color(0xff03467d),
                    size: 50,
                  )
                : null,
          ),
          Center(
              child: isLoadingAllScreen
                  ? SpinKitCircle(
                      color: Color(0xff03467d),
                      size: 50,
                    )
                  :
             
                  Column(
                      children: [
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Payment Details",
                                style: TextStyle(
                                  color: Color(0xff03467d),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: payment_details,
                            decoration: InputDecoration(
                                prefixIconColor: Color(0xff03467d),
                                prefixIcon: Icon(Icons.payment),
                                // labelText: 'Payment Details',
                                // labelStyle: const TextStyle(
                                //   color: Color(0xff03467d),
                                // ),
                                hintStyle: TextStyle(color: Color(0xff03467d)),
                                hintText: "Payment Details",
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
                                    borderSide:
                                        BorderSide(color: Color(0xff03467d))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                        BorderSide(color: Color(0xff03467d))),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The Payment Details field is required.";
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                "Payment Image",
                                style: TextStyle(
                                  color: Color(0xff03467d),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            // controller: image,
                            onTap: () {
                              Picker3(context);
                            },
                            decoration: InputDecoration(
                                prefixIconColor: Color(0xff03467d),
                                prefixIcon: Icon(Icons.image),
                                hintStyle: TextStyle(
                                  color: Color(0xff03467d),
                                ),
                                hintText: add_image3 == null
                                    ? "Choose File"
                                    : '${add_panCard}',
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
                                    borderSide: const BorderSide(
                                        color: Color(0xff03467d))),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: const BorderSide(
                                        color: Color(0xff03467d))),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The Payment image field is required.";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              add_image3 == null || payment_details.text.isEmpty
                                  ? ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: payment_details.text.isEmpty
                                          ? Text(
                                              "The Payment details field is required.")
                                          : add_image3 == null
                                              ? Text(
                                                  "The Payment image field is required.")
                                              : Text(""),
                                      backgroundColor: Color(0xff03467d),
                                      dismissDirection: DismissDirection.up,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          left: 10,
                                          right: 10),
                                    ))
                                  : setState(() {
                                      isLoading = true;
                                    });
                              //  setState(() {
                              //     isLoadingAllScreen = true;
                              //   });
                              ApiServices.paymentPost(context, add_image3,
                                      idddd, payment_details.text)
                                  .then((value) {
                                if (value.status == true) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                            },
                            //  },
                            child: Container(
                              height: 52,
                              decoration: const BoxDecoration(
                                  color: Color(0xff03467d),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    )
              // }
              // return Center(
              //     child: SpinKitCircle(
              //   color: Color(0xff03467d),
              //   size: 50,
              // ));
              // }),
              ),
        ]),
      ),
    );
  }
}
