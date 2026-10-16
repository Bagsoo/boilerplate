## 실행 방법
# 개발
flutter run -t lib/main_dev.dart

# 프로덕션
flutter run -t lib/main_prod.dart

# 빌드
flutter build apk -t lib/main_prod.dart
flutter build appbundle --release -t lib/main_prod.dart
flutter build ipa -t lib/main_prod.dart

# 필요한 것
1. .env, .env.example, .env.dev, .env.prod 필요
2. google-services.json 없이도 dev 실행 가능(Firebase 초기화는 실패해도 앱 동작)
3. Android 릴리스 서명 가이드(아직 없음)
4. Edge Function 코드 저장소에 포함되어 있는지 확인 필요.


# 현재 완료된 보일러플레이트
✅ 인증
  - 이메일 로그인/회원가입
  - 구글 소셜 로그인
  - 애플 소셜 로그인
  - 자동 로그인 (JWT 유지)
  - 로그아웃
  - 토큰 만료 처리
  - 회원탈퇴 (소프트 딜리트)
  - 회원가입 유효성 검사
  - 로그인 화면 유효성 검사
  - 약관 동의
✅ 라우팅
  - go_router
  - 바텀 네비게이션 (StatefulShellRoute)
  - 인증 상태에 따른 redirect
  - 딥링크
✅ 상태관리
  - Riverpod Notifier (auth, profile, theme, notifications)
✅ UI/UX
  - 다크/라이트 모드
  - SP로 테마 저장
  - app_theme.dart 브랜드 컬러
  - shimmer + cached_network_image 공통 위젯
  - 앱 아이콘 + 스플래시 (이미지만 교체하면 됨)
  - DEBUG 배너 제거
  - 설정스크린에 앱 버전 감지 후 노출
  - notifications_screen 페이지(10)네이션
  - 공통위젯 사용법 맨 아래
   - 온보딩 화면 (3페이지, 이미지/문구만 교체)
✅ 기능
  - 프로필 이미지 업로드 (Supabase Storage)
  - FCM 푸시 알림
  - 알림 스크린 + 배지
  - 딥링크 (알림 → 특정 화면)
✅ DB
  - profiles 테이블
  - device_tokens 테이블
  - notifications 테이블
  - 마이그레이션 파일
  - RLS 정책
  - 트리거 (회원가입 시 profiles 자동 생성)
  - 소프트 딜리트 RPC
  - send_notification RPC
  - Edge Function (FCM 푸시 전송)
  - DB Webhook
✅ 보안
  - .env로 키 관리
  - .gitignore 설정
  - RLS 정책
✅ 에러 핸들링
  - logger 패키지
  - FlutterError.onError
  - runZonedGuarded
  - Firebase Crashlytics
✅ 다국어 (gen_l10n + ARB)
  - 한국어 / 영어
  - 설정에서 언어 선택 (시스템 / 한국어 / English)
  - SP로 언어 저장
  - 공통 위젯 기본 문구, 날짜(timeAgo), 에러 문구까지 적용
✅ 에러 메시지 매핑 (AppErrorType)
  - 서버 원문 대신 enum으로 저장, 화면에서 언어별 문구 표시
  - 소셜 로그인 취소는 에러로 표시 안 함
✅ 인터넷 연결 상태 감지
✅ 환경 분리
  - main_dev.dart / main_prod.dart
  - .env.dev / .env.prod
  - AppConfig (isDev/isProd)
  - 개발: Crashlytics 비활성화
  - 프로덕션: Crashlytics 활성화
✅ 검색
  - 앱바 검색바 (홈 탭)
  - 검색 스크린 (자동 포커스)
  - 최근 검색어 (가로 슬라이드, SP 저장, 개별/전체 삭제)
  - 더미 검색 결과 (실제 앱에서 Supabase 쿼리로 교체해야함)
✅ 테스트
✅ 공통 페이지네이션
✅ 권한 요청 유틸

1. 패키지명 변경
2. 앱 이름 변경
3. 스킴 변경
4. .env 파일 설정
5. Supabase 설정 (SQL 실행, Storage, Auth)
6. Firebase 프로젝트 설정
7. 구글 로그인 설정
8. 애플 로그인 설정
9. 푸시 알림 설정
10. 브랜드 컬러 변경
11. 앱 아이콘/스플래시 이미지 교체
12. 온보딩 설정
13. Crashlytics 설정
14. 검색 커스터마이징
15. 아키텍처
16. 알림 실시간 업데이트 아직 안됨 - 아래 방법 설명 있음
17. DateFormatter 사용법
18. ClipboardUtil 사용법
19. KeyboardDismisser 사용법
20. UrlUtil
21. 앱 강제 업데이트
22. SkeletonLoader 스켈레톤 UI
23. 앱 리뷰 요청
24. 알림 설정
25. 다국어 (문자열 추가 / 언어 추가)
26. 에러 메시지 매핑
27. 이미지 압축
28. 테스트
29. 공통 페이지네이션
30. 권한 요청 유틸

