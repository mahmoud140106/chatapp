import 'package:chatapp/constants.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/widgets/custom_chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  // const ChatPage({super.key});
  static String id = 'ChatPage';
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<DocumentSnapshot>(
    // return FutureBuilder<QuerySnapshot>(
    // String email=  ModalRoute.of(context)!.settings.arguments as String;
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        // future: messages.doc('FZQYWOBjP0Pl9NwwIafK').get(),
        // future: messages.get(),
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data!.docs[0]['message']);
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(
                Message.fromJson(snapshot.data!.docs[i]),
              );
            }
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      height: 50,
                    ),
                    Text(
                      'Chat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatBubble(
                                msg: messagesList[index],
                              )
                            : ChatBubbleForFriend(
                                msg: messagesList[index],
                              );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (data) {
                        if (data != null && data.isNotEmpty) {
                          _sendMessage(data, email.toString());
                        }
                        // _sendMessage(data, email);

                        // messages.add({
                        //   // 'message': data,
                        //   kMessage: data,
                        //   kCreatedAt: DateTime.now(),
                        //   'id': email,
                        // });
                        // controller.clear();
                        // // _controller.jumpTo(
                        // //   _controller.position.maxScrollExtent,
                        // // );
                        // _controller.animateTo(
                        //   // _controller.position.maxScrollExtent,
                        //   0,
                        //   duration: Duration(milliseconds: 500),
                        //   curve: Curves.easeIn,
                        // );
                        // _scrollToBottom();
                      },
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                          // highlightColor: Colors.greenAccent,
                          icon: Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            // _sendMessage(controller.text, email.toString());

                            if (controller.text != null &&
                                controller.text.isNotEmpty) {
                              _sendMessage(controller.text, email.toString());
                            }
                          },
                        ),
                        //  Icon(
                        //   Icons.send,
                        //   color: kPrimaryColor,
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          // borderSide: BorderSide(
                          //   color: kPrimaryColor,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: Text('Loading....')),
            );
          }
        });
  }

  void _sendMessage(String data, String userEmail) {
    messages.add({
      kMessage: data,
      kCreatedAt: DateTime.now(),
      'id': userEmail,
    });
    controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _controller.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
// mahmoud@gmail.com