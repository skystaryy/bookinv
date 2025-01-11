import 'package:flutter/material.dart';
import 'book_database.dart';
import 'book.dart';
import 'package:uuid/uuid.dart';

class AddBookScreen extends StatefulWidget {
  final bool isEdit;
  final Book? book;

  const AddBookScreen({
    super.key,
    this.isEdit = false, // Default false jika menambah buku
    this.book,
  });

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    // Jika ini adalah mode edit, isi controller dengan data buku yang akan diedit
    if (widget.isEdit && widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Book' : 'Add New Book'), // Judul berubah sesuai mode
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (_titleController.text.isEmpty ||
                          _authorController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isSaving = true;
                      });

                      try {
                        if (widget.isEdit && widget.book != null) {
                          // Mode edit: update buku yang ada
                          final updatedBook = Book(
                            id: widget.book!.id, // ID tetap sama
                            title: _titleController.text,
                            author: _authorController.text,
                            publishedDate: widget.book!.publishedDate, // Tanggal tetap sama
                            isAvailable: widget.book!.isAvailable, // Status tetap sama
                          );

                          await updateBookAvailability(updatedBook);
                        } else {
                          // Mode tambah buku baru
                          final newBook = Book(
                            id: Uuid().v4(), // ID baru
                            title: _titleController.text,
                            author: _authorController.text,
                            publishedDate: DateTime.now(),
                            isAvailable: true,
                          );

                          await addBook(newBook);
                        }

                        Navigator.pop(context, true); // Kembali ke daftar buku
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      } finally {
                        setState(() {
                          isSaving = false;
                        });
                      }
                    },
              child: isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(widget.isEdit ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
