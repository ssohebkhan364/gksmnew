class ProfileModel {
  bool? status;
  Result? result;
  String? message;

  ProfileModel({
    this.status,
    this.result,
    this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        result: Result.fromJson(json["result"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result!.toJson(),
        "message": message,
      };
}

class Result {
  String? id;
  String? publicId;
  dynamic? parentId;
  dynamic? parentUserType;
  String? email;
  String? password;
  String? name;
  String? mobileNumber;
  String? status;
  String? userType;
  dynamic? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? associateReraNumber;
  String? applierName;
  String? applierReraNumber;
  String? team;
  String? allSeen;
  String? gaj;
  dynamic? tokenReg;
  String? teamName;

  Result({
    this.id,
    this.publicId,
    this.parentId,
    this.parentUserType,
    this.email,
    this.password,
    this.name,
    this.mobileNumber,
    this.status,
    this.userType,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.associateReraNumber,
    this.applierName,
    this.applierReraNumber,
    this.team,
    this.allSeen,
    this.gaj,
    this.tokenReg,
    this.teamName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        publicId: json["public_id"],
        parentId: json["parent_id"],
        parentUserType: json["parent_user_type"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        status: json["status"],
        userType: json["user_type"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        associateReraNumber: json["associate_rera_number"],
        applierName: json["applier_name"],
        applierReraNumber: json["applier_rera_number"],
        team: json["team"],
        allSeen: json["all_seen"],
        gaj: json["gaj"],
        tokenReg: json["token_reg"],
        teamName: json["team_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "public_id": publicId,
        "parent_id": parentId,
        "parent_user_type": parentUserType,
        "email": email,
        "password": password,
        "name": name,
        "mobile_number": mobileNumber,
        "status": status,
        "user_type": userType,
        "image": image,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "associate_rera_number": associateReraNumber,
        "applier_name": applierName,
        "applier_rera_number": applierReraNumber,
        "team": team,
        "all_seen": allSeen,
        "gaj": gaj,
        "token_reg": tokenReg,
        "team_name": teamName,
      };
}
