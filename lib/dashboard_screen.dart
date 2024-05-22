import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'add_screen.dart';
import 'keazy_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildCircleButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.red[400],
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('KEAZY APP'),
        backgroundColor: Colors.red[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ciao Utente',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(context, 'Le tue Keasy', Icons.key, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const KeasyListScreen()),
                  );
                }),
                _buildCircleButton(context, 'Aggiungi Keasy', Icons.add, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(context, 'Assistenza', Icons.help, () {
                  // Aggiungi l'azione qui
                }),
                _buildCircleButton(context, 'Impostazioni', Icons.settings, () {
                  // Aggiungi l'azione qui
                }),
              ],
            ),
            const SizedBox(height: 20),
            _buildCircleButton(context, 'Disconnetti', Icons.logout, () {
              _logout(context);
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ElevatedButton(
            onPressed: () {
              // Aggiungi l'azione qui
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              'SCOPRI TUTTE LE SOLUZIONI KEASY SYSTEM',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