##########################################################################
# boiler plate 사용법
1. 패키지명 바꿔주기
  - Android ex>
    dart run change_app_package_name:main com.answer.newapp
    위 명령어 치면 Android 파일들을 대부분 자동으로 변경해줌.
    수동으로 한다면
      android/app/build.gradle.kts 또는 build.gradle의 applcationId
      android/app/src/main/kotlin/...  패키지 폴더명
      MainActivity.kt에서 package com.answer.xxx
  - iOS Bundle ID
    Xcode 있다면 Runner -> Signing & Capabilities -> Bundle Identifier 여기서 기존 번들ID를 새걸로 바꿔준다
    Xcode 없다면
      ios/Runner.xcodeproj/project.pbxproj 에서 PRODUCT_BUNDLE_IDENTIFIER 
      ios/Runner/Info.plist는 일반적으로
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string> 이렇게 되어 있음.
      

2. Flutter 앱이름
  직접 수정:
  - Android: android/app/src/main/AndroidManifest.xml
    android:label="flutter_pt" → 새 앱 이름으로 변경
  - iOS: ios/Runner/Info.plist
    <key>CFBundleDisplayName</key>
    <string>flutter_pt</string> → 새 앱 이름으로 변경

3. Firebase 프로젝트
  - google-services.json
  - GoogleService-Info.plist
##########################################################################

## 스킴 변경
딥링크 스킴 `flutterpt`를 새 앱에 맞게 변경해야 해요.

1. android/app/src/main/AndroidManifest.xml
   android:scheme="flutterpt" → 새 스킴으로 변경

2. ios/Runner/Info.plist
   <string>flutterpt</string> → 새 스킴으로 변경

3. .env
   SUPABASE_CALLBACK_SCHEME=flutterpt → 새 스킴으로 변경

