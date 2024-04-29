import 'package:flutter/material.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/templates/colorsSys.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Welcome to Snippets'),
      ),
      backgroundColor: Color(0xFF232323),
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
            margin: EdgeInsets.only(bottom: 40),
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
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              child: Image.asset(image),
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Text(content,
                textAlign: TextAlign.center,
                style: TextStyle(
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
                  Navigator.of(context).pushReplacement(
                    CustomPageRoute(
                      builder: (BuildContext context) {
                        return const HomePage();
                      },
                    ),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSys.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
              ),
          ]),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: EdgeInsets.only(right: 5),
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
}
