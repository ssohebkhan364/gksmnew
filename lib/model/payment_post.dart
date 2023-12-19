class PaymentPost {
  bool? status;
  String? message;

  PaymentPost({
    this.status,
    this.message,
  });

  factory PaymentPost.fromJson(Map<String, dynamic> json) => PaymentPost(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
