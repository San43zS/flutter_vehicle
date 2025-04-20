import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/design/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage() async {
    if (selectedImage == null) {
      return defaultImageUrl;
    }

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('cars_images/$fileName');
      await ref.putFile(selectedImage!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
      return defaultImageUrl;
    }
  }

  Future<void> addBook() async {
    final imageUrl = await uploadImage();

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка загрузки изображения!')),
      );
      return;
    }

    final carData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'images': [imageUrl],
    };

    try {
      await FirebaseFirestore.instance.collection('cars').add(carData);

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить книгу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Название книги'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Описание книги'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                height: 200,
                child:
                    selectedImage == null
                        ? const Center(child: Text('Выберите изображение'))
                        : Image.file(selectedImage!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addBook,
              child: const Text('Добавить книгу'),
            ),
          ],
        ),
      ),
    );
  }
}
