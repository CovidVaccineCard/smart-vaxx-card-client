import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DisplayImage extends StatelessWidget {
  DisplayImage({required this.image, required this.onImageChange});

  final File? image;
  final Function(File? file) onImageChange;
  final double height = 150, width = 150;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      var tmpImage = File(pickedFile.path);
      await _cropImage(tmpImage);
    } else {
      print('No image selected.');
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var tmpImage = File(pickedFile.path);
      await _cropImage(tmpImage);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _cropImage(File? image) async {
    if (image != null) {
      var cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.purple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      onImageChange(cropped ?? image);
    }
  }

  Widget _buildOption(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 50,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isDismissible: true,
            context: context,
            builder: (ctx) {
              return SizedBox(
                height: 150,
                child: Material(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await getImageCamera();
                          Navigator.pop(ctx);
                        },
                        child: _buildOption(Icons.camera, 'camera'),
                      ),
                      InkWell(
                        onTap: () async {
                          await getImageGallery();
                          Navigator.pop(ctx);
                        },
                        child: _buildOption(Icons.photo, 'gallery'),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: image == null
          ? Image.asset(
              'images/placeholder.png',
              height: height,
              width: width,
            )
          : Image.file(
              image!,
              height: height,
              width: width,
              fit: BoxFit.contain,
            ),
    );
  }
}
