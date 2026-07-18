import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/services/fcm_service.dart';

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
    final now = DateTime.now().toUtc().toIso8601String();
    await Supabase.instance.client
        .from('profiles')
        .update({'terms_agreed_at': now, 'privacy_agreed_at': now})
        .eq('id', userId);
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error ?? '회원가입 실패')));
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류가 발생했어요: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('서비스 이용 동의')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '서비스 이용을 위해\n아래 약관에 동의해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // 전체 동의
            CheckboxListTile(
              value: _termsAgreed && _privacyAgreed,
              onChanged: (value) => setState(() {
                _termsAgreed = value!;
                _privacyAgreed = value;
              }),
              title: const Text(
                '전체 동의',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),

            // 이용약관
            CheckboxListTile(
              value: _termsAgreed,
              onChanged: (value) => setState(() => _termsAgreed = value!),
              title: const Text('이용약관 동의 (필수)'),
              secondary: TextButton(
                onPressed: () {}, // TODO 약관 내용 보기
                child: const Text('보기'),
              ),
            ),

            // 개인정보처리방침
            CheckboxListTile(
              value: _privacyAgreed,
              onChanged: (value) => setState(() => _privacyAgreed = value!),
              title: const Text('개인정보처리방침 동의 (필수)'),
              secondary: TextButton(
                onPressed: () {}, // TODO 내용 보기
                child: const Text('보기'),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _canProceed && !_isLoading ? _agree : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('동의하고 시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
