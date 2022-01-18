import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  String? get updateId => null;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    bool isUpdate = false;
    String updateId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Firestore Demo'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              //// VIEW DATA HERE
              //// NOTE: One Time Retrieve Data List
              // FutureBuilder<QuerySnapshot>(
              //   future: users.get(),
              //   builder: (_, snapshot) {
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: snapshot.data!.docs
              //             .map(
              //               (e) => ItemCard(
              //                ( e.data() as dynamic)['name'],
              //                ( e.data() as dynamic)['age'],
              //               ),
              //             )
              //             .toList(),
              //       );
              //     } else {
              //       return Text("Loading...");
              //     }
              //   },
              // ),
              //// NOTE: Synced Retrieve Data List (SORTING LIST by age)
              // StreamBuilder<QuerySnapshot>(
              //   stream: users.orderBy('age', descending: true).snapshots(),
              //   builder: (_, snapshot) {
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: snapshot.data!.docs
              //             .map(
              //               (e) => ItemCard(
              //                ( e.data() as dynamic)['name'],
              //                ( e.data() as dynamic)['age'],
              //               ),
              //             )
              //             .toList(),
              //       );
              //     } else {
              //       return Text("Loading...");
              //     }
              //   },
              // ),
              //// NOTE: Synced Retrieve Data List (FILTERED LIST by age)
              // StreamBuilder<QuerySnapshot>(
              //   stream: users.where('age', isGreaterThan: 20).snapshots(),
              //   builder: (_, snapshot) {
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: snapshot.data!.docs
              //             .map(
              //               (e) => ItemCard(
              //                ( e.data() as dynamic)['name'],
              //                ( e.data() as dynamic)['age'],
              //               ),
              //             )
              //             .toList(),
              //       );
              //     } else {
              //       return Text("Loading...");
              //     }
              //   },
              // ),
              // //// NOTE: Synced Retrieve Data List (NORMAL LIST)
              StreamBuilder<QuerySnapshot>(
                stream: users.orderBy('age', descending: true).snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.docs
                          .map(
                            (e) => ItemCard((e.data() as dynamic)['name'],
                                (e.data() as dynamic)['age'], onUpdate: () {
                              nameController.text =
                                  (e.data() as dynamic)['name'];
                              ageController.text =
                                  (e.data() as dynamic)['age'].toString();
                              updateId = e.id;
                              isUpdate = true;
                              showModalBottomSheet(
                                  context: context,
                                  elevation: 5,
                                  isScrollControlled: true,
                                  builder: (_) => Container(
                                        padding: EdgeInsets.only(
                                          top: 15,
                                          left: 15,
                                          right: 15,
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom +
                                              120,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Title'),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextField(
                                              controller: ageController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Description'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    nameController.text = '';
                                                    ageController.text = '';
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    //// UPDATE DATA HERE
                                                    users.doc(updateId).update({
                                                      'name':
                                                          nameController.text,
                                                      'age': int.tryParse(
                                                              ageController
                                                                  .text) ??
                                                          0
                                                    });

                                                    //// CLOSE MODAL
                                                    Navigator.of(context).pop();
                                                    nameController.text = '';
                                                    ageController.text = '';
                                                  },
                                                  child: Text('Update Data'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                            }, onDelete: () {
                              users.doc(e.id).delete();
                            }),
                          )
                          .toList(),
                    );
                  } else {
                    return Text("Loading...");
                  }
                },
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              elevation: 5,
              isScrollControlled: true,
              builder: (_) => Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(hintText: 'Title'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: ageController,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                nameController.text = '';
                                ageController.text = '';
                              },
                              child: Text('Cancel'),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //// ADD DATA HERE
                                users.add({
                                  'name': nameController.text,
                                  'age': int.tryParse(ageController.text) ?? 0
                                });

                                //// CLOSE MODAL
                                Navigator.of(context).pop();
                                nameController.text = '';
                                ageController.text = '';
                              },
                              child: Text('Create New'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
