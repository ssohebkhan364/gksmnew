
class SignUpModel {
    bool? status;
    String? message;
    Errors? errors;

    SignUpModel({
        this.status,
        this.message,
        this.errors,
    });

    factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        status: json["status"],
        message: json["message"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errors": errors?.toJson(),
    };
}

class Errors {
    List<String>? email;
    List<String>? mobileNumber;
    List<String>? associateReraNumber;

    Errors({
        this.email,
        this.mobileNumber,
        this.associateReraNumber,
    });

    factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        email: json["email"] == null ? [] : List<String>.from(json["email"]!.map((x) => x)),
        mobileNumber: json["mobile_number"] == null ? [] : List<String>.from(json["mobile_number"]!.map((x) => x)),
        associateReraNumber: json["associate_rera_number"] == null ? [] : List<String>.from(json["associate_rera_number"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
        "mobile_number": mobileNumber == null ? [] : List<dynamic>.from(mobileNumber!.map((x) => x)),
        "associate_rera_number": associateReraNumber == null ? [] : List<dynamic>.from(associateReraNumber!.map((x) => x)),
    };
}