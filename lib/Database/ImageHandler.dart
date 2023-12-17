//Authors: Alexander Okrucký (xokruc00)

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class ImageHandler {
  Future<Uint8List?> getRoomImage(String imageId) async {
    Uint8List? imageData = await FirebaseStorage.instance.ref("rooms/$imageId.png").getData();
    return imageData;
  }

  Future<Uint8List?> getRewardImage(String imageId) async {
    Uint8List? imageData = await FirebaseStorage.instance.ref("rewards/$imageId.png").getData();
    return imageData;
  }

  Future<Uint8List?> getUserImage(String imageId) async {
    Uint8List? imageData = await FirebaseStorage.instance.ref("users/$imageId.png").getData();
    return imageData;
  }

  String getLocalUsers(String imageId) {
    return "res/users/$imageId.png";
  }
}

// /b/nashhouse-6656c.appspot.com/o/rooms/10.png