// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:custom_full_image_screen/custom_full_image_screen.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isSameUser,
    required this.createdOn,
    required this.isMsg,
    required this.urlDownload,
  }) : super(key: key);

  final String message;
  final bool isMe, isSameUser, isMsg;
  final String createdOn, urlDownload;

  @override
  Widget build(BuildContext context) {
    // print('avatar $avatar');
    // print('isMsg $isMsg');
    // print('message $message');

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
                      child: isMsg
                          ? Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            )
                          : ImageCachedFullscreen(
                              imageUrl: urlDownload,
                              imageBorderRadius: 20,
                              imageWidth: 216,
                              imageHeight: 384,
                              imageDetailsHeight: 700,
                              imageDetailsWidth: 400,
                              withHeroAnimation: true,
                              placeholder: Container(
                                child: Icon(Icons.check),
                              ),
                              errorWidget: Container(
                                child: Icon(Icons.error),
                              ),
                              placeholderDetails: Container(),
                            ),
                      // : SizedBox(
                      //     height: 200,
                      //     child: Image(
                      //       image: NetworkImage(urlDownload),
                      //       width: MediaQuery.of(context).size.width * 0.3,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
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
                  child: isMsg
                      ? Text(
                          message,
                          style: const TextStyle(color: Colors.purple),
                        )
                      // : SizedBox(
                      //     height: 200,
                      //     child: Image(
                      //       image: NetworkImage(urlDownload),
                      //       width: MediaQuery.of(context).size.width * 0.3,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      : ImageCachedFullscreen(
                              imageUrl: urlDownload,
                              imageBorderRadius: 20,
                              imageWidth: 216,
                              imageHeight: 384,
                              imageDetailsHeight: 700,
                              imageDetailsWidth: 400,
                              withHeroAnimation: true,
                          placeholder: Container(
                            child: Icon(Icons.check),
                          ),
                          errorWidget: Container(
                            child: Icon(Icons.error),
                          ),
                          placeholderDetails: Container(),
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
