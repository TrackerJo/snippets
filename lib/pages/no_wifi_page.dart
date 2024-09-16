import 'package:flutter/material.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class NoWifiPage extends StatefulWidget {
  const NoWifiPage({super.key});

  @override
  State<NoWifiPage> createState() => _NoWifiPageState();
}

class _NoWifiPageState extends State<NoWifiPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperFunctions.saveOpenedPageSF("nowifi");
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "No Wifi",
            
          ),
        ),
            
        backgroundColor: ColorSys.background,
        body: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  SizedBox(height: 20),
                  Text(
                    "Oh no! Looks like you're offline",
                    style: TextStyle(
                      color: ColorSys.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Please connect to a wifi network to continue",
                    style: TextStyle(
                      color: ColorSys.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            )
      )
    );
  }
}