4. Supabase Redirect URLs (스킴://app/reset-password). 또한 AuthService.redirectTo 수정 항목(비밀번호 재설정 섹션 2번)은 이제 AppConfig가 .env 스킴을 쓰므로 삭제

## .env 파일 설정
프로젝트 루트에 .env 파일 생성:

SUPABASE_URL=https://xxxxxxxxxxxxxx.supabase.co
SUPABASE_PUBLISHABLE_KEY=eyJhbGci...
SUPABASE_CALLBACK_SCHEME=앱스킴

## Supabase 설정
1. 프로젝트 생성 후 .env에 URL, ANON_KEY 입력
2. SQL Editor에서 순서대로 실행 (모두 필수)
   001_init.sql               profiles, 트리거, Storage 정책
   002_push_notification.sql  device_tokens, notifications, send_notification,
                              register_device_token, delete_user
   003_app_config.sql         강제 업데이트용 app_config
   ※ delete_user가 device_tokens를 참조하므로 002를 빠뜨리면 회원탈퇴 실패
   ※ send_notification은 클라이언트 호출 차단(revoke), 서버/Edge Function에서만 사용
3. Storage → avatars 버킷 생성 (Public bucket ON)
4. Authentication → Providers → Email → Confirm email OFF (개발 시)
5. Authentication → Providers → Google 설정
6. Authentication → Providers → Apple 설정

# Firebase 프로젝트 설정[구글로그인, 푸시알림, crashlytics 각각 적혀있긴함] ##################
1. console.firebase.google.com 접속 → 프로젝트 추가
2. Android 앱 등록
   - 패키지명 입력 (ex. com.example.newapp)
   - SHA-1 입력 (구글 로그인에 필요)
     cd android && ./gradlew signingReport 로 확인
   - google-services.json 다운로드 → android/app/ 에 넣기
3. iOS 앱 등록
   - Bundle ID 입력
   - GoogleService-Info.plist 다운로드 → ios/Runner/ 에 넣기
4. 서비스 계정 키 발급 (푸시 알림용 FIREBASE_SERVICE_ACCOUNT)
   Firebase Console → 프로젝트 설정 → 서비스 계정
   → 새 비공개 키 생성 → JSON 다운로드
5. Crashlytics 활성화
   Firebase Console → Crashlytics → 시작하기 클릭
####################

# 구글 로그인 방법
1. 구글 클라우드 콘솔에서 Android, iOS용 클라이언트 ID 만들기
2. 실무에서는 google-services.json 자체를 .gitignore에 추가하고 CI/CD에서 주입하는 방식
final googleSignIn = GoogleSignIn(); 로 인자가 없으므로 google-services.json과 GoogleService-Info.plist에서 자동으로 읽게됨 => .gitignore에 google-services.json와 GoogleService-Info.plist추가
  google-services.json → android/app/에 넣기
  GoogleService-Info.plist → ios/Runner/에 넣기
3. Andoroid는 클라이언트 ID 설정 시 sha-1 삽입해야함.
5. Supabase 대시보드 → Authentication → Providers → Google
   - Client ID, Client Secret 입력
   - Authorized redirect URI:
     https://xxxxxxxxxxxxxx.supabase.co/auth/v1/callback
##################################################

# 애플 로그인 방법
1. developer.apple.com 접속
    - Indentifiers -> 본인 앱 Bundle ID 클릭 후 Sign In With Apple 체크 -> save
2. Services ID 생성 (supabase 콜백용)
    - Identifiers -> + -> Services IDs
    - Description: 앱 이름
    - Identifier: Bundle ID + .services  // ex. com.example.flutter_pt.service
    - Sign In with Apple 체크 -> Configure 클릭.
        - Primary App ID: 본인 앱 선택
        - Domains: <your-project-ref>.supabase.co
        - Return URLs: https://<your-project-ref>.supabase.co/auth/v1/callback
3. Key 생성
    - keys -> + -> Sign In with Apple 체크
    - configure -> Primary App ID 선택
    - Download -> .p8 파일 저장(한번만 다운로드 가능)
    - Key ID 복사해두기
4. Supabase 대시보드 설정(Authentication → Providers → Apple)
Enable Apple provider → 켜기 ✅
Service ID        → com.example.flutter_pt.service
Apple Team ID     → developer.apple.com 우측 상단 Team ID
Key ID            → 방금 복사한 Key ID
Private Key       → .p8 파일 내용 붙여넣기
5. ios/Runner.xcworkspace 열기
Runner → Signing & Capabilities → + Capability
    - Sign In with Apple 추가
  [Windows/Linux 환경에서는 macOS 환경에서 진행하거나
  CI/CD (GitHub Actions + macOS runner)를 활용하세요.]
6. 패키지 추가 pubspec.yaml
sign_in_with_apple: ^6.1.0
crypto: ^3.0.3 # nonce 생성용
7. Supabase URL을 새 프로젝트 URL로 변경:
  - Domains: 새 프로젝트 supabase URL
  - Return URLs: 새 프로젝트 supabase URL/auth/v1/callback

# 푸시 알림 방법
1. Android는 파이어베이스에서 google-services.json파일 받아서 넣기
2. android/app/build.gradle.kts에서 plugin안에 id("com.google.gms.google-services") 주석 풀기
3. iOS는 GoogleServices-Info.plist 받아서 Runner/에 넣기
4. supabase에 시크릿 키 등록[터미널에 아래처럼]
supabase secrets set FIREBASE_SERVICE_ACCOUNT='{"type":"service_account","project_id":"...전체 JSON 내용...}'
5. supabase functions deploy send-push-notification
6. DB Webhook 설정[Supabase 대시보드 → Database → Webhooks → Create webhook]
Name: on_notification_insert
Table: notifications
Events: INSERT ✅
Type: HTTP Request
URL: https://<프로젝트 ref>.supabase.co/functions/v1/send-push-notification
Headers:
  Authorization: Bearer <service_role_key>
  Content-Type: application/json
+ iOS 추가 설정:
  Xcode → Runner → Signing & Capabilities
  - Push Notifications 추가
  - Background Modes 추가 → Remote notifications 체크

+ Firebase Console → 프로젝트 설정 → 서비스 계정
  → 새 비공개 키 생성 → JSON 다운로드
  → 이게 FIREBASE_SERVICE_ACCOUNT 값

+ supabase/functions/send-push-notification/index.ts의
  project_id가 Firebase 프로젝트 ID와 일치하는지 확인

7. DB Webhook 설정 (푸시 알림)
Supabase 대시보드 → Database → Webhooks → Create webhook

Name: on_notification_insert
Table: public.notifications
Events: INSERT ✅
Type: HTTP Request
URL: https://<your-project-ref>.supabase.co/functions/v1/send-push-notification
Headers:
  Authorization: Bearer <service_role_key>
  Content-Type: application/json

⚠️ service_role_key는 Supabase 대시보드 → Settings → API → service_role 에서 확인
⚠️ 웹훅 설정 안 하면 푸시 알림이 전송되지 않음
#######################################

## 패키지명 변경 시 추가 작업
패키지명 변경 후 아래도 확인:
1. import 경로 일괄 변경
   flutter_pt → 새 패키지명
   (VSCode: Ctrl+Shift+H로 일괄 변경)
2. google-services.json 안의 package_name 확인
3. Firebase Console에서 Android 앱 패키지명 확인

## 브랜드 컬러 변경
lib/core/app_theme.dart에서 수정:
  static const primaryColor = Color(0xFF4F46E5);    // 메인 컬러
  static const secondaryColor = Color(0xFF7C3AED);  // 서브 컬러

변경 후 스플래시/아이콘 배경색도 같이 변경:
  pubspec.yaml → flutter_native_splash → color
  pubspec.yaml → flutter_launcher_icons → adaptive_icon_background

# 앱아이콘 및 스플래시 이미지
1. /assets/icons/app_icon.png 넣기(1024x1024)
2. /assets/splash/splash_logo.png 넣기(1024x1024)
3. 생성 명령어 실행
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# logger 사용법
import 'package:flutter_pt/core/logger.dart'; ← 패키지명 변경 시 같이 변경

// 레벨별 로그
logger.d('디버그: 변수값 확인');       // 🐛 debug
logger.i('정보: 로그인 성공');         // 💡 info
logger.w('경고: 토큰 만료 임박');      // ⚠️ warning
logger.e('에러: 로그인 실패',          // 🚨 error
  error: e,
  stackTrace: st,
);

## 온보딩 #############
assets/onboarding/ 폴더에 이미지 3장 교체:
  - onboarding_1.png
  - onboarding_2.png  
  - onboarding_3.png

lib/features/onboarding/screens/onboarding_screen.dart에서
제목/설명 교체:

final _pages = const [
  OnboardingItem(
    image: 'assets/onboarding/onboarding_1.png',
    title: '여기에 제목',           ← 교체
    description: '여기에 설명',     ← 교체
  ),
  ...
];
// ARB 키(onboardingTitle1~3) 수정 방식으로 교체함

SharedPreferences에 'hasSeenOnboarding' 키로 저장됨.
앱 첫 실행 시 온보딩 → 이후 실행 시 스킵.

## 앱 흐름
Splash
  ↓
온보딩 (첫 실행만)
  ↓
로그인
  ↓
홈

온보딩 초기화 (개발용)
온보딩을 다시 보고 싶을 때:
final prefs = await SharedPreferences.getInstance();
await prefs.remove('hasSeenOnboarding');
온보딩 페이지 늘릴 때 _page 리스트에 OnboardingItem 하나만 추가하고, assets/onboarding/onboarding_4.png 넣으면됨
#####################################

## Crashlytics 설정
Firebase Console → Crashlytics 활성화
별도 설정 없이 firebase_crashlytics 패키지만 있으면 자동 수집
테스트: FirebaseCrashlytics.instance.crash() 호출

## 검색 커스터마이징
lib/features/search/screens/search_screen.dart에서
_dummyData 리스트를 실제 Supabase 쿼리로 교체하면 됨

## 아키텍처 ################################
1. 레이어 구조
Screen (UI)
   ↓
Provider (Notifier) — 상태 관리
   ↓
Repository — 비즈니스 로직
   ↓
Service — Supabase/외부 API 직접 호출

2. Repository 목록
lib/features/auth/repositories/auth_repository.dart
  - signIn / signUp / signOut
  - signInWithGoogle / signInWithApple
  - deleteAccount
  - hasAgreedToTerms

lib/features/profile/repositories/profile_repository.dart
  - getProfile
  - updateNickname
  - uploadAvatar / deleteAvatar
  - saveAgreedAt

lib/features/notifications/repositories/notifications_repository.dart
  - getNotifications (페이지네이션)
  - markAsRead / markAllAsRead
  - sendNotification (RPC)

3. 새 기능 추가 시
Repository에 메서드 추가
   ↓
Provider에서 Repository 호출
   ↓
Screen에서 Provider 호출
###############################################

### 알림 실시간 업데이트
지금 구조는 알림 스크린 진입 시 갱신됨.
실시간이 필요하면 두 가지 방법:
  1. FCM 포그라운드 수신 시 refresh() 호출
     → FcmService에 Ref 주입 필요
     → FcmService(ref).initialize() 로 변경
  2. Supabase Realtime 구독
     → notifications 테이블 변경 감지
     → 복잡도 높음

### ClipboardUtil
import 'package:flutter_pt/core/utils/clipboard_util.dart';

// 복사 + 성공 스낵바 자동 표시
ClipboardUtil.copy(context, '복사할 텍스트');

// 커스텀 메시지
ClipboardUtil.copy(context, profile.email, message: '이메일이 복사되었어요');

### KeyboardDismisser
// 화면 탭하면 키보드 자동으로 내려감
// 텍스트필드 있는 화면 body에 감싸주면 됨

body: KeyboardDismisser(
  child: SingleChildScrollView(...),
),

### UrlUtil
import 'package:flutter_pt/core/utils/url_util.dart';

UrlUtil.launch(context, 'https://example.com');
// 커스텀 에러 메시지
UrlUtil.launch(context, url, errorMessage: '브라우저를 열 수 없어요');

  ## 이용약관 / 개인정보처리방침 URL 교체
  lib/features/auth/screens/terms_screen.dart에서 교체:

  1. 이용약관
  'https://www.google.com'   → 실제 이용약관 URL로 교체

  2. 개인정보처리방침
  'https://www.naver.com'    → 실제 개인정보처리방침 URL로 교체

## 앱 강제 업데이트
Supabase Table Editor → app_config 테이블에서 버전 관리:

min_version_android: 1.0.0   ← 최소 버전 변경 시 강제 업데이트
min_version_ios: 1.0.0

스토어 URL 교체:
lib/core/services/force_update_service.dart에서
_androidStoreUrl → 실제 플레이스토어 URL로 교체
_iosStoreUrl     → 실제 앱스토어 URL로 교체

앱 강제 업데이트가 필요할 때 Supabase Table Editor에서:
  app_config 테이블
  min_version_android → 1.1.0 으로 변경
  min_version_ios     → 1.1.0 으로 변경

### SkeletonLoader (스켈레톤 로딩)
1. 기본 - 너비/높이 커스텀
SkeletonLoader(width: 200, height: 14)

2. 리스트 아이템 (아바타 + 제목 + 부제목)
SkeletonListItem()

3. 카드
SkeletonCard()

4. 프로필 화면
SkeletonProfile()

5. 알림 리스트 (기본 6개)
SkeletonNotificationList()
SkeletonNotificationList(itemCount: 10)

## 앱 리뷰 요청
자동: 앱 5번 실행 시 자동으로 리뷰 팝업 표시
수동: 설정 화면 "리뷰 남기기" 버튼

커스터마이징:
lib/core/services/review_service.dart에서 수정:
  openCount >= 5    ← 실행 횟수 조건 변경
  inDays < 30       ← 재요청 간격 변경 (일)

iOS App Store ID 교체:
  openStoreListing(appStoreId: 'XXXXXXXXX')
  → 실제 App Store ID로 교체

## 알림 설정
설정 화면에서 스위치로 알림 동의 관리:

- 푸시 알림: 일반 알림 수신 여부 (기본값: ON)
- 마케팅 알림: 이벤트/혜택 알림 수신 여부 (기본값: OFF)

알림 타입별 처리:
- type: 'system', 'chat' 등 → push_notification_enabled 체크
- type: 'marketing'         → marketing_notification_enabled 체크

Edge Function에서 자동으로 필터링됨.

## 알림 권한 흐름
로그인 직후 시스템 팝업을 바로 띄우지 않고, 홈 진입 후 사전 설명 바텀시트를 먼저 보여줌.

흐름:
  홈 진입 → NotificationPermissionSheet.showIfNeeded
    → "알림 켜기": 시스템 팝업 → 허용 시 FCM 토큰 저장
    → "나중에": 기록 후 7일 뒤 재요청 (최대 3회)
  설정 > 푸시 알림 스위치 ON
    → OS 권한 영구 거부 상태면 "설정 열기" 안내

파일:
  변경: lib/core/services/notification_permission_service.dart  ← 알림 전용 래퍼 (실제 로직은 permission_service.dart)
  lib/core/widgets/notification_permission_sheet.dart     ← 사전 설명 바텀시트
  lib/core/services/fcm_service.dart                      ← 허용된 경우에만 토큰 저장

필수 설정:
- Android: AndroidManifest에 POST_NOTIFICATIONS 권한 (Android 13+)
- iOS: ios/Podfile post_install에 PERMISSION_NOTIFICATIONS=1 추가
  + Xcode > Push Notifications, Background Modes(Remote notifications)

주의:
- FcmService().initialize()는 권한이 이미 허용된 경우에만 토큰을 저장함
- 로그아웃 시 FcmService.deleteToken()으로 서버 토큰 삭제됨

※ 일반화된 구조(카메라·사진·위치 등)와 재요청 정책 설정은 아래 "권한 요청 유틸" 참고

## 공통 위젯 사용법

1. AppButton
AppButton(label: '확인', onPressed: () {}, isLoading: false)
AppButton(label: '삭제', type: AppButtonType.danger, onPressed: () {})
AppButton(label: '취소', type: AppButtonType.ghost, onPressed: () {})
AppButton(
  label: '로그인',
  isLoading: isLoading,
  onPressed: _signIn,
  icon: Icons.login,
)
AppButton(
  label: '회원탈퇴',
  type: AppButtonType.danger,
  onPressed: _deleteAccount,
)

2. AppTextField
AppTextField(controller: _controller, label: '이메일', validator: _validate)
AppTextField(
  controller: _emailController,
  label: '이메일',
  keyboardType: TextInputType.emailAddress,
  validator: _validateEmail,
  prefixIcon: const Icon(Icons.email_outlined),
)

3. EmptyView
EmptyView(title: '데이터 없음', description: '설명', icon: Icons.inbox)
EmptyView(
  title: '알림이 없어요',
  description: '새로운 알림이 오면 여기에 표시돼요',
  icon: Icons.notifications_none_rounded,
)

4. ErrorView
ErrorView(message: '오류 메시지', onRetry: () {})
ErrorView(
  message: '알림을 불러오지 못했어요',
  onRetry: () => ref.read(notificationsProvider.notifier).loadNotifications(),
)

5. LoadingView
LoadingView(message: '불러오는 중...')

6. ConfirmDialog
final confirm = await ConfirmDialog.show(context,
  title: '삭제', content: '삭제할까요?', isDanger: true);
final confirm = await ConfirmDialog.show(
  context,
  title: '회원탈퇴',
  content: '정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없어요.',
  confirmLabel: '탈퇴하기',
  isDanger: true,
);

7. AppSnackBar
AppSnackBar.show(context, message: '성공!', type: SnackBarType.success)
AppSnackBar.show(context, message: '실패!', type: SnackBarType.error)

8. AppSearchBar
// 홈 앱바에 배치 (터치하면 검색 스크린으로 이동)
AppSearchBar(
  hint: '검색어를 입력하세요',
  onTap: () => context.push('/search'),
)
// 커스텀 힌트
AppSearchBar(
  hint: '상품을 검색해보세요',
  onTap: () => context.push('/search'),
)

8-1. 검색 커스터마이징
lib/features/search/screens/search_screen.dart에서 수정:

// 더미 데이터 → 실제 Supabase 쿼리로 교체
final _dummyData = [
  '플러터', '다트', ...   ← 여기를 실제 검색 로직으로 교체
];

// 최근 검색어 최대 개수 변경
if (_recentSearches.length > 10) {   ← 숫자 변경

9. AppBottomSheet
// 기본 바텀 시트
AppBottomSheet.show(
  context,
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('내용'),
        AppButton(label: '확인', onPressed: () => Navigator.pop(context)),
      ],
    ),
  ),
);

