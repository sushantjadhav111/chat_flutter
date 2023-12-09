import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/message_bubble.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({super.key});
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapShot.hasData ||
              snapShot.data!.docs.isEmpty ||
              snapShot.hasError) {
            return Center(
              child: Text("No message found"),
            );
          }
          final lodedMessages = snapShot.data!.docs;
          return ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
              itemCount: lodedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = lodedMessages[index].data();
                final nextChatMessage = index + 1 < lodedMessages.length
                    ? lodedMessages[index + 1].data()
                    : null;
                final curretMessageUsername = chatMessage['userName'];
                final nextMessageUsername = nextChatMessage != null
                    ? nextChatMessage['userName']
                    : null;
                final curretMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;
                final nextUserIsSame = curretMessageUserId == nextMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == curretMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage["imageUrl"],
                      username: chatMessage['userName'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser.uid == curretMessageUserId);
                }
                //return Text(lodedMessages[index].data()['text']);
              });
        });
  }
}
