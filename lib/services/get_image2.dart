// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/models/user_details_model.dart';

class GetImage22 extends StatelessWidget {
  const GetImage22({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('length');
    print(PostCards.allPostCard.length);

    PostCards.allPostCard = PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard +
        PostCards.allPostCard;

    return BottomNav();
  }
}
