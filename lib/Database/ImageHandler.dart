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
}