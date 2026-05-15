import 'package:flutter/material.dart';
import '../../../categories/domain/models/category.dart';

class ProductsScreen extends StatelessWidget {
  final Category category;

  const ProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Center(
        child: Text('Products for ${category.name}'),
      ),
    );
  }
}
