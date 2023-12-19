


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/screen/bookHoldEdit.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/payment.dart';
import 'package:gkms/screen/schemeForm.dart';
import 'package:gkms/screen/waiting_list_details.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ViewSchems extends StatefulWidget {
  final get_id;
  final profile_id;
  ViewSchems(
    this.get_id,
    this.profile_id,
  );

  @override
  State<ViewSchems> createState() => _ViewSchemsState();
}

class _ViewSchemsState extends State<ViewSchems> {
  int? value = 1;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  AnimationController? animationController;
  final scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController searchitem = TextEditingController();
  var isLoading = false;
  int page = 1;
  var commentType = "A";
  var tvSelected;
  List _posts = [];
  List _foundUsers = [];
  var details;
  var isname;
  var number;
  var reranumber;
  int selected = -1;

  @override
  void initState() {
    viewSchems(context, page, widget.get_id);
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
    isname = prefs.getString('isname');
    number = prefs.getString('is number');
    reranumber = prefs.getString('is reranumber');
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
                      viewSchems(context, page, widget.get_id);
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
      await viewSchems(context, page, widget.get_id);
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _onRefresh() async {
  //   page = 1;
  //   await viewSchems(context, widget.get_id,page);
  //   _refreshController.refreshCompleted();

  //   setState(() {});
  // }
   void _onRefresh() async {
    page = 1;
    await viewSchems(context, page,widget.get_id);
    _refreshController.refreshCompleted();
    setState(() {});
  }


  void _runFilter(value) {
    if (searchitem.text.isEmpty || searchitem.text.length == 0) {
      page = 1;

      viewSchems(context, page, widget.get_id);
      setState(() {});
    } else if (searchitem.text.isNotEmpty) {
      search(context, widget.get_id);
      setState(() {});
    }
  }

  Future<void> viewSchems(BuildContext context, page, get_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
    Uri.parse(UrlHelper.SchemsMenuUrl + "$get_id?page=$page"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      print("kjkjk");
      print(res.body);
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts = page == 1
            ? _postsbody['result']['properties']['data']
            : _posts + _postsbody['result']['properties']['data'];

        _foundUsers = _posts;

        details = _postsbody['result']['scheme_detail']['hold_status'];
        isLoading = false;
      });
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

  // Future<void> viewSchems1(BuildContext context, get_id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var isToken = prefs.getString('isToken');
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var res = await http.get(
  //    Uri.parse(UrlHelper.SchemsMenuUrl + "$get_id"),
  //     headers: {
  //       'Authorization': "Bearer $isToken",
  //     },
  //   );
  //   if (res.statusCode == 200) {
  //     setState(() {
  //       final _postsbody = json.decode(res.body);

  //       _posts = _postsbody['result']['properties']['data'];

  //       _foundUsers = _posts;

  //       details = _postsbody['result']['scheme_detail']['hold_status'];
  //       isLoading = false;
  //     });
  //   } else {
  //     final _postsbody = json.decode(res.body);
  //     var data = _postsbody['message'];

  //     if (data == "Unauthenticated.") {
  //       ApiServices.getLogOut(context).then((value) {
  //         if (value.status == true) {
  //           prefs.clear();
  //         }
  //       });
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: ((context) => LoginScreen())));
  //     }
  //   }
  // }

  Future<void> search(BuildContext context, get_id) async {
    var data = searchitem.text.toLowerCase() == "completed"
        ? "5"
        : searchitem.text.toLowerCase() == "booked"
            ? "2"
            : searchitem.text.toLowerCase() == "hold"
                ? "3"
                : searchitem.text.toLowerCase() == "to be released"
                    ? "4"
                    : searchitem.text.toLowerCase() == "available"
                        ? "1"
                        : searchitem.text.toLowerCase() == "managment hold"
                            ? "6"
                            : searchitem.text.toLowerCase();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
     Uri.parse(UrlHelper.SchemsMenuUrl + '$get_id?search=$data'),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);
        _posts = _postsbody['result']['properties']['data'];
        _foundUsers = _posts;
        isLoading = false;
      });
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
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          // size: 30,
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      "View Schemes",
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

                                // setState(() {});
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide: BorderSide(
                                        color: Color(0xff03467d),
                                      )),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.only(top: 5),
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade300),
                                  hintText: 'enter... unit no type status',
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
              : Stack(
                children: [
 Column(
                    children: [
                      details == '1'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Color(0xfffff3f1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.star),
                                      Text(
                                          "Hold option is disable for this scheme",
                                          style: TextStyle(
                                              color: Color(0xffc98e89),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.star),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      Expanded(
                        child: SmartRefresher(
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
                
                                  final scheme_id = post['scheme_id'];
                                  final scheme_name = post['scheme_name'];
                                  final plot_no = post['plot_no'];
                                  final plot_type = post['plot_type'];
                                  final property_id = post['property_public_id'];
                                  final otherinfo = post['other_info'];
                                  final attribute = post['attributes_data'];
                                  final property_status = post['property_status'];
                                  final plot_name = post['plot_name'];
                                  final output = '$attribute'
                                      .replaceAll(RegExp('[\{""}]'), '');
                                  final attributes =
                                      '$output'.replaceAll(',', ', ');
                                  final management_hold = post['management_hold'];
                                  final plotname =
                                      "$plot_name" == "null" ? "" : "$plot_name";
                                  final userid = post['user_id'];
                
                                  final name = post['name'];
                                  final waiting_list = post['waiting_list'];
                
                                  String time = post['cancel_time'] == null
                                      ? "2023-08-02 09:50:49"
                                      : post['cancel_time'];
                
                                  DateTime tempDate =
                                      DateFormat("yyyy-MM-dd hh:mm:ss")
                                          .parse(time);
                
                                  DateTime current_date = DateTime.now();
                                  var curret_1 = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(current_date);
                
                                  DateTime yesterday =
                                      tempDate.add(Duration(days: 1));
                                  var ydate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .format(yesterday);
                                  DateTime dt1 = DateTime.parse(ydate);
                                  DateTime dt2 = DateTime.parse(curret_1);
                
                                  int datte = 0;
                                  if (dt1.isBefore(dt2)) {
                                    datte = 1;
                                  }
                
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: const BoxDecoration(),
                                      child: Container(
                                          color: "$property_status" == '2'
                                              ? Color(0xffe0f4f4)
                                              : "$property_status" == '3'
                                                  ? userid == widget.profile_id
                                                      ? Color(0xfffff3f1)
                                                      : Color(0xfffff3f1)
                                                  : "$property_status" == '4'
                                                      ? Color(0xffece6f8)
                                                      : "$property_status" == '5'
                                                          ? Color(0xffe4f4e4)
                                                          : "$property_status" ==
                                                                  '6'
                                                              ? "$management_hold" ==
                                                                      "1"
                                                                  ? Color(
                                                                      0xffeaf1fb)
                                                                  : "$management_hold" ==
                                                                          "2"
                                                                      ? Color(
                                                                          0xffeaf1fb)
                                                                      : "$management_hold" ==
                                                                              "3"
                                                                          ? Color(
                                                                              0xffeaf1fb)
                                                                          : "$management_hold" ==
                                                                                  "4"
                                                                              ? Color(0xffeaf1fb)
                                                                              : "$management_hold" == "5"
                                                                                  ? Color(0xffeaf1fb)
                                                                                  : "$management_hold" == "6"
                                                                                      ? Color(0xffeaf1fb)
                                                                                      : Color(0xffeaf1fb)
                                                              : Color(0xfff6f5fb),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: ExpansionTile(
                                                onExpansionChanged:
                                                    (expandedindex) {
                                                  setState(() {
                                                    tvSelected = plot_no;
                                                  });
                                                },
                                                title: Text(
                                                  "$plot_type-"
                                                  "$plotname",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: "$property_status" ==
                                                            '2'
                                                        ? Color(0xff3d9191)
                                                        : "$property_status" ==
                                                                '3'
                                                            ? userid ==
                                                                    widget
                                                                        .profile_id
                                                                ? Color(
                                                                    0xffff3727)
                                                                : Color(
                                                                    0xffff3727)
                                                            : "$property_status" ==
                                                                    '4'
                                                                ? Color(
                                                                    0xff7246dd)
                                                                : "$property_status" ==
                                                                        '5'
                                                                    ? Color(
                                                                        0xff328232)
                                                                    : "$property_status" ==
                                                                            '6'
                                                                        ? "$management_hold" ==
                                                                                "1"
                                                                            ? const Color(
                                                                                0xff427fda)
                                                                            : "$management_hold" == "2"
                                                                                ? Color(0xff427fda)
                                                                                : "$management_hold" == "3"
                                                                                    ? Color(0xff427fda)
                                                                                    : "$management_hold" == "4"
                                                                                        ? Color(0xff427fda)
                                                                                        : "$management_hold" == "5"
                                                                                            ? Color(0xff427fda)
                                                                                            : "$management_hold" == "6"
                                                                                                ? Color(0xff427fda)
                                                                                                : Color(0xff427fda)
                                                                        : Color(0xff413673),
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$scheme_name",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: "$property_status" ==
                                                                '2'
                                                            ? Color(0xff8bafaf)
                                                            : "$property_status" ==
                                                                    '3'
                                                                ? userid ==
                                                                        widget
                                                                            .profile_id
                                                                    ? Color(
                                                                        0xffc98e89)
                                                                    : Color(
                                                                        0xffc98e89)
                                                                : "$property_status" ==
                                                                        '4'
                                                                    ? Color(
                                                                        0xff9685c0)
                                                                    : "$property_status" ==
                                                                            '5'
                                                                        ? Color(
                                                                            0xff88ac88)
                                                                        : "$property_status" ==
                                                                                '6'
                                                                            ? "$management_hold" == "1"
                                                                                ? Color(0xff8294af)
                                                                                : "$management_hold" == "2"
                                                                                    ? Color(0xff8294af)
                                                                                    : "$management_hold" == "3"
                                                                                        ? Color.fromARGB(255, 4, 5, 6)
                                                                                        : "$management_hold" == "4"
                                                                                            ? Color(0xff8294af)
                                                                                            : "$management_hold" == "5"
                                                                                                ? Color(0xff8294af)
                                                                                                : "$management_hold" == "6"
                                                                                                    ? Color(0xff8294af)
                                                                                                    : Color(0xff8294af)
                                                                            : Color(0xff767191),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(""),
                                                      "$property_status" == '2'
                                                          ? '$otherinfo' == 'null'
                                                              ? const Text(
                                                                  "Booked",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xff8bafaf)),
                                                                )
                                                              : Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "Booked",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                                  14,
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                              color: Color(0xff8bafaf)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      "$otherinfo",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff8294af),
                                                                          fontSize:
                                                                              8,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  ],
                                                                )
                                                          : "$property_status" ==
                                                                  '3'
                                                              ? '$otherinfo' ==
                                                                      'null'
                                                                  ? const Text(
                                                                      "Hold",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xffc98e89),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                      ),
                                                                    )
                                                                  : Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        const Text(
                                                                          "Hold",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xffc98e89),
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "$otherinfo",
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xff8294af),
                                                                              fontSize:
                                                                                  8,
                                                                              fontWeight:
                                                                                  FontWeight.w600),
                                                                        )
                                                                      ],
                                                                    )
                                                              : "$property_status" ==
                                                                      '4'
                                                                  ? '$otherinfo' ==
                                                                          'null'
                                                                      ? const Text(
                                                                          "To be Released",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff9685c0),
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        )
                                                                      : Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            const Text(
                                                                              "To be Released",
                                                                              style:
                                                                                  TextStyle(
                                                                                color: Color(0xff9685c0),
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "$otherinfo",
                                                                              style: TextStyle(
                                                                                  color: Color(0xff8294af),
                                                                                  fontSize: 8,
                                                                                  fontWeight: FontWeight.w600),
                                                                            )
                                                                          ],
                                                                        )
                                                                  : "$property_status" ==
                                                                          '5'
                                                                      ? '$otherinfo' ==
                                                                              'null'
                                                                          ? const Text(
                                                                              "Completed",
                                                                              style: TextStyle(
                                                                                  color: Color(0xff88ac88),
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w600),
                                                                            )
                                                                          : Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.end,
                                                                              children: [
                                                                                const Text(
                                                                                  "Completed",
                                                                                  style: TextStyle(color: Color(0xff88ac88), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                ),
                                                                                Text(
                                                                                  "$otherinfo",
                                                                                  style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                )
                                                                              ],
                                                                            )
                                                                      : "$property_status" ==
                                                                              '6'
                                                                          ? "$management_hold" ==
                                                                                  "1"
                                                                              ? '$otherinfo' == 'null'
                                                                                  ? const Text(
                                                                                      "Rahan",
                                                                                      style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                    )
                                                                                  : Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        const Text(
                                                                                          "Rahan",
                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                        Text(
                                                                                          "$otherinfo",
                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                              : "$management_hold" == "2"
                                                                                  ? '$otherinfo' == 'null'
                                                                                      ? const Text(
                                                                                          "Possession issue",
                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                        )
                                                                                      : Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          children: [
                                                                                            const Text(
                                                                                              "Possession issue",
                                                                                              style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                            ),
                                                                                            Text(
                                                                                              "$otherinfo",
                                                                                              style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                            )
                                                                                          ],
                                                                                        )
                                                                                  : "$management_hold" == "3"
                                                                                      ? '$otherinfo' == 'null'
                                                                                          ? const Text(
                                                                                              "Staff plot",
                                                                                              style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                            )
                                                                                          : Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              children: [
                                                                                                const Text(
                                                                                                  "Staff plot",
                                                                                                  style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                ),
                                                                                                Text(
                                                                                                  "$otherinfo",
                                                                                                  style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                                )
                                                                                              ],
                                                                                            )
                                                                                      : "$management_hold" == "4"
                                                                                          ? '$otherinfo' == 'null'
                                                                                              ? const Text(
                                                                                                  "Executive plot",
                                                                                                  style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                )
                                                                                              : Column(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                  children: [
                                                                                                    const Text(
                                                                                                      "Executive plot",
                                                                                                      style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "$otherinfo",
                                                                                                      style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                                    )
                                                                                                  ],
                                                                                                )
                                                                                          : "$management_hold" == "5"
                                                                                              ? '$otherinfo' == 'null'
                                                                                                  ? const Text(
                                                                                                      "Associate plot",
                                                                                                      style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                    )
                                                                                                  : Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                      children: [
                                                                                                        const Text(
                                                                                                          "Associate plot",
                                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          "$otherinfo",
                                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                              : "$management_hold" == "6"
                                                                                                  ? '$otherinfo' == 'null'
                                                                                                      ? const Text(
                                                                                                          "Other",
                                                                                                          style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                        )
                                                                                                      : Column(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                          children: [
                                                                                                            const Text(
                                                                                                              "Other",
                                                                                                              style: TextStyle(color: Color(0xff8294af), fontSize: 14, fontWeight: FontWeight.w600),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              "$otherinfo",
                                                                                                              style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                                            )
                                                                                                          ],
                                                                                                        )
                                                                                                  : Text("")
                                                                          : '$otherinfo' == 'null'
                                                                              ? const Text(
                                                                                  'Available',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Color(0xff767191),
                                                                                  ),
                                                                                )
                                                                              : Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Available',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Color(0xff767191),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      "$otherinfo",
                                                                                      style: TextStyle(color: Color(0xff8294af), fontSize: 8, fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                    ]),
                                                children: [
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              right: 12),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            "$property_status" ==
                                                                        '0' ||
                                                                    "$property_status" ==
                                                                        '1' ||
                                                                    "$property_status" ==
                                                                        '4' ||
                                                                    "$property_status" ==
                                                                        '6'
                                                                ? SizedBox(
                                                                    height: 0,
                                                                  )
                                                                : waiting_list ==
                                                                        "0"
                                                                    ? Text(
                                                                        "",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xff8bafaf)),
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: ((context) => WaitingScreen(scheme_id, plot_no))));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Waiting List -  $waiting_list',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff03467d),
                                                                          ),
                                                                        ),
                                                                      ),
                                                            "$property_status" ==
                                                                        '0' ||
                                                                    "$property_status" ==
                                                                        '1' ||
                                                                    "$property_status" ==
                                                                        '4' ||
                                                                    "$property_status" ==
                                                                        '6'
                                                                ? SizedBox(
                                                                    height: 0,
                                                                  )
                                                                : Text(
                                                                    'By: $name',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff8bafaf)),
                                                                  ),
                                                          ]),
                                                    ),
                                                    Divider(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 18,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          "$property_status" ==
                                                                      '2' &&
                                                                  userid ==
                                                                      widget
                                                                          .profile_id
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) =>
                                                                                Payment(property_id))));
                                                                  },
                                                                  child: Text(
                                                                    "Upload Payment Proof",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xff03467d),
                                                                    ),
                                                                  ))
                                                              : SizedBox(
                                                                  height: 0,
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        '$attributes' != "null"
                                                            ? Expanded(
                                                                child: Text(
                                                                    "$plot_type-"
                                                                    '$attributes',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: "$property_status" ==
                                                                              '2'
                                                                          ? Color(
                                                                              0xff8bafaf)
                                                                          : "$property_status" ==
                                                                                  '3'
                                                                              ? userid == widget.profile_id
                                                                                  ? Color(0xffc98e89)
                                                                                  : Color(0xffc98e89)
                                                                              : "$property_status" == '4'
                                                                                  ? Color(0xff9685c0)
                                                                                  : "$property_status" == '5'
                                                                                      ? Color(0xff88ac88)
                                                                                      : "$property_status" == '6'
                                                                                          ? "$management_hold" == "1"
                                                                                              ? Color(0xff8294af)
                                                                                              : "$management_hold" == "2"
                                                                                                  ? Color(0xff8294af)
                                                                                                  : "$management_hold" == "3"
                                                                                                      ? Color(0xff8294af)
                                                                                                      : "$management_hold" == "4"
                                                                                                          ? Color(0xff8294af)
                                                                                                          : "$management_hold" == "5"
                                                                                                              ? Color(0xff8294af)
                                                                                                              : "$management_hold" == "6"
                                                                                                                  ? Color(0xff8294af)
                                                                                                                  : Color(0xff8294af)
                                                                                          : Color(0xff767191),
                                                                    )),
                                                              )
                                                            : const Text('-',
                                                                style: TextStyle(
                                                                    fontSize: 12))
                                                      ],
                                                    ),
                                                    Row(children: [
                                                      Expanded(
                                                          child: SizedBox(
                                                        width: 50,
                                                      )),
                                                      "$property_status" == '1'
                                                          ? userid ==
                                                                  widget
                                                                      .profile_id
                                                              ? datte == 1
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              50,
                                                                          bottom:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                      child: Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => SchemeForm(
                                                                                            isname,
                                                                                            number,
                                                                                            reranumber,
                                                                                            property_id,
                                                                                            details,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(30),
                                                                                color: Color(0xff03467d),
                                                                              ),
                                                                              height:
                                                                                  35,
                                                                              width:
                                                                                  100,
                                                                              child:
                                                                                  const Padding(
                                                                                padding: EdgeInsets.all(4.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'Book/Hold',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Text("")
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              50,
                                                                          bottom:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                  child: Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => SchemeForm(
                                                                                        isname,
                                                                                        number,
                                                                                        reranumber,
                                                                                        property_id,
                                                                                        details,
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30),
                                                                            color:
                                                                                Color(0xff03467d),
                                                                          ),
                                                                          height:
                                                                              35,
                                                                          width:
                                                                              100,
                                                                          child:
                                                                              const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4.0),
                                                                            child:
                                                                                Center(
                                                                              child:
                                                                                  Text(
                                                                                'Book/Hold',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                          : "$property_status" ==
                                                                  '3'
                                                              ? userid ==
                                                                      widget
                                                                          .profile_id
                                                                  // ? datte == 1
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              12,
                                                                          top: 10,
                                                                          bottom:
                                                                              10),
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => BookHoldEdit(
                                                                                            isname,
                                                                                            number,
                                                                                            reranumber,
                                                                                            property_id,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(30),
                                                                                color: Color(0xff03467d),
                                                                              ),
                                                                              height:
                                                                                  35,
                                                                              width:
                                                                                  100,
                                                                              child:
                                                                                  const Padding(
                                                                                padding: EdgeInsets.all(4.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'Book/Hold',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Text("")
                                                          
                                                              : "$property_status" ==
                                                                      '0'
                                                                  ? userid ==
                                                                          widget
                                                                              .profile_id
                                                                      ? datte == 1
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                  left: 50,
                                                                                  bottom: 10,
                                                                                  top: 10),
                                                                              child:
                                                                                  Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => SchemeForm(
                                                                                                    isname,
                                                                                                    number,
                                                                                                    reranumber,
                                                                                                    property_id,
                                                                                                    details,
                                                                                                  )));
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                        color: Color(0xff03467d),
                                                                                      ),
                                                                                      height: 35,
                                                                                      width: 100,
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.all(4.0),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            ' Book/Hold',
                                                                                            style: TextStyle(
                                                                                              color: Colors.white,
                                                                                              fontSize: 12,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              "")
                                                                      : Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  50,
                                                                              bottom:
                                                                                  10,
                                                                              top:
                                                                                  10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => SchemeForm(
                                                                                                isname,
                                                                                                number,
                                                                                                reranumber,
                                                                                                property_id,
                                                                                                details,
                                                                                              )));
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(30),
                                                                                    color: Color(0xff03467d),
                                                                                  ),
                                                                                  height: 35,
                                                                                  width: 100,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.all(4.0),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        ' Book/Hold',
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                  : Text("")
                                                    ])
                                                  ])
                                                ]),
                                          )),
                                    ),
                                  );
                                }
                                return Center(
                                    child: SpinKitCircle(
                                  color: Color(0xff03467d),
                                  size: 50,
                                ));
                              }),
                        ),
                      ),
                    ],
                  ),
             ] )
        ));
  }
}
