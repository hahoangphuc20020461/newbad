class DashBoardforAdmin {
  var name;
  var nameofpeople;
  var phonenumber;
  var location;
  var image;
  var id;
  var linklocation;
  List<String>? soluongsan;
  

  DashBoardforAdmin({
    this.name,
    this.nameofpeople,
    this.phonenumber,
    this.location,
    this.image,
    this.id,
    this.linklocation,
    this.soluongsan
  });

  factory DashBoardforAdmin.fromJson(Map<String, dynamic> json) {
    return DashBoardforAdmin(
        name: json["name"],
        nameofpeople: json['nameofpeople'],
        phonenumber: json['phonenumber'],
        location: json["location"],
        image: json["image"],
        id: json["_id"],
        linklocation: json["linklocation"],
        soluongsan: json['soluongsan'] != null
          ? List<String>.from(json['soluongsan'])
          : null,
        );
  }
}