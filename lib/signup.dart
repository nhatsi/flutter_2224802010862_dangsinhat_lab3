import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final username = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  bool showPass = false;
  bool showConfirm = false;
  bool loading = false;

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    pass.dispose();
    confirm.dispose();
    super.dispose();
  }

  void handleRegister() async {
    if ([username, email, pass, confirm]
        .any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đủ thông tin')),
      );
      return;
    }

    if (pass.text != confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return;
    }

    setState(() => loading = true);

    final res = await AuthService.register(
      username.text.trim(),
      email.text.trim(),
      pass.text.trim(),
    );

    if (!mounted) return;
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'])),
    );

    if (res['success']) Navigator.pop(context);
  }

  Widget input(
    TextEditingController c,
    String hint,
    IconData icon, {
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: toggle != null
              ? IconButton(
                  onPressed: toggle,
                  icon: Icon(
                    obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.person_add, size: 60),

            const SizedBox(height: 20),

            input(username, 'Username', Icons.person),
            input(email, 'Email', Icons.email),

            input(
              pass,
              'Password',
              Icons.lock,
              obscure: !showPass,
              toggle: () => setState(() => showPass = !showPass),
            ),

            input(
              confirm,
              'Confirm Password',
              Icons.lock,
              obscure: !showConfirm,
              toggle: () => setState(() => showConfirm = !showConfirm),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : handleRegister,
                child: loading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text('Đăng ký'),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đã có tài khoản?'),
            ),
          ],
        ),
      ),
    );
  }
}