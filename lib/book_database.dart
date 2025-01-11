
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bookinv/book.dart';

Future<void> addBook(Book book) async {
  final response = await Supabase.instance.client
      .from('books')
      .insert(book.toMap())
      .select(); // Gunakan .select() untuk mendapatkan data yang dimasukkan

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


Future<void> updateBookAvailability(Book book) async {
  final response = await Supabase.instance.client
      .from('books')
      .update(book.toMap())
      .eq('id', book.id)
      .select();

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

