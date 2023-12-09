import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var _messageTextController = TextEditingController();
  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    var enteredMessage = _messageTextController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageTextController.clear();

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userStore = await FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser.uid)
        .get();

    FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": currentUser.uid,
      "userName": userStore.data()!["username"],
      "imageUrl": userStore.data()!["image_url"]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _messageTextController,
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: "Send a message..."),
        )),
        IconButton(
          onPressed: _submitMessage,
          icon: Icon(Icons.send),
          color: Theme.of(context).colorScheme.primary,
        )
      ]),
    );
  }
}
