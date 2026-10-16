import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 앱 제목
  ///
  /// In ko, this message translates to:
  /// **'내 앱'**
  String get appTitle;

  /// 사용자 인사말
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요, {name}님'**
  String hello(String name);

  /// 홈 화면 인사말
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요, {nickname}님!'**
  String homeGreeting(String nickname);

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get search;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @settingsLanguage.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정 따름'**
  String get languageSystem;

  /// No description provided for @darkmode.
  ///
  /// In ko, this message translates to:
  /// **'다크모드'**
  String get darkmode;

  /// No description provided for @setting.
  ///
  /// In ko, this message translates to:
  /// **'세팅'**
  String get setting;

  /// No description provided for @profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profile;

  /// No description provided for @email.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// No description provided for @nickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get nickname;

  /// No description provided for @sign_in.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get sign_in;

  /// No description provided for @sign_up.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get sign_up;

  /// No description provided for @loginFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인 실패'**
  String get loginFailed;

  /// No description provided for @loginWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글로 로그인'**
  String get loginWithGoogle;

  /// No description provided for @loginAppleFailed.
  ///
  /// In ko, this message translates to:
  /// **'애플 로그인 실패'**
  String get loginAppleFailed;

  /// No description provided for @loginWithApple.
  ///
  /// In ko, this message translates to:
  /// **'Apple로 로그인'**
  String get loginWithApple;

  /// No description provided for @validationEmailRequired.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식이 아니에요.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 {min}자 이상이어야 해요.'**
  String validationPasswordMinLength(int min);

  /// No description provided for @validationPasswordSpecialChar.
  ///
  /// In ko, this message translates to:
  /// **'특수문자를 1개 이상 포함해주세요.'**
  String get validationPasswordSpecialChar;

  /// No description provided for @validationPasswordConfirmRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 한 번 더 입력해주세요.'**
  String get validationPasswordConfirmRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않아요.'**
  String get validationPasswordMismatch;

  /// No description provided for @validationNicknameRequired.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력해주세요.'**
  String get validationNicknameRequired;

  /// No description provided for @validationNicknameMinLength.
  ///
  /// In ko, this message translates to:
  /// **'닉네임은 {min}자 이상이어야 해요.'**
  String validationNicknameMinLength(int min);

  /// No description provided for @signupPasswordConfirm.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get signupPasswordConfirm;

  /// No description provided for @signupHaveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있어요? 로그인'**
  String get signupHaveAccount;

  /// No description provided for @notificationsTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In ko, this message translates to:
  /// **'전체 읽음'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림이 없어요'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyDescription.
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 오면 여기에 표시돼요'**
  String get notificationsEmptyDescription;

  /// No description provided for @notificationsAllLoaded.
  ///
  /// In ko, this message translates to:
  /// **'모든 알림을 불러왔어요'**
  String get notificationsAllLoaded;

  /// No description provided for @onboardingSkip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get onboardingStart;

  /// No description provided for @onboardingTitle1.
  ///
  /// In ko, this message translates to:
  /// **'환영합니다'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In ko, this message translates to:
  /// **'앱을 시작하기 전에\n몇 가지를 소개할게요.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In ko, this message translates to:
  /// **'쉽고 빠르게'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In ko, this message translates to:
  /// **'간편하게 시작하고\n필요한 것을 바로 찾아보세요.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In ko, this message translates to:
  /// **'지금 시작하세요'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In ko, this message translates to:
  /// **'모든 준비가 됐어요.\n지금 바로 시작해볼까요?'**
  String get onboardingDescription3;

  /// 프로필탭 유저 이메일
  ///
  /// In ko, this message translates to:
  /// **'이메일: {email}'**
  String profileEmail(String email);

  /// 프로필탭 유저 닉네임
  ///
  /// In ko, this message translates to:
  /// **'닉네임: {nickname}'**
  String profileNickname(String nickname);

  /// No description provided for @profileEmailCopied.
  ///
  /// In ko, this message translates to:
  /// **'이메일이 복사되었어요'**
  String get profileEmailCopied;

  /// No description provided for @profileNewNickname.
  ///
  /// In ko, this message translates to:
  /// **'새 닉네임'**
  String get profileNewNickname;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 실패: {error}'**
  String profileUpdateFailed(String error);

  /// No description provided for @searchRecentEmpty.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어가 없어요'**
  String get searchRecentEmpty;

  /// No description provided for @searchRecentTitle.
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어'**
  String get searchRecentTitle;

  /// No description provided for @clearAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get clearAll;

  /// No description provided for @searchNoResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없어요'**
  String get searchNoResults;

  /// No description provided for @termsTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 동의'**
  String get termsTitle;

  /// No description provided for @termsIntro.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용을 위해\n아래 약관에 동의해주세요.'**
  String get termsIntro;

  /// No description provided for @termsAgreeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 동의'**
  String get termsAgreeAll;

  /// No description provided for @termsServiceAgree.
  ///
  /// In ko, this message translates to:
  /// **'이용약관 동의 (필수)'**
  String get termsServiceAgree;

  /// No description provided for @termsPrivacyAgree.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침 동의 (필수)'**
  String get termsPrivacyAgree;

  /// No description provided for @termsView.
  ///
  /// In ko, this message translates to:
  /// **'보기'**
  String get termsView;

  /// No description provided for @termsAgreeAndStart.
  ///
  /// In ko, this message translates to:
  /// **'동의하고 시작하기'**
  String get termsAgreeAndStart;

  /// No description provided for @termsSignupFailed.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 실패'**
  String get termsSignupFailed;

  /// No description provided for @termsErrorOccurred.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했어요: {error}'**
  String termsErrorOccurred(String error);

  /// No description provided for @settingsProfileImage.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지'**
  String get settingsProfileImage;

  /// No description provided for @settingsPickFromGallery.
  ///
  /// In ko, this message translates to:
  /// **'갤러리에서 선택'**
  String get settingsPickFromGallery;

  /// No description provided for @settingsDeleteImage.
  ///
  /// In ko, this message translates to:
  /// **'이미지 삭제'**
  String get settingsDeleteImage;

  /// No description provided for @settingsTapToChangeImage.
  ///
  /// In ko, this message translates to:
  /// **'탭하여 이미지 변경'**
  String get settingsTapToChangeImage;

  /// No description provided for @settingsPush.
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림'**
  String get settingsPush;

  /// No description provided for @settingsPushDescription.
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림을 받아요'**
  String get settingsPushDescription;

  /// No description provided for @settingsMarketing.
  ///
  /// In ko, this message translates to:
  /// **'마케팅 알림'**
  String get settingsMarketing;

  /// No description provided for @settingsMarketingDescription.
  ///
  /// In ko, this message translates to:
  /// **'혜택 및 이벤트 소식을 받아요'**
  String get settingsMarketingDescription;

  /// No description provided for @settingsReview.
  ///
  /// In ko, this message translates to:
  /// **'리뷰 남기기'**
  String get settingsReview;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In ko, this message translates to:
  /// **'회원탈퇴'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전 {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In ko, this message translates to:
  /// **'정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없어요.'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountAction.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴하기'**
  String get settingsDeleteAccountAction;

  /// No description provided for @settingsDeleteAccountFailed.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴 실패'**
  String get settingsDeleteAccountFailed;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In ko, this message translates to:
  /// **'이메일 또는 비밀번호가 올바르지 않아요.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 이메일이에요.'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In ko, this message translates to:
  /// **'이메일 인증이 완료되지 않았어요.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorAccountDeleted.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴한 계정이에요.'**
  String get errorAccountDeleted;

  /// No description provided for @errorNetwork.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해주세요.'**
  String get errorNetwork;

  /// No description provided for @errorWeakPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 너무 약해요.'**
  String get errorWeakPassword;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In ko, this message translates to:
  /// **'요청이 너무 많아요. 잠시 후 다시 시도해주세요.'**
  String get errorTooManyRequests;

  /// No description provided for @errorUnknown.
  ///
  /// In ko, this message translates to:
  /// **'문제가 발생했어요. 잠시 후 다시 시도해주세요.'**
  String get errorUnknown;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get commonRetry;

  /// No description provided for @commonErrorTitle.
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했어요'**
  String get commonErrorTitle;

  /// No description provided for @commonErrorDescription.
  ///
  /// In ko, this message translates to:
  /// **'잠시 후 다시 시도해주세요'**
  String get commonErrorDescription;

  /// No description provided for @commonEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'데이터가 없어요'**
  String get commonEmptyTitle;

  /// No description provided for @commonOffline.
  ///
  /// In ko, this message translates to:
  /// **'인터넷 연결이 없어요'**
  String get commonOffline;

  /// No description provided for @navHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get navSettings;

  /// No description provided for @timeJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}분 전'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}시간 전'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}일 전'**
  String timeDaysAgo(int count);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}주 전'**
  String timeWeeksAgo(int count);

  /// No description provided for @timeMonthsAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}개월 전'**
  String timeMonthsAgo(int count);

  /// No description provided for @timeYearsAgo.
  ///
  /// In ko, this message translates to:
  /// **'{count}년 전'**
  String timeYearsAgo(int count);

  /// No description provided for @timeToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get timeToday;

  /// No description provided for @timeYesterday.
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get timeYesterday;

  /// No description provided for @commonCopied.
  ///
  /// In ko, this message translates to:
  /// **'복사되었어요'**
  String get commonCopied;

  /// No description provided for @commonLinkOpenFailed.
  ///
  /// In ko, this message translates to:
  /// **'링크를 열 수 없어요'**
  String get commonLinkOpenFailed;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 필요'**
  String get forceUpdateTitle;

  /// No description provided for @forceUpdateContent.
  ///
  /// In ko, this message translates to:
  /// **'새로운 버전이 출시되었어요.\n계속 사용하려면 업데이트해주세요.'**
  String get forceUpdateContent;

  /// No description provided for @forceUpdateAction.
  ///
  /// In ko, this message translates to:
  /// **'업데이트'**
  String get forceUpdateAction;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 잊으셨나요?'**
  String get forgotPasswordLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 찾기'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In ko, this message translates to:
  /// **'가입한 이메일을 입력하면\n비밀번호 재설정 링크를 보내드려요.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In ko, this message translates to:
  /// **'재설정 메일 보내기'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In ko, this message translates to:
  /// **'가입된 이메일이라면 재설정 링크를 보냈어요.\n메일함을 확인해주세요.'**
  String get forgotPasswordSent;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 설정'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordNew.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호'**
  String get resetPasswordNew;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 변경되었어요'**
  String get resetPasswordSuccess;

  /// No description provided for @notifPermissionTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림을 켤까요?'**
  String get notifPermissionTitle;

  /// No description provided for @notifPermissionDescription.
  ///
  /// In ko, this message translates to:
  /// **'새로운 소식과 중요한 알림을\n놓치지 않도록 알려드려요.'**
  String get notifPermissionDescription;

  /// No description provided for @notifPermissionAllow.
  ///
  /// In ko, this message translates to:
  /// **'알림 켜기'**
  String get notifPermissionAllow;

  /// No description provided for @notifPermissionLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get notifPermissionLater;

  /// No description provided for @notifPermissionDeniedTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림이 꺼져 있어요'**
  String get notifPermissionDeniedTitle;

  /// No description provided for @notifPermissionDeniedContent.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정에서 알림 권한을 허용해야\n알림을 받을 수 있어요.'**
  String get notifPermissionDeniedContent;

  /// No description provided for @notifPermissionOpenSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정 열기'**
  String get notifPermissionOpenSettings;

  /// No description provided for @settingsPushOsOff.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정에서 알림이 꺼져 있어요'**
  String get settingsPushOsOff;

  /// No description provided for @errorLinkExpired.
  ///
  /// In ko, this message translates to:
  /// **'링크가 만료되었어요. 다시 요청해주세요.'**
  String get errorLinkExpired;

  /// No description provided for @permAllow.
  ///
  /// In ko, this message translates to:
  /// **'허용하기'**
  String get permAllow;

  /// No description provided for @permLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get permLater;

  /// No description provided for @permDeniedTitle.
  ///
  /// In ko, this message translates to:
  /// **'권한이 필요해요'**
  String get permDeniedTitle;

  /// No description provided for @permDeniedContent.
  ///
  /// In ko, this message translates to:
  /// **'기기 설정에서 권한을 허용해야\n이 기능을 사용할 수 있어요.'**
  String get permDeniedContent;

  /// No description provided for @permOpenSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정 열기'**
  String get permOpenSettings;

  /// No description provided for @permCameraTitle.
  ///
  /// In ko, this message translates to:
  /// **'카메라 접근이 필요해요'**
  String get permCameraTitle;

  /// No description provided for @permCameraDescription.
  ///
  /// In ko, this message translates to:
  /// **'사진을 촬영하려면\n카메라 권한이 필요해요.'**
  String get permCameraDescription;

  /// No description provided for @permPhotosTitle.
  ///
  /// In ko, this message translates to:
  /// **'사진 접근이 필요해요'**
  String get permPhotosTitle;

  /// No description provided for @permPhotosDescription.
  ///
  /// In ko, this message translates to:
  /// **'사진을 선택하려면\n사진 접근 권한이 필요해요.'**
  String get permPhotosDescription;

  /// No description provided for @permLocationTitle.
  ///
  /// In ko, this message translates to:
  /// **'위치 접근이 필요해요'**
  String get permLocationTitle;

  /// No description provided for @permLocationDescription.
  ///
  /// In ko, this message translates to:
  /// **'내 주변 정보를 보여드리려면\n위치 권한이 필요해요.'**
  String get permLocationDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
