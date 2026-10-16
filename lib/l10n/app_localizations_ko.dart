// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '내 앱';

  @override
  String hello(String name) {
    return '안녕하세요, $name님';
  }

  @override
  String homeGreeting(String nickname) {
    return '안녕하세요, $nickname님!';
  }

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get search => '검색';

  @override
  String get logout => '로그아웃';

  @override
  String get settingsLanguage => '언어';

  @override
  String get languageSystem => '시스템 설정 따름';

  @override
  String get darkmode => '다크모드';

  @override
  String get setting => '세팅';

  @override
  String get profile => '프로필';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get nickname => '닉네임';

  @override
  String get sign_in => '로그인';

  @override
  String get sign_up => '회원가입';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get loginWithGoogle => '구글로 로그인';

  @override
  String get loginAppleFailed => '애플 로그인 실패';

  @override
  String get loginWithApple => 'Apple로 로그인';

  @override
  String get validationEmailRequired => '이메일을 입력해주세요.';

  @override
  String get validationEmailInvalid => '올바른 이메일 형식이 아니에요.';

  @override
  String get validationPasswordRequired => '비밀번호를 입력해주세요.';

  @override
  String validationPasswordMinLength(int min) {
    return '비밀번호는 $min자 이상이어야 해요.';
  }

  @override
  String get validationPasswordSpecialChar => '특수문자를 1개 이상 포함해주세요.';

  @override
  String get validationPasswordConfirmRequired => '비밀번호를 한 번 더 입력해주세요.';

  @override
  String get validationPasswordMismatch => '비밀번호가 일치하지 않아요.';

  @override
  String get validationNicknameRequired => '닉네임을 입력해주세요.';

  @override
  String validationNicknameMinLength(int min) {
    return '닉네임은 $min자 이상이어야 해요.';
  }

  @override
  String get signupPasswordConfirm => '비밀번호 확인';

  @override
  String get signupHaveAccount => '이미 계정이 있어요? 로그인';

  @override
  String get notificationsTitle => '알림';

  @override
  String get notificationsMarkAllRead => '전체 읽음';

  @override
  String get notificationsEmptyTitle => '알림이 없어요';

  @override
  String get notificationsEmptyDescription => '새로운 알림이 오면 여기에 표시돼요';

  @override
  String get notificationsAllLoaded => '모든 알림을 불러왔어요';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingTitle1 => '환영합니다';

  @override
  String get onboardingDescription1 => '앱을 시작하기 전에\n몇 가지를 소개할게요.';

  @override
  String get onboardingTitle2 => '쉽고 빠르게';

  @override
  String get onboardingDescription2 => '간편하게 시작하고\n필요한 것을 바로 찾아보세요.';

  @override
  String get onboardingTitle3 => '지금 시작하세요';

  @override
  String get onboardingDescription3 => '모든 준비가 됐어요.\n지금 바로 시작해볼까요?';

  @override
  String profileEmail(String email) {
    return '이메일: $email';
  }

  @override
  String profileNickname(String nickname) {
    return '닉네임: $nickname';
  }

  @override
  String get profileEmailCopied => '이메일이 복사되었어요';

  @override
  String get profileNewNickname => '새 닉네임';

  @override
  String profileUpdateFailed(String error) {
    return '업데이트 실패: $error';
  }

  @override
  String get searchRecentEmpty => '최근 검색어가 없어요';

  @override
  String get searchRecentTitle => '최근 검색어';

  @override
  String get clearAll => '전체 삭제';

  @override
  String get searchNoResults => '검색 결과가 없어요';

  @override
  String get termsTitle => '서비스 이용 동의';

  @override
  String get termsIntro => '서비스 이용을 위해\n아래 약관에 동의해주세요.';

  @override
  String get termsAgreeAll => '전체 동의';

  @override
  String get termsServiceAgree => '이용약관 동의 (필수)';

  @override
  String get termsPrivacyAgree => '개인정보처리방침 동의 (필수)';

  @override
  String get termsView => '보기';

  @override
  String get termsAgreeAndStart => '동의하고 시작하기';

  @override
  String get termsSignupFailed => '회원가입 실패';

  @override
  String termsErrorOccurred(String error) {
    return '오류가 발생했어요: $error';
  }

  @override
  String get settingsProfileImage => '프로필 이미지';

  @override
  String get settingsPickFromGallery => '갤러리에서 선택';

  @override
  String get settingsDeleteImage => '이미지 삭제';

  @override
  String get settingsTapToChangeImage => '탭하여 이미지 변경';

  @override
  String get settingsPush => '푸시 알림';

  @override
  String get settingsPushDescription => '새로운 알림을 받아요';

  @override
  String get settingsMarketing => '마케팅 알림';

  @override
  String get settingsMarketingDescription => '혜택 및 이벤트 소식을 받아요';

  @override
  String get settingsReview => '리뷰 남기기';

  @override
  String get settingsDeleteAccount => '회원탈퇴';

  @override
  String settingsVersion(String version) {
    return '버전 $version';
  }

  @override
  String get settingsDeleteAccountConfirm =>
      '정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없어요.';

  @override
  String get settingsDeleteAccountAction => '탈퇴하기';

  @override
  String get settingsDeleteAccountFailed => '탈퇴 실패';

  @override
  String get errorInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않아요.';

  @override
  String get errorEmailAlreadyRegistered => '이미 사용 중인 이메일이에요.';

  @override
  String get errorEmailNotConfirmed => '이메일 인증이 완료되지 않았어요.';

  @override
  String get errorAccountDeleted => '탈퇴한 계정이에요.';

  @override
  String get errorNetwork => '네트워크 연결을 확인해주세요.';

  @override
  String get errorWeakPassword => '비밀번호가 너무 약해요.';

  @override
  String get errorTooManyRequests => '요청이 너무 많아요. 잠시 후 다시 시도해주세요.';

  @override
  String get errorUnknown => '문제가 발생했어요. 잠시 후 다시 시도해주세요.';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonErrorTitle => '오류가 발생했어요';

  @override
  String get commonErrorDescription => '잠시 후 다시 시도해주세요';

  @override
  String get commonEmptyTitle => '데이터가 없어요';

  @override
  String get commonOffline => '인터넷 연결이 없어요';

  @override
  String get navHome => '홈';

  @override
  String get navProfile => '프로필';

  @override
  String get navSettings => '설정';

  @override
  String get timeJustNow => '방금 전';

  @override
  String timeMinutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count일 전';
  }

  @override
  String timeWeeksAgo(int count) {
    return '$count주 전';
  }

  @override
  String timeMonthsAgo(int count) {
    return '$count개월 전';
  }

  @override
  String timeYearsAgo(int count) {
    return '$count년 전';
  }

  @override
  String get timeToday => '오늘';

  @override
  String get timeYesterday => '어제';

  @override
  String get commonCopied => '복사되었어요';

  @override
  String get commonLinkOpenFailed => '링크를 열 수 없어요';

  @override
  String get forceUpdateTitle => '업데이트 필요';

  @override
  String get forceUpdateContent => '새로운 버전이 출시되었어요.\n계속 사용하려면 업데이트해주세요.';

  @override
  String get forceUpdateAction => '업데이트';

  @override
  String get forgotPasswordLink => '비밀번호를 잊으셨나요?';

  @override
  String get forgotPasswordTitle => '비밀번호 찾기';

  @override
  String get forgotPasswordDescription => '가입한 이메일을 입력하면\n비밀번호 재설정 링크를 보내드려요.';

  @override
  String get forgotPasswordSend => '재설정 메일 보내기';

  @override
  String get forgotPasswordSent => '가입된 이메일이라면 재설정 링크를 보냈어요.\n메일함을 확인해주세요.';

  @override
  String get resetPasswordTitle => '새 비밀번호 설정';

  @override
  String get resetPasswordNew => '새 비밀번호';

  @override
  String get resetPasswordSubmit => '비밀번호 변경';

  @override
  String get resetPasswordSuccess => '비밀번호가 변경되었어요';

  @override
  String get notifPermissionTitle => '알림을 켤까요?';

  @override
  String get notifPermissionDescription => '새로운 소식과 중요한 알림을\n놓치지 않도록 알려드려요.';

  @override
  String get notifPermissionAllow => '알림 켜기';

  @override
  String get notifPermissionLater => '나중에';

  @override
  String get notifPermissionDeniedTitle => '알림이 꺼져 있어요';

  @override
  String get notifPermissionDeniedContent =>
      '기기 설정에서 알림 권한을 허용해야\n알림을 받을 수 있어요.';

  @override
  String get notifPermissionOpenSettings => '설정 열기';

  @override
  String get settingsPushOsOff => '기기 설정에서 알림이 꺼져 있어요';

  @override
  String get errorLinkExpired => '링크가 만료되었어요. 다시 요청해주세요.';

  @override
  String get permAllow => '허용하기';

  @override
  String get permLater => '나중에';

  @override
  String get permDeniedTitle => '권한이 필요해요';

  @override
  String get permDeniedContent => '기기 설정에서 권한을 허용해야\n이 기능을 사용할 수 있어요.';

  @override
  String get permOpenSettings => '설정 열기';

  @override
  String get permCameraTitle => '카메라 접근이 필요해요';

  @override
  String get permCameraDescription => '사진을 촬영하려면\n카메라 권한이 필요해요.';

  @override
  String get permPhotosTitle => '사진 접근이 필요해요';

  @override
  String get permPhotosDescription => '사진을 선택하려면\n사진 접근 권한이 필요해요.';

  @override
  String get permLocationTitle => '위치 접근이 필요해요';

  @override
  String get permLocationDescription => '내 주변 정보를 보여드리려면\n위치 권한이 필요해요.';
}