// 옵션 선택 바텀 시트
final result = await AppBottomSheet.showOptions<String>(
  context,
  title: '옵션 제목',
  options: [
    const BottomSheetOption(
      label: '갤러리에서 선택',
      icon: Icons.photo_library_outlined,
      value: 'gallery',
    ),
    const BottomSheetOption(
      label: '삭제',
      icon: Icons.delete_outline,
      value: 'delete',
      isDestructive: true,    // 빨간색으로 표시
    ),
  ],
);

10. PagedListView

## 다국어 (gen_l10n + ARB)
지원 언어: 한국어(ko, 기본/템플릿), English(en)

파일 위치:
  l10n.yaml                       ← 설정 (프로젝트 루트)
  lib/l10n/app_ko.arb             ← 템플릿 (메타데이터는 여기에만)
  lib/l10n/app_en.arb
  lib/l10n/app_localizations*.dart ← 자동 생성 (직접 수정 금지)
  lib/features/settings/providers/locale_provider.dart ← 앱 내 언어 선택

### 문자열 추가하는 법
1. app_ko.arb에 키 추가 (플레이스홀더가 있으면 @키 메타데이터도)
   "login": "로그인",
   "homeGreeting": "안녕하세요, {nickname}님!",
   "@homeGreeting": {
     "placeholders": { "nickname": { "type": "String" } }
   }
