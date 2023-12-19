class WaitingList {
      String? message;
    bool? status;
    Result? result;

  WaitingList({
        this.message,
    this.status,
    this.result,
  });
  
  WaitingList.fromJson(Map<String, dynamic> json) {
        message = json['message'];
    status = json['status'];
    result = Result.fromJson(json['result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
        _data['message'] = message;
    _data['status'] = status;
    _data['result'] = result!.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.data,
  });
  late final List<Data> data;

  Result.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.schemeId,
    required this.plotNo,
    required this.userId,
    required this.associateName,
    required this.associateNumber,
    required this.associateReraNumber,
    required this.paymentMode,
    required this.adharCard,
    required this.adharCardNumber,
    this.panCard,
    required this.panCardImage,
    required this.chequePhoto,
    required this.attachment,
    required this.ownerName,
    required this.bookingStatus,
    this.contactNo,
    this.address,
    required this.bookingTime,
    this.description,
    this.otherOwner,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String schemeId;
  late final String plotNo;
  late final String userId;
  late final String associateName;
  late final String associateNumber;
  late final String associateReraNumber;
  late final String paymentMode;
  late final String adharCard;
  late final String adharCardNumber;
  late final Null panCard;
  late final String panCardImage;
  late final String chequePhoto;
  late final String attachment;
  late final String ownerName;
  late final String bookingStatus;
  late final Null contactNo;
  late final Null address;
  late final String bookingTime;
  late final Null description;
  late final Null otherOwner;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schemeId = json['scheme_id'];
    plotNo = json['plot_no'];
    userId = json['user_id'];
    associateName = json['associate_name'];
    associateNumber = json['associate_number'];
    associateReraNumber = json['associate_rera_number'];
    paymentMode = json['payment_mode'];
    adharCard = json['adhar_card'];
    adharCardNumber = json['adhar_card_number'];
    panCard = null;
    panCardImage = json['pan_card_image'];
    chequePhoto = json['cheque_photo'];
    attachment = json['attachment'];
    ownerName = json['owner_name'];
    bookingStatus = json['booking_status'];
    contactNo = null;
    address = null;
    bookingTime = json['booking_time'];
    description = null;
    otherOwner = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['scheme_id'] = schemeId;
    _data['plot_no'] = plotNo;
    _data['user_id'] = userId;
    _data['associate_name'] = associateName;
    _data['associate_number'] = associateNumber;
    _data['associate_rera_number'] = associateReraNumber;
    _data['payment_mode'] = paymentMode;
    _data['adhar_card'] = adharCard;
    _data['adhar_card_number'] = adharCardNumber;
    _data['pan_card'] = panCard;
    _data['pan_card_image'] = panCardImage;
    _data['cheque_photo'] = chequePhoto;
    _data['attachment'] = attachment;
    _data['owner_name'] = ownerName;
    _data['booking_status'] = bookingStatus;
    _data['contact_no'] = contactNo;
    _data['address'] = address;
    _data['booking_time'] = bookingTime;
    _data['description'] = description;
    _data['other_owner'] = otherOwner;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
