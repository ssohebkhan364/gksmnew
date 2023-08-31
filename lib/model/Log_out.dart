class LogOut {
  bool? status;
  String? message;

  LogOut({
    this.status,
    this.message,
  });

  factory LogOut.fromJson(Map<String, dynamic> json) => LogOut(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
