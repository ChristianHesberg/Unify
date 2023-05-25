import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Widgets/user_text.dart';
import 'package:unify/chat_service.dart';
import 'package:unify/match_state.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/user_service.dart';

import '../Widgets/contact_user_widget.dart';
import '../user_state.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  PageController controller = PageController(initialPage: MatchState.index);
  PageController imgController = PageController();

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: buildUserList(userService),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (MatchState.peopleList.isNotEmpty) {
          return buildDiscover(context);
        } else {
          return const Center(child: Column(children:[ CircularProgressIndicator(), UserText(text: "Searching for people in who fit your preferences")]));
        }
      },
    );
  }

  Future buildUserList(UserService service) async {
    if(!UserState.userInit){
      await service.initializeUser();
    }
    MatchState.peopleList += await service.getUsersWithinRadius();
    return null;
  }

  Widget buildDiscover(BuildContext context) {
    var pageView = buildPageView();
    return Scaffold(
      body: pageView
    );
  }

  PageView buildPageView() {
    return PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        onPageChanged: (int pageNumber) async {
          MatchState.index = pageNumber;
          if (pageNumber == MatchState.peopleList.length - 1) {
            setState(() {
            });
          }
          print('pageNumber: $pageNumber');
          print('index: ${MatchState.index}');
        },
        itemCount: MatchState.peopleList.length,
        itemBuilder: (context, position) {
          return Column(
            children: [
              pictures(position, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserText(
                    text:
                        "${MatchState.peopleList[position].name}, ${MatchState.peopleList[position].getBirthdayAsAge()}",
                  ),
                  buildGenderIcon(MatchState.peopleList[position].gender),
                  ContactUserBtn(user1: UserState.user!, user2: MatchState.peopleList[position]),
                ],
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserText(
                      text: MatchState.peopleList[position].description,
                      size: 20,
                      color: Colors.black45),
                ),
              )
            ],
          );
        });
  }

  Widget pictures(int position, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2, maxWidth: 500),
      child: PageView.builder(
          controller: imgController,
          scrollDirection: Axis.horizontal,
          itemCount: MatchState.peopleList[position].imageList.length,
          itemBuilder: (context, imgPosition) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  MatchState.peopleList[position].imageList[imgPosition],
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
              MatchState.peopleList[position].imageList.length,
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

  Widget buildGenderIcon(String gender){
    switch(gender){
      case 'female': return const Icon(Icons.female,size: 40,);
      case 'male': return const Icon(Icons.male, size: 40,);
      case 'other': return const UserText(text: 'X');
    }
    return const UserText(text: 'X');
  }
}
