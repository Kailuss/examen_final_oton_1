import 'dart:convert';

LaunchModel launchModelFromMap(String str) => LaunchModel.fromMap(json.decode(str));

String launchModelToMap(LaunchModel data) => json.encode(data.toMap());

class LaunchModel {
    String id;
    String name;
    Status status;
    DateTime net;
    String? lspName;
    String? pad;
    String? image;

    LaunchModel({
        required this.id,
        required this.name,
        required this.status,
        required this.net,
        this.lspName,
        this.image,
    });

    factory LaunchModel.fromMap(Map<String, dynamic> json) => LaunchModel(
        id: json["id"],
        name: json["name"],
        status: Status.fromMap(json["status"]),
        net: DateTime.parse(json["net"]),
        lspName: json["lsp_name"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "status": status.toMap(),
        "net": net.toIso8601String(),
        "lsp_name": lspName,
        "image": image,
    };
}

class Status {
    int id;
    String name;
    String description;

    Status({
        required this.id,
        required this.name,
        required this.description,
    });

    factory Status.fromMap(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
    };
}