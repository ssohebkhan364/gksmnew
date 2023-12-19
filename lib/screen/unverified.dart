import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/screen/login.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Unverified extends StatefulWidget {
  const Unverified({super.key});

  @override
  State<Unverified> createState() => _UnverifiedState();
}

class _UnverifiedState extends State<Unverified> {
   final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      String fileName = url.split('/').last;
      await FlutterDownloader.enqueue(
          url: url,
          headers: {"auth": "test_for_sql_encoding"},
          savedDir: baseStorage!.path,
          showNotification: true,
          openFileFromNotification: true,
          fileName: '${DateTime.now().millisecond}${fileName}');
    }
  }

  @override
  void initState() {
    getMyPostList();

    super.initState();
  }

  void getMyPostList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiServices.getDashboard(context).then((value) {
      setState(() {});

      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }





  void _onRefresh() async {
    getMyPostList();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff03467d),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              // size: 30,
            )),
        title: Text(
          "Unverified Payment",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    
      body: FutureBuilder(
          future: ApiServices.getDashboard(BuildContext),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.result!.proofdata!.length > 0) {
                return 
                
                   SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: true,
                            onRefresh: _onRefresh,
                            child: 
                ListView.builder(
                    itemCount: snapshot.data!.result!.proofdata!.length,
                    itemBuilder: (BuildContext context, int index) {
                                                                 
  DateTime date_time = DateTime.parse(( snapshot.data!.result!
                                                .proofdata![index].bookingTime
                                                .toString()));
                          String _formattedDate =
                              DateFormat('d-MMM-yyyy HH:mm:ss')
                                  .format(date_time);
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color(0xff03467d))),
                                      child: ExpansionTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                snapshot
                                                    .data!
                                                    .result!
                                                    .proofdata![index]
                                                    .schemeName
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Color(0xff03467d),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                           _formattedDate,
                                            style: TextStyle(
                                              color: Colors.purple.shade300,
                                              fontSize: 12,
                                            ),
                                          ),
                                          trailing: Text(
                                            snapshot
                                                        .data!
                                                        .result!
                                                        .proofdata![index]
                                                        .plotName
                                                        .toString() ==
                                                    "null"
                                                ? "-"
                                                : snapshot.data!.result!
                                                    .proofdata![index].plotName
                                                    .toString(),
                                            style: TextStyle(
                                                color: Color(0xff03467d),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          children: [
                                            Column(children: [
                                              Divider(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Associate Name",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .proofdata![index]
                                                          .associateName
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Associate Number",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .proofdata![index]
                                                          .associateNumber
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Payment Details",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .proofdata![index]
                                                          .paymentDetails
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Payment Image",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 40,
                                                      child: snapshot
                                                                  .data!
                                                                  .result!
                                                                  .proofdata![
                                                                      index]
                                                                  .proofImage
                                                                  .toString() ==
                                                              ""
                                                          ? Text("")
                                                          : InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Confirmation'),
                                                                      content:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                              'Are you sure you want to download ?'),
                                                                          SizedBox(
                                                                              height: 16),
                                                                          ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Color(0xff03467d),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              download('${UrlHelper.imaeurl}customer/payment/${snapshot.data!.result!.proofdata![index].proofImage.toString()}');
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                Text('Download'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Image.network(
                                                                 '${UrlHelper.imaeurl}customer/payment/${snapshot.data!.result!.proofdata![index].proofImage.toString()}'),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(),
                                            ])
                                          ]))))
                        ],
                      );
                    }));
              }
              return Center(child: Text("No data available"));
            }

            return Center(
              child: SpinKitCircle(
                color: Color(0xff03467d),
                size: 50,
              ),
            );
          }),
    );
  }
}
