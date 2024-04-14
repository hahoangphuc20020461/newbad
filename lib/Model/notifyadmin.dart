class NotifyAdmin{
    var id;
  var message;
  
  NotifyAdmin({
    required this.id,
    required this.message
  });
  factory NotifyAdmin.fromJson(Map<String, dynamic> json) {
    return NotifyAdmin(
        id: json["id"],
        message: json['message'],
        );
  }
}