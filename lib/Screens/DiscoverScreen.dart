

import 'package:flutter/material.dart';
import 'package:unify/Widgets/user_text.dart';

import '../Widgets/contact_user_widget.dart';

class DiscoverScreen extends StatelessWidget {
  PageController controller = PageController();
  PageController imgController = PageController();

  final peopleList = [
    user(
        "Jens",
        "28",
        "man",
        "The temporary satisfaction of quitting is outweighed by the eternal suffering of being nobody.",
        [
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
          "https://images.pexels.com/photos/5792641/pexels-photo-5792641.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        ]),
    user(
        "ole",
        "25",
        "man",
        "The most important things are the hardest things to say. They are the things you get ashamed of because words diminish your feelings - words shrink things that seem timeless when they are in your head to no more than living size when they are brought out.",
        [
          "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"
        ]),
    user(
        "Sofie",
        "24",
        "Women",
        "It takes a great deal of bravery to stand up to our enemies, but just as much to stand up to our friends.",
        [
        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "https://images.pexels.com/photos/4065187/pexels-photo-4065187.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "https://images.pexels.com/photos/15098953/pexels-photo-15098953.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "https://images.pexels.com/photos/12186144/pexels-photo-12186144.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "https://images.pexels.com/photos/13046993/pexels-photo-13046993.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
        ])
  ];

  DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          "${peopleList[position].name}, ${peopleList[position].age}",
                    ),
                    const ContractUserBtn(),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserText(
                        text: peopleList[position].desc,
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
          itemCount: peopleList[position].url.length,
          itemBuilder: (context, imgPosition) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  peopleList[position].url[imgPosition],
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
              peopleList[position].url.length,
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

class user {
  final String name;
  final String age;
  final String gender;
  final String desc;
  final List<String> url;

  user(this.name, this.age, this.gender, this.desc, this.url);
}
