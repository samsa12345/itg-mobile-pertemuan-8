import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_providers.dart';

class CategoryFilterComponent extends StatelessWidget {
  const CategoryFilterComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: productProvider.categories.length,
        itemBuilder: (context, index) {
          final category = productProvider.categories[index];
          final isSelected =
              productProvider.selectedCategory == category['key'];

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                context
                    .read<ProductProvider>()
                    .fetchProducts(category['key']!);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFF6C63FF).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  category['label']!,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}