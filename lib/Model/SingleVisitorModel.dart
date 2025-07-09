class VisitorResponse {
  VisitorDataWrapper? data;

  VisitorResponse({this.data});

  VisitorResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? VisitorDataWrapper.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class VisitorDataWrapper {
  VisitorDetailsResponse? visitorDetails;

  VisitorDataWrapper({this.visitorDetails});

  VisitorDataWrapper.fromJson(Map<String, dynamic> json) {
    visitorDetails = json['visitorDetails'] != null
        ? VisitorDetailsResponse.fromJson(json['visitorDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (visitorDetails != null) {
      json['visitorDetails'] = visitorDetails!.toJson();
    }
    return json;
  }
}

class VisitorDetailsResponse {
  String? message;
  bool? success;
  VisitorInfo? data;

  VisitorDetailsResponse({this.message, this.success, this.data});

  VisitorDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? VisitorInfo.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['message'] = message;
    json['success'] = success;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class VisitorInfo {
  String? checkedBy;
  String? createdAt;
  String? idProofImageUrl;
  String? inTime;
  String? meetingPerson;
  String? outTime;
  String? personImageUrl;
  String? phone;
  String? purpose;
  String? updatedAt;
  String? updatedBy;
  int? visitorId;
  String? visitorName;

  VisitorInfo({
    this.checkedBy,
    this.createdAt,
    this.idProofImageUrl,
    this.inTime,
    this.meetingPerson,
    this.outTime,
    this.personImageUrl,
    this.phone,
    this.purpose,
    this.updatedAt,
    this.updatedBy,
    this.visitorId,
    this.visitorName,
  });

  VisitorInfo.fromJson(Map<String, dynamic> json) {
    checkedBy = json['checkedby'];
    createdAt = json['createdat'];
    idProofImageUrl = json['idproofimageurl'];
    inTime = json['intime'];
    meetingPerson = json['meetingperson'];
    outTime = json['outtime'];
    personImageUrl = json['personimageurl'];
    phone = json['phone'];
    purpose = json['purpose'];
    updatedAt = json['updatedat'];
    updatedBy = json['updatedby'];
    visitorId = json['visitorid'];
    visitorName = json['visitorname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['checkedby'] = checkedBy;
    json['createdat'] = createdAt;
    json['idproofimageurl'] = idProofImageUrl;
    json['intime'] = inTime;
    json['meetingperson'] = meetingPerson;
    json['outtime'] = outTime;
    json['personimageurl'] = personImageUrl;
    json['phone'] = phone;
    json['purpose'] = purpose;
    json['updatedat'] = updatedAt;
    json['updatedby'] = updatedBy;
    json['visitorid'] = visitorId;
    json['visitorname'] = visitorName;
    return json;
  }
}
