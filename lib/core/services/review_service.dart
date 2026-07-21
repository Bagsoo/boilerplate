import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logger.dart';

class ReviewService {
  final _inAppReview = InAppReview.instance;

  // SP 키
  static const _keyAppOpenCount = 'app_open_count';
  static const _keyLastReviewDate = 'last_review_date';
  static const _keyHasReviewed = 'has_reviewed';

  // ① 앱 실행 횟수 증가 + 조건 충족 시 리뷰 요청
  Future<void> checkAndRequestReview() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 이미 리뷰했으면 스킵
      final hasReviewed = prefs.getBool(_keyHasReviewed) ?? false;
      if (hasReviewed) return;

      // 마지막 리뷰 요청 후 30일 지났는지 확인
      final lastReviewDate = prefs.getString(_keyLastReviewDate);
      if (lastReviewDate != null) {
        final lastDate = DateTime.parse(lastReviewDate);
        final daysSinceLastReview = DateTime.now().difference(lastDate).inDays;
        if (daysSinceLastReview < 30) return; // 30일 안 지났으면 스킵
      }

      // 앱 실행 횟수 증가
      final openCount = (prefs.getInt(_keyAppOpenCount) ?? 0) + 1;
      await prefs.setInt(_keyAppOpenCount, openCount);

      // ② 조건: 5번 이상 실행했을 때 리뷰 요청
      if (openCount >= 5) {
        await _requestReview(prefs);
      }
    } catch (e) {
      logger.e('리뷰 요청 실패', error: e);
    }
  }

  Future<void> _requestReview(SharedPreferences prefs) async {
    final isAvailable = await _inAppReview.isAvailable();
    if (!isAvailable) return;

    await _inAppReview.requestReview();

    // 리뷰 요청 날짜 저장
    await prefs.setString(_keyLastReviewDate, DateTime.now().toIso8601String());
  }

  // ③ 수동으로 리뷰 요청 (설정 화면 "리뷰 남기기" 버튼)
  Future<void> openStoreListing() async {
    await _inAppReview.openStoreListing(
      appStoreId: 'XXXXXXXXX', // ← iOS App Store ID로 교체
    );
  }

  // 리뷰 완료 표시 (선택)
  Future<void> markAsReviewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasReviewed, true);
  }
}
