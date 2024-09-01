
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/main.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';


class ForgotPasswordPage extends StatefulWidget {
  final bool? toProfile;
  final String? uid;
  const ForgotPasswordPage({super.key, this.toProfile, this.uid});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var formKey = GlobalKey<FormState>();
  String email = "";
  bool _isLoading = false;

  void sendEmail() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      //Send email
      HapticFeedback.mediumImpact();
      Auth().resetPassword(email).then((val) {
        if (val == true) {
          router.pushReplacement("/welcome/${widget.uid}/${widget.toProfile}");
        } else {
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
                    height: 200,
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        const SizedBox(height: 25),
                        Text("Enter your email connected to your account and then click send email to reset your password, you will receive an email with instructions on how to reset your password",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                ),textAlign: TextAlign.center,),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              fillColor: ColorSys.secondary,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onTap: () {
                            HapticFeedback.selectionClick();
                          },
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
                        
                        const SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator(
                                color: ColorSys.primary,
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorSys.primaryDark,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: const Text(
                                    "Send Email",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  onPressed: () {
                                    sendEmail();
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
                        Text.rich(
                              TextSpan(
                                  text: "Back",
                                  style: TextStyle(
                                      color: ColorSys.primary,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      HapticFeedback.mediumImpact();
                                      router.pushReplacement("/welcome/${widget.uid}/${widget.toProfile}");
                                    })
                            )
                      ]),
                ))),
      ),
    );
  }
}