import 'package:flutter/material.dart';
import '../errors/app_error_l10n.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../../l10n/l10n_extension.dart';
import 'paged_state.dart';

class PagedListView<T> extends StatefulWidget {
  final PagedState<T> state;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget emptyView;
  final Widget loadingView; // 첫 로딩용 (스켈레톤)
  final String? allLoadedText; // null이면 공용 문구

  const PagedListView({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.itemBuilder,
    required this.emptyView,
    this.loadingView = const LoadingView(),
    this.allLoadedText,
  });

  @override
  State<PagedListView<T>> createState() => _PagedListViewState<T>();
}

class _PagedListViewState<T> extends State<PagedListView<T>> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final p = _controller.position;
    if (p.pixels >= p.maxScrollExtent - 200) widget.onLoadMore();
  }

  // 목록이 화면보다 짧아 스크롤이 생기지 않으면 다음 페이지를 바로 요청
  void _fillIfShort() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final s = widget.state;
      if (s.hasMore &&
          !s.isLoadingMore &&
          s.error == null &&
          _controller.position.maxScrollExtent <= 0) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;

    // 첫 로딩 (아직 데이터 없음)
    if (!s.loaded || (s.isLoading && s.items.isEmpty)) {
      return widget.loadingView;
    }
    // 첫 로딩 실패
    if (s.error != null && s.items.isEmpty) {
      return ErrorView(
        message: s.error!.message(context),
        onRetry: widget.onRefresh,
      );
    }
    if (s.isEmpty) return widget.emptyView;

    _fillIfShort();

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: s.items.length + 1,
        itemBuilder: (context, index) {
          if (index < s.items.length) {
            return widget.itemBuilder(context, s.items[index], index);
          }
          return _footer(context, s);
        },
      ),
    );
  }

  Widget _footer(BuildContext context, PagedState<T> s) {
    if (s.error != null) {
      // 다음 페이지 로드 실패: 탭해서 재시도
      return TextButton(
        onPressed: widget.onLoadMore,
        child: Text(context.l10n.commonRetry),
      );
    }
    if (s.hasMore) {
      return const Padding(padding: EdgeInsets.all(16), child: LoadingView());
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          widget.allLoadedText ?? context.l10n.notificationsAllLoaded,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
