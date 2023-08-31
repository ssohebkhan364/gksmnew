class Book_Hold_Report {
  bool? status;
  Result? result;

  Book_Hold_Report({
    this.status,
    this.result,
  });

  factory Book_Hold_Report.fromJson(Map<String, dynamic> json) =>
      Book_Hold_Report(
        status: json["status"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result?.toJson(),
      };
}

class Result {
  List<ProptyReportDetail>? proptyReportDetails;

  Result({
    this.proptyReportDetails,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        proptyReportDetails: json["propty_report_details"] == null
            ? []
            : List<ProptyReportDetail>.from(json["propty_report_details"]!
                .map((x) => ProptyReportDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "propty_report_details": proptyReportDetails == null
            ? []
            : List<dynamic>.from(proptyReportDetails!.map((x) => x.toJson())),
      };
}

class ProptyReportDetail {
  String? schemePublicId;
  String? schemeName;
  String? managementHold;
  String? schemeId;
  String? schemeStatus;
  String? plotNo;
  String? ownerName;
  String? contactNo;
  String? associateName;
  String? associateNumber;
  String? associateReraNumber;
  String? bookingStatus;
  String? propertyPublicId;
  DateTime? bookingTime;
  String? description;

  ProptyReportDetail({
    this.schemePublicId,
    this.schemeName,
    this.managementHold,
    this.schemeId,
    this.schemeStatus,
    this.plotNo,
    this.ownerName,
    this.contactNo,
    this.associateName,
    this.associateNumber,
    this.associateReraNumber,
    this.bookingStatus,
    this.propertyPublicId,
    this.bookingTime,
    this.description,
  });

  factory ProptyReportDetail.fromJson(Map<String, dynamic> json) =>
      ProptyReportDetail(
        schemePublicId: json["scheme_public_id"],
        schemeName: json["scheme_name"],
        managementHold: json["management_hold"],
        schemeId: json["scheme_id"],
        schemeStatus: json["scheme_status"],
        plotNo: json["plot_no"],
        ownerName: json["owner_name"],
        contactNo: json["contact_no"],
        associateName: json["associate_name"],
        associateNumber: json["associate_number"],
        associateReraNumber: json["associate_rera_number"],
        bookingStatus: json["booking_status"],
        propertyPublicId: json["property_public_id"],
        bookingTime: json["booking_time"] == null
            ? null
            : DateTime.parse(json["booking_time"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "scheme_public_id": schemePublicId,
        "scheme_name": schemeName,
        "management_hold": managementHold,
        "scheme_id": schemeId,
        "scheme_status": schemeStatus,
        "plot_no": plotNo,
        "owner_name": ownerName,
        "contact_no": contactNo,
        "associate_name": associateName,
        "associate_number": associateNumber,
        "associate_rera_number": associateReraNumber,
        "booking_status": bookingStatus,
        "property_public_id": propertyPublicId,
        "booking_time": bookingTime?.toIso8601String(),
        "description": description,
      };
}
