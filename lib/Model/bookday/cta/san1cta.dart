class San1DayCTA {
  var courtId;
  var userId;
  var tensan;
  var sansomay;
  var starttime;
  var endtime;
  var date;
  var status;
  var paymentstatus;
  var id;

  San1DayCTA({
    this.courtId,
    this.userId,
    this.tensan,
    this.sansomay,
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
        tensan: json['tensan'],
        sansomay: json['sansomay'],
        starttime: json['starttime'],
        endtime: json["endtime"],
        date: json["date"],
        status: json["status"],
        paymentstatus: json["paymentstatus"],
        id: json["_id"]
        );
  }
}