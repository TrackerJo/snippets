import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snippets/api/auth.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';

class WelcomePage extends StatefulWidget {
  final bool? toProfile;
  final String? uid;
  const WelcomePage({super.key, this.toProfile, this.uid});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  Auth authService = Auth();

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String hapticFeedback = await HelperFunctions.getHapticFeedbackSF();
      if (hapticFeedback == "normal") {
        HapticFeedback.mediumImpact();
      } else if (hapticFeedback == "light") {
        HapticFeedback.lightImpact();
      } else if (hapticFeedback == "heavy") {
        HapticFeedback.heavyImpact();
      }
      authService.loginWithEmailandPassword(email, password).then((val) {
        if (val == true) {
          if (widget.toProfile == true) {
            router.pushReplacement("/home");
            router.push("/home/profile/${widget.uid}");
          } else {
            router.pushReplacement("/home");
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(val!.toString()),
              backgroundColor: Colors.red,
            ),
          );
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            BackgroundTile(),
            SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 80),
                    child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Welcome to Snippets!",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: styling.backgroundText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text("Creating real conversations without filters",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: styling.backgroundText)),
                            const SizedBox(height: 50),
                            TextFormField(
                              onTap: () async {
                                String hapticFeedback =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (hapticFeedback == "normal") {
                                  HapticFeedback.selectionClick();
                                } else if (hapticFeedback == "light") {
                                  HapticFeedback.selectionClick();
                                } else if (hapticFeedback == "heavy") {
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              decoration: styling
                                  .textInputDecoration()
                                  .copyWith(
                                      labelText: "Email",
                                      fillColor: styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondary,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: styling.theme == "christmas"
                                            ? styling.red
                                            : styling.primary,
                                      )),
                              onChanged: (val) {
                                setState(() {
                                  email = val.trim();
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
                              onTap: () async {
                                String hapticFeedback =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (hapticFeedback == "normal") {
                                  HapticFeedback.selectionClick();
                                } else if (hapticFeedback == "light") {
                                  HapticFeedback.selectionClick();
                                } else if (hapticFeedback == "heavy") {
                                  HapticFeedback.mediumImpact();
                                }
                              },
                              decoration: styling
                                  .textInputDecoration()
                                  .copyWith(
                                      labelText: "Password",
                                      fillColor: styling.theme == "christmas"
                                          ? styling.green
                                          : styling.secondary,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: styling.theme == "christmas"
                                            ? styling.red
                                            : styling.primary,
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
                                  password = val.trim();
                                });
                              },
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () async {
                                      String hapticFeedback =
                                          await HelperFunctions
                                              .getHapticFeedbackSF();
                                      if (hapticFeedback == "normal") {
                                        HapticFeedback.mediumImpact();
                                      } else if (hapticFeedback == "light") {
                                        HapticFeedback.lightImpact();
                                      } else if (hapticFeedback == "heavy") {
                                        HapticFeedback.heavyImpact();
                                      }
                                      router.pushReplacement(
                                          "/forgotPassword/${widget.uid}/${widget.toProfile}");
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: styling.theme == "christmas"
                                              ? styling.green
                                              : styling.primary),
                                    ))),
                            const SizedBox(height: 20),
                            _isLoading
                                ? CircularProgressIndicator(
                                    color: styling.theme == "christmas"
                                        ? styling.green
                                        : styling.primary,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: styling.elevatedButtonDecoration(),
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
                            // const Row(children: <Widget>[
                            //   Expanded(child: Divider(color: Colors.white)),
                            //   Padding(
                            //       padding: EdgeInsets.symmetric(horizontal: 10),
                            //       child: Text("OR",
                            //           style: TextStyle(color: Colors.white))),
                            //   Expanded(child: Divider(color: Colors.white)),
                            // ]),
                            // const SizedBox(height: 10),
                            // SignInButton(
                            //   Buttons.Google,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10)),
                            //   text: "Sign in with Google",
                            //   onPressed: () {},
                            // ),
                            // const SizedBox(height: 10),
                            Text.rich(TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: styling.backgroundText),
                                children: [
                                  TextSpan(
                                      text: "Register here",
                                      style: TextStyle(
                                          color: styling.theme == "christmas"
                                              ? styling.green
                                              : styling.primary,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          String hapticFeedback =
                                              await HelperFunctions
                                                  .getHapticFeedbackSF();
                                          if (hapticFeedback == "normal") {
                                            HapticFeedback.mediumImpact();
                                          } else if (hapticFeedback ==
                                              "light") {
                                            HapticFeedback.lightImpact();
                                          } else if (hapticFeedback ==
                                              "heavy") {
                                            HapticFeedback.heavyImpact();
                                          }

                                          router.pushReplacement(
                                              "/createAccount/${widget.uid}/${widget.toProfile}");
                                        })
                                ]))
                          ]),
                    ))),
          ],
        ),
      ),
    );
  }
}
