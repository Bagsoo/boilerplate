class VersionUtil {
  // "1.2.3" → [1, 2, 3] 으로 변환 후 비교
  static bool isUpdateRequired({
    required String currentVersion,
    required String minVersion,
  }) {
    final current = _parse(currentVersion);
    final min = _parse(minVersion);

    for (int i = 0; i < 3; i++) {
      if (current[i] < min[i]) return true; // 업데이트 필요
      if (current[i] > min[i]) return false; // 최신 버전
    }
    return false; // 동일 버전
  }

  static List<int> _parse(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }
}
