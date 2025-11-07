import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 80),
                Flexible(
                  flex: 5,
                  child: Image.asset(
                    'assets/foto/welcome.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Flexible(
                  child: const Text(
                    "Cari, Muat, Jalan. Gampang kan ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
                Flexible(
                  child: const Text(
                    "BoxTancap memberikan fasilitas untuk bisnis logistik dengan memelihara budaya bisnis dan kenyamanan pengguna.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Tombol Buat Akun
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman pendaftaran
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Buat Akun",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                // Sudah punya akun
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sudah memiliki akun?",
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Versi aplikasi
                const Text(
                  "Versi 1.0.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
