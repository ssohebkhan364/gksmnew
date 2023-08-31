
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
import 'package:gkms/screen/schemsMenu.dart';
import 'package:gkms/screen/schems_details.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchemesSchreem extends StatefulWidget {
  const SchemesSchreem({super.key});

  @override
  State<SchemesSchreem> createState() => _SchemesSchreemState();
}

class _SchemesSchreemState extends State<SchemesSchreem> {
  int? value = 1;

  AnimationController? animationController;

  final scrollController = ScrollController();
late ConnectivityResult result;
late StreamSubscription subscription;
var isConnected=false;
  final TextEditingController searchitem = TextEditingController();


  var isLoading = false;
  int page = 1;
  var commentType = "A";
  var _isLiked = false;
  List _posts = [];
  List _foundUsers = [];
  var id;
 

 final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
  await  
  // activityPostList(context, page, widget.get_id);
  //   _foundUsers = _posts;
    schems(context, page);
    
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
                      scrollController.addListener(scrollPagination);
    schemsList(context, page);
    _foundUsers = _posts;
    data();
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


   @override
  void initState() {
    super.initState();
    // showDialogBox();
    scrollController.addListener(scrollPagination);
    schemsList(context, page);
    _foundUsers = _posts;
    data();
    checkInternet();
     startStriming();
  }

  Future<void> search(BuildContext context, ) async {
    print("ooooo");
    print(searchitem);
    var data= searchitem.text;

    print("pppp");
    print(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(
          UrlHelper.SchemsUrl + '?search=$data'),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts =  _postsbody['result']['data'];
        _foundUsers = _posts;
      });
      final post = _posts[0];
      final id = post['scheme_id'];

      prefs.setString("schemeid", id as String);
      var isschemid = prefs.getString('schemeid');
        setState(() {
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
      schemsList(context, page);
      });

      print("ndsbjm");
    } else if (searchitem.text.isNotEmpty) {
      setState(() {
        search(context,);
      });
    }
  }

  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('is userid');
  }

  var userid;
  Future<void> schemsList(BuildContext context, page) async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    var res = await http.get(
      Uri.parse(UrlHelper.SchemsUrl + "?page=$page"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    isLoading = false;
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts = _posts + _postsbody['result']['data'];
        _foundUsers = _posts;
      });
      final post = _posts[0];
      final id = post['scheme_id'];

      prefs.setString("schemeid", id as String);
      var isschemid = prefs.getString('schemeid');
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

 Future<void> schems(BuildContext context, page) async {
    isLoading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    var res = await http.get(
      Uri.parse(UrlHelper.SchemsUrl + "?page=$page"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    isLoading = false;
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts = _postsbody['result']['data'];
        _foundUsers = _posts;
      });
      final post = _posts[0];
      final id = post['scheme_id'];

      prefs.setString("schemeid", id as String);
      var isschemid = prefs.getString('schemeid');
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
      await schemsList(context, page);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  
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
                color: Color(0xff014e78),
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
                            size: 30,
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
                                decoration: const InputDecoration(
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
                                    hintText: 'Search',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))))),
                          ))),
                ]),
              ),
            ),
            body: Column(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                    color: Colors.white,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
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
                                    final id = post['scheme_id'];
                          
                                    return Padding(
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
                                                      child:
                                                          Text("${index + 1}"))),
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
                                                              color: Color(
                                                                  0xff304754),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                          width: 30,
                                                          child: Center(
                                                              child: Text(
                                                            post['ad_slot'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                              color: Color(
                                                                  0xff6c8ea1),
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
                                                                      SchemsMenu(
                                                                          post[
                                                                              'scheme_id'],
                                                                          userid)));
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(30),
                                                            color:
                                                                Color(0xff014e78),
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
                                                          decoration:
                                                              BoxDecoration(
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
                                                                    0xff014e78),
                                                              ),
                                                            ),
                                                          ),
                                                          height: 25,
                                                          width: 80,
                                                        ),
                                                      )
,
 SizedBox(
                                                  width: 10,
                                                ),


                                                        GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyWidget(
)));
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(30),
                                                            color:
                                                                Color(0xffe6eef3),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "multiple",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff014e78),
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
                                    );
                                  }
                          
                                  return Stack(children:  [
                                   Center(
                        child: SpinKitCircle(
                            color: Color(
                                                              0xff014E78),
                          size: 50,
                          ),
                      )
                                  ]);
                                }),
                          ))
                    ])),
              ))
            ])));
  }
}
