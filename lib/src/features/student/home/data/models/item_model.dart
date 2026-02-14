enum ItemType {
  assignment,
  resource
}

class ItemModel {
  final String uuid;
  final String name;
  final String courseId;
  final ItemType type;
  final DateTime date;

  ItemModel(this.uuid, this.name, this.courseId, this.type, this.date);
}