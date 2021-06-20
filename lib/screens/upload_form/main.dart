import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smart_vaxx_card_client/models/card_details.dart';
import 'package:smart_vaxx_card_client/screens/display_image/main.dart';

enum UploadState {
  IDLE,
  UPLOADING,
  SUCCESS,
  FAILED,
}

class UploadFormScreen extends StatefulWidget {
  final storage = FirebaseStorage.instance;
  final cards = FirebaseFirestore.instance.collection("cards");
  @override
  State<StatefulWidget> createState() => UploadFormScreenState();
}

class UploadFormScreenState extends State<UploadFormScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _centerController = TextEditingController();
  TextEditingController _doseController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String? _date;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;
  late UploadState _uploadState;
  CardDetails? _cardDetails;

  @override
  void initState() {
    super.initState();
    _uploadState = UploadState.IDLE;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _centerController.dispose();
    _doseController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool validateFields() {
    final name = _nameController.text;
    final center = _centerController.text;
    final date = _date;
    final dose = _doseController.text;
    final location = _locationController.text;
    return name.isNotEmpty &&
        center.isNotEmpty &&
        date != null &&
        date.isNotEmpty &&
        dose.isNotEmpty &&
        location.isNotEmpty &&
        _image != null;
  }

  final snackBar = SnackBar(
    content: Text("Please fill all required fields"),
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {},
    ),
  );

  Widget _buildUpload() {
    return Center(
      child: DisplayImage(
        image: _image,
        onImageChange: (img) {
          setState(() {
            _image = img;
          });
        },
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildName() {
    return _buildInput('Name', _nameController);
  }

  Widget _buildCenter() {
    return _buildInput('Center of Vaccination', _centerController);
  }

  Widget _buildlocation() {
    return _buildInput('Location of Center', _locationController);
  }

  Widget _buildDate() {
    final date = _date;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (newDate == null) return;
          setState(() {
            _date = newDate.toString().substring(0, 10);
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.transparent,
              border: Border.all(
                width: 1,
                color: Colors.grey,
              )),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Date: ' + (date != null ? date : 'Not selected'),
            style: TextStyle(
              backgroundColor: Colors.transparent,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDose() {
    return _buildInput('Dose', _doseController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Add card"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildCenter(),
                _buildDose(),
                _buildlocation(),
                _buildDate(),
                SizedBox(height: 20),
                _buildUpload(),
                SizedBox(height: 30),
                _uploadState == UploadState.UPLOADING
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () async {
                          if (validateFields()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _uploadState = UploadState.UPLOADING;
                            });

                            final name = _nameController.text;
                            final center = _centerController.text;
                            final date = _date;
                            final dose = _doseController.text;
                            final location = _locationController.text;
                            final dateTime =
                                '${DateTime.now().millisecondsSinceEpoch}';
                            final randomNum = '${Random().nextInt(200)}';
                            final uId =
                                '${FirebaseAuth.instance.currentUser!.uid}';
                            final fileName = '$uId-$dateTime-$randomNum.jpg';
                            try {
                              await widget.storage
                                  .ref("cards/$uId/$fileName")
                                  .putFile(
                                      _image!,
                                      SettableMetadata(
                                        customMetadata: {
                                          'userId': uId,
                                        },
                                      ));
                              final image = await widget.storage
                                  .ref("cards/$uId/$fileName")
                                  .getDownloadURL();

                              final id = widget.cards.doc().id;
                              _cardDetails = CardDetails(
                                imageName: fileName,
                                name: name,
                                center: center,
                                date: date!,
                                dose: dose,
                                location: location,
                                image: image,
                                userId: uId,
                                id: id,
                              );
                              await widget.cards
                                  .doc(id)
                                  .set(_cardDetails!.toMap());
                              setState(() {
                                _uploadState = UploadState.SUCCESS;
                                _image = null;
                              });
                              _formKey.currentState?.reset();
                              _nameController.text = "";
                              _centerController.text = "";
                              _doseController.text = "";
                              _date = null;
                              _locationController.text = "";
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Uploaded"),
                                action: SnackBarAction(
                                    label: 'Dismiss', onPressed: () {}),
                              ));
                            } on FirebaseException catch (e) {
                              setState(() {
                                _uploadState = UploadState.FAILED;
                              });
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(e.code),
                                action: SnackBarAction(
                                    label: 'Dismiss', onPressed: () {}),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
