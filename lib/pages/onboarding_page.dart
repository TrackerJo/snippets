import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_page_route.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;
  TextEditingController descriptionController = TextEditingController();

  void savePage() async {
    await HelperFunctions.saveOpenedPageSF("onBoarding");
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Welcome to Snippets'),
      ),
      backgroundColor: const Color(0xFF232323),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                  image: 'assets/slide_1.png',
                  title: 'Real conversations with real people',
                  content: 'No filters, only conversations'),
              makePage(
                  image: 'assets/slide_2.png',
                  title: 'Connecting with people around the world',
                  content: 'New conversations every day'),
              makePage(
                  image: 'assets/slide_3.png',
                  title: '3 new prompts every day, 1 new person every week',
                  content:
                      'Every week you will be randomly matched with a new person'),
              makePage(
                  image: 'assets/slide_4.png',
                  title: 'Stay in touch with new and old friends',
                  content:
                      'Have real time discussions with your friends and new people',
                  lastPage: true),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, lastPage = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(image),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Text(content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400)),
            if (lastPage)
              const SizedBox(
                height: 30,
              ),
            if (lastPage)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showDiscriptionPopup();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSys.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
          ]),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.primary, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (var i = 0; i < 4; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

  Widget showDiscriptionPopup() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: ColorSys.background,
          title: Text("Profile's Description",
              style: TextStyle(color: ColorSys.primary)),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                const Text(
                    "Enter a short description about yourself. This will be visible to other users.",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 7,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  CustomPageRoute(
                    builder: (BuildContext context) {
                      return const HomePage();
                    },
                  ),
                );
              },
              child: const Text("Skip"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSys.primary,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateUserDescription(descriptionController.text);
        
                Navigator.of(context).pushReplacement(
                  CustomPageRoute(
                    builder: (BuildContext context) {
                      return const HomePage();
                    },
                  ),
                );
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
