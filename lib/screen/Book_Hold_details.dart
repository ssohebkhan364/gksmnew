import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/dashboard.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gkms/screen/login.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
class BookHoldDeatils extends StatefulWidget {
  var property_public_id;
  BookHoldDeatils(this.property_public_id);

  @override
  State<BookHoldDeatils> createState() => _BookHoldDeatilsState();
}

class _BookHoldDeatilsState extends State<BookHoldDeatils> {
  int pageIndex = 0;
late ConnectivityResult result;
late StreamSubscription subscription;
var isConnected=false;
  final pages = [
    HomeScreen(),
    const BookHoldReport(),
    const ProfileScreen(),
  ];
  var _date;



  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
  await  
 
ApiServices.bookHoldDetails(widget.property_public_id);
    
    _refreshController.refreshCompleted();
    setState(() {
      
    });
  }
 checkInternet() async {
    result = await Connectivity().checkConnectivity();
    print("jjjjj");
    print(result);
 
       
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      // isLoading=false;
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
    //                   scrollController.addListener(scrollPagination);
    // schemsList(context, page);
    // _foundUsers = _posts;
    // data();
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

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      print("uuul");
      print(url);
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
    getMyPostList();
      checkInternet();
     startStriming();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status =(data[1]);
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print("Download compleete");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          "Booking Details",
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

      body:  SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      onRefresh: _onRefresh,
        child: FutureBuilder(
            future: ApiServices.bookHoldDetails(widget.property_public_id),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.result != null) {
                  var date_time =
                      snapshot.data!.result!.proptyReportDetail!.cancelTime!;
      
                  String _formattedDate =
                      DateFormat('d-MMM-yyyy HH:mm:ss').format(date_time);
      
                  return Stack(children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              snapshot.data!.result!.proptyReportDetail!
                                          .schemeName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/11.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Scheme Name",
                                                style: TextStyle(
                                                    color: Color(
                                                        0xff6c8ea1)),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .schemeName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .schemeName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .plotName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/12.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Plot/Shop Number",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .plotName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .plotName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/1.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Name",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .associateName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateNumber
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/14.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Associate Contact Number",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .associateNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateNumber
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateReraNumber
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/4.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Associate Rera Number",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .associateReraNumber
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .associateReraNumber
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .ownerName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/16.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Customer Name",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .ownerName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .ownerName
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .contactNo
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/17.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Customer Contact Number",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proptyReportDetail!
                                                    .contactNo
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .contactNo
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .address
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/18.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Address",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .address
                                                            .toString() ==
                                                        "null"
                                                    ? "-"
                                                    : snapshot
                                                        .data!
                                                        .result!
                                                        .proptyReportDetail!
                                                        .address
                                                        .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .address
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .paymentMode
                                          .toString() ==
                                      "0"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/19.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Payment Method",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .paymentMode
                                                            .toString() ==
                                                        '1'
                                                    ? 'RTGS/IMPS'
                                                    : snapshot
                                                                .data!
                                                                .result!
                                                                .proptyReportDetail!
                                                                .paymentMode
                                                                .toString() ==
                                                            '2'
                                                        ? 'Bank Transfer'
                                                        : snapshot
                                                                    .data!
                                                                    .result!
                                                                    .proptyReportDetail!
                                                                    .paymentMode
                                                                    .toString() ==
                                                                '3'
                                                            ? 'Cheque'
                                                            : "",
                                                style: const TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .paymentMode
                                          .toString() ==
                                      "0"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                              .panCard
                                              .toString() ==
                                          "null" &&
                                      snapshot
                                              .data!
                                              .result!
                                              .proptyReportDetail!
                                              .panCardImage
                                              .toString() ==
                                          ""
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/20.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Pan Card",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    snapshot
                                                                .data!
                                                                .result!
                                                                .proptyReportDetail!
                                                                .panCard
                                                                .toString() ==
                                                            "null"
                                                        ? "-"
                                                        : snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .panCard
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xff304754),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: snapshot
                                                                .data!
                                                                .result!
                                                                .proptyReportDetail!
                                                                .panCardImage
                                                                .toString() ==
                                                            ""
                                                        ? Text("")
                                                        : InkWell(
                                                            onTap: () {
      
                                                              
      showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                 download(
                                                                  "https://dmlux.in/project/public/customer/pancard/${snapshot.data!.result!.proptyReportDetail!.panCardImage.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
      
                                                           
                                                            },
                                                            child: Image
                                                                .network(
                                                                    "https://dmlux.in/project/public/customer/pancard/${snapshot.data!.result!.proptyReportDetail!.panCardImage.toString()}"),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                              .panCard
                                              .toString() ==
                                          "null" &&
                                      snapshot
                                              .data!
                                              .result!
                                              .proptyReportDetail!
                                              .panCardImage
                                              .toString() ==
                                          ""
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .adharCard
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/21.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Adhar Card",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 30,
                                                width: 40,
                                                child: snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .adharCard
                                                            .toString() ==
                                                        ""
                                                    ? Text("")
                                                    : InkWell(
                                                        onTap: () {
      
      
                                                               showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                    download(
                                                              "https://dmlux.in/project/public/customer/aadhar/${snapshot.data!.result!.proptyReportDetail!.adharCard.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                       
                                                        },
                                                        child: Image.network(
                                                            "https://dmlux.in/project/public/customer/aadhar/${snapshot.data!.result!.proptyReportDetail!.adharCard.toString()}"),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .adharCard
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .chequePhoto
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/22.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Cheque Photo",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 40,
                                                child: snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .chequePhoto
                                                            .toString() ==
                                                        ""
                                                    ? Text("")
                                                    : InkWell(
                                                        onTap: () {
      
      
                                                          
                                                               showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                  download(
                                                              "https://dmlux.in/project/public/customer/cheque/${snapshot.data!.result!.proptyReportDetail!.chequePhoto.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                        
                                                        },
                                                        child: Image.network(
                                                            "https://dmlux.in/project/public/customer/cheque/${snapshot.data!.result!.proptyReportDetail!.chequePhoto.toString()}"),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .chequePhoto
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .attachment
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/23.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Attachment",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 40,
                                                child: snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .attachment
                                                            .toString() ==
                                                        ""
                                                    ? Text("")
                                                    : InkWell(
                                                        onTap: () {
      
                                                          
                                                               showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                download(
                                                              "https://dmlux.in/project/public/customer/attach/${snapshot.data!.result!.proptyReportDetail!.attachment.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                         
                                                        },
                                                        child: Image.network(
                                                            "https://dmlux.in/project/public/customer/attach/${snapshot.data!.result!.proptyReportDetail!.attachment.toString()}"),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .attachment
                                          .toString() ==
                                      ""
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .description
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/24.png",
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Description",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff6c8ea1))),
                                              const SizedBox(height: 5),
                                              Text(
                                                snapshot
                                                            .data!
                                                            .result!
                                                            .proptyReportDetail!
                                                            .description
                                                            .toString() ==
                                                        "null"
                                                    ? "-"
                                                    : snapshot
                                                        .data!
                                                        .result!
                                                        .proptyReportDetail!
                                                        .description
                                                        .toString(),
                                                style: TextStyle(
                                                    color:
                                                        Color(0xff304754),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .description
                                          .toString() ==
                                      "null"
                                  ? SizedBox()
                                  : Divider(),
                              snapshot.data!.result!.proptyReportDetail!
                                          .otherOwner
                                          .toString() ==
                                      'null'
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Card(
                                              color: Color(0xff014E78),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Other Owners Report Details",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .otherOwner
                                          .toString() ==
                                      'null'
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : ListView.builder(
                                      physics:
                                          NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.result!
                                          .otherOwner!.length,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        return Card(
                                            elevation: 3,
                                            child: ListTileTheme(
                                                contentPadding:
                                                    EdgeInsets.all(4.0),
                                                child: ExpansionTile(
                                                  tilePadding:
                                                      EdgeInsets.only(
                                                          right: 10,
                                                          top: 0,
                                                          bottom: 0,
                                                          left: 0),
                                                  title: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .only(
                                                              left: 8,
                                                              right: 8),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image.asset(
                                                            "assets/images/26.png",
                                                            height: 25,
                                                            width: 25,
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Customer Name",
                                                                  style: TextStyle(
                                                                      color:
                                                                          Color(0xff6c8ea1))),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .result!
                                                                    .otherOwner![
                                                                        index]
                                                                    .ownerName
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff304754),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 40,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(12.0),
                                                      child: Column(
                                                          children: [
                                                            Divider(),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .contactNo
                                                                        .toString() ==
                                                                    "null"
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/17.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Contact Number', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Text(
                                                                              snapshot.data!.result!.otherOwner![index].contactNo.toString(),
                                                                              style: const TextStyle(color: Color(0xff304754), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .contactNo
                                                                        .toString() ==
                                                                    "null"
                                                                ? SizedBox()
                                                                : Divider(),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .address
                                                                        .toString() ==
                                                                    "null"
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/18.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Addresss', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Text(
                                                                              snapshot.data!.result!.otherOwner![index].address.toString() == "null" ? "-" : snapshot.data!.result!.otherOwner![index].address.toString(),
                                                                              style: const TextStyle(color: Color(0xff304754), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .address
                                                                        .toString() ==
                                                                    "null"
                                                                ? SizedBox()
                                                                : Divider(),
                                                            snapshot.data!.result!.otherOwner![index].panCard.toString() ==
                                                                        "null" &&
                                                                    snapshot.data!.result!.otherOwner![index].panCardImage.toString() ==
                                                                        ""
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/20.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Pan Card', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  snapshot.data!.result!.otherOwner![index].panCard.toString() == "null" ? "-" : snapshot.data!.result!.otherOwner![index].panCard.toString(),
                                                                                  style: const TextStyle(color: Color(0xff304754), fontSize: 14, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 30,
                                                                                  width: 40,
                                                                                  child: snapshot.data!.result!.otherOwner![index].panCardImage.toString() == ""
                                                                                      ? Text("")
                                                                                      : InkWell(
                                                                                          onTap: () {
      
                                                                                              showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                 download("https://dmlux.in/project/public/customer/pancard/${snapshot.data!.result!.otherOwner![index].panCardImage.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                                                         
                                                                                          },
                                                                                          child: Image.network("https://dmlux.in/project/public/customer/pancard/${snapshot.data!.result!.otherOwner![index].panCardImage.toString()}"),
                                                                                        ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            snapshot.data!.result!.otherOwner![index].panCard.toString() ==
                                                                        "null" &&
                                                                    snapshot.data!.result!.otherOwner![index].panCardImage.toString() ==
                                                                        ""
                                                                ? SizedBox()
                                                                : Divider(),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .adharCard
                                                                        .toString() ==
                                                                    ""
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/21.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Addhar Card', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                              width: 40,
                                                                              child: snapshot.data!.result!.otherOwner![index].adharCard.toString() == ""
                                                                                  ? Text("")
                                                                                  : InkWell(
                                                                                      onTap: () {
      
           showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                 download("https://dmlux.in/project/public/customer/aadhar/${snapshot.data!.result!.otherOwner![index].adharCard.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
      
                                                                                     
                                                                                      },
                                                                                      child: Image.network("https://dmlux.in/project/public/customer/aadhar/${snapshot.data!.result!.otherOwner![index].adharCard.toString()}"),
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .adharCard
                                                                        .toString() ==
                                                                    ""
                                                                ? SizedBox()
                                                                : Divider(),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .chequePhoto
                                                                        .toString() ==
                                                                    ""
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/11.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Cheque_photo', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                              width: 40,
                                                                              child: snapshot.data!.result!.otherOwner![index].chequePhoto.toString() == ""
                                                                                  ? Text("")
                                                                                  : InkWell(
                                                                                      onTap: () {
      
        showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                 download("https://dmlux.in/project/public/customer/cheque/${snapshot.data!.result!.otherOwner![index].chequePhoto.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
      
                                                                                    
                                                                                      },
                                                                                      child: Image.network("https://dmlux.in/project/public/customer/cheque/${snapshot.data!.result!.otherOwner![index].chequePhoto.toString()}"),
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .chequePhoto
                                                                        .toString() ==
                                                                    ""
                                                                ? SizedBox()
                                                                : Divider(),
                                                            snapshot.data!.result!.otherOwner![index]
                                                                        .attachment
                                                                        .toString() ==
                                                                    ""
                                                                ? SizedBox()
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(8.0),
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Image.asset(
                                                                          "assets/images/12.png",
                                                                          height: 25,
                                                                          width: 25,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 15,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Attachment', style: TextStyle(color: Color(0xff6c8ea1))),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 30,
                                                                              width: 40,
                                                                              child: snapshot.data!.result!.otherOwner![index].attachment.toString() == ""
                                                                                  ? Text("")
                                                                                  : InkWell(
                                                                                      onTap: () {
      
      showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  'Are you sure you want to download ?'),
                                                              SizedBox(
                                                                  height:
                                                                      16),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(primary:Color(0xff03467d),),
                                                                onPressed:
                                                                    () {
                                                                 download("https://dmlux.in/project/public/customer/attach/${snapshot.data!.result!.otherOwner![index].attachment.toString()}");
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Download'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
      
                                                                                     
                                                                                      },
                                                                                      child: Image.network("https://dmlux.in/project/public/customer/attach/${snapshot.data!.result!.otherOwner![index].attachment.toString()}"),
                                                                                    ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                          ]),
                                                    )
                                                  ],
                                                )));
                                      }),
                              snapshot.data!.result!.proptyReportDetail!
                                          .cancelBy
                                          .toString() ==
                                      'null'
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Card(
                                              color: Color(0xff014E78),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancel Report Details",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                              snapshot.data!.result!.proptyReportDetail!
                                          .cancelBy
                                          .toString() ==
                                      'null'
                                  ? SizedBox(
                                      height: 0,
                                    )
                                  : Container(
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
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/25.png",
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text('Reason',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff6c8ea1))),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .proptyReportDetail!
                                                          .cancelReason
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xff304754),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/26.png",
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text('Person',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff6c8ea1))),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .proptyReportDetail!
                                                          .cancelBy
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xff304754),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/27.png",
                                                  height: 25,
                                                  width: 25,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text('Cancel Time',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff6c8ea1))),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      _formattedDate,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xff304754),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      )),
                            ]),
                      ),
                    )
                  ]);
                }
              }
              return Center(
                        child: SpinKitCircle(
                            color: Color(
                                                              0xff014E78),
                          size: 50,
                          ),
                      );
            }),
      ),

      // bottomNavigationBar: buildMyNavBar(context),
    );
  }

  void getMyPostList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiServices.bookHoldDetails(widget.property_public_id).then((value) {
      setState(() {});

      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              child: Column(
                children: [
                  pageIndex == 0
                      ? Icon(
                          Icons.home_filled,
                          size: 20,
                          color: Color(0xff03467d),
                        )
                      : Icon(
                          Icons.home_outlined,
                          color: Color(0xff03467d),
                          size: 20,
                        ),
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              child: Column(
                children: [
                  pageIndex == 1
                      ? Icon(
                          Icons.work_rounded,
                          size: 20,
                          color: Color(0xff03467d),
                        )
                      : Icon(
                          Icons.work_outline_outlined,
                          color: Color(0xff03467d),
                          size: 20,
                        ),
                  Text(
                    "Report",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              child: Column(
                children: [
                  pageIndex == 2
                      ? Icon(
                          Icons.person,
                          size: 20,
                          color: Color(0xff03467d),
                        )
                      : Icon(
                          Icons.person_2_outlined,
                          color: Color(0xff03467d),
                          size: 20,
                        ),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
