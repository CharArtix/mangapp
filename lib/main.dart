import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Gilroy',
      ),
      home: const LoginScreen(),
    );
  }
}

// --- LOGIN SCREEN (Standar: Email & Password) ---
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
      // Login Normal menggunakan Email
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      // Sukses Login -> Pindah ke Home
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
                left: 0, right: 0, bottom: 0,
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
                      const Text('Login', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF343446), fontFamily: 'Inter')),
                      const SizedBox(height: 30),

                      // Input Email
                      _buildLabel('Email Address'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Masukkan email anda'),
                      ),
                      const SizedBox(height: 18),

                      // Input Password
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration('Masukkan password').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black.withOpacity(0.4)),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot password?', style: TextStyle(fontSize: 14.5, color: const Color(0xFF343446), decoration: TextDecoration.underline, fontFamily: 'Inter')),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Login
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA22523),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          ),
                          child: _isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Log in', style: TextStyle(color: Colors.white, fontSize: 18.7, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Link Register
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Don't have an account yet? ", style: TextStyle(fontSize: 14.5, color: const Color(0xFF343446), fontFamily: 'Inter')),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(fontSize: 14.5, color: const Color(0xFF566CD8), fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
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

// --- REGISTER SCREEN (Email, Username, Password) ---
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
    _usernameController = TextEditingController(); // Tambahan untuk profil
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon isi semua data')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Daftar ke Auth menggunakan Email & Password
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      if (user != null) {
        // 2. Simpan data tambahan (Username) ke tabel profiles
        // ID Auth dan ID Profile harus sama
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'username': username,
          // 'full_name': 'Optional',
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
        );
        Navigator.pop(context); // Kembali ke Login Screen
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

              // White Card
              Positioned(
                top: screenHeight * 0.35,
                left: 0, right: 0, bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Register', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF343446), fontFamily: 'Inter')),
                      const SizedBox(height: 20),

                      // 1. Input Email
                      _buildLabel('Email'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('contoh@email.com'),
                      ),
                      const SizedBox(height: 16),

                      // 2. Input Username (Masuk ke tabel Profiles)
                      _buildLabel('Username'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        decoration: _inputDecoration('Username unik anda'),
                      ),
                      const SizedBox(height: 16),

                      // 3. Input Password
                      _buildLabel('Password'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration('Minimal 6 karakter').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black.withOpacity(0.4)),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Tombol Register
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA22523),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18.7, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      // Link Balik ke Login
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Already have an account? ", style: TextStyle(fontSize: 14.5, color: const Color(0xFF343446), fontFamily: 'Inter')),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(fontSize: 14.5, color: const Color(0xFF566CD8), fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
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

Widget _buildBackground(double height, double width) {
  return Positioned(
    top: 0, left: 0, right: 0,
    child: Container(
      height: height * 0.45,
      decoration: BoxDecoration(
        color: const Color(0xFFCB3127),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width * 0.15), bottomRight: Radius.circular(width * 0.15)),
      ),
      child: Stack(
        children: [
          Positioned(top: -50, right: -80, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.3)))),
          Positioned(bottom: 20, right: -60, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.3)))),
        ],
      ),
    ),
  );
}

Widget _buildLogo(double height) {
  return Positioned(
    top: height * 0.08, left: 0, right: 0,
    child: Column(
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
          child: const Center(child: Text('M', style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold, fontFamily: 'Pacifico'))),
        ),
        const SizedBox(height: 8),
        const Text('Mangapp', style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'Pacifico', fontWeight: FontWeight.w400)),
      ],
    ),
  );
}

Widget _buildLabel(String text) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: text, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF343446))),
        TextSpan(text: '*', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFFF94931))),
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  int _selectedIndex = 0;
  String? selectedCity;
  List<String> cities = [];
  List<Map<String, dynamic>> universities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      final res = await supabase.from('cities').select('name');
      cities = res.map<String>((row) => row['name'] as String).toList();
      if (selectedCity == null && cities.isNotEmpty) selectedCity = cities.first;
      await fetchUniversities();
      setState(() {});
    } catch (e) {}
  }

  Future<void> fetchUniversities() async {
    try {
      setState(() => isLoading = true);
      final res = await supabase
          .from('universities')
          .select('name, city_id, cities!inner(name)')
          .eq('cities.name', selectedCity!);

      universities = res
          .map<Map<String, dynamic>>((u) => {'name': u['name'], 'icon': Icons.school})
          .toList();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                child: Column(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/150/FFFFFF/D32F2F?text=Mangapp',
                      height: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    const Text('Pilih lokasi Anda', style: TextStyle(color: Colors.white, fontSize: 16)),
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
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    isExpanded: true,
                                    items: cities
                                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                        child: Text('Perguruan Tinggi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: universities.length,
                                itemBuilder: (_, i) => Container(
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
                                      Text(universities[i]['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
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
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined), label: ''),
                  BottomNavigationBarItem(icon: Icon(_selectedIndex == 1 ? Icons.favorite : Icons.favorite_border), label: ''),
                  BottomNavigationBarItem(icon: Icon(_selectedIndex == 2 ? Icons.history : Icons.history_toggle_off), label: ''),
                  BottomNavigationBarItem(icon: Icon(_selectedIndex == 3 ? Icons.person : Icons.person_outline), label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

