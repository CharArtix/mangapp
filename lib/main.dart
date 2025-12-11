import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// MAIN ENTRY POINT
// -----------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://oxxahfjamjbxukkilnkj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94eGFoZmphbWpieHVra2lsbmtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyNjM5NzYsImV4cCI6MjA3OTgzOTk3Nn0.jQ1uVCCdOYrwjTLZg3Oh--VTf-UTC2pG5tjGIX1coqo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mangapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Gilroy', // Pastikan font ini ada di pubspec.yaml
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA22523)),
      ),
      home: const LoginScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// LOGIN SCREEN
// -----------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Email dan Password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              _buildBackground(screenHeight, screenWidth),
              _buildLogo(screenHeight),
              // White Card
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
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Login',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF343446),
                              fontFamily: 'Inter')),
                      const SizedBox(height: 30),
                      _buildLabel('Email Address'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Masukkan email anda'),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration('Masukkan password')
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black.withOpacity(0.4)),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot password?',
                            style: TextStyle(
                                fontSize: 14.5,
                                color: const Color(0xFF343446),
                                decoration: TextDecoration.underline,
                                fontFamily: 'Inter')),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA22523),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text('Log in',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.7,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Don't have an account yet? ",
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      color: const Color(0xFF343446),
                                      fontFamily: 'Inter')),
                              TextSpan(
                                text: 'Register',
                                style: const TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0xFF566CD8),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen()),
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

// -----------------------------------------------------------------------------
// REGISTER SCREEN
// -----------------------------------------------------------------------------

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Mohon isi semua data')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user != null) {
        // Simpan username ke tabel profiles
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'username': username,
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register Gagal: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              _buildBackground(screenHeight, screenWidth),
              _buildLogo(screenHeight),
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
                        topRight: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Register',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF343446),
                              fontFamily: 'Inter')),
                      const SizedBox(height: 20),
                      _buildLabel('Email'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('contoh@email.com'),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Username'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        decoration: _inputDecoration('Username unik anda'),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration('Minimal 6 karakter')
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black.withOpacity(0.4)),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA22523),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text('Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.7,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                      fontSize: 14.5,
                                      color: const Color(0xFF343446),
                                      fontFamily: 'Inter')),
                              TextSpan(
                                text: 'Login',
                                style: const TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0xFF566CD8),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pop(context),
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

// -----------------------------------------------------------------------------
// SHARED WIDGETS
// -----------------------------------------------------------------------------

Widget _buildBackground(double height, double width) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      height: height * 0.45,
      decoration: BoxDecoration(
        color: const Color(0xFFCB3127),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(width * 0.15),
            bottomRight: Radius.circular(width * 0.15)),
      ),
      child: Stack(
        children: [
          Positioned(
              top: -50,
              right: -80,
              child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.3)))),
          Positioned(
              bottom: 20,
              right: -60,
              child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.3)))),
        ],
      ),
    ),
  );
}

Widget _buildLogo(double height) {
  return Positioned(
    top: height * 0.08,
    left: 0,
    right: 0,
    child: Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4)),
          child: const Center(
              child: Text('M',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'))),
        ),
        const SizedBox(height: 8),
        const Text('Mangapp',
            style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontFamily: 'Pacifico',
                fontWeight: FontWeight.w400)),
      ],
    ),
  );
}

Widget _buildLabel(String text) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
            text: text,
            style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF343446))),
        const TextSpan(
            text: '*',
            style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF94931))),
      ],
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 14.5, color: Colors.black.withOpacity(0.3)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}

// -----------------------------------------------------------------------------
// HOME PAGE
// -----------------------------------------------------------------------------

class HomePage extends StatefulWidget {
  // Tambahkan parameter initialIndex agar bisa dibuka dari halaman lain
  final int initialIndex;
  
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  late int _selectedIndex;
  String? selectedCity;
  List<String> cities = [];
  List<Map<String, dynamic>> universities = [];
  List<Map<String, dynamic>> favorites = [];
  bool isLoadingHome = true;
  bool isLoadingFav = true;

  @override
  void initState() {
    super.initState();
    // Set index awal berdasarkan parameter
    _selectedIndex = widget.initialIndex;
    
    fetchCities();
    
    // Jika langsung buka tab Favorit, load datanya
    if (_selectedIndex == 1) {
      fetchFavorites();
    }
  }

