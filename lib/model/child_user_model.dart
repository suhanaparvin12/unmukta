class ChildUserModel {
  String? name;
  String? childPhone;
  String? parentPhone;
  String? childEmail;
  String? parentEmail;
  String? id;
  String? profilePic;
  String? type;

  ChildUserModel({
    this.name,
    this.childPhone,
    this.parentPhone,
    this.childEmail,
    this.parentEmail,
    this.id,
    this.profilePic,
    this.type,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'Phone': childPhone,
        'parentPhone': parentPhone,
        'Email': childEmail,
        'parentEmail': parentEmail,
        'id': id,
        'profilePic': profilePic,
        'type': type,
      };
}
