// client_model.dart
class Client {
  final int id;
  final int localId;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? tel;
  final String? region;
  final String cashingIn;
  final String? sold;
  final String? potential;
  final String? turnover;
  final int? companyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    required this.localId,
    this.fullName,
    this.email,
    this.address,
    this.phone,
    this.tel,
    this.region,
    required this.cashingIn,
    required this.sold,
    required this.potential,
    required this.turnover,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      localId: json['localId'],
      fullName: json['fullName'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      tel: json['tel'],
      region: json['region'],
      cashingIn: json['cashingIn'],
      sold: json['sold'],
      potential: json['potential'],
      turnover: json['turnover'],
      companyId: json['companyId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localId': localId,
      'fullName': fullName,
      'email': email,
      'address': address,
      'phone': phone,
      'tel': tel,
      'region': region,
      'cashingIn': cashingIn,
      'sold': sold,
      'potential': potential,
      'turnover': turnover,
      'companyId': companyId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
