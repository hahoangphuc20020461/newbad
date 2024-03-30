class DashBoardforAdmin {
  var name;
  var nameofpeople;
  var phonenumber;
  var location;
  var image;
  var id;
  

  DashBoardforAdmin({
    this.name,
    this.nameofpeople,
    this.phonenumber,
    this.location,
    this.image,
    this.id
  });

  factory DashBoardforAdmin.fromJson(Map<String, dynamic> json) {
    return DashBoardforAdmin(
        name: json["name"],
        nameofpeople: json['nameofpeople'],
        phonenumber: json['phonenumber'],
        location: json["location"],
        image: json["image"],
        id: json["_id"]
        );
  }
}