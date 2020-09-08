class Catalog{
  final int id;
  final String name;
  final int status;

  Catalog({this.id, this.name, this.status});

  factory Catalog.fromMap(Map<String, dynamic> json) => Catalog(
      id: json["id"],
      name: json["name"],
      status: json["status"]
  );

  Map<String, dynamic> toMapAutoID() => {
    "name" : name,
    "status" : status,
  };
}