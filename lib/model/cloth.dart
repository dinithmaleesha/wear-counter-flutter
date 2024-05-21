class Cloth {
  int? id;
  final String name;
  final String imagePath;
  final int wearCount;
  int _currentWears;

  Cloth({
    this.id,
    required this.name,
    required this.imagePath,
    required this.wearCount,
    required int currentWears,
  }) : _currentWears = currentWears;

  // ignore: unnecessary_getters_setters
  int get currentWears => _currentWears;

  set currentWears(int value) {
    _currentWears = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'wearCount': wearCount,
      'currentWears': _currentWears,
    };
  }
}
