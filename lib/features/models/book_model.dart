import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @override
  @HiveField(0)
  final String key;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> authors;

  @HiveField(3)
  final String? coverId;

  @HiveField(4)
  final String? description;

  Book({
    required this.key,
    required this.title,
    required this.authors,
    this.coverId,
    this.description,
  });

  String get coverUrl => coverId != null && coverId != "No Cover"
      ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
      : 'https://via.placeholder.com/150x200?text=No+Cover';

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      authors: (json['author_name'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coverId: json['cover_i']?.toString(),
      description:
          json['description']?.toString() ?? 'No description available',
    );
  }
}
