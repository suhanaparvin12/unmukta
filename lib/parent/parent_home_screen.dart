// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safewomen/chat_module/chat_screen.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/parent/parent_profile_update.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:safewomen/utils/constants.dart';
import '../child/child_login_screen.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  String menu = "assets/svg/menu.svg";
  String? profilePic;
  String? name;
  String? email;
  String? phone;
  String? type;
  TextEditingController person = TextEditingController();
  bool isSearching = false;

  getProfilePic() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        profilePic = value.docs.first['profilePic'];
        name = value.docs.first['name'];
        email = value.docs.first['Email'];
        phone = value.docs.first['Phone'];
        type = value.docs.first['type'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: BackdropFilter(
      //   filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      //   child: Drawer(
      //     backgroundColor: Colors.white,
      //     shape: const RoundedRectangleBorder(
      //       // <-- SEE HERE
      //       borderRadius: BorderRadius.horizontal(
      //         right: Radius.circular(25.0),
      //       ),
      //     ),
      //     child: ListView(
      //       children: <Widget>[
      //         Padding(
      //           padding: const EdgeInsets.all(15.0),
      //           child: Column(
      //             children: [
      //               DrawerHeader(
      //                 child: InkWell(
      //                   onTap: () {
      //                     goTo(context, parentProfilePage());
      //                   },
      //                   child: Container(
      //                     child: profilePic != null
      //                         ? CircleAvatar(
      //                             backgroundColor: Colors.pink.shade200,
      //                             radius: 90,
      //                             child: CircleAvatar(
      //                               backgroundImage: NetworkImage(profilePic!),
      //                               radius: 65,
      //                             ),
      //                           )
      //                         : CircleAvatar(
      //                             radius: 60,
      //                             child: Icon(
      //                               Icons.account_circle_rounded,
      //                               size: 60,
      //                             ),
      //                           ),
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 decoration: BoxDecoration(
      //                   color: Colors.pink.shade50,
      //                   borderRadius: BorderRadius.circular(10),
      //                   border:
      //                       Border.all(color: Colors.pink.shade300, width: 2),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(15.0),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       Row(
      //                         children: [
      //                           Icon(
      //                             Icons.account_circle_rounded,
      //                             color: Colors.pink,
      //                             size: 25,
      //                           ),
      //                           Flexible(
      //                             child: Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   horizontal: 8.0),
      //                               child: Text(
      //                                 overflow: TextOverflow.ellipsis,
      //                                 name.toString(),
      //                                 style: TextStyle(
      //                                     fontSize: 18,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.pink),
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       Row(
      //                         children: [
      //                           Icon(
      //                             Icons.phone_rounded,
      //                             color: Colors.pink,
      //                             size: 25,
      //                           ),
      //                           Flexible(
      //                             child: Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   horizontal: 8.0),
      //                               child: Text(
      //                                 overflow: TextOverflow.ellipsis,
      //                                 phone.toString(),
      //                                 style: TextStyle(
      //                                     fontSize: 18,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.pink),
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       Row(
      //                         children: [
      //                           Icon(
      //                             Icons.email_rounded,
      //                             color: Colors.pink,
      //                             size: 25,
      //                           ),
      //                           Flexible(
      //                             child: Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   horizontal: 8.0),
      //                               child: Text(
      //                                 overflow: TextOverflow.ellipsis,
      //                                 email.toString(),
      //                                 style: TextStyle(
      //                                     fontSize: 18,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.pink),
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         /*
      //         ListTile(
      //           title: TextButton(
      //             onPressed: () async {
      //               try {
      //                 await FirebaseAuth.instance.signOut();
      //                 goTo(context, LoginScreen());
      //               } on FirebaseAuthException catch (e) {
      //                 dialogueBox(context, e.toString());
      //               }
      //             },
      //             child: Text(
      //               "SIGN OUT",
      //             ),
      //           ),
      //         ), */
      //         /* SecondaryButton(
      //             title: 'UPDATE PROFILE',
      //             onPressed: () {
      //               goTo(context, parentProfilePage());
      //             }), */

      //         SizedBox(
      //           height: 20,
      //         ),
      //         Expanded(
      //           child: Align(
      //             alignment: Alignment.bottomCenter,
      //             child: Padding(
      //                 padding: const EdgeInsets.only(bottom: 15.0),
      //                 child: Container(
      //                     width: MediaQuery.of(context).size.width * 0.5,
      //                     child: Column(
      //                       children: [
      //                         SecondaryButton(
      //                             title: 'Update Profile',
      //                             onPressed: () {
      //                               goTo(context, parentProfilePage());
      //                             }),
      //                         SecondaryButton(
      //                           title: 'Logout',
      //                           onPressed: () async {
      //                             try {
      //                               MySharedPrefference.clear();
      //                               await FirebaseAuth.instance.signOut();
      //                               //goTo(context, LoginScreen());
      //                               Navigator.pushReplacement(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                     builder: (context) => LoginScreen()),
      //                               );
      //                             } on FirebaseAuthException catch (e) {
      //                               dialogueBox(
      //                                   context, "Warning", e.toString(), 'Ok');
      //                             }
      //                           },
      //                         ),
      //                       ],
      //                     ))),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),

      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
            // systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //       statusBarColor: Colors.transparent,
      //       systemNavigationBarIconBrightness: Brightness.dark,
      //       // systemNavigationBarColor:
      //       //     Theme.of(context).colorScheme.surfaceVariant,
      //       systemNavigationBarColor: Colors.white,
      //       statusBarIconBrightness: Brightness.dark),
      //   title: Text(
      //     'Chat',
      //     style: TextStyle(
      //         fontSize: 20,
      //         color: Theme.of(context).colorScheme.primary,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   // actions: [
      //   //   Padding(
      //   //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //   //     child: Icon(
      //   //       Icons.search_rounded,
      //   //       color: Colors.pink,
      //   //     ),
      //   //   ),
      //   // ],
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0),
      //       child: Align(
      //         alignment: Alignment.topCenter,
      //         child: IconButton(
      //           icon: Icon(
      //             Icons.logout_outlined,
      //             color: Theme.of(context).colorScheme.primary,
      //             size: 20,
      //           ),
      //           onPressed: () {
      //             MySharedPrefference.clear();
      //             FirebaseAuth.instance.signOut();
      //             Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(builder: (context) => LoginScreen()),
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: SvgPicture.asset(
      //           menu,
      //           color: Theme.of(context).colorScheme.primary,
      //         ),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      //       );
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {},
        child: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
        ),
      ),
      body: SafeArea(
        child: SliderDrawer(
          slideDirection: SlideDirection.LEFT_TO_RIGHT,
          key: _key,
          appBar: SliderAppBar(
            appBarPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            drawerIconColor: Theme.of(context).colorScheme.primary,
            appBarColor: Theme.of(context).colorScheme.surface,
            title: isSearching
                ? TextFormField(
                    textCapitalization: TextCapitalization.words,
                    maxLines: 1,
                    autofocus: false,
                    controller: person,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 17, 0),
                            width: 2,
                          )),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 160, 11, 0),
                            width: 2.5,
                          )),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(22),
                      // filled: true,
                      suffixIcon: person.text.isNotEmpty
                          ? IconButton(
                              icon: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.clear_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  person.clear();
                                });
                              },
                            )
                          : null,
                      hintText: 'Search person',
                      // prefixIcon: Container(
                      //   width: 40,
                      //   height: 40,
                      //   margin: const EdgeInsets.all(10),
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context)
                      //         .colorScheme
                      //         .inversePrimary
                      //         .withOpacity(0.5),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Center(
                      //       child: Icon(
                      //     Icons.person_outline,
                      //     color: Theme.of(context).colorScheme.primary,
                      //     size: 20,
                      //   )),
                      // ),
                      // fillColor: const Color.fromARGB(15, 0, 0, 0),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                  )
                : Text(
                    "उन्मुक्त",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            trailing: IconButton(
              icon: Icon(
                Icons.logout_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              onPressed: () {
                MySharedPrefference.clear();
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            isTitleCenter: true,
          ),
          slider: Container(
            height: double.maxFinite,
            child: PhysicalModel(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.15),
              // elevation: 8,
              // shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          profilePic != null
                              ? CircleAvatar(
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(profilePic!),
                                    radius: 40,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  radius: 40,
                                  child: Icon(
                                    Icons.boy_outlined,
                                    size: 40,
                                  ),
                                ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              goTo(context, parentProfilePage());
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Text(
                                        name ?? "Loading",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tap to view profile",
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MySharedPrefference.clear();
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Logout",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: Responsive(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('type', isEqualTo: 'child')
                    .where('parentEmail',
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: progressIndicator(context));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final d = snapshot.data!.docs[index];
                      if (person.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.2),

                              // border: Border.all(color: Colors.pink.shade200, width: 2),
                            ),
                            child: ListTile(
                              onTap: () {
                                goTo(
                                  context,
                                  ChatScreen(
                                    currentUserId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    friendId: d.id,
                                    friendName: d['name'],
                                    profilePic: d['profilePic'] == null
                                        ? d['profilePic'].toString()
                                        : d['profilePic'],
                                    parentEmail: d['parentEmail'],
                                    childEmail: d['Email'],
                                    childPhone: d['Phone'],
                                    parentPhone: d['parentPhone'],
                                  ),
                                );
                              },
                              enableFeedback: true,
                              trailing: Wrap(
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.phone_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await FlutterPhoneDirectCaller
                                            .callNumber(d['Phone']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                d['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 17),
                              ),
                              subtitle: Text(
                                d['Email'],
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    fontSize: 14),
                              ),
                              /* leading: Icon(
                              Icons.account_circle_rounded,
                              color: primaryColor,
                              size: 50,
                            ), */
                              leading: d['profilePic'] != null
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 2, sigmaY: 2),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 2, sigmaY: 2),
                                                child: AlertDialog(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000000),
                                                    child: CachedNetworkImage(
                                                      imageUrl: d['profilePic'],
                                                      height: 250,
                                                      width: 250,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(d['profilePic']),
                                      ),
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                            ),
                          ),
                        );
                      }
                      if (d['name']
                              .toString()
                              .toString()
                              .toLowerCase()
                              .contains(person.text.toLowerCase()) ||
                          d['Email']
                              .toString()
                              .toLowerCase()
                              .contains(person.text.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.2),

                              // border: Border.all(color: Colors.pink.shade200, width: 2),
                            ),
                            child: ListTile(
                              onTap: () {
                                goTo(
                                  context,
                                  ChatScreen(
                                    currentUserId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    friendId: d.id,
                                    friendName: d['name'],
                                    profilePic: d['profilePic'] == null
                                        ? d['profilePic'].toString()
                                        : d['profilePic'],
                                    parentEmail: d['parentEmail'],
                                    childEmail: d['Email'],
                                    childPhone: d['Phone'],
                                    parentPhone: d['parentPhone'],
                                  ),
                                );
                              },
                              enableFeedback: true,
                              trailing: Wrap(
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.phone_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await FlutterPhoneDirectCaller
                                            .callNumber(d['Phone']);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                d['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 17),
                              ),
                              subtitle: Text(
                                d['Email'],
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                    fontSize: 14),
                              ),
                              /* leading: Icon(
                              Icons.account_circle_rounded,
                              color: primaryColor,
                              size: 50,
                            ), */
                              leading: d['profilePic'] != null
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 2, sigmaY: 2),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 2, sigmaY: 2),
                                                child: AlertDialog(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000000),
                                                    child: CachedNetworkImage(
                                                      imageUrl: d['profilePic'],
                                                      height: 250,
                                                      width: 250,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(d['profilePic']),
                                      ),
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Container(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
