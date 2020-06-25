import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';

class UserData {
  static FirebaseUser loggedInUser;
}

class ResultPage extends StatefulWidget {
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      setState(() {
        if (user != null) {
          UserData.loggedInUser = user;
          print('Got user data successfully.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void signInUser() async {
    try {
      print('Sign in user...');
      final user = await _auth.signInWithEmailAndPassword(
          email: 'sensordaten@sensordaten.de', password: 'sensordaten');
      if (user != null) {
        print('Signed in user successfully. Now getting user data...');
        getCurrentUser();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    signInUser();
    filePicker(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text(
              'Hallo',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Future filePicker(BuildContext context) async {
    if (widget.fileType == 'csv') {
      widget.file = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['csv']);
      widget.fileName = p.basename(widget.file.path);
      setState(() {
        widget.fileName = p.basename(widget.file.path);
      });
      print(widget.fileName);
      _uploadFile(widget.file, widget.fileName);
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    if (widget.fileType == 'csv') {
      storageReference =
          FirebaseStorage.instance.ref().child("file_to_process/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }
}
