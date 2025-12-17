import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// -----------------------------------------------------------------------------
// MAIN
// -----------------------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        fontFamily: 'Gilroy',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA22523)),
      ),
      home: const LoginScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// LOGIN
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

    const double fixedButtonAreaHeight = 110.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: _buildHeader(screenHeight, screenWidth),
          ),
          Positioned(
            top: screenHeight * 0.47,
            left: 0,
            right: 0,
            bottom: fixedButtonAreaHeight,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fixedButtonAreaHeight,
            child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
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
// REGISTER
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua data')),
      );
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

    const double fixedButtonAreaHeight = 110.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: _buildHeader(screenHeight, screenWidth),
          ),
          Positioned(
            top: screenHeight * 0.47,
            left: 0,
            right: 0,
            bottom: fixedButtonAreaHeight,
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
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fixedButtonAreaHeight,
            child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
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
// CURVED HEADER
// -----------------------------------------------------------------------------
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 180);
    path.lineTo(size.width / 2.2, size.height - 110);
    path.lineTo(size.width, size.height - 165);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _buildHeader(double screenHeight, double screenWidth) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      ClipPath(
        clipper: CurvedHeaderClipper(),
        child: Container(
          height: screenHeight * 0.55,
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
        top: screenHeight * 0.06,
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
  List<Map<String, dynamic>> favorites = []; // tempat favorit (list places)
  bool isLoadingHome = true;
  bool isLoadingFav = true;

  // ✅ MENU FAVORITE (BARU)
  List<Map<String, dynamic>> favoriteMenus = [];
  bool isLoadingFavMenus = true;

  bool _isLoadingProfile = true;
  bool _isLoadingHistory = true;
  Map<String, List<Map<String, dynamic>>> _groupedHistory = {};
  double _totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    fetchCities();

    // ✅ PENTING: saat buka tab favorit, load KEDUANYA
    if (_selectedIndex == 1) {
      fetchFavorites();
      fetchFavoriteMenus();
    }
    if (_selectedIndex == 2) fetchHistory();
    if (_selectedIndex == 3) fetchProfile();
  }

  // --- HOME LOGIC ---
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

  // --- FAVORITE TEMPAT ---
  Future<void> fetchFavorites() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => isLoadingFav = false);
        return;
      }
      setState(() => isLoadingFav = true);

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

  // --- FAVORITE MENU (BARU) ---
  Future<void> fetchFavoriteMenus() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => isLoadingFavMenus = false);
        return;
      }
      setState(() => isLoadingFavMenus = true);

      // ambil menu_favorites -> join ke menus + places
      final res = await supabase
          .from('menu_favorites')
          .select('menus(*, places(*))')
          .eq('user_id', user.id);

      final List<Map<String, dynamic>> loaded = [];
      for (final item in (res as List)) {
        final menu = item['menus'];
        if (menu != null) {
          loaded.add(Map<String, dynamic>.from(menu));
        }
      }

      if (!mounted) return;
      setState(() {
        favoriteMenus = loaded;
        isLoadingFavMenus = false;
      });
    } catch (e) {
      debugPrint("Fav menu error: $e");
      if (mounted) setState(() => isLoadingFavMenus = false);
    }
  }

  // --- HISTORY ---
  Future<void> fetchHistory() async {
    setState(() => _isLoadingHistory = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => _isLoadingHistory = false);
        return;
      }

      final response = await supabase
          .from('history')
          .select('*, menus(*, places(*))')
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

      tempGrouped.putIfAbsent(displayKey, () => []);
      tempGrouped[displayKey]!.add(item);
    }

    if (mounted) {
      setState(() {
        _groupedHistory = tempGrouped;
        _totalExpense = tempTotal;
        _isLoadingHistory = false;
      });
    }
  }

  String _formatCurrency(double amount) {
    return "Rp.${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}";
  }

  // --- PROFILE ---
  Future<void> fetchProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        _email = user.email;

        final res = await supabase
            .from('profiles')
            .select('username')
            .eq('id', user.id)
            .maybeSingle();

        if (res != null) _username = res['username'];
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
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout Gagal: $e')));
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      fetchFavorites();
      fetchFavoriteMenus(); // ✅ tambah
    }
    if (index == 2) fetchHistory();
    if (index == 3) fetchProfile();
  }

  // ---------------------------------------------------------------------------
  // UI HOME VIEW
  // ---------------------------------------------------------------------------
  Widget _buildHomeView() {
    return Column(
      children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Perguruan Tinggi',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = 1);
                          fetchFavorites();
                          fetchFavoriteMenus();
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
                                  Icon(universities[i]['icon'], color: Colors.black87),
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

  // ---------------------------------------------------------------------------
  // UI FAVORITES VIEW (TEMPAT + MENU dalam 1 halaman)
  // ---------------------------------------------------------------------------
  Widget _buildFavoritesView() {
  return Container(
    color: Colors.white, // ✅ full putih
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
        children: [
          const Text(
            'Tempat Favorit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (isLoadingFav)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else if (favorites.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text("Belum ada tempat favorit"),
              ),
            )
          else
            ...favorites.map((place) => _favoritePlaceCard(place)).toList(),

          const SizedBox(height: 26),

          const Text(
            'Menu Favorit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (isLoadingFavMenus)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else if (favoriteMenus.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text("Belum ada menu favorit"),
              ),
            )
          else
            ...favoriteMenus.map((m) => _favoriteMenuCard(m)).toList(),
        ],
      ),
    ),
  );
}


  Widget _favoritePlaceCard(Map<String, dynamic> place) {
    final imageUrl = place['image_url'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailTempatPage(place: place)),
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
  }

  Widget _favoriteMenuCard(Map<String, dynamic> menu) {
    final imageUrl = (menu['image_url'] ?? '').toString();
    final name = (menu['name'] ?? 'Menu').toString();
    final price = menu['price'] ?? 0;

    final place = (menu['places'] is Map) ? menu['places'] as Map : {};
    final placeName = (place['name'] ?? '').toString();

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
              child: imageUrl.isNotEmpty
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
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp $price',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                if (placeName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    placeName,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI HISTORY VIEW (punyamu, aku biarkan)
  // ---------------------------------------------------------------------------
  Widget _buildHistoryView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828),
            image: const DecorationImage(
              image: AssetImage('assets/images/bg_pattern.png'),
              fit: BoxFit.cover,
              opacity: 1,
            ),
            borderRadius: BorderRadius.circular(24),
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

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final menu = item['menus'] ?? {};
    final place = menu['places'] ?? {};

    final menuName = menu['name'] ?? 'Menu Dihapus';
    final placeName = place['name'] ?? 'Tempat Tidak Diketahui';
    final menuImage = menu['image_url'];

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
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  )
                : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343446),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  placeName,
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

  // ---------------------------------------------------------------------------
  // UI PROFILE VIEW (punyamu, aku biarkan)
  // ---------------------------------------------------------------------------
  Widget _buildProfileView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343446),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 70, color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
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
          Text(
            _email ?? 'user@email.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 60),
          _buildSimpleMenuItem(icon: Icons.edit_outlined, title: "Edit Profile", onTap: () {}),
          const SizedBox(height: 20),
          _buildSimpleMenuItem(icon: Icons.lock_outline, title: "Ganti Password", onTap: () {}),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.only(bottom: 120),
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
                backgroundColor: const Color(0xFFA22523),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout_rounded, color: Colors.white),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF343446), size: 26),
            const SizedBox(width: 16),
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
            const Icon(Icons.chevron_right, color: Colors.black54, size: 24),
          ],
        ),
      ),
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

    // sesuai punyamu: tab 2 & 3 putih
    bool isProfileTab = _selectedIndex == 2 || _selectedIndex == 3;

    return Scaffold(
      extendBody: true,
      body: Container(
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
          bottom: false,
          child: bodyContent,
        ),
      ),
      bottomNavigationBar: Container(
  color: Colors.white, // ⬅️ ini kunci biar bawahnya nggak merah
  child: Padding(
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
                  _selectedIndex == 0
                      ? Icons.home
                      : Icons.home_outlined,
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
                  _selectedIndex == 3
                      ? Icons.person
                      : Icons.person_outline,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),

    );
  }
}

