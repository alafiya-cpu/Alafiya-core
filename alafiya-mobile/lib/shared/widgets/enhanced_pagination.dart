import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';

/// Modern Pagination Controller
class PaginationController extends ChangeNotifier {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final int itemsPerPage;
  
  List<dynamic> _items = [];
  final List<Function> _loadMoreCallbacks = [];

  PaginationController({
    this.itemsPerPage = 20,
  });

  // Getters
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get items => List.unmodifiable(_items);
  bool get isFirstPage => _currentPage == 1;
  bool get isLastPage => _currentPage >= _totalPages;

  // Setters
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setData(List<dynamic> newItems, {int? totalItems, bool append = true}) {
    if (append) {
      _items.addAll(newItems);
    } else {
      _items.clear();
      _items.addAll(newItems);
    }
    
    if (totalItems != null) {
      _totalPages = (totalItems / itemsPerPage).ceil();
      _hasMoreData = _currentPage < _totalPages;
    }
    
    notifyListeners();
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void reset() {
    _currentPage = 1;
    _totalPages = 1;
    _items.clear();
    _hasMoreData = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMoreData) return;
    
    setLoading(true);
    _currentPage++;
    
    for (final callback in _loadMoreCallbacks) {
      await callback(_currentPage);
    }
    
    setLoading(false);
  }

  void addLoadMoreCallback(Function callback) {
    _loadMoreCallbacks.add(callback);
  }

  void removeLoadMoreCallback(Function callback) {
    _loadMoreCallbacks.remove(callback);
  }
}

/// Enhanced Pagination Widget with Infinite Scroll
class EnhancedPagination<T> extends StatefulWidget {
  final PaginationController controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? header;
  final Widget? footer;
  final Widget? emptyState;
  final Widget? loadingIndicator;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final bool enablePullToRefresh;
  final bool enableInfiniteScroll;
  final double? itemExtent;
  final String? scrollDirection;

  const EnhancedPagination({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.header,
    this.footer,
    this.emptyState,
    this.loadingIndicator,
    this.padding,
    this.scrollController,
    this.enablePullToRefresh = true,
    this.enableInfiniteScroll = true,
    this.itemExtent,
    this.scrollDirection,
  });

  @override
  State<EnhancedPagination<T>> createState() => _EnhancedPaginationState<T>();
}

