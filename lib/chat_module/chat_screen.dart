// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safewomen/chat_module/message_text_field.dart';
import 'package:safewomen/chat_module/singleMessage.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/responsive/responsive.dart';

import '../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;
  final String parentEmail;
  final String childEmail;
  final String childPhone;
  final String parentPhone;
  final String? profilePic;

  const ChatScreen(
      {super.key,
      required this.currentUserId,
      required this.friendId,
      required this.friendName,
      required this.profilePic,
      required this.parentEmail,
      required this.childPhone,
      required this.parentPhone,
      required this.childEmail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldScrollToBottom = true; // Add this flag

  String? type;
  String? myname;
  String? parentEmail;
  String? childEmail;
  String? childPhone;
  String? parentPhone;
  String? profilePic;

  getStatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .get()
        .then((value) {
      if (!mounted) return;
      setState(() {
        type = value.data()!['type'];
        myname = value.data()!['name'];
        parentEmail = value.data()!['parentEmail'];
        childEmail = value.data()!['childEmail'];
        childPhone = value.data()!['childPhone'];
        parentPhone = value.data()!['parentPhone'];
      });
    });
  }

  @override
  void initState() {
    getStatus();
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 50),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*       appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(widget.friendName),
          centerTitle: true,
          leading: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new IconButton(
                icon: new Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.profilePic != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.profilePic),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 40,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ), */

        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor:
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.dark,
              // systemNavigationBarColor:
              //     Theme.of(context).colorScheme.surfaceVariant,
              systemNavigationBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      (widget.friendName),
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    type == "child"
                        ? Text(
                            overflow: TextOverflow.ellipsis,
                            (widget.parentEmail),
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                fontWeight: FontWeight.normal),
                          )
                        : Text(
                            overflow: TextOverflow.ellipsis,
                            (widget.childEmail),
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                fontWeight: FontWeight.normal),
                          )
                  ],
                ),
              ),
            ],
          ),

          centerTitle: false,
          //toolbarHeight: 100,
          // leadingWidth: MediaQuery.of(context).size.width * 0.23,

          actions: [
            type == "parent"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            widget.childPhone);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () async {
                        await FlutterPhoneDirectCaller.callNumber(
                            widget.parentPhone);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.phone_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
          ],

          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                  child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: CircleAvatar(
                      backgroundImage: widget.profilePic != null
                          ? NetworkImage(widget.profilePic!)
                          : null,
                      child: widget.profilePic == null
                          ? Icon(
                              Icons.account_circle,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ) // Display an icon if profilePic is null
                          : null, // Set to null if profilePic is not null
                    )),
              )),
            ],
          ),
          leadingWidth: 70,
          toolbarHeight: 80,
        ),
        // floatingActionButton: // Scroll to Top Button
        //     Padding(
        //   padding: const EdgeInsets.only(bottom: 70.0),
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: IconButton(
        //       icon: Icon(Icons.keyboard_arrow_up),
        //       onPressed: () {
        //         _scrollController.animateTo(
        //           0,
        //           duration: Duration(milliseconds: 500),
        //           curve: Curves.easeOut,
        //         );
        //       },
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentUserId)
                      .collection('messages')
                      .doc(widget.friendId)
                      .collection('chats')
                      .orderBy('date', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            type == "parent"
                                ? "TALK WITH CHILD"
                                : "TALK WITH PARENT",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5)),
                          ),
                        );
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      return InkWell(
                        // onTap: () {
                        //   _scrollController.animateTo(
                        //       _scrollController.position.maxScrollExtent,
                        //       duration: Duration(milliseconds: 500),
                        //       curve: Curves.easeOut);
                        // },
                        child: ListView.builder(
                          //reverse: true,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isMe = snapshot.data!.docs[index]
                                    ['senderId'] ==
                                FirebaseAuth.instance.currentUser!.uid;
                            final data = snapshot.data!.docs[index];
                            return Dismissible(
                              key: UniqueKey(),
                              confirmDismiss: (direction) {
                                return showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: AlertDialog(
                                      title: Text(
                                        "Delete",
                                        textAlign: TextAlign.left,
                                      ),
                                      actions: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Are you sure to delete the message ?",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Responsive(
                                          child: PrimaryButton(
                                            title: "NO",
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Responsive(
                                          child: PrimaryButton(
                                            title: "YES",
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.currentUserId)
                                                  .collection('messages')
                                                  .doc(widget.friendId)
                                                  .collection('chats')
                                                  .doc(data.id)
                                                  .delete();
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.friendId)
                                                  .collection('messages')
                                                  .doc(widget.currentUserId)
                                                  .collection('chats')
                                                  .doc(data.id)
                                                  .delete()
                                                  .then((value) =>
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Message deleted successfully'));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              onDismissed: (direction) async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.currentUserId)
                                    .collection('messages')
                                    .doc(widget.friendId)
                                    .collection('chats')
                                    .doc(data.id)
                                    .delete();
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.friendId)
                                    .collection('messages')
                                    .doc(widget.currentUserId)
                                    .collection('chats')
                                    .doc(data.id)
                                    .delete()
                                    .then((value) => Fluttertoast.showToast(
                                        msg: 'Message deleted successfully'));
                              },
                              child: SingleMessage(
                                message: data['message'],
                                date: data['date'],
                                isMe: isMe,
                                friendName: widget.friendName,
                                myName: myname,
                                type: data['type'],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return progressIndicator(context);
                  },
                ),
              ),
            ),
            /*           Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 35,
                child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    elevation: 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.pink,
                      size: 35,
                    ),
                    onPressed: () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    }),
              ),
            ),
           */
            MessageTextField(
              currentId: widget.currentUserId,
              friendId: widget.friendId,
              scrollController: _scrollController,
            ),
          ],
        ));
  }
}
