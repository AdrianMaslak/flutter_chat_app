import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:training/components/bubble.dart';
import 'package:training/components/text_field.dart';
import 'package:training/services/auth/auth_service.dart';
import 'package:training/services/chat/chat_service.dart';
import 'package:training/services/files/file_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  final String? receiverUsername;
  ChatPage(
      {super.key,
      required this.recieverEmail,
      required this.recieverID,
      this.receiverUsername});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final FileService _fileService = FileService();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //File? _selectedImageFile;
  //String? _imageMessageUrl;
/*
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }
*/
  void sendMessage([String? imageUrl]) async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername ?? widget.recieverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final String? senderID = _authService.getCurrentUser()?.uid;
    if (senderID == null) {
      return const Text("Unable to load messages. Please log in.");
    }
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        final docs = snapshot.data?.docs ?? [];
        return ListView(
          children: docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: aligment,
        child:
            MyBubble(message: data["message"], isCurrentUser: isCurrentUser));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
                hintText: "Type a message",
                obscureText: false,
                controller: _messageController)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
      ],
    );
  }
}
