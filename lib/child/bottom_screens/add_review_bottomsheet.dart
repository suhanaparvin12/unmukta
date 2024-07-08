import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/responsive/responsive.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String name;
  const AddReviewBottomSheet({
    super.key,
    required this.name,
  });

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationC = TextEditingController();
  TextEditingController viewsC = TextEditingController();
  TextEditingController writerC = TextEditingController();
  ScrollController scrollController = ScrollController();
  String? dateTime = DateFormat('dd-MM-yyyy KK:mm:ss').format(DateTime.now());
  bool isSaving = false;

  // String? email;
  // String? profilePic;
  // String? name;
  // getDate() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     if (!mounted) return;

  //     setState(() {
  //       name = value.docs.first['name'];
  //       email = value.docs.first['Email'];
  //       //id = value.docs.first.id;
  //       profilePic = value.docs.first['profilePic'];
  //     });
  //   });
  // }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    writerC = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7, // Initial size of the bottom sheet
        minChildSize: 0.5, // Minimum size when fully collapsed

        maxChildSize: 1, // Maximum size when fully expanded
        expand: false, // Whether the sheet should expand initially
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Add Places Review",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.horizontal_rule_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  height: 15,
                ),

                Responsive(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: writerC,
                            style: const TextStyle(
                                fontSize: 15, letterSpacing: 1.5),
                            textCapitalization: TextCapitalization.words,
                            maxLines: 1,
                            autofocus: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.2),
                                    width: 2,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.5),
                                    width: 2.5,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2,
                                  )),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2.5,
                                  )),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(22),
                              filled: true,
                              hintText: 'Enter your name',
                              prefixIcon: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 20,
                                )),
                              ),
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.2),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: locationC,
                            style: const TextStyle(
                                fontSize: 15, letterSpacing: 1.5),
                            textCapitalization: TextCapitalization.none,
                            maxLines: 1,
                            autofocus: false,
                            readOnly: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.2),
                                    width: 2,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.5),
                                    width: 2.5,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2,
                                  )),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2.5,
                                  )),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(22),
                              filled: true,
                              hintText: 'Location',
                              prefixIcon: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 20,
                                )),
                              ),
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.2),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: viewsC,
                            maxLines: 5,
                            minLines: 1,
                            style: const TextStyle(
                                fontSize: 15, letterSpacing: 1.5),
                            textCapitalization: TextCapitalization.none,
                            autofocus: false,
                            readOnly: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.2),
                                    width: 2,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.5),
                                    width: 2.5,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2,
                                  )),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    width: 2.5,
                                  )),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(22),
                              filled: true,
                              hintText: 'Write your review',
                              prefixIcon: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 20,
                                )),
                              ),
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.2),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Container(
                //         width: MediaQuery.of(context).size.width * 0.3,
                //         child: PrimaryButton(
                //             title: 'CANCEL',
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             })),

                //   ],
                // ),
                Responsive(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: PrimaryButton(
                            title: 'SAVE',
                            onPressed: () {
                              savePreview();
                              Navigator.pop(context);
                            })),
                  ),
                )
              ],
            ),
          );
        });
    ;
  }
}
