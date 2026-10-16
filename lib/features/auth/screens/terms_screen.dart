import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_error_l10n.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/utils/url_util.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../features/profile/repositories/profile_repository.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/errors/app_error.dart';

class TermsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> extra;

  const TermsScreen({super.key, required this.extra});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  bool _termsAgreed = false;
  bool _privacyAgreed = false;
  bool _isLoading = false;

  bool get _canProceed => _termsAgreed && _privacyAgreed;
  String get _from => widget.extra['from'] as String;

  Future<void> _saveAgreedAt(String userId) async {
    final repository = ProfileRepository();
    await repository.saveAgreedAt(userId);
  }

  Future<void> _agree() async {
    setState(() => _isLoading = true);

    try {
      if (_from == 'signup') {
        // ① 회원가입 실행
        final success = await ref
            .read(authProvider.notifier)
            .signUp(
              email: widget.extra['email'] as String,
              password: widget.extra['password'] as String,
              nickname: widget.extra['nickname'] as String,
            );

        if (!success) {
          final error = ref.read(authProvider).error;
          if (!mounted) return;
          AppSnackBar.show(
            context,
            message: error?.message(context) ?? context.l10n.termsSignupFailed,
            type: SnackBarType.error,
          );
          if (error == AppErrorType.emailAlreadyRegistered) {
            context.pop(); // 가입 화면으로 복귀
          }
          return;
        }
      }

      // ② 약관 동의 시각 저장 (signup, google 공통)
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await _saveAgreedAt(userId);

      // ③ 프로필 로드 후 홈으로
      await ref.read(profileProvider.notifier).loadProfile();
      await FcmService().initialize();
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      AppSnackBar.show(
        context,
        message: mapToAppError(e).message(context),
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.termsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.termsIntro,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // 전체 동의
            CheckboxListTile(
              value: _termsAgreed && _privacyAgreed,
              onChanged: (value) => setState(() {
                _termsAgreed = value!;
                _privacyAgreed = value;
              }),
              title: Text(
                context.l10n.termsAgreeAll,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            // 이용약관
            CheckboxListTile(
              value: _termsAgreed,
              onChanged: (value) => setState(() => _termsAgreed = value!),
              title: Text(context.l10n.termsServiceAgree),
              secondary: TextButton(
                onPressed: () => UrlUtil.launch(
                  context,
                  'https://www.google.com', // ← 나중에 이용약관 URL로 교체
                ),
                child: Text(context.l10n.termsView),
              ),
            ),

            // 개인정보처리방침
            CheckboxListTile(
              value: _privacyAgreed,
              onChanged: (value) => setState(() => _privacyAgreed = value!),
              title: Text(context.l10n.termsPrivacyAgree),
              secondary: TextButton(
                onPressed: () => UrlUtil.launch(
                  context,
                  'https://www.naver.com', // ← 나중에 개인정보처리방침 URL로 교체
                ),
                child: Text(context.l10n.termsView),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _canProceed && !_isLoading ? _agree : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(context.l10n.termsAgreeAndStart),
            ),
          ],
        ),
      ),
    );
  }
}
