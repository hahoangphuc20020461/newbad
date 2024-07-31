// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  var id;
  var username;
  var peoplename;
  var phonenumber;
  var email;
  
  User({
    required this.id,
    required this.username,
    required this.peoplename,
    required this.phonenumber,
    required this.email,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"],
        username: json['username'],
         peoplename: json["peoplename"],
          phonenumber: json["phonenumber"],
          email: json["email"],
        );
  }
}
