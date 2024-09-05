import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';

import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';


class CreateAccountPage extends StatefulWidget {
  final bool toProfile;
  final String uid;
  const CreateAccountPage({super.key, required this.uid, required this.toProfile});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  
  PhoneNumber? phoneNumber;
  bool _isLoading = false;
  Auth authService = Auth();

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      HapticFeedback.mediumImpact();
      bool isUsernameTaken = await FBDatabase().checkUsername(usernameController.text);
      if (isUsernameTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username is already taken"),
             backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });

        return;
      }

      authService
          .registerUserWithEmailandPassword(
               fullNameController.text, emailController.text, passwordController.text,usernameController.text,  phoneNumber)
          .then((val) {
        if (val == true) {

          router.pushReplacement("/onBoarding/${widget.uid}/${widget.toProfile}");
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(
              content: Text(val!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void savePage() async {
    await HelperFunctions.saveOpenedPageSF("create_account");
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
        backgroundColor: const Color(0xFF232323),
        resizeToAvoidBottomInset: true,
        body: Padding(
            padding:
                const EdgeInsets.only(left: 20.0, top: 40, right: 20, bottom: 00),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
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
                        controller: fullNameController,
                        onTap: () {
                            HapticFeedback.selectionClick();
                          },
                        decoration: textInputDecoration.copyWith(
                            labelText: "Display Name",
                            fillColor: ColorSys.secondary,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                        
                        
                        //Check email validation
                        validator: (val) {
                          if(val!.isEmpty){
                            return "Please enter a name";
                          }
                          //Make sure name only contains a-z, A-Z, 0-9, and spaces
                          return RegExp(r"^[a-zA-Z0-9 ]+$").hasMatch(val)
                              ? null
                              : "Name can only contain letters and numbers";
                        }
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        onTap: () {
                            HapticFeedback.selectionClick();
                          },
                        decoration: textInputDecoration.copyWith(
                            labelText: "Username",
                            fillColor: ColorSys.secondary,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                       
                        
                        //Check email validation
                        validator: (val) {
                          if(val!.isEmpty){
                            return "Please enter a username";
                          }
                          if(val.length < 3){
                            return "Username must be at least 3 characters";
                          }
                
                          //Make sure name only contains a-z, A-Z, 0-9, and underscores, and dashes
                          return RegExp(r"^[a-zA-Z0-9_-]+$").hasMatch(val)
                              ? null
                              : "Username can only contain a-z, 0-9, _, and -";
                
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        onTap: () {
                            HapticFeedback.selectionClick();
                          },
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            fillColor: ColorSys.secondary,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                       
                        
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
                      // PhoneInput(
                      //   countrySelectorNavigator:
                      //       const CountrySelectorNavigator.dialog(),
                      //   decoration: textInputDecoration.copyWith(
                      //     labelText: "Phone Number",
                      //   ),
                      //   shouldFormat: true,
                      //   onChanged: (PhoneNumber? number) {
                      //     setState(() {
                      //       phoneNumber = number;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        onTap: () {
                            HapticFeedback.selectionClick();
                          },
                        decoration: textInputDecoration.copyWith(
                          fillColor: ColorSys.secondary,
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
                       
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).primaryColor)
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
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Sign in here",
                                style: TextStyle(
                                    color: ColorSys.primary,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.mediumImpact();
                                   router.pushReplacement("/welcome/${widget.uid}/${widget.toProfile}");
                                  })
                          ]))
                    ]),
              ),
            )),
      ),
    );
  }
}
