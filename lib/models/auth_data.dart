class AuthData {
  String userId;
  String accessToken;

  AuthData({
    required this.userId,
    required this.accessToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> data) {
    return AuthData(
      userId: data['_id'],
      accessToken: data['accessToken'],
    );
  }

  // AuthData copyWith({String? accessToken, String? refreshToken}) {
  //   return AuthData(
  //       userId: userId,
  //       accessToken: accessToken ?? this.accessToken,
  //       refreshToken: refreshToken ?? this.refreshToken);
  // }

  Map<String, String?> toMap() => {
        '_id': userId,
        'accessToken': accessToken,
      };
}
