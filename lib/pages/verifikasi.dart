import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; 

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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim ulang email: $e")),
      );
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verifikasi email Anda",
              style: TextStyle(
                color: Color(0xFF003366),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: "Masukkan kode 6 digit yang dikirimkan kepada Anda pada ",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      color: Color(0xFF003366),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 6 kotak input (UI-only)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _controllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Color(0xFF003366), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // 🔁 Kirim ulang
            Row(
              children: [
                const Text("Tidak mendapatkan email? "),
                GestureDetector(
                  onTap: _canResend ? _resendEmail : null,
                  child: Text(
                    "Kirim Ulang",
                    style: TextStyle(
                      color: _canResend
                          ? const Color(0xFF003366)
                          : Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "(Tunggu $_seconds detik sebelum klik kirim ulang)",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),

            const Spacer(),

            // 🔘 Tombol verifikasi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _checkVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Saya sudah verifikasi",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
