import 'package:flutter/widgets.dart';
import '../../l10n/l10n_extension.dart';
import 'app_error.dart';

extension AppErrorMessage on AppErrorType {
  String message(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case AppErrorType.invalidCredentials:
        return l10n.errorInvalidCredentials;
      case AppErrorType.emailAlreadyRegistered:
        return l10n.errorEmailAlreadyRegistered;
      case AppErrorType.emailNotConfirmed:
        return l10n.errorEmailNotConfirmed;
      case AppErrorType.accountDeleted:
        return l10n.errorAccountDeleted;
      case AppErrorType.network:
        return l10n.errorNetwork;
      case AppErrorType.weakPassword:
        return l10n.errorWeakPassword;
      case AppErrorType.tooManyRequests:
        return l10n.errorTooManyRequests;
      case AppErrorType.userCancelled:
      case AppErrorType.unknown:
        return l10n.errorUnknown;
      case AppErrorType.linkExpired:
        return l10n.errorLinkExpired;
    }
  }
}
