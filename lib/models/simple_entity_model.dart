class SimpleEntity {
  final String id;
  final String name;

  SimpleEntity({required this.id, required this.name});

  factory SimpleEntity.fromJson(Map<String, dynamic> json) {

    if (json.isEmpty) {
      return SimpleEntity(id: '', name: '');
    }
    if (!json.containsKey('id') && !json.containsKey('Id')) {
      return SimpleEntity(id: '', name: '');
    }
    if (!json.containsKey('name') && !json.containsKey('Name')) {
      return SimpleEntity(id: json['id']?.toString() ?? '', name: '');
    }


    String id = json['id']?.toString() ?? json['Id']?.toString() ?? '';
    String name = json['name']?.toString() ?? json['Name']?.toString() ?? '';
    // print("SimpleEntity.fromJson: id: $id, name: $name");
    return SimpleEntity(
      id: id,
      name: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
