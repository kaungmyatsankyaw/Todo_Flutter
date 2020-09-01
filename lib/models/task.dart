class Task {
  int id;
  String name;
  int categoryId;
  int dateTime;

  String get getName => name;

  set setName(String name) => this.name = name;

  int get getId => id;

  set setId(int id) => this.id = id;

  int get getCategoryId => categoryId;

  set setCategoryId(int categoryId) => this.categoryId = categoryId;

  int get getDateTime => dateTime;

  set setDateTime(int dateTime) => this.dateTime = dateTime;

  Task();
  Task.withId(this.id, this.name, this.categoryId, this.dateTime);
  Task.withOutId(this.name, this.categoryId, this.dateTime);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'categoryId': this.categoryId,
        'dateTime': this.dateTime
      };

  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    categoryId = map['categoryId'];
    dateTime = map['dateTime'];
  }
}
