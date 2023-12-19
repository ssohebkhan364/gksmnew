import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/model/dhashboard.dart';
import 'package:gkms/model/profile.dart';
import 'package:gkms/notification_service/local_notification.dart';
import 'package:gkms/screen/Book_Hold_details.dart';
import 'package:gkms/screen/unverified.dart';
import 'package:gkms/screen/verified.dart';
import 'package:gkms/screen/viewschems.dart';
import 'package:gkms/screen/waiting.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gkms/screen/changepassword.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/schems.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _key = GlobalKey();

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchitem = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    ApiServices.profileGet();
    data();
    super.initState();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {});
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {}
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {}
      },
    );
  }

  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isname = prefs.getString('user_name');
    });
  }

  var isname;
  int pageIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  final pages = [
    Page1(),
    const BookHoldReport(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: pageIndex == 1
            ? null
            : AppBar(
                backgroundColor: Color(0xff03467d),
                title: pageIndex == 0
                    ? const Text(
                        "GKSM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    : pageIndex == 1
                        ? const Text(
                            "BookHoldReport",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        : pageIndex == 2
                            ? const Text(
                                "Associate Details",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                "",
                              ),
                leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    }),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/splace.png",
                      height: 35,
                      width: 35,
                    ),
                  ),
                ],
              ),
        resizeToAvoidBottomInset: false,
        key: _key,
        drawer: ClipPath(
          clipper: _DrawerClipper(),
          child: Container(
            width: 255,
            child: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              backgroundColor: Color(0xff03467d),
              elevation: 1.5,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 150,
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image.asset(
                              "assets/images/splace.png",
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isname != null
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      isname,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        leading: const Icon(
                            size: 30.0, Icons.home, color: Color(0xff2597d5)),
                        title: Text(
                          "Dashboard",
                          style:
                              TextStyle(color: Color(0xff2597d5), fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                      ),
                      ListTile(
                        leading: Container(
                            height: 27,
                            width: 27,
                            child: Image.asset("assets/images/scheme.png",
                                color: Color(0xff2597d5))),
                    
                        title: const Text('Schemes',
                            style: TextStyle(
                                color: Color(0xff2597d5), fontSize: 18)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SchemesSchreem())));
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            size: 30.0,
                            Icons.event_note,
                            color: Color(0xff2597d5)),
                        title: const Text('Book/Hold Reports',
                            style: TextStyle(
                                color: Color(0xff2597d5), fontSize: 18)),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            pageIndex = 1;
                          });
                        },
                      ),
                    ],
                  )),
                  Divider(color: Color(0xff2597d5)),
                  Container(
                      height: 50,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          insetPadding: EdgeInsets.symmetric(
                                              vertical: 100),
                                          title: new Text(
                                            "Logging Out",
                                            style: TextStyle(),
                                          ),
                                          content: Text("Are you sure?"),
                                          actions: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: new Text(
                                                    "No",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xff2597d5),
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  onTap: () async {
                                                    Navigator.of(context).pop();
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    ApiServices.getLogOut(
                                                            context)
                                                        .then((value) {
                                                      if (value.status ==
                                                          true) {
                                                        prefs.clear();
                                                      }
                                                    });

                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen()),
                                                        (route) => false);
                                                  },
                                                  child: new Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Color(0xff2597d5),
                                                    ),
                                                  )),
                                            ),
                                          ]);
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: const Text(
                                          "Logout",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                            child: SizedBox(
                              width: 35,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            changepassword()));
                              },
                              child: Container(
                                height: 30,
                                width: 100,
                                child: const Center(
                                  child: Text("Change Password",
                                      style: TextStyle(
                                          color: Color(0xff2597d5),
                                          fontSize: 12)),
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
     
        body: WillPopScope(
          onWillPop: () async {
            if (pageIndex != 0) {
              setState(() {
                pageIndex = 0;
              });
              return false;
            }
            return true;
          },
          child: pages[pageIndex],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.grey.shade300,
            type: BottomNavigationBarType.fixed,
            elevation: 20,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_rounded),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: pageIndex,
            selectedItemColor: Color(0xff03467d),
            onTap: _onItemTapped,
          ),
        ));
  }
}

