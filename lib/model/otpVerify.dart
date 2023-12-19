
class OtpVerify {
    bool? status;
    String? message;

    OtpVerify({
        this.status,
        this.message,
    });

    factory OtpVerify.fromJson(Map<String, dynamic> json) => OtpVerify(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}