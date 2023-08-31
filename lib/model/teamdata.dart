class DropdownList {
  bool? status;
  Result? result;

  DropdownList({
    this.status,
    this.result,
  });

  factory DropdownList.fromJson(Map<String, dynamic> json) => DropdownList(
        status: json["status"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result!.toJson(),
      };
}

class Result {
  List<Teamdta>? teamdta;

  Result({
    this.teamdta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        teamdta:
            List<Teamdta>.from(json["teamdta"].map((x) => Teamdta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "teamdta": List<dynamic>.from(teamdta!.map((x) => x.toJson())),
      };
}

class Teamdta {
  String? id;
  String? publicId;
  String? teamName;
  String? teamDescription;
  String? superTeam;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Teamdta({
    this.id,
    this.publicId,
    this.teamName,
    this.teamDescription,
    this.superTeam,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Teamdta.fromJson(Map<String, dynamic> json) => Teamdta(
        id: json["id"],
        publicId: json["public_id"],
        teamName: json["team_name"],
        teamDescription: json["team_description"],
        superTeam: json["super_team"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "public_id": publicId,
        "team_name": teamName,
        "team_description": teamDescription,
        "super_team": superTeam,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
