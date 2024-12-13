import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // Handle the selected file
      final filePath = result.files.single.path!;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Image Selected'),
          content: Text('File Path: $filePath'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Picture'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => pickFile(context),
          child: const Text('Select Image'),
        ),
      ),
    );
  }
}
