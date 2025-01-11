// import 'package:uuid/uuid.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final DateTime publishedDate;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.isAvailable,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publishedDate: DateTime.parse(map['published_date']),
      isAvailable: map['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'published_date': publishedDate.toIso8601String(),
      'is_available': isAvailable,
    };
  }
}
