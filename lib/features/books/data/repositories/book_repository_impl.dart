import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../models/book_model.dart';
import '../../domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  static const String _baseUrl = 'https://openlibrary.org';
  final Dio _dio = Dio();

  @override
  Future<List<Book>> searchBooks(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search.json',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': 20, // Number of results per page
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data == null || data['docs'] == null) {
          return [];
        }

        final List<dynamic> docs = data['docs'];
        if (docs.isEmpty) {
          return [];
        }

        return docs.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
