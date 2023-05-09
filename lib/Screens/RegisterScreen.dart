import 'package:cross_file_image/cross_file_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:unify/Widgets/genderDropDown.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final _pageController;
  late final pages;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    pages = [_buildLoginDetails(), _buildUserInfo(), _buildUserPreferences()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register a new account")),
      body: PageView(
        controller: _pageController,
        children: [
          _buildLoginDetails(),
          _buildUserInfo(),
          _buildUserPreferences()
        ],
      ),
    );
  }

  final _email = TextEditingController();
  final _password = TextEditingController();

  _buildLoginDetails() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("E-mail"),
          TextField(controller: _email),
          const Padding(padding: EdgeInsets.only(top: 40)),
          const Text("Password"),
          TextField(
            controller: _password,
          ),
          ElevatedButton(
            onPressed: () {
              if (!_pageController.hasClients) return;
              currentPage++;
              _pageController.jumpToPage(currentPage);
              setState(() {});
            },
            child: const Text("Next"),
          )
        ],
      ),
    );
  }

  final _name = TextEditingController();
  final _image_picker = ImagePicker();
  DateTime birthDate = DateTime(1900, 01, 01);
  XFile? image;

  _buildUserInfo() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _profilePicture(),
            TextField(
              decoration: const InputDecoration(
                label: Text("Name"),
                hintText: "Your name"
              ),
              controller: _name,
            ),
            _createDateBtn(),
            GenderDropDown(),
            const Text("More pictures"),
            ElevatedButton(
              onPressed: () {
                getManyPhotos();
              },
              child: Text('Upload Photo'),
            ),
            images.isNotEmpty
                ? Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) =>
                      Image(image: XFileImage(images[index]))),
            )
                : Container(),
            const TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(label: Text("About you"),
              hintText: "Tell others a little about you"),
            )
          ],
        ),
      ),
    );
  }

  List<XFile> images = [];

  Future getManyPhotos() async {
    var images = await _image_picker.pickMultiImage();
    setState(() {
      this.images = images;
    });
  }

  Future getImage(ImageSource media) async {
    var img = await _image_picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  void imageAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildUserPreferences() {
    return Text("user pref");
  }

  _profilePicture() {
    return image == null
        ? Center(
      child: ElevatedButton(
          onPressed: () {
            imageAlert();
          },
          child: Text("Profile Image")),
    )
        : GestureDetector(
      onTap: () {
        imageAlert();
      },
      child: Center(
        child: CircleAvatar(
          radius: 60,
          backgroundImage: XFileImage(image!),
        ),
      ),
    );
  }

  _createDateBtn() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              final today = DateTime.now();
              final minusEightTeen =
              DateTime(today.year - 18, today.month, today.day);
              showDatePicker(
                  context: context,
                  initialDate: minusEightTeen,
                  firstDate: DateTime(1900),
                  lastDate: minusEightTeen)
                  .then((value) =>
                  setState(() {
                    birthDate = value!;
                  }));
            },
            child: const Text("Select birthday")),
        Text("${formatter.format(birthDate)}")
      ],
    );
  }
}
