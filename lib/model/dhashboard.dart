class DashboardModel {
  bool? status;
  String? message;
  Result? result;

  DashboardModel({
    this.status,
    this.message,
    this.result,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result?.toJson(),
      };
}

class Result {
  int? usersCount;
  int? schemesCount;
  int? bookPropertyCount;
  int? holdPropertyCount;
  List<Datum>? bookdata;
  List<Datum>? holddata;
  List<Datum>? completedata;
  List<Proofdatum>? proofvdata;
  List<Proofdatum>? proofdata;
  List<Waitingdatum>? waitingdata;

  Result({
    this.usersCount,
    this.schemesCount,
    this.bookPropertyCount,
    this.holdPropertyCount,
    this.bookdata,
    this.holddata,
    this.completedata,
    this.proofvdata,
    this.proofdata,
    this.waitingdata,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        usersCount: json["usersCount"],
        schemesCount: json["schemesCount"],
        bookPropertyCount: json["bookPropertyCount"],
        holdPropertyCount: json["holdPropertyCount"],
        bookdata: json["bookdata"] == null
            ? []
            : List<Datum>.from(json["bookdata"]!.map((x) => Datum.fromJson(x))),
        holddata: json["holddata"] == null
            ? []
            : List<Datum>.from(json["holddata"]!.map((x) => Datum.fromJson(x))),
        completedata: json["completedata"] == null
            ? []
            : List<Datum>.from(
                json["completedata"]!.map((x) => Datum.fromJson(x))),
        proofvdata: json["proofvdata"] == null
            ? []
            : List<Proofdatum>.from(
                json["proofvdata"]!.map((x) => Proofdatum.fromJson(x))),
        proofdata: json["proofdata"] == null
            ? []
            : List<Proofdatum>.from(
                json["proofdata"]!.map((x) => Proofdatum.fromJson(x))),
        waitingdata: json["waitingdata"] == null
            ? []
            : List<Waitingdatum>.from(
                json["waitingdata"]!.map((x) => Waitingdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "usersCount": usersCount,
        "schemesCount": schemesCount,
        "bookPropertyCount": bookPropertyCount,
        "holdPropertyCount": holdPropertyCount,
        "bookdata": bookdata == null
            ? []
            : List<dynamic>.from(bookdata!.map((x) => x.toJson())),
        "holddata": holddata == null
            ? []
            : List<dynamic>.from(holddata!.map((x) => x.toJson())),
        "completedata": completedata == null
            ? []
            : List<dynamic>.from(completedata!.map((x) => x.toJson())),
        "proofvdata": proofvdata == null
            ? []
            : List<dynamic>.from(proofvdata!.map((x) => x.toJson())),
        "proofdata": proofdata == null
            ? []
            : List<dynamic>.from(proofdata!.map((x) => x.toJson())),
        "waitingdata": waitingdata == null
            ? []
            : List<dynamic>.from(waitingdata!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? schemeName;
  String? userCount;
  String? noOfPlot;

  Datum({
    this.id,
    this.schemeName,
    this.userCount,
    this.noOfPlot,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        schemeName: json["scheme_name"],
        userCount: json["user_count"],
        noOfPlot: json["no_of_plot"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheme_name": schemeName,
        "user_count": userCount,
        "no_of_plot": noOfPlot,
      };
}

class Proofdatum {
  String? id;
  String? schemeName;
  String? plotNo;
  String? plotName;
  DateTime? bookingTime;
  String? associateName;
  String? associateNumber;
  String? paymentDetails;
  String? proofImage;
  String? paymentId;

  Proofdatum({
    this.id,
    this.schemeName,
    this.plotNo,
    this.plotName,
    this.bookingTime,
    this.associateName,
    this.associateNumber,
    this.paymentDetails,
    this.proofImage,
    this.paymentId,
  });

  factory Proofdatum.fromJson(Map<String, dynamic> json) => Proofdatum(
        id: json["id"],
        schemeName: json["scheme_name"],
        plotNo: json["plot_no"],
        plotName: json["plot_name"],
        bookingTime: json["booking_time"] == null
            ? null
            : DateTime.parse(json["booking_time"]),
        associateName: json["associate_name"],
        associateNumber: json["associate_number"],
        paymentDetails: json["payment_details"],
        proofImage: json["proof_image"],
        paymentId: json["payment_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheme_name": schemeName,
        "plot_no": plotNo,
        "plot_name": plotName,
        "booking_time": bookingTime?.toIso8601String(),
        "associate_name": associateName,
        "associate_number": associateNumber,
        "payment_details": paymentDetails,
        "proof_image": proofImage,
        "payment_id": paymentId,
      };
}

class Waitingdatum {
  String? id;
  String? schemeName;
  String? plotNo;
  String? plotName;
  DateTime? bookingTime;
  String? associateName;
  String? associateNumber;
  String? waitingList;

  Waitingdatum({
    this.id,
    this.schemeName,
    this.plotNo,
    this.plotName,
    this.bookingTime,
    this.associateName,
    this.associateNumber,
    this.waitingList,
  });

  factory Waitingdatum.fromJson(Map<String, dynamic> json) => Waitingdatum(
        id: json["id"],
        schemeName: json["scheme_name"],
        plotNo: json["plot_no"],
        plotName: json["plot_name"],
        bookingTime: json["booking_time"] == null
            ? null
            : DateTime.parse(json["booking_time"]),
        associateName: json["associate_name"],
        associateNumber: json["associate_number"],
        waitingList: json["waiting_list"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheme_name": schemeName,
        "plot_no": plotNo,
        "plot_name": plotName,
        "booking_time": bookingTime?.toIso8601String(),
        "associate_name": associateName,
        "associate_number": associateNumber,
        "waiting_list": waitingList,
      };
}
