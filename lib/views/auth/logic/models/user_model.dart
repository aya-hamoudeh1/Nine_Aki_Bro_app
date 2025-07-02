class UserDataModel {
  String userId, name, email, phoneNumber, address, ageGroup, skinTone;
  UserDataModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.ageGroup,
    required this.skinTone,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      address: map['address'] ?? '',
      ageGroup: map['age_group'] ?? '',
      skinTone: map['skin_tone'] ?? '',
    );
  }
}
