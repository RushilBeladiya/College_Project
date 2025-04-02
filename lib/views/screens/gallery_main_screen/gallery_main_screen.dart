// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class GalleryScreen extends StatefulWidget {
//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('gallery');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Gallery')),
//       body: StreamBuilder(
//         stream: _dbRef.onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//             return Center(child: CircularProgressIndicator());
//           }

//           Map<dynamic, dynamic> images =
//           snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//           List<String> imageList =
//           images.values.map((data) => data['image'] as String).toList();

//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: imageList.length,
//             itemBuilder: (context, index) {
//               String base64Image = imageList[index];
//               return Image.memory(
//                 base64Decode(base64Image),
//                 fit: BoxFit.cover,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:college_project/core/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('gallery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text('Gallery', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor, // Primary color
        elevation: 5,
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic> images =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          List<String> imageList =
              images.values.map((data) => data['image'] as String).toList();

          if (imageList.isEmpty) {
            return const Center(
              child: Text(
                'No images found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              String base64Image = imageList[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(base64Image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
