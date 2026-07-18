import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // 호출 스택 몇 줄 보여줄지
    errorMethodCount: 8, // 에러 시 스택 몇 줄
    lineLength: 120,
    colors: true,
    printEmojis: true, // 🐛 💡 ⚠️ 🚨 이모지 표시
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
