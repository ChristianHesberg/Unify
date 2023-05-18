import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Models/appUser.dart';
import '../user_service.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _image_picker = ImagePicker();
  late AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images"), backgroundColor: Colors.black),
      body: Consumer<UserService>(
        builder: (BuildContext context, value, Widget? child) {
          if(value.user == null){
            value.getUser();
            return Center(child: CircularProgressIndicator(),);
          }else{
            user = value.user!;
            return _buildImageScreen();
          }
        },
      ),
    );
  }

  Stack _buildImageScreen() {
    return Stack(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
          ),
          itemCount: user.imageList.length,
          itemBuilder: (context, index) {
            return InkWell(
              highlightColor: Colors.blue.withOpacity(0.3),
              splashColor: Colors.blue.withOpacity(0.5),
              onLongPress: () {
                _deleteBtn(index);
              },
              child: Ink.image(
                image: NetworkImage(user.imageList[index].url),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            onPressed: () {
              getManyPhotos();
            },
          ),
        ),
      ],
    );
  }
  List<XFile> xFileList = [];
  Future getManyPhotos() async {
    final userService = Provider.of<UserService>(context, listen:false);
    var images = await _image_picker.pickImage(source: ImageSource.camera);
    xFileList.add(images!);
    if(xFileList.length > 1){
      setState(() {
        userService.uploadImages(xFileList).then((value) => userService.getUser());
      });
    }
  }

  _deleteBtn(int index) {
    final userService = Provider.of<UserService>(context, listen:false);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete picture?"),
            content: Text("Are you sure you want to delete this picture"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    userService.deleteImage(user.id, user.imageList[index].name);
                    user.imageList.removeAt(index);
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Delete"))
            ],
          );
        });
  }
}
