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
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Gagal: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Tinggi konten form yang akan tetap (Judul, Field, Forgot Password)
    // Diperkirakan 30 (padding atas) + 42 (Title) + 20 (Space) + 140 (2 Fields) + 40 (Forgot Password) = ~270px
    const double fixedButtonAreaHeight = 110.0;

    return Scaffold(
      backgroundColor: Colors.white,
      // Hapus SingleChildScrollView dari body, ganti dengan Stack
      body: Stack(
        children: [
          // 1. Header (Background Merah)
          // Dibatasi tingginya agar tidak menutupi seluruh layar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: _buildHeader(screenHeight, screenWidth),
          ),

          // 2. Form Input (Bagian yang bisa di-scroll)
          Positioned(
            top: screenHeight * 0.47, // Form mulai di 47% layar
            left: 0,
            right: 0,
            bottom: fixedButtonAreaHeight, // <-- Dibatasi setinggi area tombol
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                // <-- Form input kini bisa di-scroll
                padding: const EdgeInsets.fromLTRB(
                  30,
                  30,
                  30,
                  0,
                ), // Padding atas Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF343446),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildLabel('Email'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Masukkan email anda'),
                    ),

                    const SizedBox(height: 14),

                    _buildLabel('Password'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration('Masukkan Password anda')
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                    ),

                    // Link Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF343446),
                            decoration: TextDecoration.underline,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),

                    // Spacer agar ada jarak sebelum konten berakhir/mentok
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tombol Login (FIXED di bawah)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fixedButtonAreaHeight, // Tinggi area tombol
            child: Container(
              color: Colors
                  .white, // Background putih agar tombol tidak menimpa konten scroll
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
                top: 10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA22523),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Link Register
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account yet? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF343446),
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF566CD8),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mohon isi semua data')));
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

    // Tingkat tombol fixed di bawah
    const double fixedButtonAreaHeight = 110.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Header (Background Merah)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: _buildHeader(screenHeight, screenWidth),
          ),

          // 2. Form Input (Bagian yang bisa di-scroll)
          Positioned(
            top: screenHeight * 0.47,
            left: 0,
            right: 0,
            bottom: fixedButtonAreaHeight, // Dibatasi setinggi area tombol
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF343446),
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 10),

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
                                color: Colors.black.withOpacity(0.4),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                    ),

                    // Spacer agar scroll tidak mentok ke input terakhir
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tombol Register (FIXED di bawah)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fixedButtonAreaHeight,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
                top: 10,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA22523),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Link Login
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF343446),
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF566CD8),
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
    );
  }
}

// -----------------------------------------------------------------------------
// CURVED WIDGETS
// -----------------------------------------------------------------------------

class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 1. Mulai dari Kiri Atas (0,0) - Default start

    // 2. Tarik garis ke Kiri Bawah (Titik A)
    // Angka '80' menentukan seberapa curam V-nya.
    // Semakin besar angkanya, semakin dalam V-nya.
    path.lineTo(0, size.height - 180);

    // 3. Tarik garis ke Tengah Bawah (Titik B - Ujung V)
    path.lineTo(size.width / 2.2, size.height - 110);

    // 4. Tarik garis ke Kanan Bawah (Titik C)
    path.lineTo(size.width, size.height - 165);

    // 5. Tutup ke Kanan Atas
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// -----------------------------------------------------------------------------
// HEADER WIDGETS
// -----------------------------------------------------------------------------

