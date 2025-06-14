import 'package:flutter/material.dart';
import 'package:book_search_app/features/models/book_model.dart';
import 'package:book_search_app/core/widgets/book_card.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_event.dart';
import 'package:book_search_app/features/books/presentation/bloc/book_state.dart';

class BookListView extends StatelessWidget {
  final List<Book> books;
  final int crossAxisCount;
  const BookListView(
      {super.key, required this.books, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final bookBloc = context.watch<BookBloc>();
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.43,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == books.length) {
              return BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  if (state is BookLoaded && state.isLoadingMore) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }
            final book = books[index];
            return BookCard(
              book: book,
              isFavorite: bookBloc.isFavorite(book),
              onFavoriteToggle: () {
                bookBloc.add(ToggleFavoriteEvent(book));
              },
            );
          },
          childCount: books.length + 1,
        ),
      ),
    );
  }
}
