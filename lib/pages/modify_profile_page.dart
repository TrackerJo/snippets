import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/templates/colorsSys.dart';
import 'package:snippets/templates/input_decoration.dart';
import 'package:snippets/widgets/custom_app_bar.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  var formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  String oldFullName = "";
  String oldUsername = "";
  String oldEmail = "";
  String oldDescription = "";

  bool isLoading = false;
  bool isLoadingPassword = false;
  bool isLoadingEmail = false;

  void getUserData() async {
    User userData = await Database()
        .getUserData(auth.FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      oldFullName = userData.displayName;
      oldUsername = userData.username;
      oldEmail = userData.email;
      oldDescription = userData.description;
      fullNameController.text = oldFullName;
      usernameController.text = oldUsername;
      descriptionController.text = oldDescription;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Modify Profile',
            showBackButton: true,
            fixRight: true,
            onBackButtonPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: const Color(0xFF232323),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
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
                        if (val!.isEmpty) {
                          return "Please enter a name";
                        }
                        //Make sure name only contains a-z, A-Z, 0-9, and spaces
                        return RegExp(r"^[a-zA-Z0-9 ]+$").hasMatch(val)
                            ? null
                            : "Name can only contain letters and numbers";
                      }),
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter a username";
                      }
                      if (val.length < 3) {
                        return "Username must be at least 3 characters";
                      }

                      //Make sure name only contains a-z, A 0-9, and underscores, and dashes
                      return RegExp(r"^[a-z0-9_-]+$").hasMatch(val)
                          ? null
                          : "Username can only contain a-z, 0-9, _, and -";
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    onTap: () => HapticFeedback.selectionClick(),
                    maxLines: 6,
                    decoration: textInputDecoration.copyWith(
                      labelText: 'Description',
                      fillColor: ColorSys.secondary,
                      counterStyle: const TextStyle(color: Colors.white),
                      // counter: Text("Characters: ${editDescription.length}/125", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                    controller: descriptionController,
                    maxLength: 125,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        confirmNewPasswordController.clear();
                      });
                      //Show change password dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: SingleChildScrollView(
                              child: AlertDialog(
                                backgroundColor: ColorSys.primaryInput,
                                title: const Text("Change Password",
                                    style: TextStyle(color: Colors.white)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      obscureText: true,
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                      },
                                      controller: currentPasswordController,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Current Password",
                                          fillColor: ColorSys.secondary,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      validator: (val) {
                                        if (val!.length < 6) {
                                          return "Password must be at least 6 characters";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      obscureText: true,
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                      },
                                      controller: newPasswordController,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "New Password",
                                          fillColor: ColorSys.secondary,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      validator: (val) {
                                        if (val!.length < 6) {
                                          return "Password must be at least 6 characters";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      obscureText: true,
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                      },
                                      controller: confirmNewPasswordController,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Confirm New Password",
                                          fillColor: ColorSys.secondary,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      validator: (val) {
                                        if (val!.length < 6) {
                                          return "Password must be at least 6 characters";
                                        } else if (confirmNewPasswordController
                                                .text !=
                                            newPasswordController.text) {
                                          return "Passwords do not match";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  isLoadingPassword
                                      ? CircularProgressIndicator(
                                          color: ColorSys.secondary,
                                        )
                                      : ElevatedButton(
                                          onPressed: () async {
                                            HapticFeedback.mediumImpact();
                                            setState(() {
                                              isLoadingPassword = true;
                                            });
                                            //Change password
                                            String res = await Auth()
                                                .changePassword(
                                                    oldEmail,
                                                    currentPasswordController
                                                        .text,
                                                    newPasswordController.text);
                                            if (res != "Done") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(res)));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Password changed successfully")));
                                              Navigator.of(context).pop();
                                            }
                                            setState(() {
                                              isLoadingPassword = false;
                                            });
                                          },
                                          style: elevatedButtonDecorationBlue,
                                          child: const Text("Change",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: elevatedButtonDecoration,
                    child: const Text("Change Password",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        confirmNewPasswordController.clear();
                      });
                      //Show change password dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: SingleChildScrollView(
                                child: AlertDialog(
                                  backgroundColor: ColorSys.primaryInput,
                                  title: const Text("Change Email",
                                      style: TextStyle(color: Colors.white)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: emailController,
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                        },
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelText: "New Email",
                                                fillColor: ColorSys.secondary,
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
                                      TextFormField(
                                        obscureText: true,
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                        },
                                        controller: currentPasswordController,
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelText: "Current Password",
                                                fillColor: ColorSys.secondary,
                                                prefixIcon: Icon(
                                                  Icons.lock,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                        validator: (val) {
                                          if (val!.length < 6) {
                                            return "Password must be at least 6 characters";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    isLoadingEmail
                                        ? CircularProgressIndicator(
                                            color: ColorSys.secondary,
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              HapticFeedback.mediumImpact();
                                              setState(() {
                                                isLoadingEmail = true;
                                              });

                                              //Change password
                                              String res = await FBDatabase(
                                                      uid: auth
                                                          .FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                  .changeUserEmail(
                                                      oldEmail,
                                                      emailController.text,
                                                      currentPasswordController
                                                          .text);
                                              if (res != "Done") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(res)));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Verification email sent, please verify your email")));
                                                Navigator.of(context).pop();
                                              }
                                              setState(() {
                                                isLoadingEmail = false;
                                              });
                                            },
                                            style: elevatedButtonDecorationBlue,
                                            child: const Text("Change",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      );
                    },
                    style: elevatedButtonDecoration,
                    child: const Text("Change Email",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 15),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorSys.primary,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              isLoading = true;
                            });
                            //Save changes
                            if (formKey.currentState!.validate()) {
                              //Save changes

                              if (oldFullName != fullNameController.text ||
                                  oldUsername !=
                                      usernameController.text.toLowerCase()) {
                                bool success = await FBDatabase(
                                        uid: auth.FirebaseAuth.instance
                                            .currentUser!.uid)
                                    .changeUserDisplayNameAndOrUserName(
                                        oldFullName != fullNameController.text
                                            ? fullNameController.text
                                            : null,
                                        oldUsername !=
                                                usernameController.text
                                                    .toLowerCase()
                                            ? usernameController.text
                                                .toLowerCase()
                                            : null);
                                if (!success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Username already exists")));
                                } else {
                                  //Show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Profile updated successfully, changes in snippets will be reflected in the next 24 hours")));
                                }
                              }
                              if (oldDescription !=
                                  descriptionController.text) {
                                await FBDatabase(
                                        uid: auth.FirebaseAuth.instance
                                            .currentUser!.uid)
                                    .updateUserDescription(
                                        descriptionController.text);
                                //Show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Description updated successfully")));
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: elevatedButtonDecoration,
                          child: const Text("Save Changes",
                              style: TextStyle(color: Colors.white)),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
