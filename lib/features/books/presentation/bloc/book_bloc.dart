import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../models/book_model.dart';
import '../../domain/repositories/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _bookRepository;
  final Box<Book> favoritesBox;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  String _currentQuery = '';

  BookBloc(this._bookRepository, this.favoritesBox) : super(BookInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreBooksEvent>(_onLoadMoreBooks);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(BookInitial());
      return;
    }

    // Reset pagination when new search is performed
    _currentPage = 1;
    _hasReachedMax = false;
    _currentQuery = event.query;

    emit(BookLoading());
    try {
      final books =
          await _bookRepository.searchBooks(event.query, page: _currentPage);
      if (books.isEmpty) {
        emit(BookLoaded([]));
      } else {
        emit(BookLoaded(books));
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onLoadMoreBooks(
    LoadMoreBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    if (_hasReachedMax || state is! BookLoaded) return;

    final currentState = state as BookLoaded;
    if (currentState.isLoadingMore) return;

    try {
      emit(BookLoaded(
        currentState.books,
        isLoadingMore: true,
      ));

      _currentPage++;
      final newBooks = await _bookRepository.searchBooks(
        _currentQuery,
        page: _currentPage,
      );

      if (newBooks.isEmpty) {
        _hasReachedMax = true;
        emit(BookLoaded(currentState.books));
      } else {
        emit(BookLoaded([...currentState.books, ...newBooks]));
      }
    } catch (e) {
      emit(BookLoaded(currentState.books));
    }
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<BookState> emit) {
    try {
      if (isFavorite(event.book)) {
        favoritesBox.delete(event.book.key);
      } else {
        favoritesBox.put(event.book.key, event.book);
      }

      if (state is BookLoaded) {
        final currentBooks = (state as BookLoaded).books;
        emit(BookLoaded(List.from(currentBooks)));
      }
    } catch (e) {
      if (state is BookLoaded) {
        emit(state);
      }
    }
  }

  bool isFavorite(Book book) {
    try {
      return favoritesBox.containsKey(book.key);
    } catch (e) {
      return false;
    }
  }
}
