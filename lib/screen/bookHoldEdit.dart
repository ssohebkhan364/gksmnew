import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/schems.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
class BookHoldEdit extends StatefulWidget {
  var isname;
  var number;
  var reranumber;
  var id;

  BookHoldEdit(
    this.isname,
    this.number,
    this.reranumber,
    this.id,
  );

  @override
  State<BookHoldEdit> createState() => _BookHoldEditState();
}

class _BookHoldEditState extends State<BookHoldEdit> {
  late ConnectivityResult result1;
late StreamSubscription subscription;
var isConnected=false;
  var isname;
  var number;
  var reranumber;
  var leangth;
  var adddar;
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
  var pannumber1;
  var numbber1;
  var pannumber2;
  var numbber2;

  String dropdownValue = 'SelectPropertyStatus';

  String dropdownValue1 = 'SelectPaymentMode';
  TextEditingController ownerName1 = TextEditingController();
  TextEditingController contact_number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pan_number = TextEditingController();
  TextEditingController description1 = TextEditingController();

  TextEditingController co_custo_name = TextEditingController();
  TextEditingController co_contact = TextEditingController();
  TextEditingController co_address = TextEditingController();
  TextEditingController co_pancard = TextEditingController();

  TextEditingController add_custo_name = TextEditingController();
  TextEditingController add_contact = TextEditingController();
  TextEditingController add_address = TextEditingController();
  TextEditingController add_pannumber = TextEditingController();

  String? filename;
  PlatformFile? pickedFile;

  File? document;

  FilePickerResult? result;

  var adhar;
  var panCard;
  var cheque;
  var pdfFile;
  bool isLoading = false;
  var co__id;
  var co_adhar;
  var co_panCard;
  var co_cheque;
  var co_pdfFile;
  var add__id;
  var add_adhar;
  var add_panCard;
  var add_cheque;
  var add_pdfFile;


