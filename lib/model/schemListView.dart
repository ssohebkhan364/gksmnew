class SchemsListView {
  bool? status;
  Result? result;

  SchemsListView({
    this.status,
    this.result,
  });

  factory SchemsListView.fromJson(Map<String, dynamic> json) => SchemsListView(
        status: json["status"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result?.toJson(),
      };
}

class Result {
  List<Property>? properties;
  SchemeDetail? schemeDetail;

  Result({
    this.properties,
    this.schemeDetail,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        properties: json["properties"] == null
            ? []
            : List<Property>.from(
                json["properties"]!.map((x) => Property.fromJson(x))),
        schemeDetail: json["scheme_detail"] == null
            ? null
            : SchemeDetail.fromJson(json["scheme_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "properties": properties == null
            ? []
            : List<dynamic>.from(properties!.map((x) => x.toJson())),
        "scheme_detail": schemeDetail?.toJson(),
      };
}

class Property {
  String? propertyPublicId;
  String? description;
  dynamic plotName;
  String? plotType;
  String? userId;
  String? schemePublicId;
  String? schemeName;
  String? plotNo;
  String? schemeId;
  String? propertyStatus;
  String? status;
  String? attributesData;
  dynamic otherInfo;
  dynamic managementHold;

  Property({
    this.propertyPublicId,
    this.description,
    this.plotName,
    this.plotType,
    this.userId,
    this.schemePublicId,
    this.schemeName,
    this.plotNo,
    this.schemeId,
    this.propertyStatus,
    this.status,
    this.attributesData,
    this.otherInfo,
    this.managementHold,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        propertyPublicId: json["property_public_id"],
        description: json["description"],
        plotName: json["plot_name"],
        plotType: json["plot_type"],
        userId: json["user_id"],
        schemePublicId: json["scheme_public_id"],
        schemeName: json["scheme_name"],
        plotNo: json["plot_no"],
        schemeId: json["scheme_id"],
        propertyStatus: json["property_status"],
        status: json["status"],
        attributesData: json["attributes_data"],
        otherInfo: json["other_info"],
        managementHold: json["management_hold"],
      );

  Map<String, dynamic> toJson() => {
        "property_public_id": propertyPublicId,
        "description": description,
        "plot_name": plotName,
        "plot_type": plotType,
        "user_id": userId,
        "scheme_public_id": schemePublicId,
        "scheme_name": schemeName,
        "plot_no": plotNo,
        "scheme_id": schemeId,
        "property_status": propertyStatus,
        "status": status,
        "attributes_data": attributesData,
        "other_info": otherInfo,
        "management_hold": managementHold,
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
