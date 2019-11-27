
class Exercise {
  String id;
  String image;
  String name;
  int set;
  int repeatCount;

  Exercise({this.id, this.image, this.name, this.set, this.repeatCount});

  Exercise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    set = json['set'];
    repeatCount = json['repeatCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['set'] = this.set;
    data['repeatCount'] = this.repeatCount;
    return data;
  }
}