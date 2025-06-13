import '../../../models/book_model.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query, {int page = 1});
}
