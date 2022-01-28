// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/services/get_image2.dart';

var valentineCollection = FirebaseFirestore.instance.collection('Valentines');
var anniversaryCollection =
    FirebaseFirestore.instance.collection('Anniversary');
var birthdayCollection = FirebaseFirestore.instance.collection('Birthday');
var holidaysCollection = FirebaseFirestore.instance.collection('Holidays');
var loveCollection = FirebaseFirestore.instance.collection('Love');
var friendCollection = FirebaseFirestore.instance.collection('Friends');

// var valentineCollection = FirebaseFirestore.instance.collection('valentines');
// var anniversaryCollection =
//     FirebaseFirestore.instance.collection('anniversary');
// var birthdayCollection = FirebaseFirestore.instance.collection('birthday');
// var holidaysCollection = FirebaseFirestore.instance.collection('holidays');
// var loveCollection = FirebaseFirestore.instance.collection('love');
// var friendCollection = FirebaseFirestore.instance.collection('friends');

class GetImages extends StatelessWidget {
  const GetImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: valentineCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;
          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);
              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.valentinePostCard.add(images[i]['image'].toString());
            }
            x--;
          }
          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage2();
      },
    );
  }
}

class GetImage2 extends StatelessWidget {
  const GetImage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: anniversaryCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;

          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);
              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.anniversaryPostCard.add(images[i]['image'].toString());
            }
            x--;
          }
          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage3();
      },
    );
  }
}

class GetImage3 extends StatelessWidget {
  const GetImage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: birthdayCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;
          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);
              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.birthdayPostCard.add(images[i]['image'].toString());
            }
            x--;
          }
          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage4();
      },
    );
  }
}

class GetImage4 extends StatelessWidget {
  const GetImage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: holidaysCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;

          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);

              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.holidayPostCard.add(images[i]['image'].toString());
            }
            x--;
          }
          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage5();
      },
    );
  }
}

class GetImage5 extends StatelessWidget {
  const GetImage5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: loveCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;

          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);

              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.lovePostCard.add(images[i]['image'].toString());
            }
            x--;
          }
          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage6();
      },
    );
  }
}

class GetImage6 extends StatelessWidget {
  const GetImage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: friendCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: kPrimaryColor));
        } else {
          final images = snapshot.data!.docs;
          int x = 10;
          while (x != 0) {
            for (int i = 0; i < images.length; i++) {
              // print(images[i]['image']);

              // PostCards.allPostCard.add(images[i]['image'].toString());
              PostCards.friendPostCard.add(images[i]['image'].toString());
            }
            x--;
          }

          for (int i = 0; i < images.length; i++) {
            // print(images[i]['image']);
            PostCards.allPostCard.add(images[i]['image'].toString());
          }
        }
        return GetImage22();
      },
    );
  }
}
