import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_providers.dart';
import '../components/category_filter_component.dart';
import '../components/product_card_component.dart';
import '../components/favorite_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<ProductProvider>().fetchProducts('all'));
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6C63FF),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Samsa Shopping',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              '${productProvider.products.length} produk tersedia',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: const [
          FavoriteComponent(),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Kategori',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const CategoryFilterComponent(),
          const SizedBox(height: 14),
          Expanded(child: _buildBody(productProvider)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C63FF),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  provider.fetchProducts(provider.selectedCategory),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.products.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada produk.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        return ProductCardComponent(product: provider.products[index]);
      },
    );
  }
}