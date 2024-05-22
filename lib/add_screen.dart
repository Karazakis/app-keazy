import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final TextEditingController _keazyCodeController = TextEditingController();
  final TextEditingController _newRingController = TextEditingController();
  String? _selectedRing;
  List<String> _rings = [];

  Future<void> _showAddRingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Nuovo Ring'),
          content: TextField(
            controller: _newRingController,
            decoration: const InputDecoration(
              labelText: 'Nome Ring',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ANNULLA'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('AGGIUNGI'),
              onPressed: () {
                setState(() {
                  _rings.add(_newRingController.text.trim());
                  _selectedRing = _newRingController.text.trim();
                  _newRingController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addKeazy() async {
    final String keazyCode = _keazyCodeController.text.trim();

    if (_selectedRing == null || keazyCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutti i campi sono obbligatori')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://51.75.18.18/api/add_keazy/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'ring': _selectedRing!,
          'keazy_code': keazyCode,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        List<String> savedKeazies = prefs.getStringList('keazies') ?? [];
        savedKeazies.add(jsonEncode({
          'ring': _selectedRing!,
          'keazy_code': keazyCode,
        }));
        await prefs.setStringList('keazies', savedKeazies);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keazy aggiunta con successo')),
        );
        Navigator.pop(context);
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String errorMessage =
            responseData['detail'] ?? 'Errore durante l\'aggiunta della Keazy';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $errorMessage')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore di connessione: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('KEAZY APP'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aggiungi Keasy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRing,
              hint: const Text('Seleziona Ring'),
              items: _rings.map((ring) {
                return DropdownMenuItem<String>(
                  value: ring,
                  child: Text(ring),
                );
              }).toList()
                ..add(DropdownMenuItem<String>(
                  value: 'new',
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Aggiungi nuovo ring'),
                    ],
                  ),
                )),
              onChanged: (newValue) {
                if (newValue == 'new') {
                  _showAddRingDialog();
                } else {
                  setState(() {
                    _selectedRing = newValue;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _keazyCodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Keazy Code',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addKeazy,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('AGGIUNGI KEAZY'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('INDIETRO',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
