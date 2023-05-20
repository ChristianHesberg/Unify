import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var img = picker.pickImage(source: ImageSource.camera);

    var ref = FirebaseStorage.instance.ref();
    var DirImg = ref.child("images");



    return Placeholder();
  }
}
