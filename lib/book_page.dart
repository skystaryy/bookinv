import 'package:bookinv/add_book_screen.dart';
import 'package:bookinv/book_database.dart';
import 'package:flutter/material.dart';
import 'book.dart';
// import 'supabase_service.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});
  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    try {
      final fetchedBooks = await fetchBooks();
      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading books: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Inventory'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('Author: ${book.author}'),
                  trailing: Switch(
                    value: book.isAvailable,
                    onChanged: (value) async {
                      await updateBookAvailability(book.id, value);
                      loadBooks();
                    },
                  ),
                  onLongPress: () async {
                    await deleteBook(book.id);
                    loadBooks();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookScreen(), // Buat screen untuk tambah buku
            ),
          );
          if (result == true) {
            loadBooks(); // Refresh daftar buku setelah berhasil menambah
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
