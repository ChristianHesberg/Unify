import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unify/user_state.dart';
import '../models/appUser.dart';
import '../user_service.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _image_picker = ImagePicker();
  late AppUser user;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images"), backgroundColor: Colors.black),
      body: !loading
          ? Consumer<UserService>(
              builder: (BuildContext context, value, Widget? child) {
                if (UserState.user == null) {
                  value.getUser();
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  user = UserState.user!;
                  return _buildImageScreen();
                }
              },
            )
          : const Center(child: CircularProgressIndicator()),
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
                image: NetworkImage(user.imageList[index]),
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
              if (user.imageList.length >= 12) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("You can only have 12 images"),
                  duration: Duration(seconds: 3),
                ));
              } else {
                getManyPhotos();
              }
            },
          ),
        ),
      ],
    );
  }

  Future getManyPhotos() async {
    var images = await _image_picker.pickMultiImage();
    if (images.length + user.imageList.length >= 12) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "You already have ${user.imageList.length} images and can only have 12."),
        duration: Duration(seconds: 3),
      ));
    } else {
      setState(() {
        loading = true;
      });
      if (images.isNotEmpty) {
        final userService = Provider.of<UserService>(context, listen: false);
        await userService.uploadImages(images);
      }
      setState(() {
        Navigator.of(context).pop();
      });
    }
  }

  _deleteBtn(int index) {
    final userService = Provider.of<UserService>(context, listen: false);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete picture?"),
            content: const Text("Are you sure you want to delete this picture"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    userService
                        .deleteImage(user.id, user.imageList[index])
                        .then((value) => user.imageList.removeAt(index));
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("Delete"))
            ],
          );
        });
  }
}
