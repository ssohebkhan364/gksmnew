import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/waiting_list_details.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
   final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
           
            )),
        title: Text(
          "Waiting List",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: ApiServices.getDashboard(BuildContext),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.result!.waitingdata!.length > 0) {
                return 
                   SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: true,
                            onRefresh: _onRefresh,
                            child: 
                
                ListView.builder(
                    itemCount: snapshot.data!.result!.waitingdata!.length,
                    itemBuilder: (BuildContext context, int index) {
                                                               
  DateTime date_time = DateTime.parse(( snapshot.data!.result!
                                                .waitingdata![index].bookingTime
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
                                                    .waitingdata![index]
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
                                            snapshot.data!.result!
                                                .waitingdata![index].plotName
                                                .toString()=="null"?




                                                      "-":  snapshot.data!.result!
                                                .waitingdata![index].plotName
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
                                                          .waitingdata![index]
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
                                                          .waitingdata![index]
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
                                                      "Waiting",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .result!
                                                          .waitingdata![index]
                                                          .waitingList
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
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
                                                      "Action",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo.shade400),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WaitingScreen(
                                                                          snapshot
                                                                              .data!
                                                                              .result!
                                                                              .waitingdata![index]
                                                                              .id
                                                                              .toString(),
                                                                          snapshot
                                                                              .data!
                                                                              .result!
                                                                              .waitingdata![index]
                                                                              .plotNo
                                                                              .toString(),
                                                                        )));
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.indigo
                                                                .shade400,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 8,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            child: Text(
                                                              "View",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          )),
                                                    )
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
