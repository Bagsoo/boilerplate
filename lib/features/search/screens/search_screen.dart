import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _recentSearches = [];
  List<String> _searchResults = [];
  bool _hasSearched = false;

  // 더미 데이터
  final _dummyData = [
    '플러터',
    '다트',
    '리버팟',
    '슈파베이스',
    '파이어베이스',
    '구글',
    '애플',
    '안드로이드',
    '아이폰',
    '앱개발',
    '보일러플레이트',
    '공통위젯',
    '상태관리',
    '라우팅',
    '인증',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    // 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // SP에서 최근 검색어 불러오기
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  // SP에 최근 검색어 저장
  Future<void> _saveRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query); // 중복 제거
    _recentSearches.insert(0, query); // 맨 앞에 추가
    if (_recentSearches.length > 10) {
      // 최대 10개
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    await prefs.setStringList('recentSearches', _recentSearches);
    setState(() {});
  }

  // 최근 검색어 삭제
  Future<void> _removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    await prefs.setStringList('recentSearches', _recentSearches);
    setState(() {});
  }

  // 전체 삭제
  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    setState(() => _recentSearches = []);
  }

  // 검색 실행
  void _search(String query) {
    if (query.trim().isEmpty) return;
    _saveRecentSearch(query.trim());
    setState(() {
      _hasSearched = true;
      _searchResults = _dummyData
          .where((item) => item.contains(query.trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _hasSearched = false;
                        _searchResults = [];
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) => setState(() {}),
          onSubmitted: _search,
          textInputAction: TextInputAction.search,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
      body: _hasSearched ? _buildResults() : _buildRecentSearches(theme),
    );
  }

  // 최근 검색어
  Widget _buildRecentSearches(ThemeData theme) {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text(
          '최근 검색어가 없어요',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 검색어',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              TextButton(
                onPressed: _clearRecentSearches,
                child: Text(
                  '전체 삭제',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 슬라이드 형식 최근 검색어
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // ← 가로 스크롤
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final query = _recentSearches[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    _searchController.text = query;
                    _search(query);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          query,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeRecentSearch(query),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 검색 결과
  Widget _buildResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 12),
            Text(
              '검색 결과가 없어요',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return ListTile(
          leading: Icon(
            Icons.article_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(result),
          subtitle: Text(
            '더미 데이터 — 실제 앱에서 교체하세요',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () {},
        );
      },
    );
  }
}
