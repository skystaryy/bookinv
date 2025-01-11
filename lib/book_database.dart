
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bookinv/book.dart';

Future<void> addBook(Book book) async {
  print('addBook function called'); // Tambahkan ini untuk debug

  final response = await Supabase.instance.client
      .from('books')
      .insert(book.toMap())
      .select();

  if (response.isNotEmpty) {
    print('Book added successfully');
  } else {
    throw Exception('Failed to add book');
  }
}


Future<List<Book>> fetchBooks() async {
  final response = await Supabase.instance.client
      .from('books')
      .select(); // Gunakan .select() untuk mengambil data

  if (response.isNotEmpty) {
    return response.map<Book>((book) => Book.fromMap(book)).toList();
  } else {
    throw Exception('Failed to fetch books');
  }
}


Future<void> updateBookAvailability(String id, bool isAvailable) async {
  final response = await Supabase.instance.client
      .from('books')
      .update({'is_available': isAvailable})
      .eq('id', id)
      .select(); // Gunakan .select() untuk mendapatkan data yang diperbarui

  if (response.isNotEmpty) {
    print('Book updated successfully');
  } else {
    throw Exception('Failed to update book');
  }
}


Future<void> deleteBook(String id) async {
  final response = await Supabase.instance.client
      .from('books')
      .delete()
      .eq('id', id)
      .select(); // Gunakan .select() untuk memastikan data telah dihapus

  if (response.isNotEmpty) {
    print('Book deleted successfully');
  } else {
    throw Exception('Failed to delete book');
  }
}

