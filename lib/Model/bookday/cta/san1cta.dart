class San1DayCTA {
  var courtId;
  var userId;
  var starttime;
  var endtime;
  var date;
  var status;
  var paymentstatus;
  var id;

  San1DayCTA({
    this.courtId,
    this.userId,
    this.starttime,
    this.endtime,
    this.date,
    this.status,
    this.paymentstatus,
    this.id
  });

  factory San1DayCTA.fromJson(Map<String, dynamic> json) {
    return San1DayCTA(
        courtId: json["courtId"],
        userId: json['userId'],
        starttime: json['starttime'],
        endtime: json["endtime"],
        date: json["date"],
        status: json["status"],
        paymentstatus: json["paymentstatus"],
        id: json["_id"]
        );
  }
}