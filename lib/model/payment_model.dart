class PaymentModel {
  bool? status;
  String? message;
  Result? result;

  PaymentModel({
    this.status,
  this.message,
    this.result,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message":message,
        "result": result?.toJson(),
      };
}

class Result {
  PropertyDetails? propertyDetails;

  Result({
    this.propertyDetails,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        propertyDetails: json["property_details"] == null
            ? null
            : PropertyDetails.fromJson(json["property_details"]),
      );

  Map<String, dynamic> toJson() => {
        "property_details": propertyDetails?.toJson(),
      };
}

class PropertyDetails {
  String? propertyPublicId;
  String? id;
  String? schemeId;
  String? schemeName;
  String? plotNo;

  PropertyDetails({
    this.propertyPublicId,
    this.id,
    this.schemeId,
    this.schemeName,
    this.plotNo,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
      PropertyDetails(
        propertyPublicId: json["property_public_id"],
        id: json["id"],
        schemeId: json["scheme_id"],
        schemeName: json["scheme_name"],
        plotNo: json["plot_no"],
      );

  Map<String, dynamic> toJson() => {
        "property_public_id": propertyPublicId,
        "id": id,
        "scheme_id": schemeId,
        "scheme_name": schemeName,
        "plot_no": plotNo,
      };
}