class _EnhancedPaginationState<T> extends State<EnhancedPagination<T>> {
  late ScrollController _scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    
    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!widget.enableInfiniteScroll) return;
    
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.8) {
      widget.controller.loadNextPage();
    }
  }

  Future<void> _onRefresh() async {
    // TODO: Implement pull to refresh
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final items = widget.controller.items;
        final isLoading = widget.controller.isLoading;
        final hasMore = widget.controller.hasMoreData;
        final isEmpty = items.isEmpty && !isLoading;

        if (isEmpty) {
          return widget.emptyState ?? _buildDefaultEmptyState();
        }

        return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: widget.enablePullToRefresh ? _onRefresh : () async {},
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (widget.header != null)
                SliverToBoxAdapter(child: widget.header!),
              
              // Items List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < items.length) {
                      return Padding(
                        padding: widget.padding ?? 
                            const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingM,
                              vertical: AppTheme.spacingXS,
                            ),
                        child: widget.itemBuilder(context, items[index], index),
                      );
                    }
                    
                    // Loading indicator at the end
                    if (isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        child: Center(
                          child: widget.loadingIndicator ?? _buildDefaultLoadingIndicator(),
                        ),
                      );
                    }
                    
                    // End of list indicator
                    if (!hasMore) {
                      return Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        child: Center(
                          child: _buildEndOfListIndicator(),
                        ),
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                  childCount: items.length + (isLoading || !hasMore ? 1 : 0),
                ),
              ),
              
              if (widget.footer != null)
                SliverToBoxAdapter(child: widget.footer!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No data available',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Pull to refresh or check back later',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLoadingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Text(
          'Loading more items...',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEndOfListIndicator() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.successColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 24,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          'You\'ve reached the end',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

/// Modern Page Indicator
class ModernPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int visiblePages;
  final Function(int)? onPageSelect;
  final bool showPageNumbers;

  const ModernPageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.visiblePages = 5,
    this.onPageSelect,
    this.showPageNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = AppTheme.isTablet(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.getCardShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          _buildPageButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1 ? () => onPageSelect?.call(currentPage - 1) : null,
            isEnabled: currentPage > 1,
          ),
          
          // Page Numbers
          Expanded(
            child: Center(
              child: _buildPageNumbers(),
            ),
          ),
          
          // Next Button
          _buildPageButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages ? () => onPageSelect?.call(currentPage + 1) : null,
            isEnabled: currentPage < totalPages,
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEnabled 
            ? AppTheme.primaryColor.withOpacity(0.1)
            : AppTheme.surfaceVariantColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isEnabled 
              ? AppTheme.primaryColor 
              : AppTheme.textDisabledColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPageNumbers() {
    if (!showPageNumbers) {
      return Text(
        'Page $currentPage of $totalPages',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondaryColor,
        ),
      );
    }

    final List<int> pages = [];
    int startPage = (currentPage - (visiblePages / 2)).ceil();
    int endPage = startPage + visiblePages - 1;

    // Adjust start and end pages to fit within total pages
    if (startPage < 1) {
      startPage = 1;
      endPage = math.min(visiblePages, totalPages);
    }

    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = math.max(1, totalPages - visiblePages + 1);
    }

    for (int i = startPage; i <= endPage; i++) {
      pages.add(i);
    }

    return Wrap(
      spacing: AppTheme.spacingXS,
      children: pages.map((page) {
        final isSelected = page == currentPage;
        return GestureDetector(
          onTap: () => onPageSelect?.call(page),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                page.toString(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected 
                      ? Colors.white 
                      : AppTheme.textSecondaryColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Breadcrumb Navigation for Pagination
class PaginationBreadcrumbs extends StatelessWidget {
  final String currentSection;
  final List<String> breadcrumbs;
  final Function(String)? onBreadcrumbTap;

  const PaginationBreadcrumbs({
    super.key,
    required this.currentSection,
    required this.breadcrumbs,
    this.onBreadcrumbTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: breadcrumbs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final breadcrumb = entry.value;
                  final isLast = index == breadcrumbs.length - 1;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index > 0)
                        Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      const SizedBox(width: AppTheme.spacingS),
                      GestureDetector(
                        onTap: isLast ? null : () => onBreadcrumbTap?.call(breadcrumb),
                        child: Text(
                          breadcrumb,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                            color: isLast 
                                ? AppTheme.primaryColor 
                                : AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search and Filter Bar for Pagination
class PaginationSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onSearch;
  final List<Widget>? filters;
  final bool showSearch;
  final bool showFilters;

  const PaginationSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onSearch,
    this.filters,
    this.showSearch = true,
    this.showFilters = true,
  });

  @override
  State<PaginationSearchBar> createState() => _PaginationSearchBarState();
}

class _PaginationSearchBarState extends State<PaginationSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isTablet = AppTheme.isTablet(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.getCardShadow(),
      ),
      child: Column(
        children: [
          if (widget.showSearch)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      widget.onSearch?.call(value);
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onSearch?.call(_searchController.text);
                  },
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? AppTheme.spacingL : AppTheme.spacingM,
                      vertical: AppTheme.spacingM,
                    ),
                  ),
                ),
              ],
            ),
          
          if (widget.showFilters && widget.filters != null && widget.filters!.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingM),
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: widget.filters!,
            ),
          ],
        ],
      ),
    );
  }
}

/// Sort and View Options
class SortAndViewOptions extends StatelessWidget {
  final String? sortBy;
  final List<DropdownMenuItem<String>> sortOptions;
  final Function(String?) onSortChanged;
  final bool showGridView;
  final bool isGridView;
  final Function(bool) onViewChanged;

  const SortAndViewOptions({
    super.key,
    this.sortBy,
    required this.sortOptions,
    required this.onSortChanged,
    required this.showGridView,
    required this.isGridView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sort Dropdown
        Expanded(
          child: DropdownButtonFormField<String>(
            value: sortBy,
            decoration: const InputDecoration(
              labelText: 'Sort by',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
            ),
            items: sortOptions,
            onChanged: onSortChanged,
          ),
        ),
        
        const SizedBox(width: AppTheme.spacingM),
        
        // View Toggle
        if (showGridView)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: isGridView ? null : () => onViewChanged(false),
                  icon: Icon(
                    Icons.list,
                    color: isGridView 
                        ? AppTheme.textSecondaryColor 
                        : AppTheme.primaryColor,
                  ),
                  tooltip: 'List View',
                ),
                IconButton(
                  onPressed: !isGridView ? null : () => onViewChanged(true),
                  icon: Icon(
                    Icons.grid_view,
                    color: !isGridView 
                        ? AppTheme.textSecondaryColor 
                        : AppTheme.primaryColor,
                  ),
                  tooltip: 'Grid View',
                ),
              ],
            ),
          ),
      ],
    );
  }
}