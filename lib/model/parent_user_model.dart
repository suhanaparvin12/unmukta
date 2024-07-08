class ParentUserModel {
  String? name;
  String? childPhone;
  String? parentPhone;
  String? childEmail;
  String? parentEmail;
  String? id;
  String? profilePic;
  String? type;

  ParentUserModel({
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
        'childPhone': childPhone,
        'Phone': parentPhone,
        'childEmail': childEmail,
        'Email': parentEmail,
        'id': id,
        'profilePic': profilePic,
        'type': type,
      };
}
