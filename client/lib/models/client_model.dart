import 'dart:convert';

class ClientModel {
  ClientModel({required this.name, String? id}) {
    this.id = id ?? '$name${DateTime.now().millisecondsSinceEpoch}';
  }

  final String name;
  late final String id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) => ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ClientModel(name: $name, id: $id)';

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
