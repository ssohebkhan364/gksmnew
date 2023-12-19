import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gkms/api/api.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/screen/login.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class SchemsDetails extends StatefulWidget {
  var scheme;
  SchemsDetails(
    this.scheme,
  );

  @override
  State<SchemsDetails> createState() => _SchemsDetailsState();
}

class _SchemsDetailsState extends State<SchemsDetails> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await ApiServices.getSchemsDetails(widget.scheme);

    _refreshController.refreshCompleted();
    setState(() {});
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
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
          saveInPublicStorage: true,
          fileName: '${DateTime.now().millisecond}${fileName}');
    }
  }

  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    getschemList();
    checkInternet();
    startStriming();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      DownloadTaskStatus status = data[1];
      if (status == DownloadTaskStatus.complete) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Download compleete"),
          backgroundColor: Color(0xff03467d),
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

 
  double? lat, long;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff03467d),
          title: const Text(
            "Scheme Details",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                // size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: FutureBuilder(
              future: ApiServices.getSchemsDetails(widget.scheme),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.result != null) {
                    final data = snapshot.data!.result;

                    final schemeimage =
                        data!.schemeDetails!.first.schemeImg.toString();

                    final schemeimages = data.schemeDetails!.first.schemeImages;
                    final paragraph =
                        data.schemeDetails!.first.schemeDescription;

                    final output = '$paragraph'.replaceAll(RegExp('<p>'), '');
                    final description = output.replaceAll(RegExp('</p>'), '');

                    final List<String> schemeimg = schemeimages!.split(",");


                    final String htmlcode =
                        data.schemeDetails!.first.video.toString();

                    return Stack(children: [
                      SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const SizedBox(
                              height: 20,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/28.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Scheme Name",
                                          style: TextStyle(
                                              color: Color(0xff6c8ea1))),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${data.schemeDetails!.first.schemeName}",
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/29.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Total Plot",
                                          style: TextStyle(
                                              color: Color(0xff6c8ea1))),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        " ${data.schemeDetails!.first.noOfPlot}",
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),

                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/5.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Team Name",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        " ${data.schemeDetails!.first.teamName}",
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/18.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Scheme Location",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            data.schemeDetails!.first.location
                                                    .toString()
                                                    .contains("https")
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      var url =
                                                          "${data.schemeDetails!.first.location.toString()}";

                                                      if (await canLaunch(
                                                          url)) {
                                                        await launch(url,
                                                            forceWebView: true,
                                                            enableJavaScript:
                                                                true);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                    child: const SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'assets/images/map.png')),
                                                    ),
                                                  )
                                                : Text(
                                                    "${data.schemeDetails!.first.location.toString()}",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff304754),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/36.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Scheme Image",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 30,
                                              width: 40,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Confirmation'),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                'Are you sure you want to download ?'),
                                                            SizedBox(
                                                                height: 16),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color(
                                                                    0xff03467d),
                                                              ),
                                                              onPressed: () {
                                                                download(
                                                                    // "https://dmlux.in/project/public/files/${schemeimage}");
                                                                    '${UrlHelper.imaeurl}files/${schemeimage}');
                                                                Navigator.of(
                                                                        context)
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
                                                child: schemeimage == 'null'
                                                    ? Text("")
                                                    : Image.network(
                                                        '${UrlHelper.imaeurl}files/${data.schemeDetails!.first.schemeImg}'),
                                              ))
                                        ],
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(),

                            data.schemeDetails!.first.schemeImages.toString() ==
                                    ""
                                ? SizedBox()
                                : const Row(
                                    children: [
                                      SizedBox(
                                        width: 52,
                                      ),
                                      Text(
                                        "Scheme Images",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                    ],
                                  ),

                            const SizedBox(
                              height: 5,
                            ),

                            data.schemeDetails!.first.schemeImages.toString() ==
                                    ""
                                ? SizedBox()
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Image.asset(
                                        "assets/images/36.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              for (var item in schemeimg)
                                                SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: InkWell(
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
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Color(
                                                                              0xff03467d),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      download(
                                                                          '${UrlHelper.imaeurl}scheme_images/${item.toString()}');
                                                                      Navigator.of(
                                                                              context)
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
                                                      child: schemeimage ==
                                                              'null'
                                                          ? Text("")
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 2,
                                                                      right: 2),
                                                              child: Image.network(
                                                                 '${UrlHelper.imaeurl}scheme_images/${item}'),
                                                            ),
                                                    )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                            //
                            data.schemeDetails!.first.schemeImages.toString() ==
                                    ""
                                ? SizedBox()
                                : Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/31.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Scheme Brochure",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 30,
                                              width: 40,
                                              child: InkWell(
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
                                                                  height: 16),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Color(
                                                                      0xff03467d),
                                                                ),
                                                                onPressed: () {
                                                                  download(
                                                                      '${UrlHelper.imaeurl}brochure/${data.schemeDetails!.first.brochure.toString()}');
                                                                  Navigator.of(
                                                                          context)
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
                                                  child: data.schemeDetails!
                                                              .first.brochure
                                                              .toString() ==
                                                          'null'
                                                      ? Text("")
                                                      : data.schemeDetails!.first.brochure.toString().contains('.jpg') ||
                                                              data
                                                                  .schemeDetails!
                                                                  .first
                                                                  .brochure
                                                                  .toString()
                                                                  .contains(
                                                                      '.png') ||
                                                              data
                                                                  .schemeDetails!
                                                                  .first
                                                                  .brochure
                                                                  .toString()
                                                                  .contains(
                                                                      '.JPEG') ||
                                                              data
                                                                  .schemeDetails!
                                                                  .first
                                                                  .brochure
                                                                  .toString()
                                                                  .contains(
                                                                      '.GIF')
                                                          ? Icon(Icons.image)
                                                          : data.schemeDetails!
                                                                  .first.brochure
                                                                  .toString()
                                                                  .contains('.pdf')
                                                              ? Icon(Icons.picture_as_pdf)
                                                              : data.schemeDetails!.first.brochure.toString().contains('.ppt')
                                                                  ? Image.asset(
                                                                      "assets/images/31.png",
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                    )
                                                                  : data.schemeDetails!.first.brochure.toString().contains('.Doc') || data.schemeDetails!.first.brochure.toString().contains('.Docx')
                                                                      ? Image.asset(
                                                                          "assets/images/60.png",
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              50,
                                                                        )
                                                                      : SizedBox(
                                                                          height: 30,
                                                                          width: 30,
                                                                          child: Icon(
                                                                            Icons.image,
                                                                            size:
                                                                                30,
                                                                          )))),
                                        ],
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            data.schemeDetails!.first.ppt.toString() == "null"
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/33.png",
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
                                              "Scheme PPT",
                                              style: TextStyle(
                                                  color: Color(0xff6c8ea1)),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    width: 40,
                                                    child: data.schemeDetails!
                                                                .first.ppt
                                                                .toString() ==
                                                            'null'
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
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                            'Are you sure you want to download ?'),
                                                                        SizedBox(
                                                                            height:
                                                                                16),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Color(0xff03467d),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            download('${UrlHelper.imaeurl}ppt/${data.schemeDetails!.first.ppt.toString()}');
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
                                                            child: Image.asset(
                                                              "assets/images/33.png",
                                                              height: 25,
                                                              width: 25,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            data.schemeDetails!.first.ppt.toString() == "null"
                                ? SizedBox()
                                : Divider(),

                            data.schemeDetails!.first.jdaMap.toString() ==
                                    "null"
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/34.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Scheme Jda Map",
                                              style: TextStyle(
                                                  color: Color(0xff6c8ea1)),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      height: 30,
                                                      width: 40,
                                                      child: data.schemeDetails!
                                                                  .first.jdaMap
                                                                  .toString() ==
                                                              ''
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
                                                                              download('${UrlHelper.imaeurl}jda_map/${data.schemeDetails!.first.jdaMap.toString()}');
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
                                                              child: data
                                                                          .schemeDetails!
                                                                          .first
                                                                          .jdaMap
                                                                          .toString() ==
                                                                      'null'
                                                                  ? Text("")
                                                                  : data.schemeDetails!.first.jdaMap.toString().contains('.jpg') ||
                                                                          data.schemeDetails!.first.jdaMap.toString().contains(
                                                                              '.png') ||
                                                                          data
                                                                              .schemeDetails!
                                                                              .first
                                                                              .jdaMap
                                                                              .toString()
                                                                              .contains('.JPEG') ||
                                                                          data.schemeDetails!.first.jdaMap.toString().contains('.GIF')
                                                                      ? Icon(Icons.image)
                                                                      : data.schemeDetails!.first.jdaMap.toString().contains('.pdf')
                                                                          ? Icon(Icons.picture_as_pdf)
                                                                          : data.schemeDetails!.first.jdaMap.toString().contains('.ppt')
                                                                              ? Image.asset(
                                                                                  "assets/images/31.png",
                                                                                  height: 25,
                                                                                  width: 25,
                                                                                )
                                                                              : data.schemeDetails!.first.jdaMap.toString().contains('.Doc') || data.schemeDetails!.first.brochure.toString().contains('.Docx')
                                                                                  ? Image.asset(
                                                                                      "assets/images/60.png",
                                                                                      height: 25,
                                                                                      width: 25,
                                                                                    )
                                                                                  : Icon(Icons.attachment))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                            data.schemeDetails!.first.jdaMap.toString() ==
                                    "null"
                                ? SizedBox()
                                : Divider(),
                            data.schemeDetails!.first.video.toString() == "null"
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/35.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Scheme Video",
                                              style: TextStyle(
                                                  color: Color(0xff6c8ea1)),
                                            ),
                                            HtmlWidget(htmlcode),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                            data.schemeDetails!.first.video.toString() == "null"
                                ? SizedBox()
                                : Divider(),

                            data.schemeDetails!.first.pra.toString() == "null"
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/32.png",
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
                                                "Scheme Rera Document",
                                                style: TextStyle(
                                                    color: Color(0xff6c8ea1)),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              InkWell(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        height: 30,
                                                        width: 40,
                                                        child: data.schemeDetails!
                                                                    .first.pra
                                                                    .toString() ==
                                                                ''
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
                                                                            Text('Are you sure you want to download ?'),
                                                                            SizedBox(height: 16),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                download('${UrlHelper.imaeurl}pra/${data.schemeDetails!.first.pra.toString()}');
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text('Download'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: data
                                                                            .schemeDetails!
                                                                            .first
                                                                            .pra
                                                                            .toString() ==
                                                                        'null'
                                                                    ? Text("")
                                                                    : data.schemeDetails!.first.pra.toString().contains('.jpg') ||
                                                                            data.schemeDetails!.first.pra.toString().contains(
                                                                                '.png') ||
                                                                            data.schemeDetails!.first.pra.toString().contains(
                                                                                '.JPEG') ||
                                                                            data.schemeDetails!.first.pra.toString().contains(
                                                                                '.GIF')
                                                                        ? Icon(
                                                                            Icons.image)
                                                                        : data.schemeDetails!.first.pra.toString().contains('.pdf')
                                                                            ? Icon(Icons.picture_as_pdf)
                                                                            : data.schemeDetails!.first.pra.toString().contains('.ppt')
                                                                                ? Image.asset(
                                                                                    "assets/images/31.png",
                                                                                    height: 25,
                                                                                    width: 25,
                                                                                  )
                                                                                : data.schemeDetails!.first.pra.toString().contains('.Doc') || data.schemeDetails!.first.brochure.toString().contains('.Docx')
                                                                                    ? Image.asset(
                                                                                        "assets/images/60.png",
                                                                                        height: 25,
                                                                                        width: 25,
                                                                                      )
                                                                                    : Icon(Icons.attachment))),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ],
                                    )),

                            data.schemeDetails!.first.pra.toString() == "null"
                                ? SizedBox()
                                : Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/38.png",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Description",
                                          style: TextStyle(
                                              color: Color(0xff6c8ea1)),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        data.schemeDetails!.first
                                                    .schemeDescription
                                                    .toString() ==
                                                "null"
                                            ? Text("-")
                                            : HtmlWidget(
                                                description,
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/39.png",
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
                                        "Bank Name",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${data.schemeDetails!.first.bankName}",
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/39.png",
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
                                        "Account Number",
                                        style:
                                            TextStyle(color: Color(0xff6c8ea1)),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data.schemeDetails!.first.accountNumber
                                            .toString(),
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/39.png",
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
                                        "IFSC Code",
                                        style: TextStyle(
                                          color: Color(0xff6c8ea1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data.schemeDetails!.first.ifscCode
                                            .toString(),
                                        style: const TextStyle(
                                            color: Color(0xff304754),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: 12, bottom: 10),
                              child: Row(children: [
                                Image.asset(
                                  "assets/images/39.png",
                                  height: 25,
                                  width: 25,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Branch Name",
                                      style: TextStyle(
                                        color: Color(0xff6c8ea1),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data.schemeDetails!.first.branchName
                                          .toString(),
                                      style: const TextStyle(
                                          color: Color(0xff304754),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ]),
                            )
                          ]))
                    ]);
                  }
                }
                return Center(
                  child: SpinKitCircle(
                    color: Color(0xff03467d),
                    size: 50,
                  ),
                );
              }),
        ));
  }

  void getschemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiServices.getSchemsDetails(widget.scheme).then((value) {
      setState(() {});

      if (value.message.toString() == "Unauthenticated.") {
       ApiServices.getLogOut(context).then((value) {
           if(value.status==true){
             prefs.clear();
          }
        });
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
    });
  }
}