2. app_en.arb에 같은 키 추가
   "login": "Login",
   "homeGreeting": "Hello, {nickname}!"
3. flutter gen-l10n
4. 코드에서 사용
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.login)
   Text(l10n.homeGreeting(profile.nickname))
   ** 확장 사용하여 import 'package:flutter_pt/l10n/l10n_extension.dart'; 후에
    Text(context.l10n.login)

주의:
- ARB는 JSON이라 객체는 하나, 항목 사이 쉼표, 마지막 항목 뒤 쉼표 금지
- 모든 언어 파일에 같은 키를 넣을 것
- 문장을 쪼개 붙이지 말고 통째로 넣고 변수는 {name}으로
- 키 이름은 화면+용도 (homeGreeting, settingsLanguage)
- 키 추가 후 빨간 줄이 뜨면 gen-l10n을 안 한 것

### 언어 추가하는 법 (예: 일본어 ja)
1. lib/l10n/app_ja.arb 생성
   { "@@locale": "ja", "login": "ログイン", ... }
   (app_ko.arb의 키를 전부 복사해서 번역)
2. flutter gen-l10n
   → supportedLocales에 자동 반영됨 (main.dart 수정 불필요)
3. 설정 화면 언어 선택에 항목 추가
   lib/features/settings/screens/settings_screen.dart
   - _showLanguageSheet의 options에 추가
     const BottomSheetOption(label: '日本語', icon: Icons.language, value: 'ja')
   - _localeLabel의 switch에 추가
     case 'ja': return '日本語';
