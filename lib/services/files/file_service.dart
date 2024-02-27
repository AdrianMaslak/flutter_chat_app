import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String storagePath) async {
    try {
      // reference for location of the file
      var fileRef = _storage.ref().child(storagePath);

      // uploading file
      var uploadTask = await fileRef.putFile(file);

      var fileUrl = await uploadTask.ref.getDownloadURL();
      return fileUrl;
    } catch (e) {
      print("Error uploading file $e");
      return null;
    }
  }
}
