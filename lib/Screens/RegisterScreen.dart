import 'package:cross_file_image/cross_file_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:unify/Widgets/DatePicker.dart';
import 'package:unify/Widgets/DistanceSlider.dart';
import 'package:unify/Widgets/GenderCheckBoxes.dart';
import 'package:unify/Widgets/ImageScroll.dart';
import 'package:unify/Widgets/genderDropDown.dart';

import '../Widgets/AgeSlider.dart';

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
        physics: const NeverScrollableScrollPhysics(),
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
  final _passwordAgain = TextEditingController();
  final _loginForm = GlobalKey<FormState>();

  _buildLoginDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Form(
          key: _loginForm,
          child: Column(
            children: [
              const Text("Create your login!"),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value) {
                  if (value == null || !EmailValidator.validate(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "Example@Email.com"),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              TextFormField(
                controller: _passwordAgain,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Repeat password"),
                validator: (value) {
                  if (value == null ||
                      _password.text != _passwordAgain.text ||
                      _passwordAgain.text.length < 6) {
                    return 'Your password must match and be 6 characters long';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_loginForm.currentState!.validate()) {
                    //_nextPage();
                  } else {}
                  //TODO REMOVE ME! PLACEHOLDER FOR TESTING
                  _nextPage();
                },
                child: const Text("Next"),
              )
            ],
          ),
        ),
      ),
    );
  }

  _nextPage() {
    if (!_pageController.hasClients) return;
    currentPage++;
    _pageController.jumpToPage(currentPage);
    setState(() {});
  }

  _previousPage() {
    if (!_pageController.hasClients) return;
    currentPage--;
    _pageController.jumpToPage(currentPage);
    setState(() {});
  }

  final _name = TextEditingController();
  final _image_picker = ImagePicker();
  XFile? profilePicture;
  final _userForm = GlobalKey<FormState>();

  String genderValue = "";

  void _handleGenderSelect(String value) {
    genderValue = value;
  }

  DateTime? birthDate;

  void _handleDateOutput(DateTime date) {
    birthDate = date;
  }

  _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: _userForm,
          child: Column(
            children: [
              _profilePicture(),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("Name"), hintText: "Your name"),
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Input your name";
                  }
                  return null;
                },
              ),
              DatePicker(
                  onClick: _handleDateOutput, birthDate: DateTime(2001, 9, 11)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Your gender"),
                  GenderDropDown(onSelect: _handleGenderSelect),
                ],
              ),
              const Text("More pictures"),
              ElevatedButton(
                onPressed: () {
                  getManyPhotos();
                },
                child: Text('Upload Photo'),
              ),
              ImageScroll(imageList: images),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    label: Text("About you"),
                    hintText: "Tell others a little about you"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tell people who you are >:^)";
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => _previousPage(),
                      child: const Text("Back")),
                  ElevatedButton(
                      onPressed: () {
                        if (profilePicture == null || images.isEmpty) {
                          const snackBar = SnackBar(
                              content: Text(
                                  "Pick a profile picture and some cool pictures of yourself"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (birthDate == null) {
                          const s = SnackBar(content: Text("pick a birthday"));
                          ScaffoldMessenger.of(context).showSnackBar(s);
                        } else if (_userForm.currentState!.validate()) {
                          // _nextPage();
                        }
                        //TODO REMOVE THIS IS FOR TESTING
                        _nextPage();
                      },
                      child: const Text("Next")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<XFile> images = [];

  Future getManyPhotos() async {
    var images = await _image_picker.pickMultiImage();
    setState(() {
      this.images.addAll(images);
    });
  }

  Future getImage(ImageSource media) async {
    var img = await _image_picker.pickImage(source: media);
    setState(() {
      profilePicture = img;
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
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
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

  _profilePicture() {
    return profilePicture == null
        ? Center(
            child: RawMaterialButton(
              onPressed: () {
                imageAlert();
              },
              fillColor: Colors.white,
              padding: const EdgeInsets.all(20.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.person,
                size: 35.0,
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              imageAlert();
            },
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: XFileImage(profilePicture!),
              ),
            ),
          );
  }

  Map<String, bool> genderMap = {};

  _handleGenderCheckBoxes(Map<String, bool> values) {
    //todo validate
    genderMap = values;
  }

  double distance = 1;

  _handleDistanceSlider(double val) {
    distance = val;
  }

  _buildUserPreferences() {
    return Column(
      children: [
        const Text("Who are you looking to meet?"),
        GenderCheckBoxes(
          men: true,
          women: true,
          other: true,
          onClick: _handleGenderCheckBoxes,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              _buildAgeSlider(),
              DistanceSlider(onSlide: _handleDistanceSlider),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              _previousPage();
            },
            child: Text("back")),
        ElevatedButton(
            onPressed: () {
              //TODO SUBMIT
              //if email taken => tilbage til page 1 ommer
            },
            child: Text("Done!"))
        //Text("data")
      ],
    );
  }

  var rangeValues = const SfRangeValues(18, 75);

  _handleOnSlide(SfRangeValues values) {
    rangeValues = values;
    //husk at round
  }

  _buildAgeSlider() {
    return AgeSlider(
      ageRangeValues: rangeValues,
      onSlide: _handleOnSlide,
    );
  }
}
