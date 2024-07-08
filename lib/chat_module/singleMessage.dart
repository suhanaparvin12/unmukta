import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final String? type;
  final String? friendName;
  final String? myName;
  final Timestamp? date;

  const SingleMessage(
      {super.key,
      this.message,
      this.isMe,
      this.image,
      this.type,
      this.friendName,
      this.myName,
      this.date});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime d = DateTime.parse(date!.toDate().toString());
    String cdate = "${d.hour}" +
        ":" +
        "${d.minute}" +
        "   " +
        "${d.day}" +
        "-" +
        "${d.month}" +
        "-" +
        "${d.year}";
    return type == "text"
        ? Align(
            alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width / 2,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMe!
                          ? Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.35)
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: isMe!
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                      // border: isMe!
                      //     ? Border.all(color: Colors.pink, width: 2)
                      //     : Border.all(color: Colors.purple, width: 2)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    constraints: BoxConstraints(
                      maxWidth: size.width / 2,
                    ),
                    alignment:
                        isMe! ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      children: [
                        // isMe!
                        //     ? Divider(
                        //         color: Colors.pink,
                        //         thickness: 0.5,
                        //       )
                        //     : Divider(
                        //         color: Colors.purple,
                        //         thickness: 0.5,
                        //       ),
                        Text(
                          message!,
                          textAlign: isMe! ? TextAlign.end : TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            color: isMe! ? Colors.black : Colors.white,
                          ),
                        ),
                        // isMe!
                        //     ? Divider(
                        //         color: Colors.pink,
                        //         thickness: 0.5,
                        //       )
                        //     : Divider(
                        //         color: Colors.purple,
                        //         thickness: 0.5,
                        //       ),
                      ],
                    ),
                  ),
                  Align(
                      alignment:
                          isMe! ? Alignment.bottomRight : Alignment.bottomLeft,
                      child: Text(
                        "$cdate",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      )),
                ],
              ),
            ),
          )
        : type == 'img'
            ? Align(
                alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  /* 
                  height: size.height / 2.5,
                  width: size.width, */
                  constraints: BoxConstraints(
                    maxWidth: size.width / 2,
                  ),
                  alignment:
                      isMe! ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: isMe!
                                ? Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.35)
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: isMe!
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                            // border: isMe!
                            //     ? Border.all(color: Colors.pink, width: 2)
                            //     : Border.all(color: Colors.purple, width: 2)),
                          ),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: size.width / 2,
                          ),
                          alignment: isMe!
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            children: [
                              // isMe!
                              //     ? const Divider(
                              //         color: Colors.pink,
                              //         thickness: 0.5,
                              //       )
                              //     : const Divider(
                              //         color: Colors.purple,
                              //         thickness: 0.5,
                              //       ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            scrollable: true,
                                            content: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                imageUrl: message!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: progressIndicator(
                                                      context),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(
                                                        Icons.error_outline),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: message!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50.0, vertical: 10),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          // minHeight: 5,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error_outline),
                                  ),
                                ),
                              ),
                              // isMe!
                              //     ? const Divider(
                              //         color: Colors.pink,
                              //         thickness: 0.5,
                              //       )
                              //     : const Divider(
                              //         color: Colors.purple,
                              //         thickness: 0.5,
                              //       ),
                            ],
                          )),
                      Align(
                          alignment: isMe!
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Text(
                            "$cdate",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          )),
                    ],
                  ),
                ),
              )
            : Align(
                alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width / 2,
                  ),
                  alignment:
                      isMe! ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: isMe!
                                ? Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.35)
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: isMe!
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                            // border: isMe!
                            //     ? Border.all(color: Colors.pink, width: 2)
                            //     : Border.all(color: Colors.purple, width: 2)),
                          ),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: size.width / 2,
                          ),
                          alignment: isMe!
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            children: [
                              // isMe!
                              //     ? const Divider(
                              //         color: Colors.pink,
                              //         thickness: 0.5,
                              //       )
                              //     : const Divider(
                              //         color: Colors.purple,
                              //         thickness: 0.5,
                              //       ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () async {
                                      await launchUrl(Uri.parse("$message"));
                                    },
                                    child: Text(
                                      message!,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: isMe!
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  )),
                              // isMe!
                              //     ? const Divider(
                              //         color: Colors.pink,
                              //         thickness: 0.5,
                              //       )
                              //     : const Divider(
                              //         color: Colors.purple,
                              //         thickness: 0.5,
                              //       ),
                            ],
                          )),
                      Align(
                          alignment: isMe!
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Text(
                            "$cdate",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black54),
                          )),
                    ],
                  ),
                ),
              );
  }
}