4. iOS: ios/Runner/Info.plist의 CFBundleLocalizations에 ja 추가
   <string>ja</string>
5. 번역 누락 확인
   l10n.yaml에 untranslated-messages-file: untranslated.json 추가 후
   gen-l10n 하면 빠진 키 목록이 생성됨

언어 이름(한국어, English, 日本語)은 번역하지 않고 각 언어 자체 표기로 둔다.

### 앱 내 언어 전환 동작
- localeProvider의 상태가 null이면 시스템 언어를 따름
- 선택한 언어는 SharedPreferences('app_locale')에 저장
- main.dart의 MaterialApp.router에 locale: ref.watch(localeProvider) 연결

### 문구 위치 (예전과 달라진 곳)
- 온보딩 제목/설명: onboarding_screen.dart가 아니라 ARB의
  onboardingTitle1~3, onboardingDescription1~3 수정
  페이지 추가 시 ARB 키 2개 + _pages 항목 1개 추가
- 공통 위젯 기본 문구 (ConfirmDialog 확인/취소, EmptyView, ErrorView,
  OfflineBanner, AppSearchBar): ARB의 common..., searchHint 수정
  파라미터를 생략하면 현재 언어의 기본 문구가 나옴
- 강제 업데이트 다이얼로그: ARB의 forceUpdate...
- 서버가 보내는 알림 제목/내용(notifications 테이블)은 번역되지 않음

### DateFormatter 사용법 변경
첫 인자로 context.l10n을 넘김
DateFormatter.timeAgo(context.l10n, dateStr)        // "3분 전" / "3 minutes ago"
DateFormatter.toDate(context.l10n, dateStr)         // 로캘 관례에 맞는 날짜
DateFormatter.toDateTime(context.l10n, dateStr)
DateFormatter.toRelativeDate(context.l10n, dateStr) // "오늘" / "Today"

### 자주 나는 오류
- "getter 'xxx' isn't defined": ARB 추가 후 gen-l10n 미실행
- gen-l10n 실패: ARB JSON 문법 오류 (쉼표, 중괄호 중복)
- "Not a constant expression": context.l10n을 감싼 const 제거
- 새 언어가 안 나옴: @@locale 값과 파일명(app_ja.arb) 일치 여부 확인
- 패키지명 변경 시 flutter_pt 일괄 치환 대상에 l10n import도 포함됨

## 에러 메시지 매핑
서버 원문(영어)이나 한국어 문구를 저장하지 않고 enum으로 저장 →
화면에서 현재 언어의 문구로 변환.

파일:
  lib/core/errors/app_error.dart       ← AppErrorType, AppException, mapToAppError
  lib/core/errors/app_error_l10n.dart  ← AppErrorType.message(context)

흐름:
  Service에서 예외 발생 (AuthException 등)
    ↓
  Notifier: catch (e) → state.copyWith(error: mapToAppError(e))
    ↓
  Screen: error?.message(context)

화면에서 사용:
  import '../../../core/errors/app_error.dart';
  import '../../../core/errors/app_error_l10n.dart';

  final error = ref.read(authProvider).error;
  if (!mounted) return;
  if (error != AppErrorType.userCancelled) {
    AppSnackBar.show(
      context,
      message: error?.message(context) ?? context.l10n.loginFailed,
      type: SnackBarType.error,
    );
  }

화면에서 직접 잡을 때 (Provider가 예외를 던지는 경우):
  } catch (e) {
    AppSnackBar.show(context, message: mapToAppError(e).message(context), ...);
  }

새 에러 타입 추가:
1. AppErrorType enum에 추가
2. mapToAppError에 변환 조건 추가
3. app_error_l10n.dart의 switch에 추가 (빠뜨리면 컴파일 오류로 알려줌)
4. ARB에 error... 키 추가 (ko/en)

