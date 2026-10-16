import '../errors/app_error.dart';

class PagedState<T> {
  final List<T> items;
  final bool isLoading; // 첫 페이지 로딩 (또는 새로고침)
  final bool isLoadingMore; // 다음 페이지 로딩
  final bool hasMore;
  final bool loaded; // 첫 로딩이 한 번이라도 끝났는지
  final AppErrorType? error;

  const PagedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.loaded = false,
    this.error,
  });

  bool get isEmpty => loaded && items.isEmpty && error == null;

  PagedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? loaded,
    AppErrorType? error,
    bool clearError = false,
  }) {
    return PagedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      loaded: loaded ?? this.loaded,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
