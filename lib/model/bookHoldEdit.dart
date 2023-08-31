class BookHold {
  bool? status;
  Result? result;
  String? message;

  BookHold({
    this.status,
    this.result,
    this.message,
  });

  factory BookHold.fromJson(Map<String, dynamic> json) => BookHold(
      status: json["status"],
      result: json["result"] == null ? null : Result.fromJson(json["result"]),
      message: json["message"]);

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result?.toJson(),
        "message": message,
      };
}

class Result {
  List<MultiCustomer>? multiCustomer;
  ProptyDetail? proptyDetail;

  Result({
    this.multiCustomer,
    this.proptyDetail,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        multiCustomer: json["multi_customer"] == null
            ? []
            : List<MultiCustomer>.from(
                json["multi_customer"]!.map((x) => MultiCustomer.fromJson(x))),
        proptyDetail: json["propty_detail"] == null
            ? null
            : ProptyDetail.fromJson(json["propty_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "multi_customer": multiCustomer == null
            ? []
            : List<dynamic>.from(multiCustomer!.map((x) => x.toJson())),
        "propty_detail": proptyDetail?.toJson(),
      };
}

class MultiCustomer {
  String? id;
  String? publicId;
  String? plotPublicId;
  String? paymentMode;
  String? adharCard;
  String? chequePhoto;
  dynamic panCard;
  String? panCardImage;
  String? attachment;
  String? ownerName;
  String? contactNo;
  String? bookingStatus;
  String? address;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;

  MultiCustomer({
    this.id,
    this.publicId,
    this.plotPublicId,
    this.paymentMode,
    this.adharCard,
    this.chequePhoto,
    this.panCard,
    this.panCardImage,
    this.attachment,
    this.ownerName,
    this.contactNo,
    this.bookingStatus,
    this.address,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory MultiCustomer.fromJson(Map<String, dynamic> json) => MultiCustomer(
        id: json["id"],
        publicId: json["public_id"],
        plotPublicId: json["plot_public_id"],
        paymentMode: json["payment_mode"],
        adharCard: json["adhar_card"],
        chequePhoto: json["cheque_photo"],
        panCard: json["pan_card"],
        panCardImage: json["pan_card_image"],
        attachment: json["attachment"],
        ownerName: json["owner_name"],
        contactNo: json["contact_no"],
        bookingStatus: json["booking_status"],
        address: json["address"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "public_id": publicId,
        "plot_public_id": plotPublicId,
        "payment_mode": paymentMode,
        "adhar_card": adharCard,
        "cheque_photo": chequePhoto,
        "pan_card": panCard,
        "pan_card_image": panCardImage,
        "attachment": attachment,
        "owner_name": ownerName,
        "contact_no": contactNo,
        "booking_status": bookingStatus,
        "address": address,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ProptyDetail {
  String? schemePublicId;
  String? schemeName;
  String? schemeId;
  String? schemeStatus;
  String? id;
  String? publicId;
  String? productionId;
  String? plotNo;
  dynamic plotDesc;
  String? status;
  String? userId;
  String? associateName;
  String? associateNumber;
  String? associateReraNumber;
  String? paymentMode;
  String? adharCard;
  dynamic panCard;
  String? panCardImage;
  String? chequePhoto;
  String? attachment;
  String? ownerName;
  String? bookingStatus;
  String? contactNo;
  String? address;
  String? gaj;
  String? plotName;
  String? plotType;
  String? attributesNames;
  String? attributesData;
  dynamic description;
  String? managementHold;
  String? otherOwner;
  dynamic otherInfo;
  dynamic cancelBy;
  dynamic cancelReason;
  dynamic cancelTime;
  DateTime? bookingTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProptyDetail({
    this.schemePublicId,
    this.schemeName,
    this.schemeId,
    this.schemeStatus,
    this.id,
    this.publicId,
    this.productionId,
    this.plotNo,
    this.plotDesc,
    this.status,
    this.userId,
    this.associateName,
    this.associateNumber,
    this.associateReraNumber,
    this.paymentMode,
    this.adharCard,
    this.panCard,
    this.panCardImage,
    this.chequePhoto,
    this.attachment,
    this.ownerName,
    this.bookingStatus,
    this.contactNo,
    this.address,
    this.gaj,
    this.plotName,
    this.plotType,
    this.attributesNames,
    this.attributesData,
    this.description,
    this.managementHold,
    this.otherOwner,
    this.otherInfo,
    this.cancelBy,
    this.cancelReason,
    this.cancelTime,
    this.bookingTime,
    this.createdAt,
    this.updatedAt,
  });

  factory ProptyDetail.fromJson(Map<String, dynamic> json) => ProptyDetail(
        schemePublicId: json["scheme_public_id"],
        schemeName: json["scheme_name"],
        schemeId: json["scheme_id"],
        schemeStatus: json["scheme_status"],
        id: json["id"],
        publicId: json["public_id"],
        productionId: json["production_id"],
        plotNo: json["plot_no"],
        plotDesc: json["plot_desc"],
        status: json["status"],
        userId: json["user_id"],
        associateName: json["associate_name"],
        associateNumber: json["associate_number"],
        associateReraNumber: json["associate_rera_number"],
        paymentMode: json["payment_mode"],
        adharCard: json["adhar_card"],
        panCard: json["pan_card"],
        panCardImage: json["pan_card_image"],
        chequePhoto: json["cheque_photo"],
        attachment: json["attachment"],
        ownerName: json["owner_name"],
        bookingStatus: json["booking_status"],
        contactNo: json["contact_no"],
        address: json["address"],
        gaj: json["gaj"],
        plotName: json["plot_name"],
        plotType: json["plot_type"],
        attributesNames: json["attributes_names"],
        attributesData: json["attributes_data"],
        description: json["description"],
        managementHold: json["management_hold"],
        otherOwner: json["other_owner"],
        otherInfo: json["other_info"],
        cancelBy: json["cancel_by"],
        cancelReason: json["cancel_reason"],
        cancelTime: json["cancel_time"],
        bookingTime: json["booking_time"] == null
            ? null
            : DateTime.parse(json["booking_time"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "scheme_public_id": schemePublicId,
        "scheme_name": schemeName,
        "scheme_id": schemeId,
        "scheme_status": schemeStatus,
        "id": id,
        "public_id": publicId,
        "production_id": productionId,
        "plot_no": plotNo,
        "plot_desc": plotDesc,
        "status": status,
        "user_id": userId,
        "associate_name": associateName,
        "associate_number": associateNumber,
        "associate_rera_number": associateReraNumber,
        "payment_mode": paymentMode,
        "adhar_card": adharCard,
        "pan_card": panCard,
        "pan_card_image": panCardImage,
        "cheque_photo": chequePhoto,
        "attachment": attachment,
        "owner_name": ownerName,
        "booking_status": bookingStatus,
        "contact_no": contactNo,
        "address": address,
        "gaj": gaj,
        "plot_name": plotName,
        "plot_type": plotType,
        "attributes_names": attributesNames,
        "attributes_data": attributesData,
        "description": description,
        "management_hold": managementHold,
        "other_owner": otherOwner,
        "other_info": otherInfo,
        "cancel_by": cancelBy,
        "cancel_reason": cancelReason,
        "cancel_time": cancelTime,
        "booking_time": bookingTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