서비스에서 직접 던질 때:
  throw const AppException(AppErrorType.accountDeleted);

주의:
- AuthState.error는 AppErrorType? (String 아님)
- 에러를 지울 때는 copyWith(clearError: true)
- 실제 Supabase 에러 코드는 로그로 한 번 찍어서 확인할 것

## 비밀번호 재설정 / 이메일 중복 검사
흐름: 로그인 화면 "비밀번호를 잊으셨나요?" → /forgot-password(메일 발송)
  → 메일 링크 클릭 → flutterpt://app/reset-password 로 앱 열림
  → passwordRecovery 이벤트 → /reset-password(새 비밀번호) → updateUser

### 필수 설정 (새 프로젝트 시작 시 해야 함)
1. Supabase → Authentication → URL Configuration → Redirect URLs에 추가
   <스킴>://app/reset-password   (예: flutterpt://app/reset-password)
   ※ AndroidManifest의 android:host="app"과 호스트까지 일치해야 함
2. AuthService.sendPasswordResetEmail의 redirectTo 값을 새 스킴으로 변경
3. Supabase → Authentication → Providers → Email → Confirm email
   - OFF(개발): 중복 가입 시 user_already_exists 에러 → 자동 매핑
   - ON(운영): 에러 대신 identities 빈 배열 → AuthService.signUp에서 처리함
   운영 배포 전 ON으로 켜고 중복 가입/재설정 메일을 직접 테스트할 것
4. (선택) Authentication → Email Templates → Reset Password 문구 수정

### 참고
- 존재하지 않는 이메일이어도 성공으로 안내함 (계정 열거 방지)
- 중복 이메일은 약관 화면에서 가입 실패 시 가입 화면으로 복귀시킴

### iOS Podfile (macOS에서 처음 빌드할 때)
- Windows에서 만든 프로젝트는 ios/Podfile이 없을 수 있음
  → macOS에서 flutter build ios 하면 자동 생성됨
- 생성된 Podfile의 post_install 안 build_configurations 블록에 추가:
  config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
    '$(inherited)',
    'PERMISSION_NOTIFICATIONS=1',
  ]
- 이 설정이 없으면 iOS에서 알림 권한 요청이 항상 denied로 나옴

## 이미지 선택/압축/업로드
lib/core/utils/image_upload_util.dart
  ImageUploadUtil.pick(maxWidth, maxHeight, quality)     갤러리 (권한 불필요)
  ImageUploadUtil.pickFromCamera(context, ...)           카메라 (권한 확인 포함)
  ImageUploadUtil.upload(image, bucket, path, upsert)    업로드 → public URL
용도별 압축값: 프로필 512, 게시글 1080~1600
프로필: ProfileService.uploadAvatar (avatars 버킷, {userId}/avatar.{ext})
새 이미지 종류: 버킷 생성 + Storage 정책(insert/update/delete/select),
  파일명은 고유하게(timestamp), 여러 장은 pickMultiImage

## 테스트
flutter test            # 전체
flutter test test/core  # 폴더 단위

구성:
  test/core/errors/        mapToAppError 매핑
  test/core/utils/         DateFormatter (en/ko, 경계값)
  test/core/services/      알림 권한 재요청 정책 (7일/3회)
  test/features/settings/  언어 저장/복원
  test/features/auth/      로그인 화면 검증 위젯 테스트

규칙:
- 새 로직(에러 매핑, 정책, 포맷)을 추가하면 같은 폴더에 테스트 추가
- 플랫폼 채널(permission_handler 등)에 직접 의존하는 코드는
  생성자로 주입받게 만들어 테스트 (NotificationPermissionService 참고)
- 시간 의존 로직은 now를 주입
- SharedPreferences는 SharedPreferences.setMockInitialValues 사용

CI: .github/workflows/ci.yml (analyze + test)
  .env 파일은 CI에서 빈 파일로 생성함

## 페이지네이션 공통화
목록 화면(알림, 검색 결과, 게시글 등)은 공통 구조를 재사용함.
스크롤 감지, 첫 로딩, 빈 상태, 에러 재시도, 다음 페이지 로딩, "모두 불러왔어요" 표시를 자동 처리.

파일:
  lib/core/pagination/paged_state.dart      PagedState<T> (상태)
  lib/core/pagination/paged_notifier.dart   PagedNotifier<T> (로직, fetchPage만 구현)
  lib/core/pagination/paged_list_view.dart  PagedListView<T> (화면 위젯)
  예제: lib/features/notifications/ (provider + screen)

### 새 목록 만드는 법 (3단계)

1. Repository에 조회 메서드 추가 (limit + 커서/오프셋)
   Future<List<Map<String, dynamic>>> getPosts({required int limit, String? before}) async {
     var query = _client.from('posts').select();
     if (before != null) query = query.lt('created_at', before);
     final data = await query.order('created_at', ascending: false).limit(limit);
     return List<Map<String, dynamic>>.from(data);
   }

2. Notifier 만들기 (fetchPage만 구현)
   class PostsNotifier extends PagedNotifier<Map<String, dynamic>> {
     late final _repository = ref.read(postsRepositoryProvider);

     @override
     int get pageSize => 20;   // 선택, 기본 10

     @override
     Future<List<Map<String, dynamic>>> fetchPage({
       required int offset,
       required int limit,
       Map<String, dynamic>? last,
     }) {
       return _repository.getPosts(limit: limit, before: last?['created_at'] as String?);
     }
   }

   final postsProvider =
       NotifierProvider<PostsNotifier, PagedState<Map<String, dynamic>>>(PostsNotifier.new);

