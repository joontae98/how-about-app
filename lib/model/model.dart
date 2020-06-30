class Category{
  final int id;
  final String option;
  final String catalog;

  Category({this.id, this.option, this.catalog});

  factory Category.fromMap(Map<String, dynamic> json) => Category(
      id: json["id"],
      option: json["option"],
      catalog: json["catalog"]
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "option" : option,
    "catalog" : catalog,
  };

  Map<String, dynamic> toMapAutoID() => {
    "option" : option,
    "catalog" : catalog,
  };
}