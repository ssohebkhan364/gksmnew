
class MultiplePloat {
    bool? status;
    String?message;
    Result? result;


    MultiplePloat({
        this.status,
        this.message,
        this.result,
    });

    factory MultiplePloat.fromJson(Map<String, dynamic> json) => MultiplePloat(
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
    List<Property>? properties;
    SchemeDetail? schemeDetail;

    Result({
        this.properties,
        this.schemeDetail,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        properties: json["properties"] == null ? [] : List<Property>.from(json["properties"]!.map((x) => Property.fromJson(x))),
        schemeDetail: json["scheme_detail"] == null ? null : SchemeDetail.fromJson(json["scheme_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
        "scheme_detail": schemeDetail?.toJson(),
    };
}

class Property {
    String? plotType;
    String? schemeName;
    String? plotNo;
    String? plotName;
    String? schemeId;

    Property({
        this.plotType,
        this.schemeName,
        this.plotNo,
        this.plotName,
        this.schemeId,
    });

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        plotType: json["plot_type"],
        schemeName: json["scheme_name"],
        plotNo: json["plot_no"],
        plotName: json["plot_name"],
        schemeId: json["scheme_id"],
    );

    Map<String, dynamic> toJson() => {
        "plot_type": plotType,
        "scheme_name": schemeName,
        "plot_no": plotNo,
        "plot_name": plotName,
        "scheme_id": schemeId,
    };
}

class SchemeDetail {
    String? holdStatus;

    SchemeDetail({
        this.holdStatus,
    });

    factory SchemeDetail.fromJson(Map<String, dynamic> json) => SchemeDetail(
        holdStatus: json["hold_status"],
    );

    Map<String, dynamic> toJson() => {
        "hold_status": holdStatus,
    };
}
