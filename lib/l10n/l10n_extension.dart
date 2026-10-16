// lib/l10n/l10n_extension.dart
import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
