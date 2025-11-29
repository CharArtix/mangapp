import 'package:flutter/material.dart';
import 'main.dart'; // Import untuk mengakses class Restaurant

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool isMenuSelected = true;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan Image
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Hero(
                    tag: 'restaurant-image-${widget.restaurant.id}',
                    child: Image.network(
                      widget.restaurant.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Tempat & Rating
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.restaurant.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                widget.restaurant.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Alamat Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(widget.restaurant.address),
                          const SizedBox(height: 8),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Map View Placeholder',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menu & Review Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isMenuSelected = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isMenuSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isMenuSelected ? Colors.transparent : Colors.grey,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Menu',
                                    style: TextStyle(
                                      color: isMenuSelected ? Colors.black : Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isMenuSelected = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isMenuSelected ? const Color(0xFF8B2E2E) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: !isMenuSelected ? Colors.transparent : Colors.grey,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Review',
                                    style: TextStyle(
                                      color: !isMenuSelected ? Colors.white : Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Content Area
                    if (isMenuSelected) _buildMenuContent() else _buildReviewContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMenuContent() {
    // Placeholder data
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Menu akan segera ditampilkan di sini.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
    // Placeholder data
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Review akan segera ditampilkan di sini.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.favorite, false),
          _buildNavItem(Icons.access_time, false),
          _buildNavItem(Icons.account_circle, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF8B2E2E) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey[600],
        size: 24,
      ),
    );
  }
}
