class SchemsDetailsModel {
  bool? status;
  Result? result;
  String? message;

  SchemsDetailsModel({
    this.status,
    this.result,
    this.message,
  });

  factory SchemsDetailsModel.fromJson(Map<String, dynamic> json) =>
      SchemsDetailsModel(
        status: json["status"],
        result: Result.fromJson(json["result"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result!.toJson(),
        "message": message,
      };
}

class Result {
  List<SchemeDetail>? schemeDetails;
  List<String>? images;

  Result({
    this.schemeDetails,
    this.images,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        schemeDetails: List<SchemeDetail>.from(
            json["scheme_details"].map((x) => SchemeDetail.fromJson(x))),
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "scheme_details":
            List<dynamic>.from(schemeDetails!.map((x) => x.toJson())),
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}

class SchemeDetail {
  String? id;
  String? publicId;
  String? productionId;
  String? schemeName;
  String? schemeImg;
  String? brochure;
  String? ppt;
  String? video;
  String? jdaMap;
  String? pra;
  String? otherDocs;
  String? schemeImages;
  String? location;
  String? noOfPlot;
  String? schemeDescription;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? branchName;
  String? team;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? teamName;

  SchemeDetail({
    this.id,
    this.publicId,
    this.productionId,
    this.schemeName,
    this.schemeImg,
    this.brochure,
    this.ppt,
    this.video,
    this.jdaMap,
    this.pra,
    this.otherDocs,
    this.schemeImages,
    this.location,
    this.noOfPlot,
    this.schemeDescription,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.branchName,
    this.team,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.teamName,
  });

  factory SchemeDetail.fromJson(Map<String, dynamic> json) => SchemeDetail(
        id: json["id"],
        publicId: json["public_id"],
        productionId: json["production_id"],
        schemeName: json["scheme_name"],
        schemeImg: json["scheme_img"],
        brochure: json["brochure"],
        ppt: json["ppt"],
        video: json["video"],
        jdaMap: json["jda_map"],
        pra: json["pra"],
        otherDocs: json["other_docs"],
        schemeImages: json["scheme_images"],
        location: json["location"],
        noOfPlot: json["no_of_plot"],
        schemeDescription: json["scheme_description"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        branchName: json["branch_name"],
        team: json["team"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        teamName: json["team_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "public_id": publicId,
        "production_id": productionId,
        "scheme_name": schemeName,
        "scheme_img": schemeImg,
        "brochure": brochure,
        "ppt": ppt,
        "video": video,
        "jda_map": jdaMap,
        "pra": pra,
        "other_docs": otherDocs,
        "scheme_images": schemeImages,
        "location": location,
        "no_of_plot": noOfPlot,
        "scheme_description": schemeDescription,
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "branch_name": branchName,
        "team": team,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "team_name": teamName,
      };
}
