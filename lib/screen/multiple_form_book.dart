import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/schems.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class MultipleForm extends StatefulWidget {
  final isname;
  final number;
  final reranumber;
  final id;
  final detail;
  List select;

  MultipleForm(
    this.isname,
    this.number,
    this.reranumber,
    this.id,
    this.select,
    this.detail,
  );

  @override
  State<MultipleForm> createState() => _MultipleFormState();
}

class _MultipleFormState extends State<MultipleForm> {
  late ConnectivityResult result1;
  late StreamSubscription subscription;
  var isConnected = false;

  var isname;
  var number;
  var reranumber;
  var detail;
  int index = 0;
  int int_index = 0;
  int val = 0;
  int remove = 0;

  ImagePicker picker = ImagePicker();
  XFile? image;
  XFile? image1;
  XFile? image2;
  XFile? image3;

  XFile? co_image;
  XFile? co_image1;
  XFile? co_image2;
  XFile? co_image3;

  XFile? add_image;
  XFile? add_image1;
  XFile? add_image2;
  XFile? add_image3;

  String dropdownValue = 'Select Property Status';
  String dropdownValue1 = 'Select Payment Mode';
  TextEditingController customer_name = TextEditingController();
  TextEditingController contact_number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pan_number = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController Adar = TextEditingController();

  TextEditingController co_custo_name = TextEditingController();
  TextEditingController co_contact = TextEditingController();
  TextEditingController co_address = TextEditingController();
  TextEditingController co_pancard = TextEditingController();
  TextEditingController co_Adar = TextEditingController();

  TextEditingController add_custo_name = TextEditingController();
  TextEditingController add_contact = TextEditingController();
  TextEditingController add_address = TextEditingController();
  TextEditingController add_pannumber = TextEditingController();
  TextEditingController add_Adar = TextEditingController();
  String? filename;
  PlatformFile? pickedFile;
  File? document;
  FilePickerResult? result;
  var adhar;
  var panCard;
  var cheque;
  var pdfFile;

  var co_adhar;
  var co_panCard;
  var co_cheque;
  var co_pdfFile;

  var add_adhar;
  var add_panCard;
  var add_cheque;
  var add_pdfFile;
  bool isLoading = false;

  void clearText() {
    add_custo_name.clear();
    add_contact.clear();
    add_address.clear();
    add_pannumber.clear();
    setState(() {
      add_image = null;
      add_image1 = null;
      add_image2 = null;
      add_image3 = null;
    });
  }

  void clearText2() {
    co_custo_name.clear();
    co_contact.clear();
    co_address.clear();
    co_pancard.clear();
    setState(() {
      co_image = null;
      co_image1 = null;
      co_image2 = null;
      co_image3 = null;
    });
  }

  checkInternet() async {
    result1 = await Connectivity().checkConnectivity();

    if (result1 != ConnectivityResult.none) {
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

  showImagePicker(BuildContext Context) {
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
                        file(Context);
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
                        _imgFromCamera(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void file(BuildContext Context) async {
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
          image = XFile(pickedFile!.path.toString());
          adhar = image!.path.split('/').last;
        });
      }
    }
  }

