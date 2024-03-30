// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  var id;
  var username;
  
  User({
    required this.id,
    required this.username,
    
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        username: json['username'],
        );
  }
}