class Page1 extends StatefulWidget {
  Page1();

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  bool isLoading = true;
  List<Datum>? bookdatta = [];
  List<Datum>? holddatta = [];
  List<Datum>? completedata = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getMyPostList();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void initState() {
    getMyPostList();
    checkInternet();
    startStriming();
    data();
    super.initState();
  }

  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('is userid');
  }

  var userid;
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

  Color tabColor = Colors.blue;

  List<String> name = [
    "Home",
    "Booked",
    "Hold",
    "Completed",
  ];
  final List<Widget> tabContents = [
    Text('Content for Tab 1'),
    Text('Content for Tab 2'),
    Text('Content for Tab 3'),
    Text('Content for Tab 3'),
  ];

  void getMyPostList() async {
    ApiServices.getDashboard(context).then((value) {
      if (value.status.toString() == "true") {
        setState(() {
          bookdatta = value.result!.bookdata;
          holddatta = value.result!.holddata;
          completedata = value.result!.completedata;
        });
      }

      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (value.status == true) {
            prefs.clear();
          }
        });
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Column(children: [
      


          TabBar(
                  indicator: BoxDecoration(
                color: Color.fromARGB(255, 190, 219, 243),
                borderRadius: BorderRadius.circular(50),
              ),
           
              padding: const EdgeInsets.all(5),
              labelPadding: EdgeInsets.zero,
              indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
           
            tabs: [
              Tab(child: 
               Container(
                
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      " Home ",
                     style: TextStyle(
                        color: Color(0xff03467d),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                ),),
        
             
              Tab(child: 
               Container(
                
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Booked",
                     style: TextStyle(
                        color: Color(0xff8bafaf),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                
                    ),
                  ),
                ),),

                 Tab(child: 
               Container(
                 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "  Hold  ",
                      style: TextStyle(
                        color: Color(0xffc98e89),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  ),
                ),),

                 Tab(child: 
               Container(
              
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Completed",
                     style: TextStyle(
                        color: Color(0xff88ac88),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  ),
                ),),
            ],),
          Expanded(
              child: TabBarView(
            children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: SmartRefresher(
                            controller: _refreshController,
                            enablePullDown: true,
                            onRefresh: _onRefresh,
                            child: Stack(children: [
                              FutureBuilder<DashboardModel>(
                                  future:
                                      ApiServices.getDashboard(BuildContext),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DashboardModel> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.result != null) {
                                        final data = snapshot.data!.result;

                                        return snapshot.data!.result != null
                                            ? SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Container(
                                                          height: 80,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      colors: [
                                                                        Color.fromARGB(
                                                                            255,
                                                                            178,
                                                                            151,
                                                                            236),
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            115,
                                                                            178,
                                                                            230)
                                                                      ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                            0.001,
                                                                        spreadRadius:
                                                                            0.01,
                                                                        offset: Offset(
                                                                            0,
                                                                            0.05))
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8,
                                                                    right: 8,
                                                                    bottom: 8,
                                                                    left: 0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                    // color: Color.fromARGB(255, 92, 105, 115),
                                                                    height: 35,
                                                                    width: 35,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/scheme.png",
                                                                      color: Color(
                                                                          0xff03467d),
                                                                    )),
                                                                const Text(
                                                                    "Number of Schemes",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff03467d),
                                                                        fontSize:
                                                                            16)),
                                                                CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Text(
                                                                    data!
                                                                        .schemesCount
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color(
                                                                            0xff03467d)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Container(
                                                          height: 80,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          255,
                                                                          241,
                                                                          175,
                                                                          197),
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          115,
                                                                          178,
                                                                          230)
                                                                    ],
                                                                    begin: Alignment
                                                                        .bottomLeft,
                                                                    end: Alignment
                                                                        .topRight,
                                                                  ),
                                                                  boxShadow: const [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .black,
                                                                        blurRadius:
                                                                            0.001,
                                                                        spreadRadius:
                                                                            0.01,
                                                                        offset: Offset(
                                                                            0,
                                                                            0.05))
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 8,
                                                                    right: 8,
                                                                    top: 8,
                                                                    left: 0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(

                                                                    // color: Color.fromARGB(255, 92, 105, 115),
                                                                    height: 43,
                                                                    width: 43,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/pending-orders.png",
                                                                      color: Color(
                                                                          0xff03467d),
                                                                    )),
                                                                Text(
                                                                    "Number of Hold Unit ",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff03467d),
                                                                        fontSize:
                                                                            16)),
                                                                CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Text(
                                                                      data.holdPropertyCount
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Color(0xff03467d))),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Container(
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          255,
                                                                          92,
                                                                          195,
                                                                          186),
                                                                      const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          115,
                                                                          178,
                                                                          230),
                                                                    ],
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment
                                                                        .bottomRight),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black,
                                                                      blurRadius:
                                                                          0.001,
                                                                      spreadRadius:
                                                                          0.01,
                                                                      offset: Offset(
                                                                          0,
                                                                          0.05))
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                  // color: Color.fromARGB(255, 92, 105, 115),
                                                                  height: 35,
                                                                  width: 35,
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/booking.png",
                                                                    color: Color(
                                                                        0xff03467d),
                                                                  )),
                                                              const Text(
                                                                  "Number of Book Unit ",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff03467d),
                                                                      fontSize:
                                                                          16)),
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                child: Text(
                                                                    data.bookPropertyCount
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color(
                                                                            0xff03467d))),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Verified()));
                                                                },
                                                                child: Card(
                                                                  elevation: 10,
                                                                  color: Color(
                                                                      0xffe0f4f4),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xffe0f4f4),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    height: 90,
                                                                    child: Image.asset(
                                                                        "assets/images/payment_success.png",
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        color: Color(
                                                                            0xff03467d)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Unverified()));
                                                                },
                                                                child: Card(
                                                                  elevation: 10,
                                                                  color: Color(
                                                                      0xfffff3f1),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xfffff3f1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    height: 90,
                                                                    child: Image.asset(
                                                                        "assets/images/payment_failed.png",
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        color: Color(
                                                                            0xff03467d)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Waiting()));
                                                                },
                                                                child: Card(
                                                                  elevation: 10,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          234,
                                                                          212,
                                                                          237),
                                                                  child: Container(
                                                                      height: 90,
                                                                      decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            234,
                                                                            212,
                                                                            237),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child: Image.asset(
                                                                        "assets/images/download (1).png",
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        color: Color(
                                                                            0xff03467d),
                                                                        height:
                                                                            3,
                                                                        width:
                                                                            3,
                                                                      )),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Container(
                                                                child: Center(
                                                                    child: Align(
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                          "Verified\nPayment",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff03467d),
                                                                          ),
                                                                        )))),
                                                          )),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Container(
                                                                child: Center(
                                                                    child: Text(
                                                                        "Unverified\nPayment",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xff03467d),
                                                                        )))),
                                                          )),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Container(
                                                                child: Center(
                                                                    child: Text(
                                                                        "Waiting Lists\nUnits",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xff03467d),
                                                                        )))),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text("data");
                                      } else {
                                        return Center(
                                            child: Text("No data available"));
                                      }
                                      //   }
                                    }

                                    return Center(
                                      child: SpinKitCircle(
                                        color: Color(0xff03467d),
                                        size: 50,
                                      ),
                                    );
                                    // }})
                                  })
                            ]))))
              ]),
              bookdatta!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookdatta!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 8, right: 8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: Color(0xffe0f4f4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: 100,
                                              child: Center(
                                                  child: Text(
                                                bookdatta![index]
                                                    .schemeName
                                                    .toString(),
                                                // snapshot
                                                //     .data!
                                                //     .result!
                                                //     .bookdata![index]
                                                //     .schemeName
                                                //     .toString(),
                                                style: TextStyle(
                                                  color: Color(0xff8bafaf),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Container(
                                              child: Center(
                                                  child: Text(
                                            "${bookdatta![index].userCount}",
                                            style: TextStyle(
                                                color: Color(0xff8bafaf),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewSchems(
                                                                  bookdatta![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  userid)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Color.fromARGB(
                                                          255, 49, 90, 90)),
                                                  child: Center(
                                                      child: Text(
                                                    "View",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                  height: 25,
                                                  width: 80,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : Center(child: Text("No data available")),
              holddatta!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: holddatta!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 8, right: 8),
                              child: Card(
                                color: Color(0xfffff3f1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              width: 100,
                                              child: Center(
                                                  child: Text(
                                                holddatta![index]
                                                    .schemeName
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xffc98e89),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              child: Center(
                                                  child: Text(
                                            holddatta![index]
                                                .userCount
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(0xffc98e89),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ))),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewSchems(
                                                                holddatta![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                userid,
                                                              )));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color.fromARGB(
                                                        255, 120, 59, 54),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    "View",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                  height: 25,
                                                  width: 80,
                                                ),
                                                // Container(
                                                //
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : Center(child: Text("No data available")),
              completedata!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedata!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 8, right: 8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: Color(0xffe4f4e4),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: 100,
                                            child: Center(
                                                child: Text(
                                              completedata![index]
                                                  .schemeName
                                                  .toString(),
                                              style: TextStyle(
                                                color: Color(0xff88ac88),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            child: Center(
                                                child: Text(
                                          completedata![index]
                                              .userCount
                                              .toString(),
                                          style: TextStyle(
                                              color: Color(0xff88ac88),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ))),
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewSchems(
                                                              completedata![
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              userid,
                                                            )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color.fromARGB(
                                                        255, 55, 105, 55)),
                                                child: Center(
                                                    child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                                height: 25,
                                                width: 80,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : Center(child: Text("No data available"))
            ],
          ))
        ]));
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  bool isLoading = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getProfile();

    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getProfile();
    checkInternet();
    startStriming();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: FutureBuilder<ProfileModel>(
                    future: ApiServices.profileGet(),
                    builder: (BuildContext context,
                        AsyncSnapshot<ProfileModel> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.result != "null") {
                          final data = snapshot.data!.result;

                          var date_time = snapshot.data!.result!.createdAt!;

                          String _formattedDate =
                              DateFormat('d-MMM-yyyy HH:mm:ss')
                                  .format(date_time);

                          return Stack(children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
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
                                                Text(
                                                  "Associate Name",
                                                  style: TextStyle(
                                                      color: Color(0xff6c8ea1)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data!.name.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/2.png",
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
                                                Text("Associate Email",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.email.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/3.png",
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
                                                Text("Associate Contact Number",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.mobileNumber.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
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
                                                Text("Associate Rera Number",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.associateReraNumber
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/5.png",
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
                                                Text("Team Name",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.teamName.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/6.png",
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
                                                Text("Immediate Uplinner Name",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.applierName.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
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
                                                    "Immediate Uplinner Rera Number",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.applierReraNumber
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/8.png",
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
                                                Text("Joining Date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${_formattedDate}',
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/9.png",
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
                                                Text("Sold Guz",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.gaj.toString() == "null"
                                                      ? "-"
                                                      : data.gaj.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff304754),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/10.png",
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
                                                Text("Status",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6c8ea1))),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.status.toString() == '1'
                                                      ? "Active"
                                                      : "Dactive",
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ]);
                        }
                      }
                      return Center(
                          child: isLoading == true
                              ? SpinKitCircle(
                                  color: Color(0xff03467d),
                                  size: 50,
                                )
                              : null);
                    }),
                // ))))
              )))
    ]));
  }

  void getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiServices.profileGet().then((value) {
      setState(() {});

      if (value.message.toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }
}

class BookHoldReport extends StatefulWidget {
  const BookHoldReport({super.key});

  @override
  State<BookHoldReport> createState() => _BookHoldReportState();
}

class _BookHoldReportState extends State<BookHoldReport> {
  int? value = 1;
  final TextEditingController searchitem = TextEditingController();
  AnimationController? animationController;
  final scrollController = ScrollController();
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  int pageIndex = 0;
  DateTime dt = DateTime.now();
  var isLoading = false;
  int page = 1;
  var commentType = "A";
  List _posts = [];
  List _foundUsers = [];
  List _posts1 = [];
  List _foundUsers1 = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var date_time4;
  var _formattedDate;
   List _formattedDate1= [];
  var pdf;
  var isname;
  var number;
  var reranumber;
  var totel_List;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollPagination);
    boolHold_Report(context, page);
    _foundUsers = _posts;
    checkInternet();
    startStriming();
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

  startStriming() async {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
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
                      boolHold_Report(context, page);
                      _foundUsers = _posts;

                      Navigator.pop(context);
                      checkInternet();
                      setState(() {});
                    })
              ],
              title: Text("No internet"),
              content: Text("Please check your internet connection"),
            ));
  }

  void _onRefresh() async {
    page = 1;
    await boolHold_Report(context, page);
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _runFilter(value) {
    if (searchitem.text.isEmpty && searchitem.text.length == 0) {
      page = 1;

      boolHold_Report(context, page);
      setState(() {});
    } else if (searchitem.text.isNotEmpty) {
      setState(() {
        search(
          context,
        );
      });
    }
  }

  void _pdfFilter() {
    if (searchitem.text.isEmpty && searchitem.text.length == 0) {
      setState(() {
        bookpdf(
          context,
        );
      });
    } else if (searchitem.text.isNotEmpty) {
      setState(() {
        search2(
          context,
        );
      });
    }
  }

  void scrollPagination() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      page = page + 1;
      await boolHold_Report(context, page);
      setState(() {
        isLoading = false;
      });
    }
  }

  void checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> boolHold_Report(
    BuildContext context,
    page,
  ) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(
        UrlHelper.associate_property_report+"?page=$page"),
        
      headers: {
        'Authorization': "Bearer $isToken",
      }, 
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts = page == 1
            ? _postsbody['result']['propty_report_details']['data']
            : _posts + _postsbody['result']['propty_report_details']['data'];
        _foundUsers = _posts;
        isLoading = false;
        totel_List = _postsbody['result']['propty_report_details']['total'];
        ;
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
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  Future<void> search(
    BuildContext context,
  ) async {
    // var data= searchitem.text;
    var data = searchitem.text.toLowerCase() == "completed"
        ? "5"
        : searchitem.text.toLowerCase() == "booked"
            ? "2"
            : searchitem.text.toLowerCase() == "hold"
                ? "3"
                : searchitem.text.toLowerCase() == "canceled"
                    ? "4"
                    : searchitem.text.toLowerCase();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(UrlHelper.associate_property_report+"?search=$data"
      
          // 'https://dmlux.in/project/public/api/associate-property-reports?search=$data'
          
          
          ),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts = _postsbody['result']['propty_report_details']['data'];

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
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  Future<void> search2(
    BuildContext context,
  ) async {
    // var data= searchitem.text;
    var data = searchitem.text.toLowerCase() == "completed"
        ? "5"
        : searchitem.text.toLowerCase() == "booked"
            ? "2"
            : searchitem.text.toLowerCase() == "hold"
                ? "3"
                : searchitem.text.toLowerCase() == "canceled"
                    ? "4"
                    : searchitem.text.toLowerCase();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(
          // 'https://dmlux.in/project/public/api/associate-property-reports?search=$data'
          UrlHelper.associate_property_report+"?search=$data"
          ),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody = json.decode(res.body);

        _posts1 = _postsbody['result']['propty_report_details']['data'];

        _foundUsers1 = _posts1;
        isLoading = false;
        generatePDF();
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
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  Future<void> bookpdf(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    setState(() {
      isLoading = true;
    });

    var res = await http.get(
      Uri.parse(

        UrlHelper.associate_property_report+"?per_page=$totel_List"
          // 'https://dmlux.in/project/public/api/associate-property-reports?per_page=$totel_List'
          
          
          ),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );
    if (res.statusCode == 200) {
      setState(() {
        final _postsbody1 = json.decode(res.body);

        _posts1 = _postsbody1['result']['propty_report_details']['data'];
        _foundUsers1 = _posts1;
        isLoading = false;
// print("fgfgfg");
// print(_foundUsers1);
//         for (int i = 0; i < _foundUsers1.length; i++){
//         //   date_time4 = _foundUsers1[i]['booking_time'];
//         DateTime dttt = DateTime.parse(_foundUsers1[i]['booking_time']);
// print("kjkj");
// print(dttt);
// print( DateFormat('d-MMM-yyyy HH:mm:ss').format(dttt));
//         _formattedDate1= DateFormat('d-MMM-yyyy HH:mm:ss').format(dttt) as List;
//         print("bbbbb");
//         print(_formattedDate1[i]);
//         }
        
        generatePDF();
      });
    } else {
      final _postsbody = json.decode(res.body);
      var data = _postsbody['message'];

      if (data == "Unauthenticated.") {
        await ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });
        // prefs.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    }
  }

  Future<void> generatePDF() async {
  
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    pdf.addPage(pw.MultiPage(

      
        build: (pw.Context context) {
    //       
      return <pw.Widget>[
        pw.Column(children: [
          pw.Container(
            child: pw.Text("Booking Report",
                style: pw.TextStyle(
                    font: ttf, fontSize: 16, fontWeight: pw.FontWeight.bold)),
            height: 50,
          ),
          pw.Container(
            // width: 600,
            height: 50,
            color: PdfColor(0, 0.3, 0.5, 0),

            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Sr\nno",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Customer\nName",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Type No.",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Scheme\nName",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Customer\nAadhaar\nNumber",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Name",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 10,
                  ),
                  pw.Text("Associate\nRera\nNumber",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 15,
                  ),
                  pw.Text("Booking\nTime    ",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(1, 1, 1, 0),
                      )),
                  pw.SizedBox(
                    width: 35,
                  ),
                  pw.Container(
                    height: 50,
                    width: 100,
                    color: PdfColor(0, 0.3, 0.5, 0),
                    child: pw.Text("   Status",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 12,
                          color: PdfColor(1, 1, 1, 0),
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ),
                  pw.SizedBox(
                    width: 15,
                  ),
                ]),
          ),
          for (int i = 0; i < _foundUsers1.length; i++)
   
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 15),
              child: pw.Container(
                  child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                  
                    pw.Container(
                      // color: PdfColors.amber,
                      width: 25,
                      child: pw.Center(
                        child: pw.Text("${i + 1}",
                            style: pw.TextStyle(font: ttf, fontSize: 12)),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                      //  color: PdfColors.black,
                      width: 45,
                      child: pw.Text(_foundUsers1[i]['owner_name'],
                          style: pw.TextStyle(font: ttf, fontSize: 12)),
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                      width: 30,
                      //  color: PdfColors.red,
                      child: _foundUsers1[i]['plot_type'] == null
                          ? pw.Center(
                              child: pw.Text("",
                                  style: pw.TextStyle(font: ttf, fontSize: 12)))
                          : pw.Center(
                              child: pw.Text(_foundUsers1[i]['plot_type'],
                                  style:
                                      pw.TextStyle(font: ttf, fontSize: 12))),
                    ),
                    pw.Text(
                      "-",
                    ),
                    pw.Container(
                        //  color: PdfColors.green,
                        width: 25,
                        child: _foundUsers1[i]['plot_name'] == null
                            ? pw.Text("",
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['plot_name'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                        //  color: PdfColors.pink,
                        width: 45,
                        child: _foundUsers1[i]['scheme_name'] == null
                            ? pw.Text("",
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['scheme_name'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                        //  color: PdfColors.blue,
                        width: 50,
                        child: _foundUsers1[i]['adhar_card_number'] == null
                            ? pw.Text("",
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['adhar_card_number'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                        //  color: PdfColors.red,
                        width: 40,
                        child: _foundUsers1[i]['associate_name'] == null
                            ? pw.Text("",
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['associate_name'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                        //  color: PdfColors.black,

                        width: 50,
                        child: _foundUsers1[i]['associate_rera_number'] == null
                            ? pw.Text("",
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['associate_rera_number'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),

                    // pw.Text(_formattedDate1[i]),
                    pw.Container(
                        //  color: PdfColors.red,
                        width: 70,
                        child: _foundUsers1[i]['formatted_bt'] == null
                            ? pw.Text(_foundUsers1[i]['formatted_bt'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))
                            : pw.Text(_foundUsers1[i]['formatted_bt'],
                                style: pw.TextStyle(font: ttf, fontSize: 12))),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Container(
                        //  color: PdfColors.cyan,
                        width: 60,
                        child: pw.Column(children: [
                          _foundUsers1[i]['booking_status'] == '2'
                              ? pw.Text("Booked",
                                  style: pw.TextStyle(font: ttf, fontSize: 12))
                              : _foundUsers1[i]['booking_status'] == '3'
                                  ? pw.Text("Hold",
                                      style:
                                          pw.TextStyle(font: ttf, fontSize: 12))
                                  : _foundUsers1[i]['booking_status'] == '4'
                                      ? pw.Text("Canceled",
                                          style: pw.TextStyle(
                                              font: ttf, fontSize: 12))
                                      : _foundUsers1[i]['booking_status'] == '5'
                                          ? pw.Text("Completed",
                                              style: pw.TextStyle(
                                                  font: ttf, fontSize: 12))
                                          : _foundUsers1[i]['booking_status'] ==
                                                  '6'
                                              ? pw.Text("Management Hold",
                                                  style: pw.TextStyle(
                                                      font: ttf, fontSize: 12))
                                              : pw.Text("",
                                                  style: pw.TextStyle(
                                                      font: ttf, fontSize: 12))
                        ])),

                    pw.SizedBox(
                      width: 10,
                    ),
                  ])),
            ),
        ])
      ];
    }));

    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year}";

    await Permission.storage.request();

    final directory = await getExternalStorageDirectory();
    final pdfFilePath = '${directory!.path}/Report_${formattedDate}.pdf';

    final pdfFile = File(pdfFilePath);
    await pdfFile.create(recursive: true);

    await pdfFile.writeAsBytes(await pdf.save());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text("'PDF has been saved to $pdfFile'"),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        OpenFile.open(pdfFile.path);
                      },
                      child: Container(
                          height: 30,
                          width: 50,
                          color: Color(0xff03467d),
                          child: Center(
                            child: Text(
                              "ok",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ))),
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 100,
              flexibleSpace: Container(
                color: Color(0xff03467d),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(children: <Widget>[
                      const SizedBox(width: 15),
                      InkWell(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 30,
                          )),
                      const SizedBox(width: 10),
                      const Text(
                        "Book/Hold Report",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () async {
                          _pdfFilter();
                        },
                        child: Image.asset(
                          "assets/images/download.png",
                          height: 35,
                        ),
                      ),
                      SizedBox(width: 15),
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
                                    hintText:
                                        'enter... unit no status scheme name',
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
                : Column(children: [
                    Expanded(
                        child: Container(
                            color: Colors.white,
                            child: Column(children: [
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
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        if (index < _foundUsers.length) {
                                          final post = _foundUsers[index];
                                          final schemeName =
                                              post['scheme_name'];

                                          final plotName = post['plot_name'];
                                          final plotname = "$plotName" == "null"
                                              ? ""
                                              : "$plotName";
                                          final plotType = post['plot_type'];
                                          final bookingStatus =
                                              post['booking_status'];
                                          var date_time1 = post['booking_time'];

                                          DateTime dt =
                                              DateTime.parse(date_time1);

                                          var _formattedDate =
                                              DateFormat('d-MMM-yyyy HH:mm:ss')
                                                  .format(dt);

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          BookHoldDeatils(post[
                                                              'property_public_id']))));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                color: "$bookingStatus" == '2'
                                                    ? Color(0xffe0f4f4)
                                                    : "$bookingStatus" == '3'
                                                        ? Color(0xfffff3f1)
                                                        : "$bookingStatus" ==
                                                                '4'
                                                            ? Color(0xffece6f8)
                                                            : "$bookingStatus" ==
                                                                    '5'
                                                                ? Color(
                                                                    0xffe4f4e4)
                                                                : "$bookingStatus" ==
                                                                        '6'
                                                                    ? Color(
                                                                        0xffeaf1fb)
                                                                    : Color(
                                                                        0xfff6f5fb),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "$plotType-"
                                                                "$plotname",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: "$bookingStatus" ==
                                                                          '2'
                                                                      ? Color(
                                                                          0xff3d9191)
                                                                      : "$bookingStatus" ==
                                                                              '3'
                                                                          ? Color(
                                                                              0xffff3727)
                                                                          : "$bookingStatus" == '4'
                                                                              ? Color(0xff7246dd)
                                                                              : "$bookingStatus" == '5'
                                                                                  ? Color(0xff328232)
                                                                                  : "$bookingStatus" == '6'
                                                                                      ? Color(0xff427fda)
                                                                                      : Color(0xff3d9191),
                                                                ),
                                                              ),
                                                              Text(
                                                                "$schemeName",
                                                                style:
                                                                    TextStyle(
                                                                  color: "$bookingStatus" ==
                                                                          '2'
                                                                      ? Color(
                                                                          0xff8bafaf)
                                                                      : "$bookingStatus" ==
                                                                              '3'
                                                                          ? Color(
                                                                              0xffc98e89)
                                                                          : "$bookingStatus" == '4'
                                                                              ? Color(0xff9685c0)
                                                                              : "$bookingStatus" == '5'
                                                                                  ? Color(0xff88ac88)
                                                                                  : "$bookingStatus" == '6'
                                                                                      ? Color(0xff8294af)
                                                                                      : Color(0xff767191),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 85,
                                                        child: Center(
                                                            child: Text(
                                                          '${_formattedDate}',
                                                          style: TextStyle(
                                                            color: "$bookingStatus" ==
                                                                    '2'
                                                                ? Color(
                                                                    0xff8bafaf)
                                                                : "$bookingStatus" ==
                                                                        '3'
                                                                    ? Color(
                                                                        0xffc98e89)
                                                                    : "$bookingStatus" ==
                                                                            '4'
                                                                        ? Color(
                                                                            0xff9685c0)
                                                                        : "$bookingStatus" ==
                                                                                '5'
                                                                            ? Color(0xff88ac88)
                                                                            : "$bookingStatus" == '6'
                                                                                ? Color(0xff8294af)
                                                                                : Color(0xff767191),
                                                          ),
                                                        )),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 65,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: "$bookingStatus" ==
                                                                    '2'
                                                                ? const Text(
                                                                    "Booked",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color(
                                                                            0xff8bafaf)),
                                                                  )
                                                                : "$bookingStatus" ==
                                                                        '3'
                                                                    ? const Text(
                                                                        "Hold",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xffc98e89),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      )
                                                                    : "$bookingStatus" ==
                                                                            '4'
                                                                        ? Text(
                                                                            "Canceled",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xff9685c0),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )
                                                                        : "$bookingStatus" ==
                                                                                '5'
                                                                            ? const Text(
                                                                                "Completed",
                                                                                style: TextStyle(color: Color(0xff88ac88), fontSize: 12, fontWeight: FontWeight.w600),
                                                                              )
                                                                            : "$bookingStatus" == '6'
                                                                                ? const Text("Management Hold", style: TextStyle(color: Color(0xff8294af), fontSize: 12, fontWeight: FontWeight.w600))
                                                                                : Text("")),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    )
                                                  ],
                                                ),
                                              ),
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
                              )
                            ])))
                  ])));
  }
}

class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, -300);
    path.quadraticBezierTo(330, -50, 230, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
