import 'package:flutter/material.dart';
import 'package:book_search_app/features/models/book_model.dart';
import 'package:book_search_app/core/widgets/book_card.dart';
import 'package:book_search_app/core/widgets/section_header.dart';

class HorizontalBookList extends StatelessWidget {
  final String title;
  final List<Book> books;
  final VoidCallback? onShowAll;
  final bool reverse ;
  const HorizontalBookList(
      {super.key, required this.title, required this.books, this.onShowAll, this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onShowAll: onShowAll),
        SizedBox(
          height: 220,
          child: ListView.separated(
            reverse: reverse,

            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final book = books[index];
              return SizedBox(
                width: 140,
                child: BookCard(
                  book: book,
                  isFavorite: false,
                  onFavoriteToggle: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