  // --- LOGIC HOME ---
  Future<void> fetchCities() async {
    try {
      final res = await supabase.from('cities').select('name');
      cities = res.map<String>((row) => row['name'] as String).toList();

      if (selectedCity == null && cities.isNotEmpty) {
        selectedCity = cities.first;
      }

      await fetchUniversities();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error fetching cities: $e");
    }
  }

  Future<void> fetchUniversities() async {
    try {
      setState(() => isLoadingHome = true);
      final res = await supabase
          .from('universities')
          .select('id, name, city_id, cities!inner(name)')
          .eq('cities.name', selectedCity!);

      universities = res
          .map<Map<String, dynamic>>((u) => {
                'id': u['id'],
                'name': u['name'],
                'icon': Icons.school,
              })
          .toList();

      if (mounted) setState(() => isLoadingHome = false);
    } catch (e) {
      if (mounted) setState(() => isLoadingHome = false);
    }
  }

  // --- LOGIC FAVORITES ---
  Future<void> fetchFavorites() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => isLoadingFav = false);
        return;
      }
      setState(() => isLoadingFav = true);

      // Ambil places yang di-favoritkan user
      final res = await supabase
          .from('favorites')
          .select('places(*)')
          .eq('user_id', user.id);

      final List<Map<String, dynamic>> loaded = [];
      for (var item in (res as List)) {
        if (item['places'] != null) {
          loaded.add(Map<String, dynamic>.from(item['places']));
        }
      }

      setState(() {
        favorites = loaded;
        isLoadingFav = false;
      });
    } catch (e) {
      debugPrint("Fav error: $e");
      if (mounted) setState(() => isLoadingFav = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      fetchFavorites();
    }
  }

  Widget _buildHomeView() {
    return Column(
      children: [
        // Header Merah
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          child: Column(
            children: [
              const Icon(Icons.location_city, size: 80, color: Colors.white),
              const SizedBox(height: 30),
              const Text(
                'Pilih lokasi Anda',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCity,
                              dropdownColor: const Color(0xFFE53935),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              isExpanded: true,
                              items: cities
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ))
                                  .toList(),
                              onChanged: (v) async {
                                selectedCity = v;
                                await fetchUniversities();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // White Curved Container
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan tombol navigasi ke Favorites
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Perguruan Tinggi',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // Tombol navigasi ke Favorites
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = 1);
                          fetchFavorites();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoadingHome
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: universities.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlaceListPage(
                                    universityId: universities[i]['id'],
                                    universityName: universities[i]['name'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(universities[i]['icon'],
                                      color: Colors.black87),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      universities[i]['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- UI FAVORITES VIEW ---
  Widget _buildFavoritesView() {
    return Column(
      children: [
        // Header Merah
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          child: Column(
            children: [
              const Icon(Icons.favorite, size: 80, color: Colors.white),
              const SizedBox(height: 30),
              const Text(
                'Tempat Favorit Anda',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 50),
            ],
          ),
        ),
        // White Curved Container
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Text(
                    'Daftar Tersimpan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: isLoadingFav
                      ? const Center(child: CircularProgressIndicator())
                      : favorites.isEmpty
                          ? const Center(child: Text("Belum ada favorit"))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: favorites.length,
                              itemBuilder: (_, i) {
                                final place = favorites[i];
                                final imageUrl = place['image_url'];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          color: Colors.grey[200],
                                          child: (imageUrl != null &&
                                                  imageUrl
                                                      .toString()
                                                      .isNotEmpty)
                                              ? Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey),
                                                )
                                              : const Icon(Icons.image,
                                                  color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              place['name'] ?? 'Nama Tempat',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              place['price_range'] ?? '',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    size: 16,
                                                    color: Colors.orange),
                                                const SizedBox(width: 4),
                                                Text(place['rating']
                                                        ?.toString() ??
                                                    "-"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = _buildHomeView();
        break;
      case 1:
        bodyContent = _buildFavoritesView();
        break;
      case 2:
        bodyContent = _buildPlaceholderView("History\n(Coming Soon)");
        break;
      case 3:
        bodyContent = _buildPlaceholderView("Profile\n(Coming Soon)");
        break;
      default:
        bodyContent = _buildHomeView();
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE53935), Color(0xFFC62828)],
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: bodyContent,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 0
                          ? Icons.home
                          : Icons.home_outlined),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 1
                          ? Icons.favorite
                          : Icons.favorite_border),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 2
                          ? Icons.history
                          : Icons.history_toggle_off),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedIndex == 3
                          ? Icons.person
                          : Icons.person_outline),
                      label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PLACE LIST PAGE (DENGAN TOMBOL FAVORITE & NAVIGASI YANG BENAR)
// -----------------------------------------------------------------------------

class PlaceListPage extends StatefulWidget {
  final int universityId;
  final String universityName;

  const PlaceListPage({
    super.key,
    required this.universityId,
    required this.universityName,
  });

  @override
  State<PlaceListPage> createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> places = [];
  bool isLoading = true;
  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    try {
      final user = supabase.auth.currentUser;

      // Ambil places dengan info favorites
      final res = await supabase
          .from('places')
          .select('*, favorites(*)')
          .eq('university_id', widget.universityId);

      final List<Map<String, dynamic>> loadedPlaces = [];
      for (final item in (res as List).cast<Map<String, dynamic>>()) {
        final favs = (item['favorites'] is List)
            ? List<Map<String, dynamic>>.from(
                item['favorites'].cast<Map<String, dynamic>>())
            : <Map<String, dynamic>>[];
        
        final isFav = (user != null) 
            ? favs.any((f) => f['user_id'] == user.id) 
            : false;
        
        final cleaned = Map<String, dynamic>.from(item);
        cleaned['is_favorite'] = isFav;
        loadedPlaces.add(cleaned);
      }

      setState(() {
        places = loadedPlaces;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFavorite(int placeId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan login terlebih dahulu')));
      return;
    }

    final idx = places.indexWhere((p) => p['id'] == placeId);
    if (idx == -1) return;

    final currentlyFav = places[idx]['is_favorite'] == true;
    
    // Update UI optimistically
    setState(() {
      places[idx]['is_favorite'] = !currentlyFav;
    });

    try {
      if (!currentlyFav) {
        // Add to favorites
        await supabase
            .from('favorites')
            .insert({'user_id': user.id, 'place_id': placeId});
      } else {
        // Remove from favorites
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('place_id', placeId);
      }
    } catch (e) {
      if (!mounted) return;
      // Revert UI if failed
      setState(() {
        places[idx]['is_favorite'] = currentlyFav;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
    }
  }

  // Handle Navigasi Navbar Bawah
  void _onBottomNavTapped(int index) {
    // Navigasi kembali ke HomePage dengan index tab yang sesuai
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomePage(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: bottomIndex,
                onTap: _onBottomNavTapped, // Menggunakan logika navigasi baru
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(bottomIndex == 0
                          ? Icons.home
                          : Icons.home_outlined),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(bottomIndex == 1
                          ? Icons.favorite
                          : Icons.favorite_border),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(bottomIndex == 2
                          ? Icons.history
                          : Icons.history_toggle_off),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(bottomIndex == 3
                          ? Icons.person
                          : Icons.person_outline),
                      label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFC62828)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navbar Atas
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB61C1C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.universityName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Bar Dummy
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 25, 20, 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6E6E6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.search,
                                          color: Colors.black54),
                                      SizedBox(width: 10),
                                      Text("Cari makanan atau tempat",
                                          style:
                                              TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Section Rekomendasi
                              _buildSection(
                                "Rekomendasi Mahasiswa",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RecommendationPage(
                                        initialUniversityId:
                                            widget.universityId,
                                        initialUniversityName:
                                            widget.universityName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildHorizontalList(),
                              const SizedBox(height: 24),
                              _buildSection("Hidden Gem"),
                              const SizedBox(height: 14),
                              _buildHorizontalList(),
                              const SizedBox(height: 24),
                              _buildSection("Lainnya"),
                              const SizedBox(height: 14),
                              _buildVerticalList(),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
          if (onPressed != null)
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: onPressed,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: places.length,
        itemBuilder: (_, i) => _buildHorizontalCard(places[i]),
      ),
    );
  }

  Widget _buildHorizontalCard(Map<String, dynamic> place) {
    final imageUrl = place["image_url"]?.toString();
    final isFav = place['is_favorite'] == true;
    final placeId = place['id'];
    
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey))),
                        )
                      : const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey)),
                ),
                // Favorite Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(placeId),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFF94931) : Colors.black54,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              place['name']?.toString() ?? 'Nama Tempat',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(place['price_range']?.toString() ?? '',
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(place['rating']?.toString() ?? "-",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: places.length,
      itemBuilder: (_, i) => _buildVerticalCard(places[i]),
    );
  }

  Widget _buildVerticalCard(Map<String, dynamic> place) {
    final imageUrl = place["image_url"]?.toString();
    final isFav = place['is_favorite'] == true;
    final placeId = place['id'];
    
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 70,
                width: 70,
                color: Colors.grey[200],
                child: (imageUrl != null && imageUrl.isNotEmpty)
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                      )
                    : const Icon(Icons.image_not_supported,
                        color: Colors.grey),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(place["rating"]?.toString() ?? "-"),
                  ]),
                  Text(place["name"]?.toString() ?? "Nama Tempat",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(place["price_range"]?.toString() ?? "",
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Row(children: const [
                    Icon(Icons.location_on,
                        size: 14, color: Colors.black45),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text("Alamat tidak ditampilkan",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: Colors.black45)),
                    ),
                  ])
                ],
              ),
            ),
            // Favorite Button
            IconButton(
              onPressed: () => _toggleFavorite(placeId),
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? const Color(0xFFF94931) : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// RECOMMENDATION PAGE (LENGKAP DENGAN FILTER CHIPS)
// -----------------------------------------------------------------------------

class RecommendationPage extends StatefulWidget {
  final int? initialUniversityId;
  final String? initialUniversityName;

  const RecommendationPage(
      {super.key, this.initialUniversityId, this.initialUniversityName});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _places = [];
  bool _loading = true;
  List<String> _categories = [];
  String _selectedCategory = 'Semua';
  String _selectedUniversityName = '';
  List<Map<String, dynamic>> _universities = [];
  int? _selectedUniversityId;

  @override
  void initState() {
    super.initState();
    _selectedUniversityId = widget.initialUniversityId;
    _selectedUniversityName = widget.initialUniversityName ?? '';
    _initData();
  }

  Future<void> _initData() async {
    setState(() => _loading = true);
    try {
      await _loadUniversities();
      await _loadCategories();
      await _loadPlaces();
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _loadUniversities() async {
    try {
      final res = await supabase.from('universities').select().order('name');
      final list = (res as List).cast<Map<String, dynamic>>().toList();
      setState(() {
        _universities = list;
        if (_selectedUniversityId == null && list.isNotEmpty) {
          final first = list.first;
          _selectedUniversityId = (first['id'] is int)
              ? first['id'] as int
              : int.tryParse(first['id'].toString());
          _selectedUniversityName =
              (first['name']?.toString() ?? 'Pilih Lokasi');
        }
      });
    } catch (_) {}
  }

  Future<void> _loadCategories() async {
    try {
      // Pastikan Anda memiliki tabel 'jenisresto' di Supabase
      final res = await supabase.from('jenisresto').select('nama');
      final list = (res as List).cast<Map<String, dynamic>>().toList();
      final names = <String>[];
      for (final item in list) {
        final n = item['nama']?.toString();
        if (n != null && n.isNotEmpty) names.add(n.trim());
      }
      final uniq = names.toSet().toList();
      setState(() {
        _categories = ['Semua', ...uniq];
        _selectedCategory = 'Semua';
      });
    } catch (_) {
      // Fallback jika tabel belum ada atau error
      setState(() {
        _categories = ['Semua'];
        _selectedCategory = 'Semua';
      });
    }
  }

  Future<void> _loadPlaces() async {
    setState(() => _loading = true);
    try {
      final user = supabase.auth.currentUser;

      final base = supabase.from('places').select('*, favorites(*)');
      final res = (_selectedUniversityId != null)
          ? await base
              .eq('university_id', _selectedUniversityId!)
              .order('rating', ascending: false)
          : await base.order('rating', ascending: false);

      final List<Map<String, dynamic>> places = [];
      for (final item in (res as List).cast<Map<String, dynamic>>()) {
        final favs = (item['favorites'] is List)
            ? List<Map<String, dynamic>>.from(
                item['favorites'].cast<Map<String, dynamic>>())
            : <Map<String, dynamic>>[];
        final favCount = favs.length;
        final isFav =
            (user != null) ? favs.any((f) => f['user_id'] == user.id) : false;
        final cleaned = Map<String, dynamic>.from(item);
        cleaned['favorites_count'] = favCount;
        cleaned['is_favorite'] = isFav;
        places.add(cleaned);
      }

      // Filter lokal berdasarkan kategori (Nama Kategori vs Nama Tempat/Jenis)
      // Note: Idealnya ada relasi ID kategori, tapi di sini kita filter text
      final filtered = (_selectedCategory != 'Semua')
          ? places.where((p) {
              final pname = (p['name'] ?? '').toString().toLowerCase();
              final pdesc = (p['description'] ?? '').toString().toLowerCase();
              final term = _selectedCategory.toLowerCase();
              return pname.contains(term) || pdesc.contains(term);
            }).toList()
          : places;

      if (!mounted) return;
      setState(() {
        _places = filtered;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleFavorite(int placeId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to favourite places')));
      return;
    }

    final idx = _places.indexWhere((p) => p['id'] == placeId);
    if (idx == -1) return;

    final currentlyFav = _places[idx]['is_favorite'] == true;
    setState(() {
      _places[idx]['is_favorite'] = !currentlyFav;
      _places[idx]['favorites_count'] =
          (_places[idx]['favorites_count'] ?? 0) + (currentlyFav ? -1 : 1);
    });

    try {
      if (!currentlyFav) {
        await supabase
            .from('favorites')
            .insert({'user_id': user.id, 'place_id': placeId});
      } else {
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('place_id', placeId);
      }
    } catch (e) {
      if (!mounted) return;
      // Revert UI jika gagal
      setState(() {
        _places[idx]['is_favorite'] = currentlyFav;
        _places[idx]['favorites_count'] =
            (_places[idx]['favorites_count'] ?? 0) + (currentlyFav ? 0 : -1);
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling favourite: $e')));
    }
  }

  void _showUniversitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 12),
            const Text('Pilih Universitas',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _universities.map((u) {
                  final idRaw = u['id'];
                  final id = (idRaw is int)
                      ? idRaw
                      : int.tryParse(idRaw.toString());
                  final name = u['name'] ?? '';
                  final selected = id == _selectedUniversityId;
                  return ListTile(
                    title: Text(name),
                    trailing: selected
                        ? const Icon(Icons.check, color: Color(0xFFA22523))
                        : null,
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
              ),
            ),
            const SizedBox(height: 16),
          ]),
        );
      },
    );
  }

  Widget _buildCategoryChips() {
    if (_categories.isEmpty) return const SizedBox.shrink();
    final categories = _categories;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isActive = categories[index] == _selectedCategory;
          return GestureDetector(
            onTap: () async {
              setState(() {
                _selectedCategory = categories[index];
                _loading = true;
              });
              await _loadPlaces();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFAA2623) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFAA2623))),
              child: Center(
                  child: Text(categories[index],
                      style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : const Color(0xFFAA2623),
                          fontWeight: FontWeight.w600))),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    final name = (place['name'] != null) ? place['name'].toString() : '';
    final price =
        (place['price_range'] != null) ? place['price_range'].toString() : '';
    final address =
        (place['address'] != null) ? place['address'].toString() : '';
    final rating =
        (place['rating'] != null) ? place['rating'].toString() : '';
    final imageUrl =
        (place['image_url'] != null && place['image_url'] != '')
            ? place['image_url'] as String
            : null;
    final favoritesCount = place['favorites_count'] ?? 0;
    final isFav = place['is_favorite'] == true;
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Image with rating badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 84,
                    height: 84,
                    color: Colors.grey.shade200,
                    child: imageUrl != null
                        ? Image.network(imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.camera_alt_outlined,
                                size: 36,
                                color: Colors.grey))
                        : const Icon(Icons.camera_alt_outlined,
                            size: 36, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6)
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFFF4B33A), size: 14),
                        const SizedBox(width: 4),
                        Text(rating,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(price,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(address,
                              style:
                                  const TextStyle(color: Colors.black54))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('$favoritesCount orang menyukai',
                      style: const TextStyle(
                          color: Colors.black38, fontSize: 12)),
                ],
              ),
            ),

            // Favorit Button
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    final idRaw = place['id'];
                    final id = (idRaw is int)
                        ? idRaw
                        : int.tryParse(idRaw.toString()) ?? 0;
                    _toggleFavorite(id);
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav
                        ? const Color(0xFFF94931)
                        : Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handle Navigasi Navbar Bawah
  void _onBottomNavTapped(int index) {
    // Navigasi kembali ke HomePage dengan index tab yang sesuai
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomePage(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFC62828)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: InkWell(
                  onTap: _showUniversitySelector,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB61C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedUniversityName.isNotEmpty
                                ? _selectedUniversityName
                                : 'Pilih Lokasi',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.keyboard_arrow_down,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rekomendasi Mahasiswa',
                              style: TextStyle(
                                  color: Color(0xFF343446),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildCategoryChips(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadPlaces,
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 0, 12, 80),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: 0,
                onTap: _onBottomNavTapped, // Menggunakan logika navigasi baru
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history_toggle_off), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline), label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}