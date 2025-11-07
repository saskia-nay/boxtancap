import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // pastikan sudah ada file login.dart

class VerifikasiPage extends StatefulWidget {
  const VerifikasiPage({super.key});

  @override
  State<VerifikasiPage> createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;
  int _seconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 🔹 Kirim email verifikasi pertama kali
  Future<void> _sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim email verifikasi: $e")),
      );
    }
  }

  /// 🔹 Mulai timer 30 detik
  void _startTimer() {
    _canResend = false;
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  /// 🔹 Kirim ulang email verifikasi
  Future<void> _resendEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email verifikasi telah dikirim ulang.")),
      );
      _startTimer();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim ulang email: $e")));
    }
  }

  /// 🔹 Cek apakah email sudah diverifikasi
  Future<void> _checkVerification() async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email berhasil diverifikasi!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email belum diverifikasi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = _auth.currentUser?.email ?? "namaemail@gmail.com";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Judul
            const Text(
              "Verifikasi email Anda",
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Gambar ilustrasi
            Center(
              child: Image.asset(
                'assets/images/email_verify.png', // Ganti sesuai path aset kamu
                height: 220,
              ),
            ),
            const SizedBox(height: 24),

            // Deskripsi
            Text.rich(
              TextSpan(
                text: "Link verifikasi telah dikirimkan ke ",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      color: Color(0xFF003366),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " Segera cek email dan klik link yang tertera agar bisa melanjutkan proses pendaftaran akun Boxtancap Anda.",
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Tombol kirim ulang email
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _canResend ? _resendEmail : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Kirim Ulang Email",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Timer text
            Text(
              "(Tunggu $_seconds detik sebelum klik kirim ulang)",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Tombol verifikasi (tetap fungsional tapi tidak di gambar)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: _checkVerification,
                child: const Text(
                  "Saya sudah verifikasi",
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
