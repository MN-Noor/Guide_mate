import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Future<void> uploadVideo(File videoFile, String location) async {
  try {
    // Create a unique file name for the video
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Upload video to Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('videos/$location/$fileName')
        .putFile(videoFile);

    // Wait for the upload to complete
    TaskSnapshot snapshot = await uploadTask;

    // Get the download URL
    String downloadURL = await snapshot.ref.getDownloadURL();

    // Store the video metadata in Firestore
    await FirebaseFirestore.instance.collection('videos').add({
      'location': location,
      'fileName': fileName,
      'downloadURL': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error uploading video: $e');
  }
}
