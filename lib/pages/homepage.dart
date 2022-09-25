import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/desktop.dart';
import 'package:chatapp/utility/colors.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size.width < 576
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: webAppBarColor,
              centerTitle: false,
              title: const Text(
                'ChatApp',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    });
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            // AppBar(
            //   title: const Text('Chat App'),
            //   centerTitle: true,
            //   actions: [
            // IconButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut().then((value) {
            //       Navigator.of(context).pushReplacementNamed('/login');
            //     });
            //   },
            //   icon: const Icon(Icons.logout),
            // ),
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
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  messageUser: doc['uid'],
                                  userName: doc['name'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                (doc['name']),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                // child: Text(
                                //   (doc['messages']),
                                //   style: const TextStyle(
                                //       fontSize: 15, color: Colors.grey),
                                // ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 30,
                              ),
                              // trailing: Text(
                              //   (doc['time']),
                              //   style: const TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 13,
                              //   ),
                              // ),
                            ),
                          ),

                          // Container(
                          //     color: grey,
                          //     padding: const EdgeInsets.all(18),
                          //     margin: const EdgeInsets.all(8),
                          //     child: Text(doc['name'])),
                        );
                      });
                } else {
                  return Container();
                }
              },
            ),
          )
        : const DesktopHomePage();
  }
}
