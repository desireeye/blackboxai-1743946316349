class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final List<String> customizationOptions;
  final bool isVeg;
  final List<String>? addons;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.customizationOptions,
    required this.isVeg,
    this.addons,
    this.description,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data, String id) {
    return MenuItem(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      customizationOptions: List<String>.from(data['customizationOptions'] ?? []),
      isVeg: data['isVeg'] ?? false,
      addons: data['addons'] != null ? List<String>.from(data['addons']) : null,
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'customizationOptions': customizationOptions,
      'isVeg': isVeg,
      'addons': addons,
      'description': description,
    };
  }
}