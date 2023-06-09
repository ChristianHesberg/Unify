import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/Widgets/DatePicker.dart';
import 'package:unify/Widgets/genderDropDown.dart';
import 'package:unify/Widgets/user_text.dart';
import 'package:unify/user_state.dart';
import '../Widgets/user_text_field.dart';
import '../user_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AppUser user;
  bool canEdit = false;
  bool loading = false;

  DateTime? birthDate;
  String genderValue = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  Map<String, int> gender = {"other": 0, "male": 1, "female": 2};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
        backgroundColor: Colors.black,
      ),
      body: !loading ? Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 500,
          child: Consumer<UserService>(
            builder: (context, value, child) {
              if (UserState.user == null) {
                value.getUser();
                return const Center(child: CircularProgressIndicator());
              } else {
                user = UserState.user!;
                return _accountScreen();
              }
            },
          ),
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }


  Widget _accountScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: 200,
            child: Stack(
              children: [
                _profilePicture(), // profile picture
                _editBtn(),
                Align(alignment: Alignment.bottomCenter,
                    child: UserText(text: user.name))
              ],
            ),
          ),
          _userInfoForm(context),
          _submitBtn(),
        ],
      ),
    );
  }

  _editBtn() {
    return Positioned(
        bottom: 25,
        right: 10,
        child: ElevatedButton(
          style: ButtonStyle(
            shape:
            MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300.0),
              ),
            ),
          ),
          onPressed: () {
            canEdit = true;
            setState(() {});
          },
          child: const Icon(Icons.edit),
        ));
  }

  _profilePicture() {
    return Align(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 120,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.blue.withOpacity(0.3),
              highlightColor: Colors.blue.withOpacity(0.5),
              onLongPress: () {
                if (canEdit) {
                  getImage(ImageSource.gallery);
                }
              },
              child: Ink.image(image: NetworkImage(user.profilePicture),
                fit: BoxFit.cover,
                width: 240,
                height: 240,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    final userService = Provider.of<UserService>(context, listen: false);

    final _image_picker = ImagePicker();
    var img = await _image_picker.pickImage(source: ImageSource.gallery);

    setState(() {
      userService.uploadProfilePicture(img!);
    });
  }

  Widget _userInfoForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
              children: [
                UserTextField(
                  controller: descController
                    ..text = this.user.description,
                  label: "desc",
                  enabled: canEdit,
                ),
                _datePicker(),
                _genderDropDown(),
              ]),
        ));
  }

  Widget _datePicker() {
    return IgnorePointer(
        ignoring: !canEdit,
        child: DatePicker(
          onClick: _handleDateOutput,
          birthDate: user.birthday,
        ));
  }


  void _handleDateOutput(DateTime date) {
    birthDate = date;
  }

  Widget _genderDropDown() {
    return GenderDropDown(
      onSelect: _handleGenderSelect,
      canChange: !canEdit,
      startIndex: gender[user.gender],
    );
  }


  void _handleGenderSelect(String value) {
    genderValue = value;
  }

  Widget _submitBtn() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (canEdit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: () async {
            setState(() {
              loading = true;
            });
            await userService.updateUserInfo(
                descController.text, genderValue, birthDate ?? user.birthday);
            canEdit = false;
            setState(() {
              Navigator.of(context).pop();
            });
          }, child: const Text("Submit")),
          ElevatedButton(
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                canEdit = false;
                setState(() {});
              },
              child: const Text("Cancel")),
        ],
      );
    } else {
      return Container();
    }
  }
}