 checkInternet() async {
    result1 = await Connectivity().checkConnectivity();
    print("jjjjj");
    print(result);
 
       
    if (result1 != ConnectivityResult.none) {
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

  var co__owner;
  var co__contact;
  var co__address;
  var co__pancardd;
  var co__adar;
  var co__ceque;
  var co__attacment;
  var co__pancard;

  var add__owner;
  var add__contact;
  var add__address;
  var add__pancardd;
  var add__adar;
  var add__ceque;
  var add__attacment;
  var add__pancard;
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

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
 String fileName =url.split('/').last;
      await FlutterDownloader.enqueue(
        url: url,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: baseStorage!.path,
        showNotification: true,
        openFileFromNotification: true,
          fileName:
            '${DateTime.now().millisecond}${fileName}'
      );
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    book();
     checkInternet();
     startStriming();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status =(data[1]);
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        ScaffoldMessenger.of(context as BuildContext)
            .showSnackBar(const SnackBar(
          content: Text("Download compleete"),
          backgroundColor: Color.fromRGBO(1, 48, 74, 1),
        ));
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff03467d),
          title: const Text(
            "Book/Hold Edit Form",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: isLoading
            ? Center(
                        child: SpinKitCircle(
                            color: Color(
                                                              0xff014E78),
                          size: 50,
                          ),
                      )
            : FutureBuilder(
                future: ApiServices.bookHoldEdit(context, widget.id),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.result != null) {
                      final data = snapshot.data!.result!.proptyDetail;
                      leangth = snapshot.data!.result!.multiCustomer!.length;
                      String addres = data!.address.toString();

                      String status = data.bookingStatus.toString();

                      var adhar1 = data.adharCard.toString();

                      var cheque1 = data.chequePhoto.toString();

                      var attachement = data.attachment.toString();

                      var pancardd = data.panCardImage.toString();

                      var pannumber = data.panCard.toString();
                      var contact = data.contactNo.toString();
                      var description = data.description.toString();
                      var payment_status = data.paymentMode.toString();

                      String status_value = status == '3'
                          ? 'Hold'
                          : status == '2'
                              ? 'Book'
                              : '';

                      String Value2 = payment_status == '1'
                          ? 'RTGS/IMPS'
                          : payment_status == '2'
                              ? 'Bank Transfer'
                              : payment_status == '3'
                                  ? 'Cheque'
                                  : "";

                      co__owner = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].ownerName
                          : "null";
                      print("vvvvvvvvv");
                      print(co__owner);
                      co__contact = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].contactNo
                          : "null";
                      co__address = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].address
                          : "null";
                      co__pancardd = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].panCard
                          : "null";

                      co__id = snapshot.data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].id
                              .toString()
                          : "";

                      co__adar = snapshot.data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].adharCard
                          : "null";
                      print('zczczc');
                      print(co__adar);

                      co__ceque = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].chequePhoto
                          : "null";
                      co__attacment = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot.data!.result!.multiCustomer![0].attachment
                          : "null";
                      co__pancard = snapshot
                                      .data!.result!.multiCustomer!.length ==
                                  1 ||
                              snapshot.data!.result!.multiCustomer!.length == 2
                          ? snapshot
                              .data!.result!.multiCustomer![0].panCardImage
                          : "null";

                      add__id =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot.data!.result!.multiCustomer![1].id
                                  .toString()
                              : "";

                      add__owner =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].ownerName
                              : "null";
                      print("bbbbbbbbbb");
                      print(co__owner);
                      add__contact =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].contactNo
                              : "null";

                      add__address =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot.data!.result!.multiCustomer![1].address
                              : "null";
                      add__pancardd =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot.data!.result!.multiCustomer![1].panCard
                              : "null";

                      add__adar =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].adharCard
                              : "null";

                      print('zxzxzx');
                      print(add__adar);
                      add__ceque =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].chequePhoto
                              : "null";
                      add__attacment =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].attachment
                              : "null";
                      add__pancard =
                          snapshot.data!.result!.multiCustomer!.length == 2
                              ? snapshot
                                  .data!.result!.multiCustomer![1].panCardImage
                              : "null";
                      return Form(
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 12),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.isname,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff03467d),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 12),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.number,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff03467d),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 12),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget.reranumber,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff03467d),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            enabled:
                                                data!.ownerName.toString() ==
                                                        'null'
                                                    ? true
                                                    : false,
                                            controller: ownerName1,
                                            decoration: InputDecoration(
                                                  prefixIconColor: Color(0xff03467d),
                                                prefixIcon: Icon(Icons.person,
                                                  ),
                                                hintText:
                                                    data!.ownerName.toString(),
                                              
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
                                              Text("Status"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButtonFormField(
                                              elevation: 1,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                    color: Color(0xff03467d),),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xff03467d),
                                                    ),
                                                  ),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xff03467d))),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff03467d))),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide:
                                                        const BorderSide(
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
                                                        color:
                                                            Color(0xff03467d),
                                                      ))),
                                              value: status_value,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              validator: (dropdownValue) {
                                                if (dropdownValue ==
                                                    'SelectPropertyStatus') {
                                                  return "please enter value";
                                                }
                                                return null;
                                              },
                                              items: <String>[
                                                'SelectPropertyStatus',
                                                'Book',
                                                'Hold',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Contact No."),
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
                                                prefixIcon: Icon(Icons.phone,
                                                  ),
                                                enabled: contact == 'null'
                                                    ? true
                                                    : false,
                                                hintText: contact == 'null'
                                                    ? 'Enter Contact'
                                                    : '${contact}',
                                              
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
                                              Text("Address"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: address,
                                            decoration: InputDecoration(
                                                  prefixIconColor: Color(0xff03467d),
                                                prefixIcon: Icon(Icons.info_outline_rounded,
                                               ),
                                                enabled: addres == 'null'
                                                    ? true
                                                    : false,
                                                hintText: addres == 'null'
                                                    ? 'Enter Address'
                                                    : '${addres}',
                                          
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
                                                    borderRadius: BorderRadius.circular(
                                                        25),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff03467d))),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(
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
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(color: Color(0xff03467d))),
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
                                                  color: Color(0xff03467d),),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xff03467d),
                                                    ),
                                                  ),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xff03467d))),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff03467d))),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide:
                                                        const BorderSide(
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
                                                        color:
                                                            Color(0xff03467d),
                                                      ))),
                                              value: '${payment_status}' == '0'
                                                  ? dropdownValue1
                                                  : Value2,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue1 = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'SelectPaymentMode',
                                                'RTGS/IMPS',
                                                'Bank Transfer',
                                                'Cheque',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Aadhaar Card"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.none,
                                            onTap: () {
                                              showImagePicker(context);
                                            },
                                            decoration: InputDecoration(
                                                  prefixIconColor: Color(0xff03467d),
                                                prefixIcon: Icon(Icons.image,
                                                  ),
                                                enabled:
                                                    adhar1 == '' ? true : false,
                                                hintText: adhar1 == ''
                                                    ? image == null
                                                        ? "Choose File"
                                                        : '${adhar}'
                                                    : '${adhar1}',
                                              
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: BorderSide(
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
                                                    borderSide: BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        data.adharCard.toString() == ''
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        download(
                                                            'https://dmlux.in/project/public/customer/aadhar/${data.adharCard.toString()}');
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 50,
                                                        child: Image.network(
                                                            'https://dmlux.in/project/public/customer/aadhar/${data.adharCard.toString()}',
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ],
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
                                                prefixIcon: Icon(Icons.image,
                                                   ),
                                                enabled: cheque1 == ''
                                                    ? true
                                                    : false,
                                                hintText: cheque1 == ''
                                                    ? image1 == null
                                                        ? "Choose File"
                                                        : '${cheque}'
                                                    : '${cheque1}',
                                              
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
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        data.chequePhoto.toString() == ''
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        download(
                                                            'https://dmlux.in/project/public/customer/cheque/${data.chequePhoto.toString()}');
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 50,
                                                        child: Image.network(
                                                            'https://dmlux.in/project/public/customer/cheque/${data.chequePhoto.toString()}',
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ],
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
                                                prefixIcon: Icon(Icons.attachment,
                                                    ),
                                                enabled: attachement == ''
                                                    ? true
                                                    : false,
                                                hintText: attachement == ''
                                                    ? image2 == null
                                                        ? "Choose File"
                                                        : '${pdfFile}'
                                                    : '${attachement}',
                                             
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
                                                    borderSide: BorderSide(color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        data.attachment.toString() == ''
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        download(
                                                            'https://dmlux.in/project/public/customer/attach/${data.attachment.toString()}');
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 50,
                                                        child: Image.network(
                                                            'https://dmlux.in/project/public/customer/attach/${data.attachment.toString()}',
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("Pan Card Number"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: pan_number,
                                            decoration: InputDecoration(
                                                  prefixIconColor: Color(0xff03467d),
                                                prefixIcon: Icon(Icons.numbers,
                                                   ),
                                                enabled: pannumber == 'null'
                                                    ? true
                                                    : false,
                                                hintText: pannumber == 'null'
                                                    ? 'enter Number'
                                                    : '${pannumber}',
                                               
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
                                              Text("Pan Card Photo"),
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
                                                prefixIcon: Icon(Icons.image,
                                                  ),
                                                enabled: pancardd == ''
                                                    ? true
                                                    : false,
                                                hintText: pancardd == ''
                                                    ? image3 == null
                                                        ? "Choose File"
                                                        : '${panCard}'
                                                    : '${pancardd}',
                                              
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
                                                    borderSide: BorderSide(
                                                        color: Color(0xff03467d))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xff03467d),
                                                    ))),
                                          ),
                                        ),
                                        data.panCardImage.toString() == ''
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        download(
                                                            'https://dmlux.in/project/public/customer/pancard/${data.panCardImage.toString()}');
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 50,
                                                        child: Image.network(
                                                            'https://dmlux.in/project/public/customer/pancard/${data.panCardImage.toString()}',
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        index == 1 ||
                                                snapshot
                                                        .data!
                                                        .result!
                                                        .multiCustomer!
                                                        .length ==
                                                    1 ||
                                                snapshot
                                                        .data!
                                                        .result!
                                                        .multiCustomer!
                                                        .length ==
                                                    2
                                            ? Column(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Add Co-Applicant 1",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Customer Name"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: co_custo_name,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  '$co__owner' ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: '$co__owner' ==
                                                                      'null'
                                                                  ? 'Enter Customer Name'
                                                                  : '$co__owner',
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "please enter customer_name";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Contact No."),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller: co_contact,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$co__contact" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$co__contact" ==
                                                                      'null'
                                                                  ? "Enter Contact No"
                                                                  : "$co__contact",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "please enter contact number";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Address"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller: co_address,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$co__address" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$co__address" ==
                                                                      'null'
                                                                  ? "Enter Address"
                                                                  : "$co__address",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Aadhaar Card"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        co_ImagePicker(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: '$co__adar' == "" || '$co__adar' == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: '$co__adar' == "" ||
                                                                      '$co__adar' ==
                                                                          "null"
                                                                  ? co_image ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${co_adhar}'
                                                                  : '$co__adar',
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(25),
                                                                      borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  '$co__adar' == "" ||
                                                          '$co__adar' == "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/aadhar/${co__adar.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/aadhar/${co__adar.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Cheque Photo"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        co_ImagePicker1(
                                                            context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: "$co__ceque" == "" || "$co__ceque" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$co__ceque" == "" ||
                                                                      "$co__ceque" ==
                                                                          "null"
                                                                  ? co_image1 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${co_cheque}'
                                                                  : "$co__ceque",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(25),
                                                                  borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$co__ceque" == "" ||
                                                          "$co__ceque" == "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/cheque/${co__ceque.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/cheque/${co__ceque.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Attachement"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        co_ImagePicker2(
                                                            context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(Icons
                                                                  .attachment),
                                                              enabled: "$co__attacment" == "" || "$co__attacment" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$co__attacment" == "" ||
                                                                      "$co__attacment" ==
                                                                          "null"
                                                                  ? co_image2 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${co_pdfFile}'
                                                                  : "$co__attacment",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(25),
                                                                      borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$co__attacment" == "" ||
                                                          "$co__attacment" ==
                                                              "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/attach/${co__attacment.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/attach/${co__attacment.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Pan Card Number"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller: co_pancard,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$co__pancardd" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$co__pancardd" ==
                                                                      'null'
                                                                  ? "Enter Address"
                                                                  : "$co__pancardd",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Pan Card Photo"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        co_ImagePicker3(
                                                            context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: "$co__pancard" == "" || "$co__pancard" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$co__pancard" == "" ||
                                                                      "$co__pancard" ==
                                                                          "null"
                                                                  ? co_image3 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${co_panCard}'
                                                                  : "$co__pancard",
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: const BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(25),
                                                                  borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$co__pancard" == "" ||
                                                          "$co__pancard" ==
                                                              "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/pancard/${co__pancard.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/pancard/${co__pancard.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.blue,
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
                                                    ],
                                                  ),
                                                ))
                                            : val == 2
                                                ? SizedBox()
                                                : SizedBox(),
                                        int_index == 2 ||
                                                snapshot
                                                        .data!
                                                        .result!
                                                        .multiCustomer!
                                                        .length ==
                                                    2
                                            ? Column(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Add Co-Applicant 2",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Customer Name"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller:
                                                          add_custo_name,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  '$add__owner' ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: '$add__owner' ==
                                                                      'null'
                                                                  ? 'Enter Customer Name'
                                                                  : '$add__owner',
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "please enter customer name";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Contact No."),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller: add_contact,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$add__contact" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$add__contact" ==
                                                                      'null'
                                                                  ? "Enter Contact No"
                                                                  : "$add__contact",
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "please enter contact number";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Address"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller: add_address,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$add__address" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$add__address" ==
                                                                      'null'
                                                                  ? "Enter Address"
                                                                  : "$add__address",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Aadhaar Card"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        Picker(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: '$add__adar' == "" || '$add__adar' == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: '$add__adar' == "" ||
                                                                      '$add__adar' ==
                                                                          "null"
                                                                  ? add_image ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${add_adhar}'
                                                                  : '$add__adar',
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(25),
                                                                  borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  '$add__adar' == "" ||
                                                          '$add__adar' == "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/aadhar/${add__adar.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/aadhar/${add__adar.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Cheque Photo"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        Picker1(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: "$add__ceque" == "" || "$add__ceque" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$add__ceque" == "" ||
                                                                      "$add__ceque" ==
                                                                          "null"
                                                                  ? add_image1 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${add_cheque}'
                                                                  : "$add__ceque",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(25),
                                                                  borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$add__ceque" == "" ||
                                                          "$add__ceque" ==
                                                              "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/cheque/${add__ceque.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/cheque/${add__ceque.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Attachement"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        Picker2(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(Icons
                                                                  .attachment),
                                                              enabled: "$add__attacment" == "" || "$add__attacment" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$add__attacment" == "" ||
                                                                      "$add__attacment" ==
                                                                          "null"
                                                                  ? add_image2 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${add_pdfFile}'
                                                                  : "$add__attacment",
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(25),
                                                                      borderSide: BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$add__attacment" == "" ||
                                                          "$add__attacment" ==
                                                              "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/attach/${add__attacment.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/attach/${add__attacment.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Pan Card Number"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller: add_pannumber,
                                                      decoration:
                                                          InputDecoration(
                                                              enabled:
                                                                  "$add__pancardd" ==
                                                                          'null'
                                                                      ? true
                                                                      : false,
                                                              hintText: "$add__pancardd" ==
                                                                      'null'
                                                                  ? "Enter Address"
                                                                  : "$add__pancardd",
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: const BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      borderSide:
                                                                          const BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Pan Card Photo"),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.none,
                                                      onTap: () {
                                                        Picker3(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                                prefixIconColor: Color(0xff03467d),
                                                              prefixIcon: Icon(
                                                                  Icons.image),
                                                              enabled: "$add__pancard" == "" || "$add__pancard" == "null"
                                                                  ? true
                                                                  : false,
                                                              hintText: "$add__pancard" == "" ||
                                                                      "$add__pancard" ==
                                                                          "null"
                                                                  ? add_image3 ==
                                                                          null
                                                                      ? "Choose File"
                                                                      : '${add_panCard}'
                                                                  : "$add__pancard",
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          10.0),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          25),
                                                                  borderSide: const BorderSide(
                                                                      color: Color(
                                                                          0xff03467d))),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(25),
                                                                  borderSide: const BorderSide(color: Color(0xff03467d))),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff03467d),
                                                                ),
                                                              ),
                                                              enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)), borderSide: BorderSide(color: Color(0xff03467d))),
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  ))),
                                                    ),
                                                  ),
                                                  "$add__pancard" == "" ||
                                                          "$add__pancard" ==
                                                              "null"
                                                      ? SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  download(
                                                                      'https://dmlux.in/project/public/customer/pancard/${add__pancard.toString()}');
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 50,
                                                                  child: Image.network(
                                                                      'https://dmlux.in/project/public/customer/pancard/${add__pancard.toString()}',
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                            ],
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
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            80,
                                                                        child:
                                                                            const Center(
                                                                          child: Text(
                                                                              "Remove",
                                                                              style: TextStyle(color: Colors.white)),
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
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        height:
                                                                            35,
                                                                        width:
                                                                            80,
                                                                        child: const Center(
                                                                            child:
                                                                                Text("Remove", style: TextStyle(color: Colors.white)))),
                                                              )),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              int_index = 2;
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
                                                                    Colors.red,
                                                              ),
                                                              height: 35,
                                                              width: 80,
                                                              child: const Center(
                                                                  child: Text(
                                                                      "Add More",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white))))),
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
                                                                    setState(
                                                                        () {
                                                                      index = 1;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              color: Colors.red,
                                                                            ),
                                                                            height:
                                                                                35,
                                                                            width:
                                                                                80,
                                                                            child: const Center(
                                                                                child: Text(
                                                                              "Add More",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ))),
                                                                      ],
                                                                    ),
                                                                  ))
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      int_index =
                                                                          1;
                                                                      clearText2();
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        height: 35,
                                                                        width: 80,
                                                                        child: const Center(child: Text("Remove", style: TextStyle(color: Colors.white)))),
                                                                  )),
                                                          int_index == 1
                                                              ? SizedBox()
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      index = 1;
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      height: 35,
                                                                      width: 80,
                                                                      child: const Center(child: Text("Add More", style: TextStyle(color: Colors.white))))),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : snapshot
                                                            .data!
                                                            .result!
                                                            .multiCustomer!
                                                            .length ==
                                                        0
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
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .red,
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
                                                            ],
                                                          ),
                                                        ))
                                                    : snapshot
                                                                .data!
                                                                .result!
                                                                .multiCustomer!
                                                                .length ==
                                                            2
                                                        ? InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    height: 35,
                                                                    width: 80,
                                                                    child: const Center(
                                                                        child: Text(
                                                                      "Add More",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ))),
                                                              ],
                                                            ))
                                                        : snapshot
                                                                    .data!
                                                                    .result!
                                                                    .multiCustomer!
                                                                    .length ==
                                                                1
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  int_index == 2
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Column(
                                                                              children: [
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        int_index = 1;
                                                                                        clearText2();
                                                                                      });
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Container(height: 35, width: 80, color: Colors.blue, child: const Center(child: Text("remove", style: TextStyle(color: Colors.white)))),
                                                                                    )),
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Container(height: 35, width: 80, color: Colors.red, child: const Center(child: Text("Add More", style: TextStyle(color: Colors.white))))),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        )
                                                                      : InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              int_index = 2;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                  height: 35,
                                                                                  width: 80,
                                                                                  color: Colors.red,
                                                                                  child: const Center(
                                                                                      child: Text(
                                                                                    "Add More",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ))),
                                                                            ],
                                                                          ))
                                                                ],
                                                              )
                                                            : const SizedBox(
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
                                                controller: description1,
                                                decoration: InputDecoration(
                                                  enabled: data!.description
                                                              .toString() ==
                                                          'null'
                                                      ? true
                                                      : false,
                                                  hintText: data!.description
                                                              .toString() ==
                                                          'null'
                                                      ? "Description"
                                                      : data!.description
                                                          .toString(),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xff03467d),
                                                    ),
                                                  ),
                                                ))),
                                        InkWell(
                                          onTap: () {
                                            var adharimage =
                                                data.adharCard.toString() == ''
                                                    ? image
                                                    : data.adharCard.toString();
                                            var checkimage = data.chequePhoto
                                                        .toString() ==
                                                    ''
                                                ? image
                                                : data.chequePhoto.toString();

                                            var attacheimage = data.chequePhoto
                                                        .toString() ==
                                                    ''
                                                ? image2
                                                : data.attachment.toString();

                                            var panimage = data.panCardImage
                                                        .toString() ==
                                                    ''
                                                ? image3
                                                : data.panCardImage.toString();

                                            var customer =
                                                data.ownerName.toString() ==
                                                        'null'
                                                    ? ownerName1.text
                                                    : data.ownerName.toString();

                                            var numbber =
                                                data.contactNo.toString() ==
                                                        'null'
                                                    ? contact_number.text
                                                    : data.contactNo.toString();

                                            var addresss =
                                                data.address.toString() ==
                                                        'null'
                                                    ? address.text
                                                    : data.address.toString();

                                            var pannumber =
                                                data.panCard.toString() ==
                                                        'null'
                                                    ? pan_number.text
                                                    : data.panCard.toString();

                                            var desciption = data.description
                                                        .toString() ==
                                                    'null'
                                                ? description1.text
                                                : data.description.toString();

                                            var status = dropdownValue ==
                                                    'SelectPropertyStatus'
                                                ? data.status.toString()
                                                : dropdownValue == "Hold"
                                                    ? '3'
                                                    : dropdownValue == "Book"
                                                        ? '2'
                                                        : '0';

                                            var modevalue = dropdownValue1 ==
                                                    'SelectPaymentMode'
                                                ? data.bookingStatus.toString()
                                                : dropdownValue1 == "RTGS/IMPS"
                                                    ? '1'
                                                    : dropdownValue1 ==
                                                            "Bank Transfer"
                                                        ? '2'
                                                        : dropdownValue1 ==
                                                                "Cheque"
                                                            ? '3'
                                                            : '0';

                                            var co__owner1 =
                                                co__owner == null ||
                                                        co__owner == 'null'
                                                    ? co_custo_name.text
                                                    : co__owner;
                                            var co__contact1 =
                                                co__contact == null ||
                                                        co__contact == 'null'
                                                    ? co_contact.text
                                                    : co__contact;
                                            var co__address1 =
                                                co__address == null ||
                                                        co__address == 'null'
                                                    ? co_address.text
                                                    : co__address;
                                            var co__pancarnumber =
                                                co__pancardd == null ||
                                                        co__pancardd == 'null'
                                                    ? co_pancard.text
                                                    : co__pancardd;

                                            var co__adar1 = co__adar == '' ||
                                                    co__adar == 'null'
                                                ? co_image
                                                : '';

                                            var co__ceque1 = co__ceque == '' ||
                                                    co__ceque == 'null'
                                                ? co_image1
                                                : co__ceque;
                                            var co__attacment1 =
                                                co__attacment == '' ||
                                                        co__attacment == 'null'
                                                    ? co_image2
                                                    : co__attacment;
                                            var co__pancard1 =
                                                co__pancard == '' ||
                                                        co__pancard == 'null'
                                                    ? co_image3
                                                    : co__pancard;

                                            print('yesyes');
                                            print(co__adar1);
                                            print(co__ceque1);
                                            print(co__attacment1);
                                            print(co__pancard1);

                                            var add__owner1 =
                                                add__owner == null ||
                                                        add__owner == 'null'
                                                    ? add_custo_name.text
                                                    : add__owner;
                                            var add__contact1 =
                                                add__contact == null ||
                                                        add__contact == 'null'
                                                    ? add_contact.text
                                                    : add__contact;
                                            var add__address1 =
                                                add__address == null ||
                                                        add__address == 'null'
                                                    ? add_address.text
                                                    : add__address;
                                            var add__pancarnumber =
                                                add__pancardd == null ||
                                                        add__pancardd == 'null'
                                                    ? add_pannumber.text
                                                    : add__pancardd;

                                            var add__adar1 = add__adar == '' ||
                                                    add__adar == 'null'
                                                ? add_image
                                                : add__adar;

                                            upload2(
                                              context,
                                              adharimage,
                                              checkimage,
                                              attacheimage,
                                              panimage,
                                              widget.id,
                                              modevalue,
                                              status,
                                              customer,
                                              numbber,
                                              addresss,
                                              pannumber,
                                              desciption,
                                              co__owner1,
                                              co__contact1,
                                              co__address1,
                                              co__pancarnumber,
                                              co__adar1,
                                              co__ceque1,
                                              co__attacment1,
                                              co__pancard1,
                                              add__owner1,
                                              add__contact1,
                                              add__address1,
                                              add__pancarnumber,
                                              add__adar1,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xff03467d),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                height: 52,
                                                width: double.infinity,
                                                child: const Center(
                                                    child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ))),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  )),
                            )
                          ]));
                      // }
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                }));
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

          // if (file == "jpg" || file == "pdf") {
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

  void upload2(
      BuildContext context,
      adharimage,
      checkimage,
      attacheimage,
      panimage,
      id,
      modevalue,
      status,
      customer,
      number1,
      addresss,
      pannumber,
      desciption,
      co__owner1,
      co__contact1,
      co__address1,
      co__pancarnumber,
      co__adar1,
      co__ceque1,
      co__attacment1,
      co__pancard1,
      add__owner1,
      add__contact1,
      add__address1,
      add__pancarnumber,
      add__adar1) async {
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

    var uri = Uri.parse('https://dmlux.in/project/public/api/property/booking');
    var request = http.MultipartRequest('POST', uri);

    print('soesoeb');
    print(leangth);
    print(add__id);
    print(co__id);
    if (image != null) {
      var stream = http.ByteStream(image!.openRead());
      var length = await image!.length();
      String filename = Path.basename(image!.path);
      var multipartFile = http.MultipartFile(
        'adhar_card',
        stream,
        length,
        filename: filename,
      );

      request.files.add(multipartFile);
    }
    print("wwwwww");

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
    print("wwwwww");

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
    print("wwwwww");

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

    request.fields['property_id'] = id;
    request.fields['associate_name'] = isname.toString();
    request.fields['associate_number'] = number.toString();
    request.fields['associate_rera_number'] = reranumber.toString();
    request.fields['owner_name'] = customer;

    request.fields['ploat_status'] = status;

    request.fields['contact_no'] = number1;

    request.fields['address'] = addresss;

    request.fields['payment_mode'] = modevalue;
    request.fields['pan_card_no'] = pannumber;

    request.fields['description'] = desciption;

    request.fields['pan_card_no'] = pan_number.text;

    leangth == 1 || leangth == 2 ? request.fields['piid[0]'] = co__id : null;
    index == 1 ? request.fields['piid[0]'] = '' : null;

    leangth == 2 ? request.fields['piid[1]'] = add__id : null;

    int_index == 2 ? request.fields['piid[1]'] = '' : null;
    index == 1 || leangth == 1 || leangth == 2
        ? request.fields['owner_namelist[0]'] = co__owner1
        : null;
    int_index == 2 || leangth == 2
        ? request.fields['owner_namelist[1]'] = add__owner1
        : null;
    index == 1 || leangth == 1 || leangth == 2
        ? request.fields['contact_nolist[0]'] = co__contact1
        : null;

    int_index == 2 || leangth == 2
        ? request.fields['contact_nolist[1]'] = add__contact1
        : null;
    index == 1 || leangth == 1 || leangth == 2
        ? request.fields['addresslist[0]'] = co__address1
        : null;
    int_index == 2 || leangth == 2
        ? request.fields['addresslist[1]'] = add__address1
        : null;
    index == 1 || leangth == 1 || leangth == 2
        ? request.fields['pan_card_nolist[0]'] = co__pancarnumber
        : null;
    int_index == 2 || leangth == 2
        ? request.fields['pan_card_nolist[1]'] = add__pancarnumber
        : null;

    request.headers.addAll(headers);
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("ppppppmmmm");
      print(decodedMap['status']);
      decodedMap['status'] == true
          ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Property details update successfully"),
              backgroundColor: Color.fromRGBO(1, 48, 74, 1),
            ))
          : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Plot already booked/Hold"),
              backgroundColor: Color.fromRGBO(1, 48, 74, 1),
            ));

      decodedMap['status'] == true
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SchemesSchreem()),
              (Route<dynamic> route) => route.isFirst)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SchemesSchreem()),
              (Route<dynamic> route) => route.isFirst);
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Not compleete"),
        backgroundColor: Color.fromRGBO(1, 48, 74, 1),
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchemesSchreem()),
          (Route<dynamic> route) => route.isFirst);
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print(decodedMap['message']);

      if (decodedMap['message'] == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  void book() async {
    print("ddddd");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiServices.bookHoldEdit(context, widget.id).then((value) {
      setState(() {});
      print("object");
      print(value.message.toString());
      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }
}
