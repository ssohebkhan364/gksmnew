import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/screen/dashboard.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/multiple_ploat.dart';
import 'package:gkms/screen/viewschems.dart';
import 'package:gkms/screen/schems_details.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SchemesSchreem extends StatefulWidget {
  const SchemesSchreem({super.key});

  @override
  State<SchemesSchreem> createState() => _SchemesSchreemState();
}

class _SchemesSchreemState extends State<SchemesSchreem> {
  int? value = 1;

  AnimationController? animationController;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final scrollController = ScrollController();
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  final TextEditingController searchitem = TextEditingController();
  var isLoading = false;
  int page = 1;
  var commentType = "A";
  List _posts = [];
  List _foundUsers = [];
  var id;
  var userid;

  @override
  void initState() {
    schemsList(context, page);
    scrollController.addListener(scrollPagination);
    data();
    checkInternet();
    startStriming();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('is userid');
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
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
                      scrollController.addListener(scrollPagination);
                      schemsList(context, page);
                      _foundUsers = _posts;
                      data();
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

  void scrollPagination() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      page = page + 1;
      await schemsList(context, page);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onRefresh() async {
    page = 1;
    await schemsList(context, page);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _runFilter(value) {
    if (searchitem.text.isEmpty || searchitem.text.length == 0) {
      page = 1;

      schemsList(context, page);
      setState(() {});
    } else if (searchitem.text.isNotEmpty) {
      search(
        context,
      );

      setState(() {});
    }
  }

  Future<void> schemsList(BuildContext context, page) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    var res = await http.get(
      Uri.parse(UrlHelper.SchemsUrl + "?page=$page"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (res.statusCode == 200) {
      final _postsbody = json.decode(res.body);

      _posts = page == 1
          ? _postsbody['result']['data']
          : _posts + _postsbody['result']['data'];
      setState(() {
        _foundUsers = _posts;
        isLoading = false;
      });
      final post = _posts[0];
      final id = post['scheme_id'];
      prefs.setString("schemeid", id as String);
    } else {
      final _postsbody = json.decode(res.body);
      var data = _postsbody['message'];
      if (data == "Unauthenticated.") {
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

  Future<void> search(
    BuildContext context,
  ) async {
    var data = searchitem.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(UrlHelper.SchemsUrl + '?search=$data'),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      final _postsbody = json.decode(res.body);

      _posts = _postsbody['result']['data'];
      setState(() {
        _foundUsers = _posts;
        isLoading = false;
      });

      final post = _posts[0];
      final id = post['scheme_id'];

      prefs.setString("schemeid", id as String);
      setState(() {});
    } else {
      final _postsbody = json.decode(res.body);
      var data = _postsbody['message'];
      if (data == "Unauthenticated.") {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 95,
              flexibleSpace: Container(
                color: Color(0xff03467d),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(children: <Widget>[
                      const SizedBox(width: 15),
                      InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            // size: 30,
                          )),
                      const SizedBox(width: 10),
                      const Text(
                        "Schemes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                          height: 35,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: TextFormField(
                                controller: searchitem,
                                onChanged: (value) {
                                  _runFilter(value);

                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        borderSide: BorderSide(
                                          color: Color(0xff03467d),
                                        )),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.only(top: 5),
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade300),
                                    hintText: 'enter... scheme production name',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))))),
                          ))),
                ]),
              ),
            ),
            body: _foundUsers.isEmpty || _foundUsers.length == "0"
                ? Center(
                    child: isLoading
                        ? SpinKitCircle(
                            color: Color(0xff03467d),
                            size: 50,
                          )
                        : Center(
                            child: Text("No data available",
                                style: TextStyle(
                                  color: Color(0xff1b434d),
                                ))))
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: isLoading
                            ? _foundUsers.length + 1
                            : _foundUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < _foundUsers.length) {
                            final post = _foundUsers[index];

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              color: Color(0xffe6eef3),
                                              height: 30,
                                              width: 30,
                                              child: Center(
                                                  child: Text("${index + 1}"))),
                                          Container(
                                            color: const Color(0xffe6eef3),
                                            height: 67,
                                            width: 1,
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8,
                                                  top: 8,
                                                  right: 8,
                                                  bottom: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      post['scheme_name'],
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff304754),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: 30,
                                                      child: Center(
                                                          child: Text(
                                                        post['ad_slot'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff03467d)),
                                                      )))
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      post['production_name'],
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff6c8ea1),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 8),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewSchems(
                                                                      post[
                                                                          'scheme_id'],
                                                                      userid)));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color:
                                                            Color(0xff03467d),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        "View",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      height: 25,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SchemsDetails(
                                                                      post[
                                                                          'scheme_id'])));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color:
                                                            Color(0xffe6eef3),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Details",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff03467d),
                                                          ),
                                                        ),
                                                      ),
                                                      height: 25,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Multiple_ploat(
                                                                    post[
                                                                        'scheme_id'],
                                                                  )));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color:
                                                            Color(0xffe6eef3),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Book+1",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff03467d),
                                                          ),
                                                        ),
                                                      ),
                                                      height: 25,
                                                      width: 80,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return Center(
                              child: SpinKitCircle(
                            color: Color(0xff03467d),
                            size: 50,
                          ));
                        }))));
  }
}
