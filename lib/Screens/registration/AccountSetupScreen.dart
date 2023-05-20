import 'package:cross_file_image/cross_file_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:unify/FireService.dart';
import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/geolocator_server.dart';
import 'package:unify/models/SettingDTO.dart';

import '../../Widgets/AgeSlider.dart';
import '../../Widgets/DatePicker.dart';
import '../../Widgets/DistanceSlider.dart';
import '../../Widgets/GenderCheckBoxes.dart';
import '../../Widgets/ImageScroll.dart';
import '../../Widgets/genderDropDown.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({Key? key}) : super(key: key);

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  late final _pageController;
  int currentPage = 0;
  double distance = 1;
  var ageRangeValues = const SfRangeValues(18, 75);
  final _image_picker = ImagePicker();
  XFile? profilePicture;
  final _userForm = GlobalKey<FormState>();
  DateTime birthDate = DateTime(2001, 9, 11); //starting value
  String genderValue = "";
  final _description = TextEditingController();
  final _name = TextEditingController(text: "asdasdasd");
  late final Position currentLocation;
  var _loading = false;
  List<XFile> images = [];

  @override
  initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    var fireService = Provider.of<FireService>(context);
    return Scaffold(
      appBar:
          AppBar(title: const Text("Set up your account details!"), actions: [
        IconButton(
          onPressed: () {
            fireService.signOut(context);
          },
          icon: const Icon(Icons.exit_to_app),
        )
      ]),
      body: _loading == false
          ? PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                _buildUserInfo(),
                _buildUserPreferences(fireService, context)
              ],
            )
          : const CircularProgressIndicator(),
    );
  }

  void _handleGenderSelect(String value) {
    genderValue = value;
  }

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
              DatePicker(onClick: _handleDateOutput, birthDate: birthDate),
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
                controller: _description,
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
          ),
        ),
      ),
    );
  }

  _buildUserPreferences(FireService fireService, context) {
    return Column(
      children: [
        const Text("Who are you looking to meet?"),
        GenderCheckBoxes(
          men: genderMap["Men"]!,
          women: genderMap["Women"]!,
          other: genderMap["Other"]!,
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
        _buildDoneBtn(fireService, context),
        //Text("data")
      ],
    );
  }

  _buildDoneBtn(FireService fireService, context) {
    return ElevatedButton(
        onPressed: () async {
          _loading = true;
          setState(() {});
          var dto = await _createSettingsDto();
          await fireService.updateAccount(dto);
          _loading = false;
          //fireService.isSetup = true; //TODO SCUFFED?
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NavigatorScreen(),
              ),
            );
          });
          //if email taken => tilbage til page 1 ommer
        },
        child: Text("Done!"));
  }

  _createSettingsDto() async {
    var minAge = ageRangeValues.start.round();
    var maxAge = ageRangeValues.end.round();
    var pos = await Server.determinePosition();
    final geo = GeoFlutterFire();
    var point = geo.point(latitude: pos.latitude, longitude: pos.longitude);


    return SettingsDTO(
      id: FirebaseAuth.instance.currentUser!.uid,
      name: _name.text,
      age: birthDate,
      position: point,
      gender: genderValue,
      maxAgePreference: maxAge,
      minAgePreference: minAge,
      locationPreference: distance,
      profilePicture: profilePicture!,
      imageList: images,
      description: _description.text,
      femalePreference: genderMap["Women"]!,
      malePreference: genderMap["Men"]!,
      otherPreference: genderMap["Other"]!,
    );
  }

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
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
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
                    child: const Row(
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

  Map<String, bool> genderMap = {"Men": true, "Women": true, "Other": true};

  _handleGenderCheckBoxes(Map<String, bool> values) {
    genderMap = values;
  }

  _handleDistanceSlider(double val) {
    distance = val;
  }

  _handleOnSlide(SfRangeValues values) {
    ageRangeValues = values;
    //husk at round
  }

  _buildAgeSlider() {
    return AgeSlider(
      ageRangeValues: ageRangeValues,
      onSlide: _handleOnSlide,
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
}