Widget _buildHeader(double screenHeight, double screenWidth) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      ClipPath(
        clipper: CurvedHeaderClipper(), // Panggil Clipper Lengkung
        child: Container(
          height:
              screenHeight * 0.55, // Area container diperbesar agar kurva muat
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFC62828),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_pattern.png'),
              fit: BoxFit.cover,
              opacity: 0.7,
            ),
          ),
        ),
      ),
      Positioned(
        top: screenHeight * 0.06, // Logo naik sedikit
        child: Image.asset(
          'assets/images/logo_mangapp.png',
          width: screenWidth * 0.60,
          fit: BoxFit.contain,
        ),
      ),
    ],
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
            color: Color(0xFF343446),
          ),
        ),
        const TextSpan(
          text: '*',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF94931),
          ),
        ),
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
  String? _username = "Mahasiswa";
  String? _email = "user@email.com";
  List<String> cities = [];
  List<Map<String, dynamic>> universities = [];
  List<Map<String, dynamic>> favorites = [];
  bool isLoadingHome = true;
  bool isLoadingFav = true;
  bool _isLoadingProfile = true;
  bool _isLoadingHistory = true;
  // List<Map<String, dynamic>> _rawHistory = [];
  Map<String, List<Map<String, dynamic>>> _groupedHistory = {};
  double _totalExpense = 0;

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
    if (_selectedIndex == 2) fetchHistory();
    if (_selectedIndex == 3) fetchProfile();
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
          .map<Map<String, dynamic>>(
            (u) => {'id': u['id'], 'name': u['name'], 'icon': Icons.school},
          )
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

  // --- LOGIC HISTORY ---
  Future<void> fetchHistory() async {
    setState(() => _isLoadingHistory = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => _isLoadingHistory = false);
        return;
      }

      // QUERY BARU: Mengambil data history beserta detail menu dan tempatnya
      final response = await supabase
          .from('history')
          .select('*, menus(*, places(*))') // <--- JOIN RELASI
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      _processHistoryData(data);
    } catch (e) {
      debugPrint("Error fetching history: $e");
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  void _processHistoryData(List<Map<String, dynamic>> data) {
    double tempTotal = 0;
    Map<String, List<Map<String, dynamic>>> tempGrouped = {};

    final List<String> months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final now = DateTime.now();
    final todayStr = "${now.day} ${months[now.month]} ${now.year}";
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayStr =
        "${yesterday.day} ${months[yesterday.month]} ${yesterday.year}";

    for (var item in data) {
      final price = (item['price'] ?? 0).toDouble();
      tempTotal += price;

      final date = DateTime.parse(item['created_at']).toLocal();
      final dateKeyRaw = "${date.day} ${months[date.month]} ${date.year}";

      String displayKey = dateKeyRaw;

      if (dateKeyRaw == todayStr) {
        displayKey = "Hari ini";
      } else if (dateKeyRaw == yesterdayStr) {
        displayKey = "Kemarin";
      } else {
        displayKey = "${date.day} ${months[date.month]}";
      }

      if (!tempGrouped.containsKey(displayKey)) {
        tempGrouped[displayKey] = [];
      }
      tempGrouped[displayKey]!.add(item);
    }

    if (mounted) {
      setState(() {
        // _rawHistory = data;
        _groupedHistory = tempGrouped;
        _totalExpense = tempTotal;
        _isLoadingHistory = false;
      });
    }
  }

  String _formatCurrency(double amount) {
    return "Rp.${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // --- LOGIC PROFILE ---
  Future<void> fetchProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        _email = user.email;

        // Ambil username dari tabel profiles
        final res = await supabase
            .from('profiles')
            .select('username')
            .eq('id', user.id)
            .maybeSingle();

        if (res != null) {
          _username = res['username'];
        }
      }
    } catch (e) {
      debugPrint("Profile Error: $e");
    } finally {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await supabase.auth.signOut();
      if (!mounted) return;
      Navigator.pop(context); // Tutup dialog

      // Kembali ke Login & Hapus history route
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout Gagal: $e')));
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      fetchFavorites();
    }
    if (index == 2) fetchHistory();
    if (index == 3) fetchProfile();
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
                      horizontal: 20,
                      vertical: 12,
                    ),
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
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              isExpanded: true,
                              items: cities
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                                  Icon(
                                    universities[i]['icon'],
                                    color: Colors.black87,
                                  ),
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
                  fontWeight: FontWeight.bold,
                ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: favorites.length,
                          itemBuilder: (_, i) {
  final place = favorites[i];
  final imageUrl = place['image_url'];

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailTempatPage(place: place),
        ),
      );
    },
    child: Container(
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
          ),
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
              child: (imageUrl != null && imageUrl.toString().isNotEmpty)
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'] ?? 'Nama Tempat',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  place['price_range'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(place['rating']?.toString() ?? "-"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  // --- UI HISTORY VIEW ---
  Widget _buildHistoryView() {
    return Column(
      children: [
        // 1. Header Card Merah (Floating Card Style)
        Container(
          width: double.infinity,
          // PERBAIKAN: Tambahkan Margin agar tidak mentok ke pinggir
          margin: const EdgeInsets.all(24), 
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828),
            // Opsional: Un-comment baris ini jika pattern sudah ada di assets
            image: const DecorationImage(
               image: AssetImage('assets/images/bg_pattern.png'), 
               fit: BoxFit.cover, 
               opacity: 1
            ),
            // PERBAIKAN: Radius melingkar di SEMUA sisi
            borderRadius: BorderRadius.circular(24), 
            // Opsional: Shadow agar terlihat mengambang
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC62828).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Pengeluaran",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Bulan ini",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _formatCurrency(_totalExpense),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),

        // 2. List History
        Expanded(
          child: _isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : _groupedHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text("Belum ada riwayat", style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      // Tambahkan padding bawah lebih besar agar tidak tertutup navbar
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      itemCount: _groupedHistory.length,
                      itemBuilder: (context, index) {
                        String dateKey = _groupedHistory.keys.elementAt(index);
                        List<Map<String, dynamic>> items = _groupedHistory[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12, top: 10),
                              child: Text(
                                dateKey,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF343446),
                                ),
                              ),
                            ),
                            ...items.map((item) => _buildHistoryItem(item)).toList(),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
        ),
      ],
    );
  }

  // Helper Widget untuk Item History
  Widget _buildHistoryItem(Map<String, dynamic> item) {
    // Ambil data dari relasi (Safety check agar tidak error jika data menu dihapus)
    final menu = item['menus'] ?? {};
    final place = menu['places'] ?? {};

    final menuName = menu['name'] ?? 'Menu Dihapus';
    final placeName = place['name'] ?? 'Tempat Tidak Diketahui';
    final menuImage = menu['image_url']; // Bisa null

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Gambar Menu
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: (menuImage != null && menuImage.toString().isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      menuImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.camera_alt,
                          color: Colors.white),
                    ),
                  )
                : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),

          // Detail Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuName, // Menggunakan nama dari tabel menus
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343446),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  placeName, // Menggunakan nama dari tabel places
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency((item['price'] ?? 0).toDouble()),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF343446),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Container(
      color: Colors.white, // Pastikan background putih
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Judul Header
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343446),
            ),
          ),

          const SizedBox(height: 50),

          // Avatar Icon (Lingkaran Tebal)
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 4, // Ketebalan garis lingkaran
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 70, color: Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // Username
          _isLoadingProfile
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _username ?? 'Username',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343446),
                  ),
                ),

          const SizedBox(height: 4),

          // Email
          Text(
            _email ?? 'user@email.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 60),

          // Menu Items (Edit Profile & Ganti Password)
          _buildSimpleMenuItem(
            icon: Icons.edit_outlined,
            title: "Edit Profile",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          _buildSimpleMenuItem(
            icon: Icons.lock_outline,
            title: "Ganti Password",
            onTap: () {},
          ),

          const Spacer(),

          // Tombol Sign Out (Merah Solid & Shadow)
          Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.only(
              bottom: 120,
            ), // Jarak dari bawah (untuk navbar)
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA22523).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA22523), // Warna Merah Gelap
                foregroundColor: Colors.white,
                elevation:
                    0, // Kita pakai shadow manual di Container agar lebih soft
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ), // Icon Pintu Keluar
                  SizedBox(width: 10),
                  Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Item Menu Sederhana
  Widget _buildSimpleMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8), // Spacing klik
        child: Row(
          children: [
            // Icon Kiri
            Icon(icon, color: const Color(0xFF343446), size: 26),
            const SizedBox(width: 16),

            // Teks Judul
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF343446),
                ),
              ),
            ),

            // Panah Kanan
            const Icon(Icons.chevron_right, color: Colors.black54, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        bodyContent = _buildHistoryView();
        break;
      case 3:
        bodyContent = _buildProfileView();
        break;
      default:
        bodyContent = _buildHomeView();
    }

    bool isProfileTab = _selectedIndex == 2 || _selectedIndex == 3;

    return Scaffold(
      extendBody: true,
      body: Container(
        // JIKA Profile: Putih, JIKA Lainnya: Gradien Merah
        decoration: BoxDecoration(
          color: isProfileTab ? Colors.white : null,
          gradient: isProfileTab
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE53935), Color(0xFFC62828)],
                ),
        ),
        width: double.infinity,
        child: SafeArea(
          // Pada profile, kita ingin content mentok atas, jadi sesuaikan bottom-nya saja
          bottom: false,
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
                color: const Color(0xFFA22523).withOpacity(0.95),
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
                    icon: Icon(
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      _selectedIndex == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.history
                          : Icons.history_toggle_off,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                    ),
                    label: '',
                  ),
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

      final res = await supabase
          .from('places')
          .select('''
            *,
            favorites!left (
              user_id
            )
          ''')
          .eq('university_id', widget.universityId);

      final List<Map<String, dynamic>> loadedPlaces = [];

      for (final item in (res as List).cast<Map<String, dynamic>>()) {
        final favs = (item['favorites'] is List)
            ? List<Map<String, dynamic>>.from(item['favorites'])
            : <Map<String, dynamic>>[];

        final favCount = favs.length;

        final isFav = (user != null)
            ? favs.any((f) => f['user_id'] == user.id)
            : false;

        final cleaned = Map<String, dynamic>.from(item);
        cleaned['is_favorite'] = isFav;
        cleaned['favorite_count'] = favCount;

        loadedPlaces.add(cleaned);
      }

      // ⬇️ SORT berdasarkan favorite_count DESC
      loadedPlaces.sort(
        (a, b) =>
            (b['favorite_count'] as int).compareTo(a['favorite_count'] as int),
      );

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
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
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
        await supabase.from('favorites').insert({
          'user_id': user.id,
          'place_id': placeId,
        });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                    icon: Icon(
                      bottomIndex == 0 ? Icons.home : Icons.home_outlined,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      bottomIndex == 1 ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      bottomIndex == 2
                          ? Icons.history
                          : Icons.history_toggle_off,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      bottomIndex == 3 ? Icons.person : Icons.person_outline,
                    ),
                    label: '',
                  ),
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
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
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
                            fontWeight: FontWeight.bold,
                          ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Bar Dummy
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  25,
                                  20,
                                  10,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6E6E6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.search, color: Colors.black54),
                                      SizedBox(width: 10),
                                      Text(
                                        "Cari makanan atau tempat",
                                        style: TextStyle(color: Colors.black54),
                                      ),
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (onPressed != null)
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailTempatPage(place: place)),
        );
      },
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
            ),
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
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
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
                          ),
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
            Text(
              place['price_range']?.toString() ?? '',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  place['rating']?.toString() ?? "-",
                  style: const TextStyle(fontSize: 12),
                ),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailTempatPage(place: place)),
        );
      },
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
              offset: const Offset(0, 3),
            ),
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
                            const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                      )
                    : const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(place["rating"]?.toString() ?? "-"),
                    ],
                  ),
                  Text(
                    place["name"]?.toString() ?? "Nama Tempat",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    place["price_range"]?.toString() ?? "",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 14, color: Colors.black45),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Alamat tidak ditampilkan",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
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

  const RecommendationPage({
    super.key,
    this.initialUniversityId,
    this.initialUniversityName,
  });

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
                item['favorites'].cast<Map<String, dynamic>>(),
              )
            : <Map<String, dynamic>>[];
        final favCount = favs.length;
        final isFav = (user != null)
            ? favs.any((f) => f['user_id'] == user.id)
            : false;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        const SnackBar(content: Text('Please login to favourite places')),
      );
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
        await supabase.from('favorites').insert({
          'user_id': user.id,
          'place_id': placeId,
        });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error toggling favourite: $e')));
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
              const Text(
                'Pilih Universitas',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
            ],
          ),
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
    final price = (place['price_range'] != null)
        ? place['price_range'].toString()
        : '';
    final address = (place['address'] != null)
        ? place['address'].toString()
        : '';
    final rating = (place['rating'] != null) ? place['rating'].toString() : '';
    final imageUrl = (place['image_url'] != null && place['image_url'] != '')
        ? place['image_url'] as String
        : null;

    final favoritesCount = place['favorites_count'] ?? 0;
    final isFav = place['is_favorite'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailTempatPage(
              place: place, // KIRIM DATA PLACE KE HALAMAN DETAIL
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.camera_alt_outlined,
                                size: 36,
                                color: Colors.grey,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt_outlined,
                              size: 36,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    left: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF4B33A),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(price, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$favoritesCount orang menyukai',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
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
                      color: isFav ? const Color(0xFFF94931) : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
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
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rekomendasi Mahasiswa',
                              style: TextStyle(
                                color: Color(0xFF343446),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildCategoryChips(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: _loadPlaces,
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    0,
                                    12,
                                    80,
                                  ),
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
                    icon: Icon(Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_toggle_off),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

  // --- UI Detail Tempat ---
class DetailTempatPage extends StatefulWidget {
  final Map<String, dynamic> place;

  const DetailTempatPage({super.key, required this.place});

  @override
  State<DetailTempatPage> createState() => _DetailTempatPageState();
}

class _DetailTempatPageState extends State<DetailTempatPage> {
  final supabase = Supabase.instance.client;

  bool _isLoadingMenu = true;
  bool _isLoadingReview = true;
  bool _isMenuSelected = true;
  bool _isFavorite = false;

  List<Map<String, dynamic>> _menus = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchMenus();
    _fetchReviews();
  }

  // ================= FETCH MENU =================
  Future<void> _fetchMenus() async {
    try {
      final res = await supabase
          .from('menus')
          .select()
          .eq('place_id', widget.place['id'])
          .order('created_at');

      setState(() {
        _menus = List<Map<String, dynamic>>.from(res);
        _isLoadingMenu = false;
      });
    } catch (e) {
      debugPrint('Error fetch menu: $e');
      setState(() {
        _isLoadingMenu = false;
      });
    }
  }

  // ================= FETCH REVIEW =================
  Future<void> _fetchReviews() async {
    try {
      final res = await supabase
          .from('reviews')
          .select('rating, comment, profiles(username)')
          .eq('place_id', widget.place['id'])
          .order('created_at', ascending: false);

      setState(() {
        _reviews = List<Map<String, dynamic>>.from(res);
        _isLoadingReview = false;
      });
    } catch (e) {
      debugPrint('Error fetch review: $e');
      setState(() {
        _isLoadingReview = false;
      });
    }
  }

  void _onBottomNavTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomePage(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final imageUrl = place['image_url'] ?? '';
    final name = place['name'] ?? 'Tanpa Nama';
    final address = place['address'] ?? 'Alamat tidak tersedia';
    final rating = (place['rating'] ?? 0).toString();

    return Scaffold(
      backgroundColor: const Color(0xFFC8C8C8),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER IMAGE =================
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color(0xFFB0B0B0),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.camera_alt,
                            size: 60,
                            color: Color(0xFF6B6B6B),
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Color(0xFF6B6B6B),
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ================= WHITE CONTENT AREA =================
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Nama Tempat & Rating
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFF8A00), size: 24),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Alamat atau Tab Section
                            if (_isMenuSelected) 
                              _buildAlamatSection(address)
                            else
                              const SizedBox.shrink(),

                            const SizedBox(height: 16),

                            // Menu & Review Tabs
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isMenuSelected = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: _isMenuSelected ? const Color(0xFF8B1A1A) : Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: _isMenuSelected ? const Color(0xFF8B1A1A) : const Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Menu',
                                            style: TextStyle(
                                              color: _isMenuSelected ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isMenuSelected = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: !_isMenuSelected ? const Color(0xFF8B1A1A) : Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: !_isMenuSelected ? const Color(0xFF8B1A1A) : const Color(0xFFD0D0D0),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Review',
                                            style: TextStyle(
                                              color: !_isMenuSelected ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Content Area
                            if (_isMenuSelected) _buildMenuContent() else _buildReviewContent(),
                            
                            const SizedBox(height: 100),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ================= ALAMAT SECTION =================
  Widget _buildAlamatSection(String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alamat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Placeholder map atau bisa diganti dengan Google Maps
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 40, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU CONTENT =================
  Widget _buildMenuContent() {
    if (_isLoadingMenu) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(
            color: Color(0xFF8B1A1A),
          ),
        ),
      );
    }

    if (_menus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Menu belum tersedia',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _menus.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(_menus[index]);
        },
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> menu) {
    final imageUrl = menu['image_url'] ?? '';
    final name = menu['name'] ?? 'Menu';
    final price = menu['price'] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.camera_alt, size: 40, color: Color(0xFF6B6B6B)),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.camera_alt, size: 40, color: Color(0xFF6B6B6B)),
                        ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${price.toString()}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= REVIEW CONTENT =================
  Widget _buildReviewContent() {
    return Column(
      children: [
        // Video Review Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Video Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 110,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Beri rating tempat ini',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (index) => const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.place['rating']?.toStringAsFixed(1) ?? '4.8',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildRatingBar(5, 0.8),
                                        _buildRatingBar(4, 0.6),
                                        _buildRatingBar(3, 0.3),
                                        _buildRatingBar(2, 0.1),
                                        _buildRatingBar(1, 0.05),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Color(0xFFFF8A00),
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Reviews List
        if (_isLoadingReview)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(
                color: Color(0xFF8B1A1A),
              ),
            ),
          )
        else if (_reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Belum ada ulasan',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              return _buildReviewItem(_reviews[index]);
            },
          ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8A00),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    final username = review['profiles']?['username'] ?? 'account178465';
    final rating = review['rating'] ?? 0;
    final comment = review['comment'] ?? 'Tidak ada komentar';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle, size: 28, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF8B1A1A),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: _onBottomNavTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite, size: 28), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.schedule, size: 28), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
          ],
        ),
      ),
    );
  }
}
