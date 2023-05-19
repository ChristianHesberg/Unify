

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Widgets/user_text.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/user_service.dart';

import '../Widgets/contact_user_widget.dart';

class DiscoverScreen extends StatelessWidget {
  PageController controller = PageController();
  PageController imgController = PageController();

  //TODO get people from firebase
  List<AppUser> peopleList = [];

  DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: buildUserList(userService),
      builder: (BuildContext context, AsyncSnapshot<dynamic>
          snapshot){
        if(peopleList.isNotEmpty){
          return buildDiscover();
        }
        else{
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future buildUserList(UserService service) async {
    await service.initializeUser();
    peopleList = await service.getUsersWithinRadius();
    return null;
  }

  Widget buildDiscover(){
    return Scaffold(
      body: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
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
                    const ContractUserBtn(),
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
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2, maxWidth: 500),
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

