class DashboardModel {
  bool? status;
  Result? result;
  String? message;

  DashboardModel({
    this.status,
    this.result,
    this.message,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result!.toJson(),
      };
}

class Result {
  int? usersCount;
  int? productionsCount;
  int? schemesCount;
  int? bookPropertyCount;
  int? holdPropertyCount;

  Result({
    this.usersCount,
    this.productionsCount,
    this.schemesCount,
    this.bookPropertyCount,
    this.holdPropertyCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        usersCount: json["usersCount"],
        productionsCount: json["productionsCount"],
        schemesCount: json["schemesCount"],
        bookPropertyCount: json["bookPropertyCount"],
        holdPropertyCount: json["holdPropertyCount"],
      );

  Map<String, dynamic> toJson() => {
        "usersCount": usersCount,
        "productionsCount": productionsCount,
        "schemesCount": schemesCount,
        "bookPropertyCount": bookPropertyCount,
        "holdPropertyCount": holdPropertyCount,
      };
}
