// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My App';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String homeGreeting(String nickname) {
    return 'Hello, $nickname!';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get search => 'Search';

  @override
  String get logout => 'Log out';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get darkmode => 'Darkmode';

  @override
  String get setting => 'Setting';

  @override
  String get profile => 'Profile';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get nickname => 'Nickname';

  @override
  String get sign_in => 'Sign In';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginWithGoogle => 'Sign in with Google';

  @override
  String get loginAppleFailed => 'Apple sign-in failed';

  @override
  String get loginWithApple => 'Sign in with Apple';

  @override
  String get validationEmailRequired => 'Please enter your email.';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String validationPasswordMinLength(int min) {
    return 'Password must be at least $min characters.';
  }

  @override
  String get validationPasswordSpecialChar =>
      'Please include at least one special character.';

  @override
  String get validationPasswordConfirmRequired =>
      'Please re-enter your password.';

  @override
  String get validationPasswordMismatch => 'Passwords do not match.';

  @override
  String get validationNicknameRequired => 'Please enter a nickname.';

  @override
  String validationNicknameMinLength(int min) {
    return 'Nickname must be at least $min characters.';
  }

  @override
  String get signupPasswordConfirm => 'Confirm password';

  @override
  String get signupHaveAccount => 'Already have an account? Sign in';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyDescription =>
      'New notifications will appear here';

  @override
  String get notificationsAllLoaded => 'You\'re all caught up';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingTitle1 => 'Welcome';

  @override
  String get onboardingDescription1 =>
      'Before you begin,\nlet us show you around.';

  @override
  String get onboardingTitle2 => 'Simple and fast';

  @override
  String get onboardingDescription2 =>
      'Get started easily and\nfind what you need right away.';

  @override
  String get onboardingTitle3 => 'Start now';

  @override
  String get onboardingDescription3 =>
      'You\'re all set.\nReady to get started?';

  @override
  String profileEmail(String email) {
    return 'Email: $email';
  }

  @override
  String profileNickname(String nickname) {
    return 'Nickname: $nickname';
  }

  @override
  String get profileEmailCopied => 'Email copied';

  @override
  String get profileNewNickname => 'New nickname';

  @override
  String profileUpdateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get searchRecentEmpty => 'No recent searches';

  @override
  String get searchRecentTitle => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get termsIntro =>
      'To use the service,\nplease agree to the terms below.';

  @override
  String get termsAgreeAll => 'Agree to all';

  @override
  String get termsServiceAgree => 'I agree to the Terms of Service (required)';

  @override
  String get termsPrivacyAgree => 'I agree to the Privacy Policy (required)';

  @override
  String get termsView => 'View';

  @override
  String get termsAgreeAndStart => 'Agree and get started';

  @override
  String get termsSignupFailed => 'Sign-up failed';

  @override
  String termsErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get settingsProfileImage => 'Profile photo';

  @override
  String get settingsPickFromGallery => 'Choose from gallery';

  @override
  String get settingsDeleteImage => 'Delete photo';

  @override
  String get settingsTapToChangeImage => 'Tap to change photo';

  @override
  String get settingsPush => 'Push notifications';

  @override
  String get settingsPushDescription => 'Receive new notifications';

  @override
  String get settingsMarketing => 'Marketing notifications';

  @override
  String get settingsMarketingDescription => 'Get news about offers and events';

  @override
  String get settingsReview => 'Leave a review';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsDeleteAccountConfirm =>
      'Are you sure you want to delete your account?\nAll data will be deleted and cannot be recovered.';

  @override
  String get settingsDeleteAccountAction => 'Delete';

  @override
  String get settingsDeleteAccountFailed => 'Failed to delete account';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailAlreadyRegistered => 'This email is already in use.';

  @override
  String get errorEmailNotConfirmed => 'Your email has not been verified yet.';

  @override
  String get errorAccountDeleted => 'This account has been deleted.';

  @override
  String get errorNetwork => 'Please check your network connection.';

  @override
  String get errorWeakPassword => 'This password is too weak.';

  @override
  String get errorTooManyRequests =>
      'Too many requests. Please try again later.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again later.';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonErrorDescription => 'Please try again later';

  @override
  String get commonEmptyTitle => 'No data';

  @override
  String get commonOffline => 'No internet connection';

  @override
  String get navHome => 'Home';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String timeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String timeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String timeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String get timeToday => 'Today';

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonLinkOpenFailed => 'Unable to open the link';

  @override
  String get forceUpdateTitle => 'Update required';

  @override
  String get forceUpdateContent =>
      'A new version is available.\nPlease update to continue using the app.';

  @override
  String get forceUpdateAction => 'Update';

  @override
  String get forgotPasswordLink => 'Forgot your password?';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email and we\'ll send\nyou a password reset link.';

  @override
  String get forgotPasswordSend => 'Send reset link';

  @override
  String get forgotPasswordSent =>
      'If this email is registered, we\'ve sent a reset link.\nPlease check your inbox.';

  @override
  String get resetPasswordTitle => 'Set new password';

  @override
  String get resetPasswordNew => 'New password';

  @override
  String get resetPasswordSubmit => 'Change password';

  @override
  String get resetPasswordSuccess => 'Your password has been changed';

  @override
  String get notifPermissionTitle => 'Turn on notifications?';

  @override
  String get notifPermissionDescription =>
      'We\'ll let you know about news and\nimportant updates.';

  @override
  String get notifPermissionAllow => 'Turn on';

  @override
  String get notifPermissionLater => 'Not now';

  @override
  String get notifPermissionDeniedTitle => 'Notifications are off';

  @override
  String get notifPermissionDeniedContent =>
      'Allow notifications in your device settings\nto receive them.';

  @override
  String get notifPermissionOpenSettings => 'Open settings';

  @override
  String get settingsPushOsOff =>
      'Notifications are turned off in device settings';

  @override
  String get errorLinkExpired =>
      'This link has expired. Please request a new one.';

  @override
  String get permAllow => 'Allow';

  @override
  String get permLater => 'Not now';

  @override
  String get permDeniedTitle => 'Permission required';

  @override
  String get permDeniedContent =>
      'Allow this permission in your device settings\nto use this feature.';

  @override
  String get permOpenSettings => 'Open settings';

  @override
  String get permCameraTitle => 'Camera access needed';

  @override
  String get permCameraDescription =>
      'Camera permission is required\nto take photos.';

  @override
  String get permPhotosTitle => 'Photo access needed';

  @override
  String get permPhotosDescription =>
      'Photo access is required\nto choose pictures.';

  @override
  String get permLocationTitle => 'Location access needed';

  @override
  String get permLocationDescription =>
      'Location permission is required\nto show nearby information.';
}
