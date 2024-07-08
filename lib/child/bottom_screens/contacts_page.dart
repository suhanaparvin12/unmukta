import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safewomen/child/bottom_screens/add_contacts.dart';
import 'package:safewomen/db/db_services.dart';
import 'package:safewomen/model/contactsm.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:flutter/services.dart';

class ContactsPage extends StatefulWidget {
  final ScrollController scrollController;
  const ContactsPage({super.key, required this.scrollController});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = TextEditingController();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContact();
      });
    } else {
      handInvaliedPermissions(permissionStatus);
    }
  }

  handInvaliedPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Warning",
          "Access to the contacts denied by the user", "Ok");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(
          context, "Warning", "May contact does exist in this device", "Ok");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  getAllContacts() async {
    List<Contact> _contacts =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattren = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);
        if (nameMatch == true) {
          return true;
        }
        if (searchTermFlattren.isEmpty) {
          return false;
        }

        var phone = element.phones!.firstWhere((p) {
          String phnFLattered = flattenPhoneNumber(p.value!);
          return phnFLattered.contains(searchTermFlattren);
        });
        return phone.value != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearchIng = searchController.text.isNotEmpty;
    bool listItemExist = (contactsFiltered.length > 0 || contacts.length > 0);
    return Scaffold(
      // appBar: AppBar(
      //   shadowColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios_new_outlined,
      //       color: Colors.black,
      //       size: 22,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   title: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Text(
      //       'Contacts',
      //       style: TextStyle(
      //           fontSize: 25,
      //           color: Theme.of(context).colorScheme.primary,
      //           fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      body: contacts.length == 0
          ? Center(child: progressIndicator(context))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             color: Theme.of(context)
                    //                 .colorScheme
                    //                 .inversePrimary,
                    //             borderRadius: BorderRadius.circular(20)),
                    //         child: IconButton(
                    //           icon: const Icon(
                    //             Icons.arrow_back_ios_new_outlined,
                    //             color: Colors.white,
                    //             size: 22,
                    //           ),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "Contacts",
                    //       style: TextStyle(
                    //           fontSize: 25,
                    //           fontWeight: FontWeight.bold,
                    //           letterSpacing: 1.5,
                    //           color: Theme.of(context).colorScheme.primary),
                    //     )
                    //   ],
                    // ),
                    Text(
                      "All Contacts",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Icon(
                      Icons.horizontal_rule_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 9.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context)
                    //           .colorScheme
                    //           .inversePrimary
                    //           .withOpacity(0.2),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: TextField(
                    //       inputFormatters: <TextInputFormatter>[
                    //         FilteringTextInputFormatter.allow(
                    //             RegExp("[a-zA-Z]")),
                    //       ],
                    //       keyboardType: TextInputType.name,
                    //       autofocus: false,
                    //       controller: searchController,
                    //       decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.all(20),
                    //         border: InputBorder.none,
                    //         focusedBorder: InputBorder.none,
                    //         enabledBorder: InputBorder.none,
                    //         errorBorder: InputBorder.none,
                    //         disabledBorder: InputBorder.none,
                    //         // label: Text('Search Contact'),
                    //         hintText: "Search Contacts",
                    //         prefixIcon: Container(
                    //           width: 40,
                    //           height: 40,
                    //           margin: const EdgeInsets.all(10),
                    //           padding: const EdgeInsets.all(10),
                    //           decoration: BoxDecoration(
                    //             color: Theme.of(context)
                    //                 .colorScheme
                    //                 .inversePrimary,
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           child: const Center(
                    //               child: Icon(
                    //             Icons.search,
                    //             color: Colors.white,
                    //             size: 20,
                    //           )),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    listItemExist == true
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              controller: widget.scrollController,
                              itemCount: isSearchIng == true
                                  ? contactsFiltered.length
                                  : contacts.length,
                              itemBuilder: (BuildContext context, int index) {
                                Contact contact = isSearchIng == true
                                    ? contactsFiltered[index]
                                    : contacts[index];

                                return Responsive(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withOpacity(0.25),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          contact.displayName?.length == 0
                                              ? "Unnammed"
                                              : contact.displayName.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        //subtitle: Text(),
                                        subtitle: Text(
                                            contact.phones?.length == 0
                                                ? 'No Phone Number'
                                                : contact.phones!
                                                    .elementAt(0)
                                                    .value
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                        leading: contact.avatar != null &&
                                                contact.avatar!.length > 0
                                            ? Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: Center(
                                                    child: Image.memory(
                                                        contact.avatar!)),
                                              )
                                            : Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    contact.initials(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        onTap: () {
                                          setState(() {
                                            if (contact.phones!.length > 0) {
                                              final String phoneNum = contact
                                                  .phones!
                                                  .elementAt(0)
                                                  .value!;
                                              final String name =
                                                  contact.displayName!;
                                              _addContacts(
                                                TContact(phoneNum, name),
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'OOps! phone number of this contact does not exist');
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            child: Text('searching'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  void _addContacts(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    setState(() {
      if (result != 0) {
        Fluttertoast.showToast(msg: 'Contact added successfully');
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: 'Failed to add contacts');
        setState(() {});
      }
    });

    Navigator.of(context).pop(true);
  }
}
