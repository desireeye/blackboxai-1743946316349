import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(ChicagoDelightsApp());
}

class ChicagoDelightsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Chicago Delight\'s Pizza & Grillz',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MenuScreen(),
      ),
    );
  }
}
