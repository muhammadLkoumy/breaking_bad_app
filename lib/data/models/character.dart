class Character {
  int? charId;
  String? name;
  String? birthday;
  List<String>? jobs;
  String? image;
  String? deadOrAlive;
  String? nickname;
  List<int>? appearance;
  String? realName;
  String? category;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    birthday = json['birthday'];
    jobs = json['occupation'].cast<String>();
    image = json['img'];
    deadOrAlive = json['status'];
    nickname = json['nickname'];
    appearance = json['appearance'].cast<int>();
    realName = json['portrayed'];
    category = json['category'];
  }
}
