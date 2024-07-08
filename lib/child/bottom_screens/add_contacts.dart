import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safewomen/child/bottom_screens/contacts_page.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/db/db_services.dart';
import 'package:safewomen/model/contactsm.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TContact>? contactList;
  int count = 0;
  final ScrollController _scrollController = ScrollController();

  void showList() {
    Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then(
      (database) {
        Future<List<TContact>> contactListFuture =
            databaseHelper.getContactList();
        contactListFuture.then(
          (value) {
            setState(
              () {
                this.contactList = value;
                this.count = value.length;
              },
            );
          },
        );
      },
    );
  }

  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: 'Contact removed successfully');
      showList();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
      showList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = [];
    }
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
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Container(
        width: 140,
        child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "Add Contacts",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    // <-- SEE HERE
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: DraggableScrollableSheet(
                          initialChildSize:
                              0.55, // Initial size of the bottom sheet
                          minChildSize:
                              0.2, // Minimum size when fully collapsed
                          maxChildSize: 0.9, // Maximum size when fully expanded
                          expand:
                              false, // Whether the sheet should expand initially
                          builder: (context, scrollController) {
                            return ContactsPage(
                                scrollController: scrollController);
                          }),
                    );
                  });
            }),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Expanded(
                  child: count == 0
                      ? Center(
                          child: Text(
                            'No Emergency Contacts Added',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      : ListView.builder(
                          //shrinkWrap: true,
                          itemCount: count,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                        .inversePrimary
                                        .withOpacity(0.2),
                                    width: 3,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(contactList![index].name),
                                  subtitle: Text(contactList![index].number),
                                  leading: Icon(
                                    Icons.account_circle_rounded,
                                    size: 50,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                                    contactList![index].number);
                                          },
                                          icon: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                                  .withOpacity(0.5),
                                            ),
                                            child: Icon(
                                              Icons.phone_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            deleteContact(contactList![index]);
                                          },
                                          icon: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                                  .withOpacity(0.5),
                                            ),
                                            child: Icon(
                                              Icons.delete_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
