import 'package:equatable/equatable.dart';

import '../../../models/book_model.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class SearchBooksEvent extends BookEvent {
  final String query;

  const SearchBooksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreBooksEvent extends BookEvent {
  const LoadMoreBooksEvent();
}

class ToggleFavoriteEvent extends BookEvent {
  final Book book;

  const ToggleFavoriteEvent(this.book);

  @override
  List<Object?> get props => [book];
}
