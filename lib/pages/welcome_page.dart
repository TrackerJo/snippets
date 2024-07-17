import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/pages/create_account_page.dart';
import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/swipe_pages.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

import '../widgets/custom_page_route.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  Auth authService = Auth();

  void login() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService.loginWithEmailandPassword(email, password).then((val) {
        if (val == true) {
          Navigator.of(context).pushAndRemoveUntil(
            CustomPageRoute(
              builder: (BuildContext context) {
                return const SwipePages();
              },
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
              ),
              builder: (BuildContext context) {
                return SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          val.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )));
              });
        }
      });
    }
  }

  void savePage() async {
    await HelperFunctions.saveOpenedPageSF("login");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    savePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Welcome to Snippets!",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text("Creating real conversations without filters",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },

                        //Check email validation
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: ColorSys.primary,
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorSys.primarySolid,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                onPressed: () {
                                  login();
                                },
                              )),
                      const SizedBox(height: 10),
                      const Row(children: <Widget>[
                        Expanded(child: Divider(color: Colors.white)),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR",
                                style: TextStyle(color: Colors.white))),
                        Expanded(child: Divider(color: Colors.white)),
                      ]),
                      const SizedBox(height: 10),
                      SignInButton(
                        Buttons.Google,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        text: "Sign in with Google",
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10),
                      Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Register here",
                                style: TextStyle(
                                    color: ColorSys.primary,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                      CustomPageRoute(
                                        builder: (BuildContext context) {
                                          return const CreateAccountPage();
                                        },
                                      ),
                                    );
                                  })
                          ]))
                    ]),
              ))),
    );
  }
}
