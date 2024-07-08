// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:safewomen/child/bottom_screens/add_review_bottomsheet.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/components/custom_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  TextEditingController writerC = TextEditingController();
  String? dateTime = DateFormat('dd-MM-yyyy KK:mm:ss').format(DateTime.now());
  bool isSaving = false;
  String? place;
  String? email;
  String? profilePic;
  String? name;

  bool isSearching = false;
  TextEditingController placeName = TextEditingController();

  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (!mounted) return;

      setState(() {
        name = value.docs.first['name'];
        email = value.docs.first['Email'];
        //id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection('reviews');

  savePreview() async {
    if (locationC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Location cannot be empty");
      locationC.clear();
      viewsC.clear();
      writerC.clear();
    } else if (viewsC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Review cannot be empty");
      locationC.clear();
      viewsC.clear();
      writerC.clear();
    } else if (writerC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Name cannot be empty");
      locationC.clear();
      viewsC.clear();
      writerC.clear();
    } else {
      setState(() {
        isSaving = true;
      });
      await FirebaseFirestore.instance.collection('reviews').add({
        'location': locationC.text,
        'views': viewsC.text,
        'writer': writerC.text,
        'dateTime': '$dateTime',
      }).then((value) {
        setState(() {
          isSaving = false;
          Fluttertoast.showToast(msg: 'review uploaded successfully');
        });
      });
    }
  }

  Future<void> _delete(String reviewId) async {
    await _reviews.doc(reviewId).delete();
    Fluttertoast.showToast(msg: 'Successfully deleted');
  }

  openMap(String place) async {
    final url = "https://www.google.com/maps/place/$place";

    final Uri _url = Uri.parse(url);

    await launchUrl(_url, mode: LaunchMode.platformDefault);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextFormField(
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
                autofocus: false,
                controller: placeName,
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
                  suffixIcon: placeName.text.isNotEmpty
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
                              placeName.clear();
                            });
                          },
                        )
                      : null,
                  hintText: 'Search places',
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
                      Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    )),
                  ),
                  // fillColor: const Color.fromARGB(15, 0, 0, 0),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
              )
            : Text(
                'Places Reviews',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
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
        leading: null,
      ),

      ///
      ///
      ///
      ///

      ///
      ///
      body: isSaving == true
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('reviews')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final data = snapshot.data!.docs[index];
                            if (placeName.text.isEmpty) {
                              return Responsive(
                                child: GestureDetector(
                                    onTap: () {
                                      openMap(data['location']);
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: GestureDetector(
                                            onTap: () {
                                              openMap(data['location']);
                                            },
                                            child: AlertDialog(
                                              icon: Container(
                                                margin: EdgeInsets.only(
                                                    left: 95, right: 95),
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                data['location'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Review - ' +
                                                            data['views'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Posted by - ' +
                                                            data['writer'],
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Posted on - ' +
                                                            data['dateTime'],
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.2),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['location'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Review - ' +
                                                          data['views'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Posted by - ' +
                                                          data['writer'] +
                                                          '\n' +
                                                          data['dateTime']
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    // Text(
                                                    //   'Posted on - '.toUpperCase() +
                                                    //       data['dateTime']
                                                    //           .toString()
                                                    //           .toUpperCase(),
                                                    //   style: TextStyle(
                                                    //       fontStyle: FontStyle.italic,
                                                    //       fontSize: 12),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              );
                            }
                            if (data['location']
                                    .toString()
                                    .toLowerCase()
                                    .contains(placeName.text.toLowerCase()) ||
                                data['writer']
                                    .toString()
                                    .toLowerCase()
                                    .contains(placeName.text.toLowerCase())) {
                              return Responsive(
                                child: GestureDetector(
                                    onTap: () {
                                      openMap(data['location']);
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: GestureDetector(
                                            onTap: () {
                                              openMap(data['location']);
                                            },
                                            child: AlertDialog(
                                              icon: Container(
                                                margin: EdgeInsets.only(
                                                    left: 95, right: 95),
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                data['location'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                              ),
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Review - ' +
                                                            data['views'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Posted by - ' +
                                                            data['writer'],
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Posted on - ' +
                                                            data['dateTime'],
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.2),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['location'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Review - ' +
                                                          data['views'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Posted by - ' +
                                                          data['writer'] +
                                                          '\n' +
                                                          data['dateTime']
                                                              .toString()
                                                              .toUpperCase(),
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    // Text(
                                                    //   'Posted on - '.toUpperCase() +
                                                    //       data['dateTime']
                                                    //           .toString()
                                                    //           .toUpperCase(),
                                                    //   style: TextStyle(
                                                    //       fontStyle: FontStyle.italic,
                                                    //       fontSize: 12),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
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
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              builder: (BuildContext context) {
                return AddReviewBottomSheet(
                  name: name.toString(),
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        child: const Icon(
          Icons.edit_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
