import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _image_picker = ImagePicker();
  List<String> _items = [
    "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/4065187/pexels-photo-4065187.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/15098953/pexels-photo-15098953.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/12186144/pexels-photo-12186144.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/13046993/pexels-photo-13046993.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images"), backgroundColor: Colors.black),
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 3,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return InkWell(
                highlightColor: Colors.blue.withOpacity(0.3),
                splashColor: Colors.blue.withOpacity(0.5),
                onLongPress: () {
                  _deleteBtn(index);
                },
                child: Ink.image(
                  image: NetworkImage(_items[index]),
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
      ),
    );
  }

  Future getManyPhotos() async {
    var images = await _image_picker.pickMultiImage();
    setState(() {
      //TODO add to firebase and get them again
    });
  }

  _deleteBtn(int index) {
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
                    //TODO Delete Picture
                    _items.removeAt(index);
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
