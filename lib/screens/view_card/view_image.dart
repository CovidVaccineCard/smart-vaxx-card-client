import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ViewImageScreen extends StatelessWidget {
  final String image, imageName, userId;

  const ViewImageScreen({
    required this.image,
    required this.imageName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          File downloadToFile = File('${appDocDir.path}/$imageName');

          try {
            if (!downloadToFile.existsSync()) {
              await FirebaseStorage.instance
                  .ref('cards/$userId/$imageName')
                  .writeToFile(downloadToFile);
            }
            Share.shareFiles(['${appDocDir.path}/$imageName']);
          } on FirebaseException catch (e) {
            debugPrint(e.stackTrace.toString());
          }
        },
        child: Icon(Icons.share),
      ),
      body: Container(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.network(
            image,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) =>
                Center(child: Text('Failed')),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}