// -----------------------------------------------------------------------------
// PLACE LIST PAGE (punyamu, aku biarkan — sudah ada favorite places)
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

      loadedPlaces.sort(
        (a, b) => (b['favorite_count'] as int).compareTo(a['favorite_count'] as int),
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

    setState(() {
      places[idx]['is_favorite'] = !currentlyFav;
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
      setState(() {
        places[idx]['is_favorite'] = currentlyFav;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
                onTap: _onBottomNavTapped,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(bottomIndex == 0 ? Icons.home : Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(bottomIndex == 1 ? Icons.favorite : Icons.favorite_border),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(bottomIndex == 2 ? Icons.history : Icons.history_toggle_off),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(bottomIndex == 3 ? Icons.person : Icons.person_outline),
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
                        child: const Icon(Icons.arrow_back, color: Colors.white),
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
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Spacer(),
        ],
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
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, color: Colors.grey),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    place["price_range"]?.toString() ?? "",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
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
// DETAIL TEMPAT PAGE (menu favorite + place favorite)
// -----------------------------------------------------------------------------
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

  bool _isFavorite = false; // favorite PLACE

  List<Map<String, dynamic>> _menus = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaceFavorite();
    _fetchMenus();
    _fetchReviews();
  }

  // ---------------- PLACE FAVORITE ----------------
  Future<void> _fetchPlaceFavorite() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final res = await supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('place_id', widget.place['id'])
          .maybeSingle();

      if (!mounted) return;
      setState(() => _isFavorite = (res != null));
    } catch (e) {
      debugPrint('Error fetch place favorite: $e');
    }
  }

  Future<void> _togglePlaceFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    final placeId = widget.place['id'];
    final prev = _isFavorite;
    setState(() => _isFavorite = !prev);

    try {
      if (!prev) {
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
      setState(() => _isFavorite = prev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan favorit tempat: $e')),
      );
    }
  }

  // ---------------- MENU FAVORITE ----------------
  Future<void> _tryLoadMenuFavorites() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final res = await supabase
          .from('menu_favorites')
          .select('menu_id')
          .eq('user_id', user.id);

      final favIds = (res as List)
          .map((e) => e['menu_id'])
          .where((id) => id != null)
          .toSet();

      if (!mounted) return;
      setState(() {
        for (final m in _menus) {
          final id = m['id'];
          m['is_favorite'] = favIds.contains(id);
        }
      });
    } catch (e) {
      debugPrint('menu_favorites error: $e');
    }
  }

  Future<void> _fetchMenus() async {
    try {
      final res = await supabase
          .from('menus')
          .select()
          .eq('place_id', widget.place['id'])
          .order('created_at');

      if (!mounted) return;
      setState(() {
        _menus = List<Map<String, dynamic>>.from(res).map((m) {
          final mm = Map<String, dynamic>.from(m);
          mm['is_favorite'] = false;
          return mm;
        }).toList();
        _isLoadingMenu = false;
      });

      await _tryLoadMenuFavorites();
    } catch (e) {
      debugPrint('Error fetch menu: $e');
      if (!mounted) return;
      setState(() => _isLoadingMenu = false);
    }
  }

  Future<void> _toggleMenuFavorite(int menuId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    final idx = _menus.indexWhere((m) => m['id'] == menuId);
    if (idx == -1) return;

    final prev = _menus[idx]['is_favorite'] == true;
    setState(() => _menus[idx]['is_favorite'] = !prev);

    try {
      if (!prev) {
        await supabase.from('menu_favorites').insert({
          'user_id': user.id,
          'menu_id': menuId,
        });
      } else {
        await supabase
            .from('menu_favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('menu_id', menuId);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _menus[idx]['is_favorite'] = prev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan favorit menu: $e')),
      );
    }
  }

  // ---------------- REVIEW (punyamu, biarkan) ----------------
  Future<void> _fetchReviews() async {
    try {
      final res = await supabase
          .from('reviews')
          .select('rating, comment, profiles(username)')
          .eq('place_id', widget.place['id'])
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        _reviews = List<Map<String, dynamic>>.from(res);
        _isLoadingReview = false;
      });
    } catch (e) {
      debugPrint('Error fetch review: $e');
      if (!mounted) return;
      setState(() => _isLoadingReview = false);
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
    final imageUrl = (place['image_url'] ?? '').toString();
    final name = place['name'] ?? 'Tanpa Nama';
    final address = place['address'] ?? 'Alamat tidak tersedia';
    final rating = (place['rating'] ?? 0).toString();

    return Scaffold(
      backgroundColor: const Color(0xFFC8C8C8),
      body: SafeArea(
        child: Column(
          children: [
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
                    onTap: _togglePlaceFavorite,
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

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
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
                              const Icon(Icons.star,
                                  color: Color(0xFFFF8A00), size: 24),
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

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isMenuSelected) _buildAlamatSection(address),

                            const SizedBox(height: 16),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _isMenuSelected = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: _isMenuSelected
                                              ? const Color(0xFF8B1A1A)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: _isMenuSelected
                                                ? const Color(0xFF8B1A1A)
                                                : const Color(0xFFD0D0D0),
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
                                      onTap: () => setState(() => _isMenuSelected = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        decoration: BoxDecoration(
                                          color: !_isMenuSelected
                                              ? const Color(0xFF8B1A1A)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: !_isMenuSelected
                                                ? const Color(0xFF8B1A1A)
                                                : const Color(0xFFD0D0D0),
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

  Widget _buildAlamatSection(String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alamat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 40, color: Colors.grey[600]),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent() {
    if (_isLoadingMenu) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: Color(0xFF8B1A1A)),
        ),
      );
    }
    if (_menus.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Menu belum tersedia', style: TextStyle(color: Colors.grey))),
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
        itemBuilder: (context, index) => _buildMenuItem(_menus[index]),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> menu) {
    final imageUrl = (menu['image_url'] ?? '').toString();
    final name = menu['name'] ?? 'Menu';
    final price = menu['price'] ?? 0;
    final isFav = menu['is_favorite'] == true;

    final menuIdRaw = menu['id'];
    final menuId = (menuIdRaw is int) ? menuIdRaw : int.tryParse(menuIdRaw.toString()) ?? 0;

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

              // ✅ FAVORITE MENU: dibungkus GestureDetector + kliknya tidak mengganggu card
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _toggleMenuFavorite(menuId),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
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
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp $price',
                        style: const TextStyle(color: Colors.black87, fontSize: 11),
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
                      child: const Icon(Icons.add, color: Colors.black, size: 18),
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

  // review part (aku minimal biar compile)
  Widget _buildReviewContent() {
    if (_isLoadingReview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: Color(0xFF8B1A1A)),
        ),
      );
    }
    if (_reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Belum ada ulasan', style: TextStyle(color: Colors.grey))),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _reviews.length,
      itemBuilder: (context, index) => _buildReviewItem(_reviews[index]),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    final username = review['profiles']?['username'] ?? 'account';
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
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
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


