

class SportEquipment {
  String id;
  String image;
  String name;
  int equipmentNumber;

  SportEquipment({this.id, this.image, this.name, this.equipmentNumber});

  SportEquipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    equipmentNumber = json['equipmentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['equipmentNumber'] = this.equipmentNumber;
    return data;
  }
}