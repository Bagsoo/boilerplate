class ProfileModel {
  final String id;
  final String email;
  final String nickname;
  final String? profileImage;
  final DateTime? termsAgreedAt;
  final DateTime? privacyAgreedAt;
  final bool pushNotificationEnabled;
  final bool marketingNotificationEnabled;

  ProfileModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImage,
    this.termsAgreedAt,
    required this.privacyAgreedAt,
    this.pushNotificationEnabled = true,
    this.marketingNotificationEnabled = false,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, String email) {
    return ProfileModel(
      id: map['id'],
      email: email,
      nickname: map['nickname'],
      profileImage: map['profile_image'],
      termsAgreedAt: map['terms_agreed_at'] != null
          ? DateTime.parse(map['terms_agreed_at'])
          : null,
      privacyAgreedAt: map['privacy_agreed_at'] != null
          ? DateTime.parse(map['privacy_agreed_at'])
          : null,
      pushNotificationEnabled: map['push_notification_enabled'] ?? true,
      marketingNotificationEnabled:
          map['marketing_notification_enabled'] ?? false,
    );
  }

  // 닉네임만 바뀐 새 객체를 만들 때 사용
  ProfileModel copyWith({
    String? nickname,
    String? profileImage,
    DateTime? termsAgreedAt,
    DateTime? privacyAgreedAt,
    bool? pushNotificationEnabled,
    bool? marketingNotificationEnabled,
  }) {
    return ProfileModel(
      id: id,
      email: email,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      termsAgreedAt: termsAgreedAt ?? this.termsAgreedAt,
      privacyAgreedAt: privacyAgreedAt ?? this.privacyAgreedAt,
      pushNotificationEnabled:
          pushNotificationEnabled ?? this.pushNotificationEnabled,
      marketingNotificationEnabled:
          marketingNotificationEnabled ?? this.marketingNotificationEnabled,
    );
  }
}
