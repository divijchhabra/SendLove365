import 'package:flutter/material.dart';
import 'package:temp/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isSameUser,
    required this.createdOn,
    required this.avatar,
  }) : super(key: key);

  final String message, avatar;
  final bool isMe, isSameUser;
  final String createdOn;

  @override
  Widget build(BuildContext context) {
    int n = createdOn.length;

    print('avatar $avatar');
    return (isMe)
        ? Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.80,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    createdOn.substring(11, 16),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
              !isSameUser
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          createdOn.substring(11, 16),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.5),
                        //         spreadRadius: 2,
                        //         blurRadius: 5,
                        //       ),
                        //     ],
                        //   ),
                        //   child: CircleAvatar(
                        //     radius: 15,
                        //     backgroundImage: NetworkImage(avatar),
                        //   ),
                        // ),
                      ],
                    )
                  : Container(
                      child: null,
                    ),
            ],
          )
        : Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              !isSameUser
                  ? Row(
                      children: <Widget>[
                        // Container(
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.5),
                        //         spreadRadius: 2,
                        //         blurRadius: 5,
                        //       ),
                        //     ],
                        //   ),
                        //   child: CircleAvatar(
                        //     radius: 15,
                        //     backgroundImage: NetworkImage(avatar),
                        //   ),
                        // ),
                        const SizedBox(width: 10),
                        Text(
                          createdOn.substring(11, 16),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: null,
                    ),
            ],
          );
  }
}
