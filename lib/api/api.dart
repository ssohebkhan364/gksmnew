import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gkms/api/url_helper.dart';
import 'package:gkms/model/Log_out.dart';
import 'package:gkms/model/Multiple_ploat.dart';
import 'package:gkms/model/bookHoldEdit.dart';
import 'package:gkms/model/login.dart';
import 'package:gkms/model/otpVerify.dart';
import 'package:gkms/model/otpreverify.dart';
import 'package:gkms/model/payment_model.dart';
import 'package:gkms/model/payment_post.dart';
import 'package:gkms/model/report_details.dart';
import 'package:gkms/model/schems_details.dart';
import 'package:gkms/model/verify.dart';
import 'package:gkms/model/waiting_list.dart';
import 'package:gkms/screen/login.dart';
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
print("jjjjjj");
print(response.statusCode);
    if (response.statusCode == 200) {
      return SignUpModel.fromJson(jsonDecode(response.body));
    }
    
     else if (response.statusCode == 500) {
       signUpModel.message = jsonDecode(response.body)["message"];
        //  signUpModel.errors = jsonDecode(response.body)["errors"];
        return signUpModel;
    } else {
              
    //  signUpModel.message = jsonDecode(response.body)["message"];
    //   //  return SignUpModel.fromJson(jsonDecode(response.body));
    //      signUpModel.errors = jsonDecode(response.body)["Errors"];
    //      print("jhhjhj");
       print("hjhjh");
       print(response.body);
     return SignUpModel.fromJson(jsonDecode(response.body));
    }
  }

  static Future<LoginModel> login(Map<String, dynamic> map) async {
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
      return DashboardModel.fromJson(jsonDecode(response.body.toString()));
    } else {
      dashboardModel.message = jsonDecode(response.body)["message"];
      return dashboardModel;
    }
  }

  static Future<ProfileModel> profileGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

      return ProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      profileModel.result;

      return profileModel;
    } else {
      profileModel.message = jsonDecode(response.body)["message"];
      return profileModel;
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
          // "https://dmlux.in/project/public/api/property/book-hold?scheme_id=$isschemid&property_id=$id"),
    
    UrlHelper.property_book_hold +'?scheme_id=$isschemid&property_id=$id'),
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
      Uri.parse(UrlHelper.book_details_url + '$scheme'),
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

  static Future<MultiplePloat> multiple_ploat(context, scheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    MultiplePloat multiplePloat = MultiplePloat();
    var response = await http.get(
      Uri.parse(
          UrlHelper.multiple_booking + '$scheme'),
  
         
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200) {
      return MultiplePloat.fromJson(jsonDecode(response.body.toString()));
    } else {
      multiplePloat.status = jsonDecode(response.body)["status"];
        multiplePloat.message = jsonDecode(response.body)["message"];
      return multiplePloat;
    }
  }

  static Future<WaitingList> waiting(context, id, num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    WaitingList waitingList1 = WaitingList();
    var response = await http.get(
      Uri.parse(UrlHelper.waitin_list+'$id/$num'),
 

     
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200) {
      return WaitingList.fromJson(jsonDecode(response.body.toString()));
    } else {
      // waitingList1.status = jsonDecode(response.body)["status"];
        waitingList1.message = jsonDecode(response.body)["message"];
        print("uuuu");
        print( waitingList1.message);
      return waitingList1;
    }
  }

  static Future<PaymentModel> payment(
    context,
    id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    PaymentModel paymentModel = PaymentModel();
    var response = await http.get(
      Uri.parse( UrlHelper.payment_prrof+'$id'),
      
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200) {
      return PaymentModel.fromJson(jsonDecode(response.body.toString()));
    } else {
      paymentModel.status = jsonDecode(response.body)["status"];
        paymentModel.message = jsonDecode(response.body)["message"];
      return paymentModel;
    }
  }

  static Future<PaymentPost> paymentPost(
      context, add_image3, id, payment_details) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');

    PaymentPost paymentPost = PaymentPost();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $isToken',
    };

    var stream = http.ByteStream(add_image3!.openRead());
    stream.cast();
    var length = await add_image3!.length();
    String filename = basename(add_image3!.path);
 var uri = Uri.parse(UrlHelper.payment_prrof_post);
   
    var request = http.MultipartRequest('POST', uri);

    var multipartFile = http.MultipartFile(
      'payment_proof',
      stream,
      length,
      filename: filename,
    );
    request.files.add(multipartFile);
    request.fields['payment_detail'] = payment_details;
    request.fields['id'] = id.toString();
    request.headers.addAll(headers);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

     
      
      if(decodedMap['message'].toString() == "Payment details update successfully"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(decodedMap['message'].toString()),
        backgroundColor: Color(0xff03467d)
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SchemesSchreem()),
          (Route<dynamic> route) => route.isFirst);

      }
      return paymentPost;
    } else {
       var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

        paymentPost.message =decodedMap['message'].toString();
             if (decodedMap['message'].toString() == "Unauthenticated.") {
        ApiServices.getLogOut(context).then((value) {
          if(value.status==true){
             prefs.clear();
          }
        });
   
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())));
      }
      return paymentPost;
    }
  }

  static Future<VerifyModel> verify() async {
    VerifyModel verifyModel = VerifyModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.get(
      Uri.parse(UrlHelper.verify),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      return VerifyModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      verifyModel;
      return verifyModel;
    } else {
      verifyModel.message = jsonDecode(response.body)["message"];
      return verifyModel;
    }
  }

  static Future<OtpVerify> otpVerify(String otp) async {


    OtpVerify otpVerify = OtpVerify();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.get(
      Uri.parse(UrlHelper.vrifyotp+"?token=$otp"),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      return OtpVerify.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      otpVerify;
      return otpVerify;
    } else {
      otpVerify.message = jsonDecode(response.body)["message"];
      return otpVerify;
    }
  }

  static Future<OtpReVerify> otpReVerify() async {
  
    OtpReVerify otpReVerify = OtpReVerify();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isToken = prefs.getString('isToken');
    var response = await http.get(
      Uri.parse(UrlHelper.revrifyrotp),
      headers: {
        'Authorization': "Bearer $isToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      return OtpReVerify.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 500) {
      otpReVerify;
      return otpReVerify;
    } else {
      otpReVerify.message = jsonDecode(response.body)["message"];
      return otpReVerify;
    }
  }
}

