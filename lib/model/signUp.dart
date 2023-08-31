class SignUpModel {
  bool? status;
  String? message;

  SignUpModel({
    this.status,
    this.message,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
