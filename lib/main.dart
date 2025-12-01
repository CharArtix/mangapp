import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oxxahfjamjbxukkilnkj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94eGFoZmphbWpieHVra2lsbmtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyNjM5NzYsImV4cCI6MjA3OTgzOTk3Nn0.jQ1uVCCdOYrwjTLZg3Oh--VTf-UTC2pG5tjGIX1coqo',
  );

  runApp(const MyApp());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: [
              // Red background with pattern
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCB3127),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenWidth * 0.15),
                      bottomRight: Radius.circular(screenWidth * 0.15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles/patterns
                      Positioned(
                        top: -50,
                        right: -80,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: -60,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mangapp logo and text
              Positioned(
                top: screenHeight * 0.08,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mangapp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // White card content
              Positioned(
                top: screenHeight * 0.35,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Login title
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF343446),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Username field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Username',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF343446),
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF94931),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan username anda',
                              hintStyle: TextStyle(
                                fontSize: 14.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF343446),
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Password field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Password',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF343446),
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF94931),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Password anda',
                              hintStyle: TextStyle(
                                fontSize: 14.5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF343446),
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: const Color(0xFF343446),
                            decoration: TextDecoration.underline,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            final email = _usernameController.text.trim();
                            final password = _passwordController.text;

                            try {
                              await Supabase.instance.client.auth
                                  .signInWithPassword(
                                email: email,
                                password: password,
                              );

                              final user = Supabase.instance.client.auth.currentUser;
                              if (user != null) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login berhasil')),
                                );
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const MyHomePage(
                                      title: 'Mangapp Home',
                                    ),
                                  ),
                                );
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login gagal')),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA22523),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.7,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Register link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account yet? ",
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: const Color(0xFF343446),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: const Color(0xFF566CD8),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mangapp',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Gilroy',
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _places = [];
  bool _loading = true;
  List<String> _categories = [];
  String _selectedUniversityName = 'Pilih Lokasi';
  List<Map<String, dynamic>> _universities = [];
  int? _selectedUniversityId;

  @override
  void initState() {
    super.initState();
    _loadUniversities();
    _loadCategories();
    _loadPlaces();
  }

  Future<void> _loadUniversities() async {
    try {
      final res = await Supabase.instance.client.from('universities').select().order('name');
      if (res is List) {
        final list = res.cast<Map<String, dynamic>>().toList();
        setState(() {
          _universities = list;
          if (list.isNotEmpty) {
            final first = list.first;
            _selectedUniversityId = (first['id'] is int) ? first['id'] as int : int.tryParse(first['id'].toString());
            _selectedUniversityName = first['name'] ?? 'Pilih Lokasi';
          }
        });
      }
    } catch (_) {
      // ignore failures for now
    }
  }

  Future<void> _loadCategories() async {
    try {
      final res = await Supabase.instance.client.from('menus').select('name');
      if (res is List) {
        final names = <String>[];
        for (final item in res.cast<Map<String, dynamic>>()) {
          final n = item['name']?.toString();
          if (n != null && n.isNotEmpty) names.add(n);
        }
        final uniq = names.toSet().toList();
        setState(() {
          _categories = ['Semua', ...uniq];
        });
      }
    } catch (_) {
      // fallback to defaults
      setState(() {
        _categories = ['Semua', 'Ayam Geprek', 'Masakan Rumahan', 'Bakso', 'Pizza'];
      });
    }
  }

  Future<void> _loadPlaces() async {
    setState(() {
      _loading = true;
    });

    try {
      // Select places and embed favorites to compute counts and whether current user favorited
      final user = Supabase.instance.client.auth.currentUser;

      final res = (_selectedUniversityId != null)
          ? await Supabase.instance.client
              .from('places')
              .select('*, favorites(*)')
                      .eq('university_id', _selectedUniversityId!)
              .order('rating', ascending: false)
          : await Supabase.instance.client
              .from('places')
              .select('*, favorites(*)')
              .order('rating', ascending: false);

      if (res is List) {
        final List<Map<String, dynamic>> places = [];
        for (final item in res.cast<Map<String, dynamic>>()) {
          final favs = (item['favorites'] is List) ? List<Map<String, dynamic>>.from(item['favorites'].cast<Map<String, dynamic>>()) : <Map<String, dynamic>>[];
          final favCount = favs.length;
          final isFav = (user != null) ? favs.any((f) => f['user_id'] == user.id) : false;

          // Create cleaned place map with convenience fields
          final cleaned = Map<String, dynamic>.from(item);
          cleaned['favorites_count'] = favCount;
          cleaned['is_favorite'] = isFav;

          places.add(cleaned);
        }

        setState(() {
          _places = places;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No places found or unexpected response')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int placeId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to favourite places')),
      );
      return;
    }

    // Optimistic update
    final idx = _places.indexWhere((p) => p['id'] == placeId);
    if (idx == -1) return;

    final currentlyFav = _places[idx]['is_favorite'] == true;
    setState(() {
      _places[idx]['is_favorite'] = !currentlyFav;
      _places[idx]['favorites_count'] = (_places[idx]['favorites_count'] ?? 0) + (currentlyFav ? -1 : 1);
    });

    try {
      if (!currentlyFav) {
        // insert
        await Supabase.instance.client.from('favorites').insert({
          'user_id': user.id,
          'place_id': placeId,
        });
      } else {
        // delete
        await Supabase.instance.client
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('place_id', placeId);
      }
    } catch (e) {
      // revert optimistic
      if (!mounted) return;
      setState(() {
        _places[idx]['is_favorite'] = currentlyFav;
        _places[idx]['favorites_count'] = (_places[idx]['favorites_count'] ?? 0) + (currentlyFav ? 0 : -1);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error toggling favourite: $e')));
    }
  }

  void _showUniversitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text('Pilih Universitas', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ..._universities.map((u) {
                final idRaw = u['id'];
                final id = (idRaw is int) ? idRaw : int.tryParse(idRaw.toString());
                final name = u['name'] ?? '';
                final selected = id == _selectedUniversityId;
                return ListTile(
                  title: Text(name),
                  trailing: selected ? const Icon(Icons.check, color: Color(0xFFA22523)) : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _selectedUniversityId = id;
                      _selectedUniversityName = name;
                      _loading = true;
                    });
                    _loadPlaces();
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChips() {
    final categories = _categories.isNotEmpty ? _categories : ['Semua', 'Ayam Geprek', 'Masakan Rumahan', 'Bakso', 'Pizzazz'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isActive = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFAA2623) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFAA2623)),
            ),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFFAA2623),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    final name = place['name'] ?? 'Nama Tempat';
    final price = place['price_range'] ?? 'Rp.10.000-25.000';
    final address = place['address'] ?? 'Jl. Gebang Lor No. X';
    final rating = (place['rating'] != null) ? place['rating'].toString() : '4.8';
    final imageUrl = (place['image_url'] != null && place['image_url'] != '') ? place['image_url'] as String : null;
    final favoritesCount = place['favorites_count'] ?? 0;
    final isFav = place['is_favorite'] == true;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Left: image with rating badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 84,
                    height: 84,
                    color: Colors.grey.shade200,
                    child: imageUrl != null
                        ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.camera_alt_outlined, size: 36, color: Colors.grey))
                        : const Icon(Icons.camera_alt_outlined, size: 36, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF4B33A), size: 14),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Middle: details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(price, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Expanded(child: Text(address, style: const TextStyle(color: Colors.black54))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('$favoritesCount orang menyukai', style: const TextStyle(color: Colors.black38, fontSize: 12)),
                ],
              ),
            ),

            // Right: favorite
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    final idRaw = place['id'];
                    final id = (idRaw is int) ? idRaw : int.tryParse(idRaw.toString()) ?? 0;
                    _toggleFavorite(id);
                  },
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? const Color(0xFFF94931) : Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top red header with location pill
            Container(
              padding: EdgeInsets.only(top: statusBar, left: 16, right: 16, bottom: 18),
              decoration: const BoxDecoration(
                color: Color(0xFFCB3127),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text('Rekomendasi Mahasiswa', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Location pill (tap to change university)
                  GestureDetector(
                    onTap: () {
                      if (_universities.isNotEmpty) {
                        _showUniversitySelector();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDEB),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.place, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_selectedUniversityName, style: const TextStyle(color: Colors.white))),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryChips(),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // List
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadPlaces,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                        itemCount: _places.length,
                        itemBuilder: (context, index) {
                          return _buildPlaceCard(_places[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      // Bottom nav with centered home button
      bottomNavigationBar: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.favorite_border, color: Color(0xFFBDBDBD)),
                      Icon(Icons.history, color: Color(0xFFBDBDBD)),
                      SizedBox(width: 64), // space for center button
                      Icon(Icons.person_outline, color: Color(0xFFBDBDBD)),
                      Icon(Icons.search, color: Color(0xFFBDBDBD)),
                    ],
                  ),
                ),
              ),
            ),

            // center floating red home
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 84,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA22523),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
                  ),
                  child: const Center(child: Icon(Icons.home_outlined, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
