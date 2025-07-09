class VisitorData {
  Data? data;

  VisitorData({this.data});

  VisitorData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class Data {
  List<Visitors>? visitors;

  Data({this.visitors});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['visitors'] != null) {
      visitors = <Visitors>[];
      json['visitors'].forEach((v) {
        visitors!.add(Visitors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (visitors != null) {
      result['visitors'] = visitors!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Visitors {
  String? checkedby;
  String? createdat;
  String? idproofimageurl;
  String? intime;
  String? meetingperson;
  String? outtime;
  String? personimageurl;
  String? phone;
  String? purpose;
  String? updatedat;
  String? updatedby;
  int? visitorid;
  String? visitorname;

  Visitors({
    this.checkedby,
    this.createdat,
    this.idproofimageurl,
    this.intime,
    this.meetingperson,
    this.outtime,
    this.personimageurl,
    this.phone,
    this.purpose,
    this.updatedat,
    this.updatedby,
    this.visitorid,
    this.visitorname,
  });

  Visitors.fromJson(Map<String, dynamic> json) {
    checkedby = json['checkedby'];
    createdat = json['createdat'];
    idproofimageurl = json['idproofimageurl'];
    intime = json['intime'];
    meetingperson = json['meetingperson'];
    outtime = json['outtime'];
    personimageurl = json['personimageurl'];
    phone = json['phone'];
    purpose = json['purpose'];
    updatedat = json['updatedat'];
    updatedby = json['updatedby'];
    visitorid = json['visitorid'];
    visitorname = json['visitorname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['checkedby'] = checkedby;
    result['createdat'] = createdat;
    result['idproofimageurl'] = idproofimageurl;
    result['intime'] = intime;
    result['meetingperson'] = meetingperson;
    result['outtime'] = outtime;
    result['personimageurl'] = personimageurl;
    result['phone'] = phone;
    result['purpose'] = purpose;
    result['updatedat'] = updatedat;
    result['updatedby'] = updatedby;
    result['visitorid'] = visitorid;
    result['visitorname'] = visitorname;
    return result;
  }
}
