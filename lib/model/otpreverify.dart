
class OtpReVerify {
    bool? status;
    String? message;

    OtpReVerify({
        this.status,
        this.message,
    });

    factory OtpReVerify.fromJson(Map<String, dynamic> json) => OtpReVerify(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
