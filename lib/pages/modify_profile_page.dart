import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippets/api/auth.dart';
import 'package:snippets/api/database.dart';
import 'package:snippets/api/fb_database.dart';
import 'package:snippets/constants.dart';
import 'package:snippets/helper/helper_function.dart';
import 'package:snippets/main.dart';
import 'package:snippets/widgets/background_tile.dart';
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
      child: Stack(
        children: [
          BackgroundTile(),
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(
                title: 'Modify Profile',
                showBackButton: true,
                fixRight: true,
                onBackButtonPressed: () async {
                  String hapticFeedback =
                      await HelperFunctions.getHapticFeedbackSF();
                  if (hapticFeedback == "normal") {
                    HapticFeedback.mediumImpact();
                  } else if (hapticFeedback == "light") {
                    HapticFeedback.lightImpact();
                  } else if (hapticFeedback == "heavy") {
                    HapticFeedback.heavyImpact();
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
            backgroundColor: Colors.transparent,
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
                          decoration: styling.textInputDecoration().copyWith(
                              labelText: "Display Name",
                              fillColor: styling.secondary,
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
                        decoration: styling.textInputDecoration().copyWith(
                            labelText: "Username",
                            fillColor: styling.secondary,
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
                        maxLines: 6,
                        decoration: styling.textInputDecoration().copyWith(
                              labelText: 'Description',
                              fillColor: styling.secondary,
                              counterStyle:
                                  const TextStyle(color: Colors.white),
                              // counter: Text("Characters: ${editDescription.length}/125", style: TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                        controller: descriptionController,
                        maxLength: 125,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String hapticFeedback =
                              await HelperFunctions.getHapticFeedbackSF();
                          if (hapticFeedback == "normal") {
                            HapticFeedback.mediumImpact();
                          } else if (hapticFeedback == "light") {
                            HapticFeedback.lightImpact();
                          } else if (hapticFeedback == "heavy") {
                            HapticFeedback.heavyImpact();
                          }
                          setState(() {
                            confirmNewPasswordController.clear();
                          });
                          //Show change password dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: SingleChildScrollView(
                                    child: AlertDialog(
                                      backgroundColor: styling.background,
                                      title: Text("Change Password",
                                          style: TextStyle(
                                              color: styling.theme ==
                                                      "colorful-light"
                                                  ? styling.secondaryDark
                                                  : styling.backgroundText)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            obscureText: true,
                                            onTap: () async {
                                              String hapticFeedback =
                                                  await HelperFunctions
                                                      .getHapticFeedbackSF();
                                              if (hapticFeedback == "normal") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "light") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "heavy") {
                                                HapticFeedback.mediumImpact();
                                              }
                                            },
                                            controller:
                                                currentPasswordController,
                                            decoration: styling
                                                .textInputDecoration()
                                                .copyWith(
                                                    labelText:
                                                        "Current Password",
                                                    fillColor:
                                                        styling.secondary,
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
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            obscureText: true,
                                            onTap: () async {
                                              String hapticFeedback =
                                                  await HelperFunctions
                                                      .getHapticFeedbackSF();
                                              if (hapticFeedback == "normal") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "light") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "heavy") {
                                                HapticFeedback.mediumImpact();
                                              }
                                            },
                                            controller: newPasswordController,
                                            decoration: styling
                                                .textInputDecoration()
                                                .copyWith(
                                                    labelText: "New Password",
                                                    fillColor:
                                                        styling.secondary,
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
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            obscureText: true,
                                            onTap: () async {
                                              String hapticFeedback =
                                                  await HelperFunctions
                                                      .getHapticFeedbackSF();
                                              if (hapticFeedback == "normal") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "light") {
                                                HapticFeedback.selectionClick();
                                              } else if (hapticFeedback ==
                                                  "heavy") {
                                                HapticFeedback.mediumImpact();
                                              }
                                            },
                                            controller:
                                                confirmNewPasswordController,
                                            decoration: styling
                                                .textInputDecoration()
                                                .copyWith(
                                                    labelText:
                                                        "Confirm New Password",
                                                    fillColor:
                                                        styling.secondary,
                                                    prefixIcon: Icon(
                                                      Icons.lock,
                                                      color: Theme.of(context)
                                                          .primaryColor,
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
                                          onPressed: () async {
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
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: styling.theme ==
                                                          "colorful-light"
                                                      ? styling.secondaryDark
                                                      : styling
                                                          .backgroundText)),
                                        ),
                                        isLoadingPassword
                                            ? CircularProgressIndicator(
                                                color: styling.secondary,
                                              )
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  String hapticFeedback =
                                                      await HelperFunctions
                                                          .getHapticFeedbackSF();
                                                  if (hapticFeedback ==
                                                      "normal") {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                  } else if (hapticFeedback ==
                                                      "light") {
                                                    HapticFeedback
                                                        .lightImpact();
                                                  }
                                                  setState(() {
                                                    isLoadingPassword = true;
                                                  });
                                                  //Change password
                                                  String res = await Auth()
                                                      .changePassword(
                                                          oldEmail,
                                                          currentPasswordController
                                                              .text,
                                                          newPasswordController
                                                              .text);
                                                  if (res != "Done") {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content:
                                                                Text(res)));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "Password changed successfully")));
                                                    Navigator.of(context).pop();
                                                  }
                                                  setState(() {
                                                    isLoadingPassword = false;
                                                  });
                                                },
                                                style: styling
                                                    .elevatedButtonDecoration(),
                                                child: Text("Change",
                                                    style: TextStyle(
                                                      color: styling.theme ==
                                                              "colorful-light"
                                                          ? styling
                                                              .secondaryDark
                                                          : Colors.white,
                                                    )),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: styling.elevatedButtonDecoration(),
                        child: Text("Change Password",
                            style: TextStyle(
                              color: styling.theme == "colorful-light"
                                  ? styling.primaryDark
                                  : Colors.white,
                            )),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String hapticFeedback =
                              await HelperFunctions.getHapticFeedbackSF();
                          if (hapticFeedback == "normal") {
                            HapticFeedback.mediumImpact();
                          } else if (hapticFeedback == "light") {
                            HapticFeedback.lightImpact();
                          } else if (hapticFeedback == "heavy") {
                            HapticFeedback.heavyImpact();
                          }
                          setState(() {
                            confirmNewPasswordController.clear();
                          });
                          //Show change password dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        backgroundColor: styling.background,
                                        title: Text("Change Email",
                                            style: TextStyle(
                                                color: styling.theme ==
                                                        "colorful-light"
                                                    ? styling.secondaryDark
                                                    : styling.backgroundText)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: emailController,
                                              onTap: () async {
                                                String hapticFeedback =
                                                    await HelperFunctions
                                                        .getHapticFeedbackSF();
                                                if (hapticFeedback ==
                                                    "normal") {
                                                  HapticFeedback
                                                      .selectionClick();
                                                } else if (hapticFeedback ==
                                                    "light") {
                                                  HapticFeedback
                                                      .selectionClick();
                                                }
                                              },
                                              decoration: styling
                                                  .textInputDecoration()
                                                  .copyWith(
                                                      labelText: "New Email",
                                                      fillColor:
                                                          styling.secondary,
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
                                              onTap: () async {
                                                String hapticFeedback =
                                                    await HelperFunctions
                                                        .getHapticFeedbackSF();
                                                if (hapticFeedback ==
                                                    "normal") {
                                                  HapticFeedback
                                                      .selectionClick();
                                                } else if (hapticFeedback ==
                                                    "light") {
                                                  HapticFeedback
                                                      .selectionClick();
                                                }
                                              },
                                              controller:
                                                  currentPasswordController,
                                              decoration: styling
                                                  .textInputDecoration()
                                                  .copyWith(
                                                      labelText:
                                                          "Current Password",
                                                      fillColor:
                                                          styling.secondary,
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
                                            onPressed: () async {
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
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                    color: styling.theme ==
                                                            "colorful-light"
                                                        ? styling.secondaryDark
                                                        : styling
                                                            .backgroundText)),
                                          ),
                                          isLoadingEmail
                                              ? CircularProgressIndicator(
                                                  color: styling.secondary,
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    String hapticFeedback =
                                                        await HelperFunctions
                                                            .getHapticFeedbackSF();
                                                    if (hapticFeedback ==
                                                        "normal") {
                                                      HapticFeedback
                                                          .mediumImpact();
                                                    } else if (hapticFeedback ==
                                                        "light") {
                                                      HapticFeedback
                                                          .lightImpact();
                                                    }
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
                                                            emailController
                                                                .text,
                                                            currentPasswordController
                                                                .text);
                                                    if (res != "Done") {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      res)));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "Verification email sent, please verify your email")));
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                    setState(() {
                                                      isLoadingEmail = false;
                                                    });
                                                  },
                                                  style: styling
                                                      .elevatedButtonDecoration(),
                                                  child: Text("Change",
                                                      style: TextStyle(
                                                        color: styling.theme ==
                                                                "colorful-light"
                                                            ? styling
                                                                .secondaryDark
                                                            : Colors.white,
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        style: styling.elevatedButtonDecoration(),
                        child: Text("Change Email",
                            style: TextStyle(
                              color: styling.theme == "colorful-light"
                                  ? styling.primaryDark
                                  : Colors.white,
                            )),
                      ),
                      const SizedBox(height: 15),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: styling.primary,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                String hapticFeedback =
                                    await HelperFunctions.getHapticFeedbackSF();
                                if (hapticFeedback == "normal") {
                                  HapticFeedback.mediumImpact();
                                } else if (hapticFeedback == "light") {
                                  HapticFeedback.lightImpact();
                                } else if (hapticFeedback == "heavy") {
                                  HapticFeedback.heavyImpact();
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                //Save changes
                                if (formKey.currentState!.validate()) {
                                  //Save changes

                                  if (oldFullName != fullNameController.text ||
                                      oldUsername !=
                                          usernameController.text
                                              .toLowerCase()) {
                                    bool success = await FBDatabase(
                                            uid: auth.FirebaseAuth.instance
                                                .currentUser!.uid)
                                        .changeUserDisplayNameAndOrUserName(
                                            oldFullName !=
                                                    fullNameController.text
                                                ? fullNameController.text.trim()
                                                : null,
                                            oldUsername !=
                                                    usernameController.text
                                                        .toLowerCase()
                                                ? usernameController.text
                                                    .toLowerCase()
                                                    .trim()
                                                : null);
                                    if (!success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Username already exists")));
                                    } else {
                                      //Show snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
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
                                            descriptionController.text.trim());
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
                              style: styling.elevatedButtonDecoration(),
                              child: Text("Save Changes",
                                  style: TextStyle(
                                    color: styling.theme == "colorful-light"
                                        ? styling.primaryDark
                                        : Colors.white,
                                  )),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
