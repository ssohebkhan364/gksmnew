import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/model/Log_out.dart';
import 'package:gkms/model/SchemsForm.dart';
import 'package:gkms/model/bookHoldEdit.dart';
import 'package:gkms/model/login.dart';
import 'package:gkms/model/report_details.dart';
import 'package:gkms/model/schems_details.dart';
import 'package:gkms/screen/schems.dart';
import 'package:path/path.dart';
import 'package:gkms/model/changePassword.dart';
import 'package:gkms/model/dhashboard.dart';
import 'package:gkms/model/forgot.dart';

import 'package:gkms/model/profile.dart';
import 'package:gkms/model/signUp.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  List data = [];
  static Future<SignUpModel> signUpPost(Map<String, dynamic> map) async {
    SignUpModel signUpModel = SignUpModel();

    var response = await http.post(
      Uri.parse(UrlHelper.SignupUrl),
      body: map,
    );

    if (response.statusCode == 200) {
      return SignUpModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      return signUpModel;
    } else {
      return signUpModel;
    }
  }

  static Future<LoginModel> login(Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginModel loginModel = LoginModel();
    List<LoginModel> loginMode;
    var response = await http.post(
      Uri.parse(UrlHelper.LoginUrl),
      body: map,
    );

    if (response.statusCode == 200) {
      loginMode = <LoginModel>[];
      loginMode.add(LoginModel.fromJson(jsonDecode(response.body)));
      LoginModel user = loginMode[0];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", true);
      prefs.setString("isToken", user.token as String);

      return LoginModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      loginModel.message = 'Server error';
      return loginModel;
    } else {
      
      loginModel.message = jsonDecode(response.body)["message"];
      return loginModel;
    }
  }

  static Future<ForgotModel> forgotpassword(Map<String, dynamic> map) async {
    ForgotModel forgotModel = ForgotModel();

    var response = await http.post(
      Uri.parse(UrlHelper.ForgotUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      return ForgotModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      forgotModel.message = 'Server error';
      return forgotModel;
    } else {
      forgotModel.message = jsonDecode(response.body)["message"];
      return forgotModel;
    }
  }

  static Future<ChangePassword> chngaePassword(Map<String, dynamic> map) async {
    ChangePassword changePassword = ChangePassword();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.post(
      Uri.parse(UrlHelper.ChangePasswordUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': "Bearer $isToken",
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      return ChangePassword.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      changePassword.message = 'Server error';
      return changePassword;
    } else {
      changePassword.message = jsonDecode(response.body)["message"];
      return changePassword;
    }
  }

  static Future<LogOut> getLogOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    LogOut log = LogOut();
    var response = await http.get(
      Uri.parse(UrlHelper.logOut),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200) {
      return LogOut.fromJson(jsonDecode(response.body));
    } else {
      log.message = jsonDecode(response.body)["message"];
      return log;
    }
  }

  static Future<DashboardModel> getDashboard(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    DashboardModel dashboardModel = DashboardModel();
    var response = await http.get(
      Uri.parse(UrlHelper.DashboardUrl),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200) {
      print("hghgjghgh");
      print(response.body);
      return DashboardModel.fromJson(jsonDecode(response.body.toString()));
    } else {
      dashboardModel.message = jsonDecode(response.body)["message"];
      return dashboardModel;
    }
  }

  static Future<ProfileModel> profileGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ProfileModel loginModel = ProfileModel();
    List<ProfileModel> loginMode;

    var isToken = prefs.getString('isToken');

    ProfileModel profileModel = ProfileModel();
    var response = await http.get(
      Uri.parse(UrlHelper.ProfileUrl),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      loginMode = <ProfileModel>[];
      loginMode.add(ProfileModel.fromJson(jsonDecode(response.body)));
      ProfileModel user = loginMode[0];

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool("isLoggedIn", true);
      prefs.setString("isname", user.result!.name as String);
      prefs.setString("is number", user.result!.mobileNumber as String);
      prefs.setString(
          "is reranumber", user.result!.associateReraNumber as String);
      prefs.setString("is userid", user.result!.publicId as String);
      var isname = prefs.getString('isname');
      var number = prefs.getString('is number');
      var reranumber = prefs.getString('is reranumber');

      return ProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      profileModel.result;

      return profileModel;
    } else {
      profileModel.message = jsonDecode(response.body)["message"];
      return profileModel;
    }
  }

  static Future<SchemsForm> SchemForm(Map<String, dynamic> map) async {
    SchemsForm schemsForm = SchemsForm();

    var response = await http.post(
      Uri.parse("https://dmlux.in/project/public/api/property/booking"),
      body: map,
    );

    if (response.statusCode == 200) {
      return SchemsForm.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      return schemsForm;
    } else {
      return schemsForm;
    }
  }

  static Future<SchemsForm> upload(
      BuildContext context,
      image,
      image1,
      image2,
      image3,
      id,
      value,
      dropdownValue1,
      customer_name,
      contact_number,
      address,
      pan_number,
      description) async {
    SchemsForm schemsForm = SchemsForm();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isname = prefs.getString('isname');
    var number = prefs.getString('is number');
    var reranumber = prefs.getString('is reranumber');

    var isToken = prefs.getString('isToken');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $isToken',
    };
    var stream = http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    String filename = basename(image!.path);
    var uri = Uri.parse('https://dmlux.in/project/public/api/property/booking');
    var request = http.MultipartRequest('POST', uri);
    var multipartFile = http.MultipartFile(
      'adhar_card',
      stream,
      length,
      filename: filename,
    );
    request.files.add(multipartFile);

    String fileName2 = basename(image1!.path);
    var stream2 = http.ByteStream(image1!.openRead());
    var lengthOfFile2 = await image1!.length();
    var multipartFile2 = http.MultipartFile(
        'cheque_photo', stream2, lengthOfFile2,
        filename: fileName2);
    request.files.add(multipartFile2);
    String fileName3 = basename(image2!.path);
    var stream3 = http.ByteStream(image2!.openRead());
    var lengthOfFile3 = await image2!.length();
    var multipartFile3 = http.MultipartFile(
        'attachement', stream3, lengthOfFile3,
        filename: fileName3);
    request.files.add(multipartFile3);
    String fileName4 = basename(image3!.path);
    var stream4 = http.ByteStream(image3!.openRead());
    var lengthOfFile4 = await image3!.length();
    var multipartFile4 = http.MultipartFile(
        'pan_card_image', stream4, lengthOfFile4,
        filename: fileName4);
    request.files.add(multipartFile4);
    request.fields['property_id'] = id;
    request.fields['associate_name'] = isname.toString();
    request.fields['associate_number'] = number.toString();
    request.fields['associate_rera_number'] = reranumber.toString();
    request.fields['owner_name'] = customer_name.text;
    request.fields['ploat_status'] = value == "Hold"
        ? '3'
        : value == "Book"
            ? '2'
            : '0';
    request.fields['contact_no'] = contact_number.text;
    request.fields['address'] = address.text;
    request.fields['payment_mode'] = dropdownValue1 == "RTGS/IMPS"
        ? '1'
        : dropdownValue1 == "Bank Transfer"
            ? '2'
            : dropdownValue1 == "Cheque"
                ? '3'
                : '0';
    request.fields['pan_card_no'] = pan_number.text;
    request.fields['description'] = description.text;
    request.headers.addAll(headers);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        SchemsForm.fromJson(jsonDecode(value));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("successfully"),
          backgroundColor: Color.fromRGBO(1, 48, 74, 1),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SchemesSchreem()));
      });

      return SchemsForm.fromJson(jsonDecode(value));
    } else {
      return schemsForm;
    }
  }

  static Future<BookHold> bookHoldEdit(
    context,
    id,
  ) async {
    BookHold bookHold = BookHold();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var isToken = prefs.getString('isToken');
    var isschemid = prefs.getString('schemeid');
    var response = await http.get(
      Uri.parse(
          "https://dmlux.in/project/public/api/property/book-hold?scheme_id=$isschemid&property_id=$id"),
      headers: {
        'Authorization': "Bearer $isToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return BookHold.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      return bookHold;
    } else {
      bookHold.message = jsonDecode(response.body)["message"];
      return bookHold;
    }
  }

  static Future<SchemsDetailsModel> getSchemsDetails(scheme) async {
    SchemsDetailsModel schemsDetailsModel = SchemsDetailsModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.get(
      Uri.parse(UrlHelper.SchemsDetailsUrl + "$scheme"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SchemsDetailsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      schemsDetailsModel.result;
      return schemsDetailsModel;
    } else {
      schemsDetailsModel.message = jsonDecode(response.body)["message"];
      return schemsDetailsModel;
    }
  }

  static Future<BookHoldDetails> bookHoldDetails(scheme) async {
    BookHoldDetails schemsDetailsModel = BookHoldDetails();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.get(
      Uri.parse(
          UrlHelper.book_details_url+'$scheme'),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return BookHoldDetails.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      schemsDetailsModel.result;
      return schemsDetailsModel;
    } else {
      schemsDetailsModel.message = jsonDecode(response.body)["message"];
      return schemsDetailsModel;
    }
  }





  
}
