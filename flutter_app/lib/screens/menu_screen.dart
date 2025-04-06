import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../models/menu_item.dart';
import '../widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = [
    'Pizzas',
    'Burgers',
    'Fries',
    'Shakes',
    'Desserts',
    'Pasta',
    'Wraps',
    'Tacos',
    'Salad',
    'Sandwiches',
    'Coolers',
    'Coffee'
  ];
  String selectedCategory = 'Pizzas';
  late Future<List<MenuItem>> menuItems;

  @override
  void initState() {
    super.initState();
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    menuItems = firebaseService.getMenuItemsByCategory(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chicago Delight\'s Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = categories[index];
                        final firebaseService =
                            Provider.of<FirebaseService>(context, listen: false);
                        menuItems = firebaseService
                            .getMenuItemsByCategory(selectedCategory);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: menuItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading menu items'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items found'));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ProductCard(item: snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}