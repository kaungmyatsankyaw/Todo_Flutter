class Category {
  int id;
  String name;
  String color;
  String image;
  String type;

  int get getId => id;

  set setId(int id) => this.id = id;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getColor => color;

  set setColor(String color) => this.color = color;

   String get getType => type;

  set setType(String type) => this.type = type;

  String get getImage => image;

  set setImage(String image) => this.image = image;

  Category();
  Category.withId(this.id, this.name, this.color, this.image);
  Category.withOutId(this.name, this.color, this.image);
  Category.withType(this.id,this.name, this.color, this.image, this.type);

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'color': color, 'image': image};

  Category.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    color = map['color'];
    image = map['image'];
  }
}
