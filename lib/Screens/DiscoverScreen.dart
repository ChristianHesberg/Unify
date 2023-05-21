import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Widgets/user_text.dart';
import 'package:unify/chat_service.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/user_service.dart';

import '../Widgets/contact_user_widget.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  PageController controller = PageController();

  PageController imgController = PageController();

  List<AppUser> peopleList = [];

  bool userInit = false;

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: buildUserList(userService),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (peopleList.isNotEmpty) {
          return buildDiscover(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future buildUserList(UserService service) async {
    if(!userInit){
      await service.initializeUser();
    }
    peopleList += await service.getUsersWithinRadius();
    return null;
  }

  Widget buildDiscover(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      body: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (i) async {
            if (i == peopleList.length - 1) {
              setState(() {
              });
            }
          },
          itemCount: peopleList.length,
          itemBuilder: (context, position) {
            return Column(
              children: [
                pictures(position, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserText(
                      text:
                          "${peopleList[position].name}, ${peopleList[position].getBirthdayAsAge()}",
                    ),
                    ContactUserBtn(user1: userService.user!, user2: peopleList[position]),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserText(
                        text: peopleList[position].description,
                        size: 20,
                        color: Colors.black45),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget pictures(int position, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2, maxWidth: 500),
      child: PageView.builder(
          controller: imgController,
          scrollDirection: Axis.horizontal,
          itemCount: peopleList[position].imageList.length,
          itemBuilder: (context, imgPosition) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  peopleList[position].imageList[imgPosition],
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
                indicator(position, imgPosition)
              ],
            );
          }),
    );
  }

  Widget indicator(int position, int imgPosition) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 40,
      child: Container(
        color: Colors.black54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
              peopleList[position].imageList.length,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        imgController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor:
                            imgPosition == index ? Colors.cyan : Colors.grey,
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
