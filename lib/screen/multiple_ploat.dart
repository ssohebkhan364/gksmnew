import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/model/Multiple_ploat.dart';
import 'package:flutter/material.dart';
import 'package:gkms/screen/login.dart';
import 'package:gkms/screen/multiple_form_book.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:selectable_box/selectable_box.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Multiple_ploat extends StatefulWidget {
  final scheme_id;
  Multiple_ploat(this.scheme_id, {super.key});

  @override
  State<Multiple_ploat> createState() => _Multiple_ploatState();
}

class _Multiple_ploatState extends State<Multiple_ploat> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  int index = 0;
  bool isSelected = false;
  var selectedIndexes = [];
  void data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isname = prefs.getString('isname');
    number = prefs.getString('is number');
    reranumber = prefs.getString('is reranumber');
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var isname;
  var number;
  var isLoading = false;
  var reranumber;
  var id;
  var isConnected = false;
  bool isLoadingAllScreen = false;
  var offererProductList1;
  List<Property> offererProductList = [];

  @override
  void initState() {
    super.initState();
    get();
    data();
  }

  void get() {
    setState(() {
      isLoadingAllScreen = true;
    });

    ApiServices.multiple_ploat(context, widget.scheme_id).then((value) async {
      print(value.status);
      setState(() {
        isLoadingAllScreen = false;
      });

      if (value.message.toString() == "Unauthenticated.") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        ApiServices.getLogOut(context).then((value) {
          if (value.status == true) {
            prefs.clear();
          }
        });

        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }

      if (value.status == true) {
        setState(() {
          offererProductList = value.result!.properties!;
          offererProductList1 = value.result!.schemeDetail!.holdStatus;
        });
      }
    });
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
                      get();
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

  void _onRefresh() async {
    //  page = 1;
    get();
    _refreshController.refreshCompleted();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                // size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
              style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
            
            "Book Multiple Units",
          ),
          backgroundColor: Color(0xff03467d),
        ),
        body: offererProductList.isEmpty
            ? Center(
                child: SpinKitCircle(
                  color: Color(0xff03467d),
                  size: 50,
                ),
              )
            : Stack(children: [
                Column(children: [
                  offererProductList1 == '1'
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
                                  Text("Hold option is disable for this scheme",
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
                    child: GridView.count(
                        crossAxisCount: 4,
                        children:
                            List.generate(offererProductList.length, (index) {
                          if (index < offererProductList.length) {
                            id = offererProductList[index].schemeId;

                            return SelectableBox(
                                height: 250,
                                width: 400,
                                color: Colors.white,
                                selectedColor: Color(0xffe6eef3),
                                borderColor: Colors.grey,
                                selectedBorderColor:
                                    Color.fromARGB(255, 18, 114, 21),
                                borderWidth: 1,
                                borderRadius: 10,
                                padding: const EdgeInsets.all(8),
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                opacity: 0.5,
                                selectedOpacity: 1,
                                checkboxAlignment: Alignment.topRight,
                                checkboxPadding: const EdgeInsets.all(8),
                                selectedIcon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                unSelectedIcon: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.grey,
                                ),
                                showCheckbox: true,
                                onTap: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                  });

                                  if (selectedIndexes.contains(
                                      offererProductList[index]
                                          .plotNo
                                          .toString())) {
                                    selectedIndexes.remove(
                                        offererProductList[index]
                                            .plotNo
                                            .toString());
                                  } else if (selectedIndexes.length == 2) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "You can select maximum 2 properties"),
                                      backgroundColor: Color(0xff03467d),
                                      dismissDirection: DismissDirection.up,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          left: 10,
                                          right: 10),
                                    ));
                                  } else {
                                    if (selectedIndexes.length <= 1)
                                      selectedIndexes.add(
                                          offererProductList[index]
                                              .plotNo
                                              .toString());
                                  }

                                  setState(() {});
                                },
                                isSelected: selectedIndexes.contains(
                                    offererProductList[index]
                                        .plotNo
                                        .toString()),
                                child: Center(
                                    child: offererProductList[index]
                                                .plotName
                                                .toString() ==
                                            "null"
                                        ? Text("-",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xff03467d),
                                            ))
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                offererProductList[index]
                                                    .plotName
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Color(0xff03467d),
                                                )),
                                          )));
                          }
                          return Stack(children: [
                            Center(
                              child: SpinKitCircle(
                                color: Color(0xff03467d),
                                size: 50,
                              ),
                            ),
                          ]);
                        })),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultipleForm(
                                    isname,
                                    number,
                                    reranumber,
                                    id,
                                    selectedIndexes,
                                    offererProductList1)));
                      },
                      child: Container(
                        height: 52,
                        decoration: const BoxDecoration(
                            color: Color(0xff03467d),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Center(
                          child: Text(
                            "Book/Hold",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ])
              ]));
  }
}
