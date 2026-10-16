import 'package:flutter/material.dart';
import 'package:flutter_pt/core/widgets/app_button.dart';
import 'package:flutter_pt/features/auth/screens/login_screen.dart';
import 'package:flutter_pt/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('빈 폼으로 로그인하면 이메일/비밀번호 검증 문구가 표시됨', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );

    // 제목/버튼이 같은 문구라 타입으로 찾음
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(find.text('Please enter your email.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
  });
}
