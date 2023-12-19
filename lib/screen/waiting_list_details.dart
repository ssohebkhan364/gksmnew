import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/model/waiting_list.dart';
import 'package:gkms/screen/login.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class WaitingScreen extends StatefulWidget {
  var id, number;
  WaitingScreen(this.id, this.number, {super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoadingAllScreen = false;
  List<Data> offererProductList = [];
  @override
  void initState() {
    super.initState();
    get();
  }

  void get() {
    setState(() {
      isLoadingAllScreen = true;
    });
    ApiServices.waiting(context, widget.id, widget.number).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("nbnb");
      print(value.message.toString());
      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
      setState(() {
        isLoadingAllScreen = false;
      });
      if (value.status == true) {
        offererProductList = value.result!.data;
        setState(() {});
      }
    });
  }

  void _onRefresh() async {
    get();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff03467d),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            "Waiting List Details",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(children: [
          isLoadingAllScreen
              ? Center(
                  child: SpinKitCircle(
                    color: Color(0xff03467d),
                    size: 50,
                  ),
                )
              : Text(""),
          SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount: offererProductList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (offererProductList.isNotEmpty ||
                        offererProductList != "null") {
                      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(
                              offererProductList[index].bookingTime.toString());

                      String _formattedDate =
                          DateFormat('d-MMM-yyyy HH:mm:ss').format(tempDate);
                      print("jdsfkj");
                      print(offererProductList[index].associateNumber.toString());
                      return Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Colors.indigo.shade100),
                                child: Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ExpansionTile(
                                            title: Text(
                                              offererProductList[index]
                                                  .associateName
                                                  .toString(),
                                              style: TextStyle(
                                                color: Color(0xff03467d),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            trailing: Text(
                                              _formattedDate,
                                              style: TextStyle(
                                                color: Color(0xff03467d),
                                              ),
                                            ),
                                            children: [
                                              Column(children: [
                                                Divider(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        "Customer Name",
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      ),
                                                      Text(
                                                        offererProductList[
                                                                index]
                                                            .ownerName
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        "Customer Addhar Number",
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      ),
                                                      Text(
                                                        offererProductList[
                                                                index]
                                                            .adharCardNumber
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        "Associate Contact Number",
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      ),
                                                      offererProductList[index]
                                                                  .associateNumber
                                                                  .toString() !=
                                                              "null"
                                                          ? Text(
                                                              offererProductList[
                                                                      index]
                                                                  .associateNumber
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .indigo
                                                                      .shade400),
                                                            )
                                                          : Text(
                                                              "-",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .indigo
                                                                      .shade400),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        "Associate Rera Number",
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      ),
                                                      Text(
                                                        offererProductList[
                                                                index]
                                                            .associateReraNumber
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.indigo
                                                                .shade400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                              ])
                                            ])))))
                      ]);
                    }
                    Center(child: Text("No Data found"));
                  }))
        ]));
  }
}
