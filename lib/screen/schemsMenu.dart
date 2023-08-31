import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/model/schemListView.dart';
import 'package:gkms/screen/bookHoldEdit.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/schemeForm.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class SchemsMenu extends StatefulWidget {
  var get_id;
  var profile_id;
  SchemsMenu(this.get_id, this.profile_id);

  @override
  State<SchemsMenu> createState() => _SchemsMenuState();
}

class _SchemsMenuState extends State<SchemsMenu> {
  int? value = 1;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  AnimationController? animationController;
  final scrollController = ScrollController();
  final TextEditingController searchitem = TextEditingController();
  var isLoading = false;
  int page = 1;
  var commentType = "A";
  var _isLiked = false;
  List _posts = [];
  List _foundUsers = [];
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollPagination);
    activityPostList(context, page, widget.get_id);
    _foundUsers = _posts;
    data();
    checkInternet();
    startStriming();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
  await  
  // activityPostList(context, page, widget.get_id);
  //   _foundUsers = _posts;
   activity(context,  widget.get_id);
    
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
                      activityPostList(context, page, widget.get_id);
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

  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isname = prefs.getString('isname');
    number = prefs.getString('is number');
    reranumber = prefs.getString('is reranumber');
  }

  var isname;
  var number;
  var reranumber;
  List<SchemeDetail> tempschemeDetail = [];
  Future<void> activityPostList(BuildContext context, page, get_id) async {
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
      print("pppp");
      print(res.body);
      setState(() {
        final _postsbody = json.decode(res.body);
        _posts = _posts + _postsbody['result']['properties']['data'];
        _foundUsers = _posts;
        isLoading = false;
      });
    } else {
      final _postsbody = json.decode(res.body);
      var data = _postsbody['message'];

      if (data == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }


   Future<void> activity(BuildContext context,  get_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(UrlHelper.SchemsMenuUrl + "$get_id"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      print("pppp");
      print(res.body);
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
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  void scrollPagination() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      page = page + 1;
      await activityPostList(context, page, widget.get_id);
      setState(() {
        isLoading = false;
      });
    }
  }

  List results = [];
  Future<void> search(BuildContext context, get_id) async {
    print("ooooo");
    print(searchitem);
    var data = searchitem.text == "Completed"
        ? "5"
        : searchitem.text == "Booked"
            ? "2"
            : searchitem.text == "Hold"
                ? "3"
                : searchitem.text == "To be Released"
                    ? "4"
                    : searchitem.text == "Available"
                        ? "1"
                     
                            : searchitem.text == "managment hold"
                                ? "6"
                                : searchitem.text;
    print("pppp");
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(
        UrlHelper.SchemsMenuUrl + '$get_id?search=$data'),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      print("sksksk");
      print(res.body);
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
        ApiServices.getLogOut(context).then((value) {});
        prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  void _runFilter(value) {
    print("mmmm");
    print(searchitem.text.length);
    if (searchitem.text.isEmpty && searchitem.text.length == 0) {
      setState(() {
        activityPostList(context, page, widget.get_id);
      });

      print("ndsbjm");
    } else if (searchitem.text.isNotEmpty) {
      setState(() {
        search(context, widget.get_id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("vvvvvv");
    print(_posts.length);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xff03467d),
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
                          size: 30,
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

                                setState(() {});
                              },
                              decoration: const InputDecoration(
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
                                  hintText: 'Search',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))))),
                        ))),
              ]),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child:SmartRefresher(
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

                                final data = post['property_public_id'];
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



// if(post['cancel_time']!=null){
//  time = post['cancel_time'];
// }
String time = post['cancel_time']==null?"2023-08-02 09:50:49":post['cancel_time'];
        print("kkkk");
        print(time) ;           
DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(time);
                    

 DateTime current_date = DateTime.now();
  var curret_1 = DateFormat("yyyy-MM-dd HH:mm:ss").format(current_date);


  DateTime yesterday = tempDate.add(Duration(days: 1));
  var ydate = DateFormat("yyyy-MM-dd HH:mm:ss").format(yesterday);
DateTime dt1 = DateTime.parse(ydate);
DateTime dt2 = DateTime.parse(curret_1);


int datte =0;
if(dt1.isBefore(dt2)){
  datte=1;
   print("DT1 is after DT2");
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: ExpansionTile(
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
                                              subtitle: Text(
                                                "$scheme_name",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
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
                                                                      ? "$management_hold" ==
                                                                              "1"
                                                                          ? Color(
                                                                              0xff8294af)
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
                                                ),
                                              ),
                                              trailing: "$property_status" ==
                                                      '2'
                                                  ? '$otherinfo' == 'null'
                                                      ? const Text(
                                                          "Booked",
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                                            Text(
                                                              "Booked",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color(
                                                                      0xff8bafaf)),
                                                            ),
                                                            Text(
                                                              "$otherinfo",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff8294af),
                                                                  fontSize: 8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        )
                                                  : "$property_status" == '3'
                                                      ? '$otherinfo' == 'null'
                                                          ? const Text(
                                                              "Hold",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffc98e89),
                                                                fontSize: 14,
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
                                                                    color: Color(
                                                                        0xffc98e89),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                                          FontWeight
                                                                              .w600),
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
                                                                    color: Color(
                                                                        0xff9685c0),
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
                                                                      "To be Released",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xff9685c0),
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
                                                                  '5'
                                                              ? '$otherinfo' ==
                                                                      'null'
                                                                  ? const Text(
                                                                      "Completed",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff88ac88),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w600),
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
                                                                          "Completed",
                                                                          style: TextStyle(
                                                                              color: Color(0xff88ac88),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600),
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
                                                                      '6'
                                                                  ? "$management_hold" ==
                                                                          "1"
                                                                      ? '$otherinfo' ==
                                                                              'null'
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
                                                                      : "$management_hold" ==
                                                                              "2"
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
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                Color(0xff767191),
                                                                          ),
                                                                        )
                                                                      : Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
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
                                                                            )
                                                                          ],
                                                                        ),
                                              children: [
                                                Column(children: [
                                                  Divider(),
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
                                                        ?  userid ==
                                                                    widget
                                                                        .profile_id? 
                                                                        
                                                                        datte==1?
                                                                        
                                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 50,
                                                                    bottom: 10,
                                                                    top: 10),
                                                            child: Row(
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
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      color: Color(
                                                                          0xff014e78),
                                                                    ),
                                                                    height: 35,
                                                                    width: 100,
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Book/Hold',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ):Text("")
                                                          
                                                          :
                                                        
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 50,
                                                                    bottom: 10,
                                                                    top: 10),
                                                            child: Row(
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
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      color: Color(
                                                                          0xff014e78),
                                                                    ),
                                                                    height: 35,
                                                                    width: 100,
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Book/Hold',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
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

                                                                        ?

                                                                          datte==1
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
                                                                              color: Color(0xff014e78),
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
                                                                  ):Text("")
                                                                : const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            40),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "",
                                                                          style:
                                                                              TextStyle(color: Color(0xffff2e29)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                            : "$property_status" ==
                                                                    '0'
                                                                ?userid ==
                                                                    widget
                                                                        .profile_id? 
                                                                        
                                                                        datte==1?
                                                                        
                                                                        Padding(
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
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: Color(0xff014e78),
                                                                            ),
                                                                            height:
                                                                                35,
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Padding(
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
                                                                  ):Text("")

:
                                                                  Padding(
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
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              color: Color(0xff014e78),
                                                                            ),
                                                                            height:
                                                                                35,
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Padding(
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
                                // );
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
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
