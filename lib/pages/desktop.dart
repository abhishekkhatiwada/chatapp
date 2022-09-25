import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/utility/colors.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  var messageUser = user!.uid;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextEditingController message = TextEditingController();

    List<String> listUser = [
      "${user!.uid}+$messageUser",
      "$messageUser+${user!.uid}"
    ];
    return MediaQuery.of(context).size.width > 576
        ? Scaffold(
            // appBar: AppBar(
            //   title: const Text('Chat App'),
            //   centerTitle: true,
            //   actions: [
            //     IconButton(
            //       onPressed: () async {
            //         await FirebaseAuth.instance.signOut().then((value) {
            //           Navigator.of(context).pushReplacement(
            //             MaterialPageRoute(
            //               builder: (context) => const UserLogin(),
            //             ),
            //           );
            //         });
            //       },
            //       icon: const Icon(Icons.logout),
            //     ),
            //   ],
            // ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/chatapp/account/users')
                  .where(
                    'uid',
                    isNotEqualTo: user!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: size.width / 4),
                        decoration: MediaQuery.of(context).size.width > 576
                            ? BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 202, 202, 202)
                                            .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  ),
                                ],
                              )
                            : const BoxDecoration(
                                color: Colors.transparent,
                              ),
                        child: ListView.builder(
                            // reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    messageUser = doc['uid'];
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                    doc['name'],
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),

                                //  Container(
                                //     padding: const EdgeInsets.all(18),
                                //     margin: const EdgeInsets.all(8),
                                //     child: Text(doc['name'])),
                              );
                            }),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: size.width / 1.35),
                        child: messageUser != user!.uid
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.077,
                                      width: MediaQuery.of(context).size.width,
                                      constraints: BoxConstraints(
                                          minHeight: 50, maxHeight: 50),
                                      padding: const EdgeInsets.all(10.0),
                                      //color: webAppBarColor,
                                      decoration: BoxDecoration(
                                        color: webAppBarColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg',
                                                ),
                                                radius: 20,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              const Text(
                                                'My Name',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.search,
                                                    color: Colors.black),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                  color: dividerColor),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFFf4d5d2),
                                                  Color(0xFFe1dbe9)
                                                ])),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection(
                                                  '/chatapp/chat/messages')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    DocumentSnapshot doc =
                                                        snapshot
                                                            .data!.docs[index];

                                                    return listUser.contains(
                                                            doc['users'])
                                                        ? Container(
                                                            child: doc['users'] ==
                                                                    "${user!.uid}+$messageUser"
                                                                ? Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            300,
                                                                      ),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            1,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8)),
                                                                        color:
                                                                            messageColor,
                                                                        margin: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                5),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                right: 30,
                                                                                top: 5,
                                                                                bottom: 20,
                                                                              ),
                                                                              child: Text(
                                                                                doc['message'],
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              bottom: 4,
                                                                              right: 10,
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'now',
                                                                                    style: const TextStyle(
                                                                                      fontSize: 13,
                                                                                      color: Colors.white60,
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  const Icon(
                                                                                    Icons.done_all,
                                                                                    size: 20,
                                                                                    color: Colors.white60,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            300,
                                                                      ),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            1,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8)),
                                                                        color:
                                                                            senderMessageColor,
                                                                        margin: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                5),
                                                                        child: Stack(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(
                                                                                  left: 10,
                                                                                  right: 30,
                                                                                  top: 5,
                                                                                  bottom: 20,
                                                                                ),
                                                                                child: Text(
                                                                                  doc['message'],
                                                                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Positioned(
                                                                                bottom: 2,
                                                                                right: 10,
                                                                                child: Text(
                                                                                  '22:20',
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                  )

                                                            //  Text(
                                                            //   doc['message'],
                                                            // ),
                                                            )
                                                        : Container();
                                                  });
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: TextFormField(
                                                  controller: message,
                                                  autofocus: false,
                                                  cursorColor: black,
                                                  decoration: InputDecoration(
                                                    hintText: 'Message',
                                                    fillColor: white,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  onSaved: (value) {
                                                    message.text = value!;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (message.text.isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '/chatapp/chat/messages/')
                                                    .doc()
                                                    .set({
                                                  'message':
                                                      message.text.trim(),
                                                  'time': DateTime.now(),
                                                  'users':
                                                      "${user!.uid}+$messageUser",
                                                });

                                                message.clear();
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.send,
                                              size: 29,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: size.width / 2),
                                  child: const Text('Select User'),
                                ),
                              ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        : const HomePage();
  }
}
