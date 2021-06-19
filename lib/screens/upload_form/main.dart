import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:smart_vaxx_card_client/screens/displayImage/main.dart';

class UploadFormScreen extends StatefulWidget {
  // UploadForm({Key? key, this.title}) : super(key: key);

  // final String title;
  @override
  State<StatefulWidget> createState() => UploadFormScreenState();
}

class UploadFormScreenState extends State<UploadFormScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _centerController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _doseController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;

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

  Widget _buildName() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
    );
  }

  Widget _buildCenter() {
    return TextFormField(
      controller: _centerController,
      decoration: InputDecoration(labelText: 'Center of Vaccination'),
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Center of Vaccination is Required';
        }

        return null;
      },
    );
  }

  Widget _buildlocation() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(labelText: 'Location of Center'),
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Location of Center';
        }

        return null;
      },
    );
  }

  Widget _buildDate() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(labelText: 'Date'),
      keyboardType: TextInputType.datetime,
      validator: (var value) {
        if (value!.isEmpty) {
          return 'date is Required';
        }

        return null;
      },
    );
  }

  Widget _buildDose() {
    return TextFormField(
      controller: _doseController,
      decoration: InputDecoration(labelText: 'Dose'),
      keyboardType: TextInputType.number,
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Dose  number is Required';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add card"),
        backgroundColor: Colors.blueAccent,
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
                _buildDate(),
                _buildDose(),
                _buildlocation(),

                SizedBox(height: 20),
                _buildUpload(),
                SizedBox(height: 30),
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _formKey.currentState!.save();

                    //Send to API
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
