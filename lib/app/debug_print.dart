
class DebugPrint {
  final object;
  DebugPrint(this.object) {
    print("DebugPrint => ${object?.toString()}");
  }

  static debugPrint(Object object) {
    print("DebugPrint => ${object.toString()}");
  }
}