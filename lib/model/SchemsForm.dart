class SchemsForm {
  bool? status;
  String? message;

  SchemsForm({
    this.status,
    this.message,
  });

  factory SchemsForm.fromJson(Map<String, dynamic> json) => SchemsForm(
        status: json["status"],
        message: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": message,
      };
}
