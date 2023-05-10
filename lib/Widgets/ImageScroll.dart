import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScroll extends StatefulWidget {
  final List<XFile> imageList;

  const ImageScroll({Key? key, required this.imageList}) : super(key: key);

  @override
  State<ImageScroll> createState() => _ImageScrollState();
}

class _ImageScrollState extends State<ImageScroll> {
  get imageList => widget.imageList;

  @override
  Widget build(BuildContext context) {
    if ((imageList as List<XFile>).isEmpty) {
      return const Text("Upload some pictures for you profile :)");
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: imageList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _showpic(context, index),
          child: Image(
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            image: XFileImage(imageList[index]),
          ),
        ),
      ),
    );
  }

  _showpic(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete image?"),
            content: Column(
              children: [
                Expanded(
                  child: Image(
                    image: XFileImage(imageList[index]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => removeImage(context, index),
                      child: Text("Delete"),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                )
              ],
            ),
          );
        });
  }

  removeImage(BuildContext context, int index) {
    (imageList as List<XFile>).removeAt(index);
    Navigator.pop(context);
    setState(() {});
  }
}
