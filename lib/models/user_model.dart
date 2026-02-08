class UserModel {
  final String id;
  final String matricule;
  final String fullName;
  final String phoneNumber;
  final bool isFemale;
  final DateTime? registerAt;

  UserModel(
      {required this.id,
      required this.matricule,
      required this.fullName,
      required this.phoneNumber,
      required this.isFemale,
      this.registerAt});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      matricule: data['matricule'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      isFemale: data['isFemale'],
      registerAt: data['registerAt'] != null
          ? DateTime.parse(data['registerAt'])
          : null,
      id: data['_id'],
    );
  }
}
