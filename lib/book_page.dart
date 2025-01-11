import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'book_database.dart';
import 'book.dart';
import 'book_item.dart';

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
                return BookItem(
                  title: book.title,
                  author: book.author,
                  publishedDate: book.publishedDate,
                  onEdit: () async {
                    // Navigasi ke halaman edit buku
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBookScreen(
                          isEdit: true,
                          book: book,
                        ),
                      ),
                    );
                    if (updated == true) {
                      loadBooks(); // Refresh daftar buku setelah edit
                    }
                  },
                  onDelete: () async {
                    // Konfirmasi sebelum menghapus
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text(
                            'Are you sure you want to delete "${book.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await deleteBook(book.id);
                      loadBooks(); // Refresh daftar buku setelah delete
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookScreen(),
            ),
          );
          if (result == true) {
            loadBooks(); // Refresh daftar buku setelah tambah
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
