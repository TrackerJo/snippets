import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/api/notifications.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';


import '../widgets/custom_app_bar.dart';


class OnBoardingPage extends StatefulWidget {
  final bool? toProfile;
  final String? uid;
  final bool? alreadyOnboarded;
  const OnBoardingPage({super.key, this.toProfile, this.uid, this.alreadyOnboarded});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();
  int currentIndex = 0;
  String editDescription = "";

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Welcome to Snippets', showBackButton: widget.alreadyOnboarded == true ? true : false, onBackButtonPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).pop();
        },
        fixRight: widget.alreadyOnboarded == true ? true : false,),
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
                  image: 'assets/slide_3.png',
                  title: '3 prompts daily,  1 anonymous prompt weekly',
                  content:
                      'Answer each prompt, view your friends responses. Every week at a random time, there will be an public anonymous snippet for all to answer.',
                  smallText: true),
                  
              makePage(
                  image: 'assets/slide_2.png',
                  title: 'One public snippet of the week',
                  content: 'Every week one question will be asked to all users. Responses will be public and can be viewed by all users. On the weekend, vote for your favorite response.'),
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

  Widget makePage({image, title, content, lastPage = false, smallText = false}) {
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
                style: TextStyle(
                    fontSize: smallText ? 15 : 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400)),
            if (lastPage)
              const SizedBox(
                height: 30,
              ),
            if (lastPage)
              ElevatedButton(
                onPressed: () {

                  if(widget.alreadyOnboarded == true){
                    // router.pushReplacement("/home");
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showDiscriptionPopup();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSys.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                child: Text(
                  widget.alreadyOnboarded == true ? 'Back to Home' :
                  'Get Started',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
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
            height: 375,
            child: Column(
              children: [
                const Text(
                    "Enter a short description about yourself. This will be visible to other users.",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    initialValue: editDescription,
                    maxLines: 7,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Description',
                      counterStyle: const TextStyle(color: Colors.white),

                    ),
                    onChanged: (value) => editDescription = value,
                    maxLength: 125,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await PushNotifications().initNotifications();
                        if(widget.toProfile == true){

                          router.pushReplacement("/home");
                          router.push("/home/profile/${widget.uid}");
                        } else {
                        router.pushReplacement("/home");
                        }
                      },
                      child: const Text("Skip"),
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSys.primary,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await PushNotifications().initNotifications();
                        await FBDatabase(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateUserDescription(editDescription);
                
                        if(widget.toProfile == true){
                          router.pushReplacement("/home");
                          router.push("/home/profile/${widget.uid}");
                        } else {
                        router.pushReplacement("/home");
                        }
                      },
                      child: const Text("Save", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
         
        ),
      ),
    );
  }
}
