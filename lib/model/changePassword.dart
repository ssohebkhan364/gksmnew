class ChangePassword {
  bool? status;
  String? message;

  ChangePassword({
    this.status,
    this.message,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
