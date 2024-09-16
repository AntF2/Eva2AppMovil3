import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GridView con Hero Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GridViewExample(),
    );
  }
}

class GridViewExample extends StatefulWidget {
  const GridViewExample({super.key});

  @override
  GridViewExampleState createState() => GridViewExampleState();
}

class GridViewExampleState extends State<GridViewExample> {
  List<String> imagePaths = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.png',
    'assets/images1.jpeg',
  ];

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final file = result.files.first;
        if (file.bytes != null) {
          imagePaths.add('data:image/${file.extension};base64,${base64Encode(file.bytes!)}');
        } else if (file.path != null) {
          imagePaths.add(file.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView con Hero Animation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            final imagePath = imagePaths[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePreviewScreen(imagePath: imagePath),
                  ),
                );
              },
              child: Hero(
                tag: imagePath,
                child: imagePath.startsWith('data:image/')
                    ? Image.memory(
                        base64Decode(imagePath.split(',').last),
                        fit: BoxFit.cover,
                      )
                    : imagePath.startsWith('assets/')
                        ? Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la imagen'),
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: imagePath.startsWith('data:image/')
              ? Image.memory(
                  base64Decode(imagePath.split(',').last),
                )
              : imagePath.startsWith('assets/')
                  ? Image.asset(imagePath)
                  : Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
