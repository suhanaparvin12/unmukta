// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:safewomen/chat_module/chat_screen.dart';
import 'package:safewomen/responsive/responsive.dart';

import '../../utils/constants.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // const ChatPage({super.key});
  bool isSearching = false;
  TextEditingController person = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
        title: isSearching == false
            ? Text(
                'Chat With Guardian',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              )
            : TextFormField(
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
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Icon(
                              Icons.clear_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            )),
                          ),
                          onPressed: () {
                            setState(() {
                              person.clear();
                            });
                          },
                        )
                      : null,
                  hintText: 'Search person',
                  prefixIcon: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    )),
                  ),
                  // fillColor: const Color.fromARGB(15, 0, 0, 0),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('childEmail',
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];

              if (person.text.isEmpty) {
                return Responsive(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.2),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            width: 3),
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
                              profilePic: d['profilePic'],
                              parentEmail: d['Email'],
                              childEmail: d['childEmail'],
                              childPhone: d['Phone'],
                              parentPhone: d['childPhone'],
                            ),
                          );
                        },
                        title: Text(
                          d['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.primary),
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      d['Phone']);
                                },
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(d['Email']),
                        /* leading: Icon(
                        Icons.account_circle_rounded,
                        color: primaryColor,
                        size: 50,
                      ), */
                        enableFeedback: true,
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
                                            backgroundColor: Colors.transparent,
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
                return Responsive(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.2),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            width: 3),
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
                              profilePic: d['profilePic'],
                              parentEmail: d['Email'],
                              childEmail: d['childEmail'],
                              childPhone: d['Phone'],
                              parentPhone: d['childPhone'],
                            ),
                          );
                        },
                        title: Text(
                          d['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.primary),
                              child: IconButton(
                                icon: Icon(
                                  Icons.phone_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      d['Phone']);
                                },
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(d['Email']),
                        /* leading: Icon(
                        Icons.account_circle_rounded,
                        color: primaryColor,
                        size: 50,
                      ), */
                        enableFeedback: true,
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
                                            backgroundColor: Colors.transparent,
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
    );
  }
}
