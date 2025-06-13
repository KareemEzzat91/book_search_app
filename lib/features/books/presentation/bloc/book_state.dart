import 'package:equatable/equatable.dart';

import '../../../models/book_model.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookLoaded extends BookState {
  final List<Book> books;
  final bool isLoadingMore;

  const BookLoaded(this.books, {this.isLoadingMore = false});

  @override
  List<Object?> get props => [books, isLoadingMore];
}
