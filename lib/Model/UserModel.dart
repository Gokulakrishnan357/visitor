class UserModel {
  Data? data;

  UserModel({this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Users>? users;

  Data({this.users});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = List<Users>.from(json['users'].map((v) => Users.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? companyname;
  String? createdAt;
  String? email;
  bool? isActive;
  String? passwordhash;
  String? phonenumber;
  int? roleId;
  String? updatedAt;
  int? userId;
  String? username;

  Users({
    this.companyname,
    this.createdAt,
    this.email,
    this.isActive,
    this.passwordhash,
    this.phonenumber,
    this.roleId,
    this.updatedAt,
    this.userId,
    this.username,
  });

  Users.fromJson(Map<String, dynamic> json) {
    companyname = json['companyname'];
    createdAt = json['createdAt'];
    email = json['email'];
    isActive = json['isActive'];
    passwordhash = json['passwordhash'];
    phonenumber = json['phonenumber'];
    roleId = json['roleId'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['companyname'] = companyname;
    data['createdAt'] = createdAt;
    data['email'] = email;
    data['isActive'] = isActive;
    data['passwordhash'] = passwordhash;
    data['phonenumber'] = phonenumber;
    data['roleId'] = roleId;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['username'] = username;
    return data;
  }
}
