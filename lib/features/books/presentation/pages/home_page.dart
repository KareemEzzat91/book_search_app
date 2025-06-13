import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_event.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_state.dart';
import 'package:book_search_app/features/models/book_model.dart';
import 'package:book_search_app/features/books/presentation/widgets/home_header.dart';
import 'package:book_search_app/features/books/presentation/widgets/search_bar.dart'
    as custom_widgets;
import 'package:book_search_app/features/books/presentation/widgets/book_list_view.dart';
import 'package:book_search_app/features/books/presentation/widgets/shimmer_loading_grid.dart';
import 'package:book_search_app/features/books/presentation/widgets/error_state.dart';
import 'package:book_search_app/features/books/presentation/widgets/empty_state.dart';
import 'package:book_search_app/features/books/presentation/widgets/horizontal_book_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<String> popularNow = [
    "15088223",
    "125082",
    "8161099",
    "584701",
    "8408534"
  ];
  List<String> trendingBooks = [
    "15088223",
    "125082",
    "8161099",
    "584701",
    "8408534"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<BookBloc>().add(SearchBooksEvent(query));
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<BookBloc>().add(const SearchBooksEvent(''));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    // Create Book objects for horizontal lists
    final popularBooks = List.generate(
      popularNow.length,
      (index) => Book(
        key: 'key$index',
        title: 'Popular Book $index',
        authors: ['Author $index'],
        coverId: popularNow[index],
        description: '',
      ),
    );
    final trendingBooksList = List.generate(
      trendingBooks.length,
      (index) => Book(
        key: 'trend$index',
        title: 'Trending Book $index',
        authors: ['Author $index'],
        coverId: trendingBooks[index],
        description: '',
      ),
    );

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent * 0.8) {
              context.read<BookBloc>().add(const LoadMoreBooksEvent());
            }
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            HomeHeader(
              fadeAnimation: _fadeAnimation,
              onFavorites: () => context.pushNamed('favorites'),
              onSettings: () => context.pushNamed('settings'),
            ),
            SliverToBoxAdapter(
              child: custom_widgets.SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
                currentText: _searchController.text,
              ),
            ),
            BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return ShimmerLoadingGrid(crossAxisCount: crossAxisCount);
                }
                if (state is BookError) {
                  return SliverFillRemaining(
                    child: ErrorState(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          _onSearchChanged(_searchController.text);
                        }
                      },
                    ),
                  );
                }
                if (state is BookLoaded) {
                  if (state.books.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyState(message: 'noBooksFound'),
                    );
                  }
                  return BookListView(
                    books: state.books,
                    crossAxisCount: crossAxisCount,
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalBookList(
                    reverse: true,
                    title: 'Popular Now',
                    books: popularBooks,
                    onShowAll: () {},
                  ),
                  HorizontalBookList(
                    title: 'Trending Books',
                    books: trendingBooksList,
                    onShowAll: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