3. 화면에서 PagedListView 사용
   @override
   void initState() {
     super.initState();
     Future.microtask(() => ref.read(postsProvider.notifier).refresh());
   }

   @override
   Widget build(BuildContext context) {
     final state = ref.watch(postsProvider);
     final notifier = ref.read(postsProvider.notifier);

     return PagedListView<Map<String, dynamic>>(
       state: state,
       onRefresh: notifier.refresh,
       onLoadMore: notifier.loadMore,
       loadingView: const SkeletonCard(),          // 선택 (기본: LoadingView)
       emptyView: EmptyView(title: context.l10n.postsEmpty),
       allLoadedText: context.l10n.postsAllLoaded, // 선택 (기본 문구 있음)
       itemBuilder: (context, post, index) => ListTile(title: Text(post['title'])),
     );
   }

### 제공 기능
- 첫 로딩: loadingView(스켈레톤), 첫 로딩 실패: ErrorView + 재시도
- 빈 목록: emptyView
- 스크롤 하단 200px 근처에서 자동으로 다음 페이지 로드
- 목록이 화면보다 짧아 스크롤이 안 생겨도 다음 페이지를 자동 요청
- 당겨서 새로고침 (RefreshIndicator)
- 다음 페이지 로드 실패 시 하단 "다시 시도" 버튼 (hasMore 유지)
- 중복 호출 방지 (로딩 중에는 loadMore 무시)
- 에러는 AppErrorType으로 변환되어 현재 언어 문구로 표시

### PagedNotifier 메서드
  refresh()                 첫 페이지 로드 / 새로고침
  loadMore()                다음 페이지 (자동 호출됨)
  updateItems((items) => …) 항목 일부 갱신 (읽음 처리, 좋아요 등)
  clear()                   초기화 (로그아웃 시)

### 커서 vs 오프셋
- offset: 지금까지 불러온 개수 (정적인 목록, 검색 결과에 적합)
- last: 마지막 항목 (새 항목이 위에 계속 쌓이는 목록에 적합)
  새 알림/게시글이 생기면 offset 방식은 항목이 중복/누락될 수 있으므로
  created_at 같은 커서(lt)를 권장. 알림이 이 방식 사용.
- 같은 created_at이 페이지 경계에 걸릴 수 있으면 (created_at, id) 복합 커서 사용

### 주의
- pageSize보다 적게 오면 마지막 페이지로 판단함 (hasMore = false)
  서버가 pageSize보다 적게 주는 구조(필터링 등)면 판단 로직 수정 필요
- 로그아웃 시 notifier.clear()로 이전 사용자 데이터 제거
- 상태에 hasMore/isLoadingMore가 포함되어 변경 시 화면이 자동 갱신됨
  (Notifier 필드로 두면 갱신 안 됨)
- 알림 Notifier의 loadNotifications()는 refresh()의 호환용 별칭

### 테스트
test/core/pagination/paged_notifier_test.dart
- 가짜 fetchPage로 첫 페이지 / 마지막 페이지 / 빈 목록 / 중복 호출 방지 / 실패 후 재시도 검증
- 새 PagedNotifier를 만들면 같은 방식으로 테스트 추가

## 권한 요청 유틸
lib/core/services/permission_service.dart   PermissionService / AppPermission
lib/core/widgets/permission_gate.dart       PermissionGate.ensure (사전 설명 → 요청 → 설정 안내)
lib/core/services/notification_permission_service.dart  알림 전용 래퍼 (기존 API 유지)

기능 실행 직전에 호출:
  final ok = await PermissionGate.ensure(context, AppPermission.camera);
  if (!ok) return;
  // 카메라 사용

- 허용됨: 바로 true
- 처음/재요청 가능: 사전 설명 바텀시트 → 시스템 팝업
- 영구 거부: "설정 열기" 다이얼로그 → false
- 이미지 촬영: ImageUploadUtil.pickFromCamera(context)
- 갤러리 선택(image_picker)은 시스템 포토 피커라 권한 불필요
- 알림처럼 앱이 먼저 묻는 권한은 shouldShowPrompt/recordAsked (7일/3회 정책) 사용
- 재요청 정책 변경: PermissionService 생성자의 retryInterval(기본 7일), maxAskCount(기본 3회)

새 권한 추가:
1. AppPermission enum + PermissionService._map에 Permission 매핑
2. permission_gate.dart의 아이콘/제목/설명 switch + ARB 키(ko/en)
3. Android Manifest 권한, iOS Info.plist 문구, Podfile PERMISSION_xxx=1 매크로
   (iOS는 Podfile 매크로가 없으면 항상 denied로 보임)

## 버전/빌드 정보
- 설정 화면 하단: "버전 1.0.0 (빌드번호)" (dev는 " · dev" 추가)
- dev 빌드: 화면 왼쪽 위에 DEV 리본 (AppConfig.isDev)
- 버전/빌드 번호: pubspec.yaml의 version: 1.0.0+3  (+ 뒤가 빌드 번호)
  빌드 시 덮어쓰기: flutter build apk --build-name=1.2.0 --build-number=10
  (스토어에 올릴 때마다 빌드 번호는 반드시 증가해야 함)
- Crashlytics: 환경(env), 버전 키가 리포트에 포함됨