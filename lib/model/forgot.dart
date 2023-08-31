class ForgotModel {
  bool? status;
  String? message;

  ForgotModel({
    this.status,
    this.message,
  });
  factory ForgotModel.fromJson(Map<String, dynamic> json) => ForgotModel(
        status: json["status"],
        message: json["message"],
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
