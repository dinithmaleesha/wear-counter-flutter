class Cloth {
  final String id;
  final String name;
  final String imagePath;
  final int wearCount;
  int currentWears;

  Cloth({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.wearCount,
    this.currentWears = 0,
  });
}
