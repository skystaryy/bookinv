import 'package:flutter/material.dart';
import 'book_database.dart';
import 'book.dart';
import 'package:uuid/uuid.dart';

class AddBookScreen extends StatefulWidget {
  final bool isEdit;
  final Book? book;

  const AddBookScreen({
    super.key,
    this.isEdit = false, // Berikan nilai default
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
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
                    final newBook = Book(
                      id: Uuid().v4(), // Menggunakan UUID sebagai ID unik
                      title: _titleController.text,
                      author: _authorController.text,
                      publishedDate: DateTime.now(),
                      isAvailable: true,
                    );

                    await addBook(newBook);
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
                  : Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
