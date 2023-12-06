class Room {
  late String name;
  late String imageId;
  late int progressBarValue;

  Room(this.name, this.imageId, this.progressBarValue);

  void debugPrint() {
    print("Name: $name");
    print("ImageId: $imageId");
    print("ProgressBarValue: $progressBarValue");
  }
}