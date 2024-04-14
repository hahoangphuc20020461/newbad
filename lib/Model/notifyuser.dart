// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notify {
  var id;
  var courtname;
  var message;
  
  Notify({
    required this.id,
    required this.courtname,
    required this.message
  });
  factory Notify.fromJson(Map<String, dynamic> json) {
    return Notify(
        id: json["id"],
        courtname: json['courtname'],
        message: json['message'],
        );
  }
}
