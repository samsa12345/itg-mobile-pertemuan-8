import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_providers.dart';
import '../models/product.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final List<Product> favorites = favoriteProvider.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Produk Favorit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${favoriteProvider.favoriteCount} item tersimpan',
              style:
                  const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: favorites.isEmpty
          ? _buildEmpty(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return _FavoriteItemCard(
                  product: favorites[index],
                  index: index,
                );
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              size: 70,
              color: Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Belum Ada Favorit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Simpan produk favoritmu\ndengan tekan ikon bookmark',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Kembali Belanja'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteItemCard extends StatelessWidget {
  final Product product;
  final int index;

  const _FavoriteItemCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.read<FavoriteProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailPage(product: product)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Nomor urut
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail,
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 75,
                    height: 75,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.broken_image,
                        size: 30, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Informasi produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.category.isNotEmpty)
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    const SizedBox(height: 3),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.inventory_2_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(
                          'Stok: ${product.stock}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tombol hapus favorit
              IconButton(
                icon: const Icon(Icons.bookmark_remove_rounded,
                    color: Colors.red, size: 22),
                onPressed: () => favoriteProvider.toggleFavorite(product),
                tooltip: 'Hapus dari favorit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}