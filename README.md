## 실행 방법
# 개발
flutter run -t lib/main_dev.dart

# 프로덕션
flutter run -t lib/main_prod.dart

# 빌드
flutter build apk -t lib/main_prod.dart
flutter build appbundle --release -t lib/main_prod.dart
flutter build ipa -t lib/main_prod.dart

# 현재 완료된 보일러플레이트
✅ 인증
  - 이메일 로그인/회원가입
  - 구글 소셜 로그인
  - 애플 소셜 로그인
  - 자동 로그인 (JWT 유지)
  - 로그아웃
  - 토큰 만료 처리
  - 회원탈퇴 (소프트 딜리트)
  - 회원가입 유효성 검사(중복 이메일은 아직.)
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
✅ 인터넷 연결 상태 감지

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
12. Crashlytics 설정

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

## .env 파일 설정
프로젝트 루트에 .env 파일 생성:

SUPABASE_URL=https://xxxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_CALLBACK_SCHEME=앱스킴

## Supabase 설정
1. 프로젝트 생성 후 .env에 URL, ANON_KEY 입력
2. SQL Editor에서 supabase/migrations/001_init.sql 실행
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

## Crashlytics 설정
Firebase Console → Crashlytics 활성화
별도 설정 없이 firebase_crashlytics 패키지만 있으면 자동 수집
테스트: FirebaseCrashlytics.instance.crash() 호출

## 공통 위젯

### AppButton
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

### AppTextField
AppTextField(controller: _controller, label: '이메일', validator: _validate)
AppTextField(
  controller: _emailController,
  label: '이메일',
  keyboardType: TextInputType.emailAddress,
  validator: _validateEmail,
  prefixIcon: const Icon(Icons.email_outlined),
)

### EmptyView
EmptyView(title: '데이터 없음', description: '설명', icon: Icons.inbox)
EmptyView(
  title: '알림이 없어요',
  description: '새로운 알림이 오면 여기에 표시돼요',
  icon: Icons.notifications_none_rounded,
)

### ErrorView
ErrorView(message: '오류 메시지', onRetry: () {})
ErrorView(
  message: '알림을 불러오지 못했어요',
  onRetry: () => ref.read(notificationsProvider.notifier).loadNotifications(),
)

### LoadingView
LoadingView(message: '불러오는 중...')

### ConfirmDialog
final confirm = await ConfirmDialog.show(context,
  title: '삭제', content: '삭제할까요?', isDanger: true);
final confirm = await ConfirmDialog.show(
  context,
  title: '회원탈퇴',
  content: '정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없어요.',
  confirmLabel: '탈퇴하기',
  isDanger: true,
);

### AppSnackBar
AppSnackBar.show(context, message: '성공!', type: SnackBarType.success)
AppSnackBar.show(context, message: '실패!', type: SnackBarType.error)