  _imgFromCamera(BuildContext Context) async {
    image =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));
    setState(() {
      adhar = image!.path.split('-').last;
    });
  }

  showImagePicker1(BuildContext Context) {
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
                        file1(Context);
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
                        _imgFromCamera1(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromCamera1(BuildContext Context) async {
    image1 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));
    setState(() {
      cheque = image1!.path.split('-').last;
    });
  }

  void file1(BuildContext Context) async {
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
          image1 = XFile(pickedFile!.path.toString());
          cheque = image1!.path.split('/').last;
        });
      }
    }
  }

  showImagePicker2(BuildContext Context) {
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
                        file2(Context);
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
                        _imgFromCamera2(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromCamera2(BuildContext Context) async {
    image2 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));
    setState(() {
      pdfFile = image2!.path.split('-').last;
    });
  }

  void file2(BuildContext Context) async {
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
          image2 = XFile(pickedFile!.path.toString());
          pdfFile = image2!.path.split('/').last;
        });
      }
    }
  }

  showImagePicker3(BuildContext Context) {
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
                        file3(Context);
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
                        _imgFromCamera3(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  _imgFromCamera3(BuildContext Context) async {
    image3 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      panCard = image3!.path.split('-').last;
    });
  }

  void file3(BuildContext Context) async {
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

          image3 = XFile(pickedFile!.path.toString());
          panCard = image3!.path.split('/').last;

          setState(() {});
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff03467d),
          title: const Text(
            "Book/Hold Form",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                // size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: isLoading
            ? Center(
                child: SpinKitCircle(
                  color: Color(0xff03467d),
                  size: 50,
                ),
              )
            : Form(
                key: _formKey,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Associate Name"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 48,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff03467d),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.isname,
                                              style: const TextStyle(
                                                  color: Color(0xff03467d),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Associate Contact Number"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 48,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff03467d),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.number,
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
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Associate Rera Number"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 48,
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff03467d),
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.reranumber,
                                              style: const TextStyle(
                                                  color: Color(0xff03467d),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer Name"),
                                    Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: customer_name,
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(
                                        Icons.person,
                                      ),
                                      hintText: "Enter Name...",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "The Customer Name field is required";
                                    }
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Status"),
                                    Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                              widget.detail == "1"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        elevation: 1,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xff03467d),
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                color: Color(0xff03467d),
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Color(0xff03467d))),
                                            focusedErrorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Color(0xff03467d))),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                color: Color(0xff03467d),
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        validator: (dropdownValue) {
                                          if (dropdownValue ==
                                              'Select Property Status') {
                                            return "The Select Property Status field is required.";
                                          }
                                          return null;
                                        },
                                        items: <String>[
                                          'Select Property Status',
                                          'Book',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          );
                                        }).toList(),
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonFormField(
                                        elevation: 1,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xff03467d),
                                        ),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                color: Color(0xff03467d),
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Color(0xff03467d))),
                                            focusedErrorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: Color(0xff03467d))),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: const BorderSide(
                                                color: Color(0xff03467d),
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        },
                                        validator: (dropdownValue) {
                                          if (dropdownValue ==
                                              'Select Property Status') {
                                            return "The Select Property Status field is required.";
                                          }
                                          return null;
                                        },
                                        items: <String>[
                                          'Select Property Status',
                                          'Book',
                                          'Hold',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer Contact Number"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: contact_number,
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.phone),
                                      hintText: "Enter Contact Number...",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer Address"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: address,
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon:
                                          Icon(Icons.info_outline_rounded),
                                      hintText: "Enter Address...",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Payment Mode"),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(
                                    elevation: 1,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xff03467d),
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            color: Color(0xff03467d),
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: Color(0xff03467d))),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: Color(0xff03467d))),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            color: Color(0xff03467d),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            borderSide: BorderSide(
                                                color: Color(0xff03467d))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            borderSide: BorderSide(
                                              color: Color(0xff03467d),
                                            ))),
                                    value: dropdownValue1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue1 = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Select Payment Mode',
                                      'RTGS/IMPS',
                                      'Bank Transfer',
                                      'Cheque',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    }).toList(),
                                  )),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer Aadhaar Card Number"),
                                    Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  maxLength: 12,
                                  keyboardType: TextInputType.number,
                                  controller: Adar,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.numbers),
                                      hintText: "Enter Aadhaar Card Number...",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "The Adhar Card Number field is required";
                                    } else if (value.length < 12 ||
                                        value.length > 12) {
                                      return 'Aadhaar Number must be of 12 digit';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer Aadhaar Card Photo"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.none,
                                  onTap: () {
                                    showImagePicker(context);
                                  },
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.image),
                                      hintText: image == null
                                          ? "Choose File"
                                          : '${adhar}',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Cheque Photo"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.none,
                                  onTap: () {
                                    showImagePicker1(context);
                                  },
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.image),
                                      hintText: image1 == null
                                          ? "Choose File"
                                          : '${cheque}',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Attachement"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.none,
                                  onTap: () {
                                    showImagePicker2(context);
                                  },
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.attachment),
                                      hintText: image2 == null
                                          ? "Choose File"
                                          : '${pdfFile}',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer PAN Card Number"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: pan_number,
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.numbers),
                                      hintText: "Enter PAN Card Number...",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Customer PAN Card Photo"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.none,
                                  onTap: () {
                                    showImagePicker3(context);
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      prefixIconColor: Color(0xff03467d),
                                      prefixIcon: Icon(Icons.image),
                                      hintText: image3 == null
                                          ? "Choose File"
                                          : '${panCard}',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                          color: Color(0xff03467d),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                              color: Color(0xff03467d))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          borderSide: BorderSide(
                                            color: Color(0xff03467d),
                                          ))),
                                ),
                              ),
                              index == 1
                                  ? Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Add Co-Applicant 1",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Name"),
                                              Icon(
                                                Icons.star,
                                                color: Colors.red,
                                                size: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: co_custo_name,
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                hintText: "Enter Name...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "The Customer Name field is required";
                                              }
                                            },
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Contact Number"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: co_contact,
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                hintText:
                                                    "Enter Contact Number...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Address"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: co_address,
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                hintText: "Enter Address...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "Customer Aadhaar Card Number"),
                                              Icon(Icons.star,
                                                  color: Colors.red, size: 10)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            maxLength: 12,
                                            keyboardType: TextInputType.number,
                                            controller: co_Adar,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.numbers),
                                                hintText:
                                                    "Enter Aadhaar Card Number...",
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "The Adhar Card Number field is required";
                                              } else if (value.length < 12 ||
                                                  value.length > 12) {
                                                return 'Aadhaar Number must be of 12 digit';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "Customer Aadhaar Card Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.none,
                                            onTap: () {
                                              co_ImagePicker(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: co_image == null
                                                    ? "Choose File"
                                                    : '${co_adhar}',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                                    
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Cheque Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.none,
                                            onTap: () {
                                              co_ImagePicker1(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: co_image1 == null
                                                    ? "Choose File"
                                                    : '${co_cheque}',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Attachement"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.none,
                                            onTap: () {
                                              co_ImagePicker2(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon:
                                                    Icon(Icons.attachment),
                                                hintText: co_image2 == null
                                                    ? "Choose File"
                                                    : '${co_pdfFile}',
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide:
                                                        BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer PAN Card Number"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: co_pancard,
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.numbers),
                                                hintText:
                                                    "Enter Pan Card Number...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer PAN Card Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.none,
                                            onTap: () {
                                              co_ImagePicker3(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: co_image3 == null
                                                    ? "Choose File"
                                                    : '${co_panCard}',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              val == 1
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          index = 4;
                                          val = 2;
                                          clearText();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.red,
                                                ),
                                                height: 35,
                                                width: 80,
                                                child: const Center(
                                                  child: Text("Remove",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                )),
                                          ],
                                        ),
                                      ))
                                  : val == 2
                                      ? SizedBox()
                                      : SizedBox(),
                              int_index == 2
                                  ? Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Add Co-Applicant 2",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Name"),
                                              Icon(Icons.star,
                                                  color: Colors.red, size: 10)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: add_custo_name,
                                            decoration: InputDecoration(
                                                hintText: "Enter Name...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "The Customer Name field is required";
                                              }
                                            },
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Contact Number"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: add_contact,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Enter Contact Number...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer Address"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: add_address,
                                            decoration: InputDecoration(
                                                hintText: "Enter Address...",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                25),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "Customer Aadhaar Card Number"),
                                              Icon(Icons.star,
                                                  color: Colors.red, size: 10)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            maxLength: 12,
                                            keyboardType: TextInputType.number,
                                            controller: add_Adar,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.numbers),
                                                hintText:
                                                    "Enter Adhar Card Number...",
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "The Adhar Card Number field is required";
                                              } else if (value.length < 12 ||
                                                  value.length > 12) {
                                                return 'Aadhaar Number must be of 12 digit';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "Customer Aadhaar Card Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onTap: () {
                                              Picker(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: add_image == null
                                                    ? "Choose File"
                                                    : '${add_adhar}',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Cheque Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onTap: () {
                                              Picker1(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: add_image1 == null
                                                    ? "Choose File"
                                                    : '${add_cheque}',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Attachement"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onTap: () {
                                              Picker2(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon:
                                                    Icon(Icons.attachment),
                                                hintText: add_image2 == null
                                                    ? "Choose File"
                                                    : '${add_pdfFile}',
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide:
                                                        BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer PAN Card Number"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: add_pannumber,
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.numbers),
                                                hintText:
                                                    "Enter Pan Card Number...",
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Customer PAN Card Photo"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onTap: () {
                                              Picker3(context);
                                            },
                                            decoration: InputDecoration(
                                                prefixIconColor:
                                                    Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image),
                                                hintText: add_image3 == null
                                                    ? "Choose File"
                                                    : '${add_panCard}',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: const BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff03467d),
                                                  ),
                                                ),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(25)),
                                                    borderSide: BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              index == 1
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            int_index == 1
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        index = 3;
                                                        clearText2();
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.red,
                                                          ),
                                                          height: 35,
                                                          width: 80,
                                                          child: const Center(
                                                            child: Text(
                                                                "Remove",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          )),
                                                    ))
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        int_index = 1;
                                                        val = 2;
                                                        clearText();
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.red,
                                                          ),
                                                          height: 35,
                                                          width: 80,
                                                          child: const Center(
                                                              child: Text(
                                                                  "Remove",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)))),
                                                    )),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    int_index = 2;
                                                    val = 1;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.blue,
                                                    ),
                                                    height: 35,
                                                    width: 80,
                                                    child: const Center(
                                                        child: Text("Add More",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))))),
                                          ],
                                        ),
                                      ],
                                    )
                                  : index == 4
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                int_index == 1
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            index = 1;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              height: 35,
                                                              width: 80,
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Text(
                                                                "Add More",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ))),
                                                        ))
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            int_index = 1;
                                                            clearText2();
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              height: 35,
                                                              width: 80,
                                                              child: const Center(
                                                                  child: Text(
                                                                      "Remove",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)))),
                                                        )),
                                                int_index == 1
                                                    ? SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            index = 1;
                                                            val = 1;
                                                          });
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            height: 35,
                                                            width: 80,
                                                            child: const Center(
                                                                child: Text(
                                                                    "Add More",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))))),
                                              ],
                                            ),
                                          ],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              index = 1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.blue,
                                                    ),
                                                    height: 35,
                                                    width: 80,
                                                    child: const Center(
                                                        child: Text(
                                                      "Add More",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                              ],
                                            ),
                                          )),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Description"),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      controller: description,
                                      decoration: InputDecoration(
                                        hintText: "Description...",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                            color: Color(0xff03467d),
                                          ),
                                        ),
                                      ))),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading == true;
                                    });
                                    upload1(
                                      context,
                                      image,
                                      image1,
                                      image2,
                                      image3,
                                      widget.id,
                                      dropdownValue,
                                      dropdownValue1,
                                      customer_name,
                                      contact_number,
                                      address,
                                      pan_number,
                                      description,
                                      co_pancard,
                                      co_address,
                                      co_contact,
                                      co_custo_name,
                                      add_pannumber,
                                      add_address,
                                      add_contact,
                                      add_custo_name,
                                    );
                                    checkInternet();
                                    startStriming();
                                    setState(() {});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff03467d),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      height: 52,
                                      width: double.infinity,
                                      child: const Center(
                                          child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ))),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        )),
                  )
                ]),
              ));
  }

  co_ImagePicker(BuildContext Context) {
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
                        co_file(Context);
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
                        co_imgFromCamera(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void co_file(BuildContext Context) async {
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
          co_image = XFile(pickedFile!.path.toString());

          co_adhar = co_image!.path.split('/').last;
        });
      }
    }
  }

  co_imgFromCamera(BuildContext Context) async {
    co_image =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      co_adhar = co_image!.path.split('-').last;
    });
  }

  co_ImagePicker1(BuildContext Context) {
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
                        co_file1(Context);
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
                        co_imgFromCamera1(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  co_imgFromCamera1(BuildContext Context) async {
    co_image1 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      co_cheque = co_image1!.path.split('-').last;
    });
  }

  void co_file1(BuildContext Context) async {
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
          co_image1 = XFile(pickedFile!.path.toString());

          co_cheque = co_image1!.path.split('/').last;
        });
      }
    }
  }

  co_ImagePicker2(BuildContext Context) {
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
                        co_file2(Context);
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
                        co_imgFromCamera2(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  co_imgFromCamera2(BuildContext Context) async {
    co_image2 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      co_pdfFile = co_image2!.path.split('-').last;
    });
  }

  void co_file2(BuildContext Context) async {
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
          co_image2 = XFile(pickedFile!.path.toString());

          co_pdfFile = co_image2!.path.split('/').last;
        });
      }
    }
  }

  co_ImagePicker3(BuildContext Context) {
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
                        co_file3(Context);
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
                        co_imgFromCamera3(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  co_imgFromCamera3(BuildContext Context) async {
    co_image3 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      co_panCard = co_image3!.path.split('-').last;
    });
  }

  void co_file3(BuildContext Context) async {
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

          co_image3 = XFile(pickedFile!.path.toString());

          co_panCard = co_image3!.path.split('/').last;

          setState(() {});
        });
      }
    }
  }

  Picker(BuildContext Context) {
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
                        add_file(Context);
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
                        add_imgFromCamera(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void add_file(BuildContext Context) async {
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
          add_image = XFile(pickedFile!.path.toString());

          add_adhar = add_image!.path.split('/').last;
        });
      }
    }
  }

  add_imgFromCamera(BuildContext Context) async {
    add_image =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      add_adhar = add_image!.path.split('-').last;
    });
  }

  Picker1(BuildContext Context) {
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
                        add_file1(Context);
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
                        add_imgFromCamera1(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  add_imgFromCamera1(BuildContext Context) async {
    add_image1 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      add_cheque = add_image1!.path.split('-').last;
    });
  }

  void add_file1(BuildContext Context) async {
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
          add_image1 = XFile(pickedFile!.path.toString());

          add_cheque = add_image1!.path.split('/').last;
        });
      }
    }
  }

  Picker2(BuildContext Context) {
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
                        add_file2(Context);
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
                        add_imgFromCamera2(Context);
                        Navigator.pop(Context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  add_imgFromCamera2(BuildContext Context) async {
    add_image2 =
        (await picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      add_pdfFile = add_image2!.path.split('-').last;
    });
  }

  void add_file2(BuildContext Context) async {
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
          add_image2 = XFile(pickedFile!.path.toString());

          add_pdfFile = add_image2!.path.split('/').last;
        });
      }
    }
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

  void upload1(
    BuildContext context,
    image,
    image1,
    image2,
    image3,
    id,
    value,
    dropdownValue1,
    customer_name,
    contact_number,
    address,
    pan_number,
    description,
    co_pancard,
    co_address,
    co_contact,
    co_custo_name,
    add_pannumber,
    add_address,
    add_contact,
    add_custo_name,
  ) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isname = prefs.getString('isname');
    var number = prefs.getString('is number');
    var reranumber = prefs.getString('is reranumber');

    var isToken = prefs.getString('isToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $isToken',
    };

    // var uri = Uri.parse('https://dmlux.in/project/public/api/multiplebookhold');
     var uri = Uri.parse(UrlHelper.multiple_schemform);
    var request = http.MultipartRequest('POST', uri);
    if (image != null) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      String filename = Path.basename(image.path);
      var multipartFile = http.MultipartFile(
        'adhar_card',
        stream,
        length,
        filename: filename,
      );

      request.files.add(multipartFile);
    }

    if (image1 != null) {
      String fileName2 = Path.basename(image1!.path);
      var stream2 = http.ByteStream(image1!.openRead());
      var lengthOfFile2 = await image1!.length();
      var multipartFile2 = http.MultipartFile(
          'cheque_photo', stream2, lengthOfFile2,
          filename: fileName2);
      request.files.add(multipartFile2);
    }

    if (image2 != null) {
      String fileName3 = Path.basename(image2!.path);
      var stream3 = http.ByteStream(image2!.openRead());
      var lengthOfFile3 = await image2!.length();
      var multipartFile3 = http.MultipartFile(
          'attachement', stream3, lengthOfFile3,
          filename: fileName3);
      request.files.add(multipartFile3);
    }

    if (image3 != null) {
      String fileName4 = Path.basename(image3!.path);
      var stream4 = http.ByteStream(image3!.openRead());
      var lengthOfFile4 = await image3!.length();
      var multipartFile4 = http.MultipartFile(
          'pan_card_image', stream4, lengthOfFile4,
          filename: fileName4);
      request.files.add(multipartFile4);
    }

    if (co_image != null) {
      var stream = http.ByteStream(co_image!.openRead());
      var length = await co_image!.length();
      String filename = Path.basename(co_image!.path);
      var multipartFile = http.MultipartFile(
        'adhar_cardlist[0]',
        stream,
        length,
        filename: filename,
      );

      request.files.add(multipartFile);
    }

    if (co_image1 != null) {
      String fileName2 = Path.basename(co_image1!.path);
      var stream2 = http.ByteStream(co_image1!.openRead());
      var lengthOfFile2 = await co_image1!.length();
      var multipartFile2 = http.MultipartFile(
          'cheque_photolist[0]', stream2, lengthOfFile2,
          filename: fileName2);
      request.files.add(multipartFile2);
    }

    if (co_image2 != null) {
      String fileName3 = Path.basename(co_image2!.path);
      var stream3 = http.ByteStream(co_image2!.openRead());
      var lengthOfFile3 = await co_image2!.length();
      var multipartFile3 = http.MultipartFile(
          'attachementlist[0]', stream3, lengthOfFile3,
          filename: fileName3);
      request.files.add(multipartFile3);
    }

    if (co_image3 != null) {
      String fileName4 = Path.basename(co_image3!.path);
      var stream4 = http.ByteStream(co_image3!.openRead());
      var lengthOfFile4 = await co_image3!.length();
      var multipartFile4 = http.MultipartFile(
          'pan_card_imagelist[0]', stream4, lengthOfFile4,
          filename: fileName4);
      request.files.add(multipartFile4);
    }

    if (add_image != null) {
      var stream = http.ByteStream(add_image!.openRead());
      var length = await add_image!.length();
      String filename = Path.basename(add_image!.path);
      var multipartFile = http.MultipartFile(
        'adhar_cardlist[1]',
        stream,
        length,
        filename: filename,
      );

      request.files.add(multipartFile);
    }

    if (add_image1 != null) {
      String fileName2 = Path.basename(add_image1!.path);
      var stream2 = http.ByteStream(add_image1!.openRead());
      var lengthOfFile2 = await add_image1!.length();
      var multipartFile2 = http.MultipartFile(
          'cheque_photolist[1]', stream2, lengthOfFile2,
          filename: fileName2);
      request.files.add(multipartFile2);
    }

    if (add_image2 != null) {
      String fileName3 = Path.basename(add_image2!.path);
      var stream3 = http.ByteStream(add_image2!.openRead());
      var lengthOfFile3 = await add_image2!.length();
      var multipartFile3 = http.MultipartFile(
          'attachementlist[1]', stream3, lengthOfFile3,
          filename: fileName3);
      request.files.add(multipartFile3);
    }

    if (add_image3 != null) {
      String fileName4 = Path.basename(add_image3!.path);
      var stream4 = http.ByteStream(add_image3!.openRead());
      var lengthOfFile4 = await add_image3!.length();
      var multipartFile4 = http.MultipartFile(
          'pan_card_imagelist[1]', stream4, lengthOfFile4,
          filename: fileName4);
      request.files.add(multipartFile4);
    }
    request.fields['scheme_id'] = id;
    request.fields['associate_name'] = isname.toString();
    request.fields['associate_number'] = number.toString();
    request.fields['associate_rera_number'] = reranumber.toString();
    request.fields['owner_name'] = customer_name.text;
    request.fields['adhar_card_number'] = Adar.text;
    request.fields['ploat_status'] = value == "Hold"
        ? '3'
        : value == "Book"
            ? '2'
            : '0';
    request.fields['contact_no'] = contact_number.text;
    request.fields['address'] = address.text;
    request.fields['payment_mode'] = dropdownValue1 == "RTGS/IMPS"
        ? '1'
        : dropdownValue1 == "Bank Transfer"
            ? '2'
            : dropdownValue1 == "Cheque"
                ? '3'
                : '0';

    request.fields['pan_card_no'] = pan_number.text;
    index == 1 ? request.fields['piid[0]'] = '' : null;
    int_index == 2 ? request.fields['piid[1]'] = '' : null;
    request.fields['owner_namelist[0]'] = co_custo_name.text;
    request.fields['owner_namelist[1]'] = add_custo_name.text;
    request.fields['adhar_card_number_list[0]'] = co_Adar.text;
    request.fields['adhar_card_number_list[1]'] = add_Adar.text;
    request.fields['contact_nolist[0]'] = co_contact.text;
    request.fields['contact_nolist[1]'] = add_contact.text;
    request.fields['addresslist[0]'] = co_address.text;
    request.fields['addresslist[1]'] = add_address.text;
    request.fields['pan_card_nolist[0]'] = co_pancard.text;
    request.fields['pan_card_nolist[1]'] = add_pannumber.text;
    request.fields['description'] = description.text;
    widget.select.length == 1 || widget.select.length == 2
        ? request.fields['plot_name[0]'] = widget.select[0]
        : null;
    widget.select.length == 2
        ? request.fields['plot_name[1]'] = widget.select[1]
        : print("jjj");

    request.headers.addAll(headers);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      decodedMap['status'] == true
          ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Property details update successfully"),
              backgroundColor: Color(0xff03467d),
            ))
          : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Plot already booked/Hold"),
              backgroundColor: Color(0xff03467d),
            ));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchemesSchreem()),
          (Route<dynamic> route) => route.isFirst);
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Not compleete"),
        backgroundColor: Color(0xff03467d),
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchemesSchreem()),
          (Route<dynamic> route) => route.isFirst);
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      if (decodedMap['message'] == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }
}
