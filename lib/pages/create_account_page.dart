import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';

import 'package:snippets/pages/home_page.dart';
import 'package:snippets/pages/onboarding_page.dart';
import 'package:snippets/pages/welcome_page.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';

import '../widgets/custom_page_route.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var formKey = GlobalKey<FormState>();
  String email = "";
  String username = "";
  String fullName = "";
  String password = "";
  PhoneNumber? phoneNumber;
  bool _isLoading = false;
  Auth authService = Auth();

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool isUsernameTaken = await Database().checkUsername(username);
      if (isUsernameTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Username is already taken"),
          ),
        );
        setState(() {
          _isLoading = false;
        });

        return;
      }

      authService
          .registerUserWithEmailandPassword(
              fullName, email, password, username, phoneNumber)
          .then((val) {
        if (val == true) {
          Navigator.of(context).pushAndRemoveUntil(CustomPageRoute(
            builder: (BuildContext context) {
              return const OnBoardingPage();
            },
          ), (route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(val!),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232323),
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
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },

                        //Check email validation
                        validator: (val) {
                          return val!.isEmpty
                              ? "Please enter a valid name"
                              : null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },

                        //Check email validation
                        validator: (val) {
                          return val!.isEmpty
                              ? "Please enter a valid name"
                              : null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                      PhoneInput(
                        countrySelectorNavigator:
                            const CountrySelectorNavigator.dialog(),
                        decoration: textInputDecoration.copyWith(
                          labelText: "Phone Number",
                        ),
                        shouldFormat: true,
                        onChanged: (PhoneNumber? number) {
                          setState(() {
                            phoneNumber = number;
                          });
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
                              color: Theme.of(context).primaryColor)
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorSys.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                onPressed: () {
                                  register();
                                },
                              )),
                      const SizedBox(height: 10),
                      Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Sign in here",
                                style: TextStyle(
                                    color: ColorSys.primary,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                      CustomPageRoute(
                                        builder: (BuildContext context) {
                                          return const WelcomePage();
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
