class UserModel {
  final String uid;
  final String name;
  final String email;
  final String ffUid; // Free Fire UID
  final double walletBalance;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.ffUid,
    this.walletBalance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'ffUid': ffUid,
      'walletBalance': walletBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      ffUid: map['ffUid'] ?? '',
      walletBalance: (map['walletBalance'] ?? 0.0).toDouble(),
    );
  }
}
