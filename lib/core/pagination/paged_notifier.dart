import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_error.dart';
import 'paged_state.dart';

abstract class PagedNotifier<T> extends Notifier<PagedState<T>> {
  int get pageSize => 10;

  /// offset: 지금까지 불러온 개수, last: 마지막 항목(커서 방식용, 첫 페이지는 null)
  Future<List<T>> fetchPage({required int offset, required int limit, T? last});

  @override
  PagedState<T> build() => const PagedState();

  /// 첫 페이지 로드 / 새로고침
  Future<void> refresh() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await fetchPage(offset: 0, limit: pageSize);
      state = PagedState<T>(
        items: data,
        hasMore: data.length >= pageSize,
        loaded: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        loaded: true,
        error: mapToAppError(e),
      );
    }
  }

  /// 다음 페이지 (중복 호출/마지막 페이지/에러 상태 방지)
  Future<void> loadMore() async {
    if (!state.loaded ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final data = await fetchPage(
        offset: state.items.length,
        limit: pageSize,
        last: state.items.isEmpty ? null : state.items.last,
      );
      state = state.copyWith(
        items: [...state.items, ...data],
        isLoadingMore: false,
        hasMore: data.length >= pageSize,
      );
    } catch (e) {
      // 실패해도 hasMore는 유지 → 재시도 가능
      state = state.copyWith(isLoadingMore: false, error: mapToAppError(e));
    }
  }

  /// 항목 일부 갱신 (읽음 처리 등)
  void updateItems(List<T> Function(List<T> items) transform) {
    state = state.copyWith(items: transform(state.items));
  }

  void clear() => state = const PagedState();
}
