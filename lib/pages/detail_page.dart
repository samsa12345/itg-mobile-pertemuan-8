import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorite_providers.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorite(product.id);

    final List<String> allImages =
        product.images.isNotEmpty ? product.images : [product.thumbnail];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar dengan galeri gambar ──
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            title: const Text(
              'Detail Produk',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFav ? Icons.bookmark : Icons.bookmark_border,
                    key: ValueKey(isFav),
                    color: isFav ? Colors.amber : Colors.white,
                  ),
                ),
                onPressed: () => favoriteProvider.toggleFavorite(product),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: allImages.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    itemBuilder: (_, i) => Image.network(
                      allImages[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Gradient overlay bawah
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Indikator dot gambar
                  if (allImages.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          allImages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == i ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Konten Detail ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori
                  if (product.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Judul
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Brand
                  if (product.brand.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.storefront_outlined,
                            size: 15, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          product.brand,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Harga, Rating, Stok dalam satu baris kartu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Harga
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Divider vertikal
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        // Rating
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Divider vertikal
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        // Stok
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Stok',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.stock > 0
                                    ? '${product.stock}'
                                    : 'Habis',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: product.stock > 0
                                      ? const Color(0xFF2ECC71)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Deskripsi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.description_outlined,
                                size: 18, color: Color(0xFF6C63FF)),
                            SizedBox(width: 8),
                            Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // ruang buat bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Button ──
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => favoriteProvider.toggleFavorite(product),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFav ? Colors.red.shade400 : const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFav ? Icons.bookmark_remove : Icons.bookmark_add,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isFav ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}