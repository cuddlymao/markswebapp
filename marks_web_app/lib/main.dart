import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: MarksWebApp()));

class MarksWebApp extends StatefulWidget {
  const MarksWebApp({super.key});

  @override
  State<MarksWebApp> createState() => _MarksWebAppState();
}

class _MarksWebAppState extends State<MarksWebApp> {
  final _nameController = TextEditingController();
  final _marksController = TextEditingController();
  List<dynamic> _allData = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromBrowser(); // Load saved marks when page opens
  }

  // 1. Load Data from Browser Storage
  Future<void> _loadDataFromBrowser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString('marks_list');
    if (savedJson != null) {
      setState(() {
        _allData = jsonDecode(savedJson);
      });
    }
  }

  // 2. Save Data to Browser Storage (as JSON)
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Create the JSON object
    Map<String, dynamic> newEntry = {
      "name": _nameController.text,
      "score": _marksController.text,
    };

    setState(() {
      _allData.add(newEntry);
    });

    // Save the whole list as a JSON string
    await prefs.setString('marks_list', jsonEncode(_allData));

    _nameController.clear();
    _marksController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Marks Web Registry'),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ), // Makes it look like a web form
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _marksController,
                decoration: const InputDecoration(
                  labelText: 'Marks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Mark to Browser JSON'),
              ),
              const Divider(height: 50),
              const Text(
                "Stored Marks:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _allData.length,
                  itemBuilder: (context, i) => Card(
                    child: ListTile(
                      title: Text(_allData[i]['name']),
                      trailing: Text(
                        _allData[i]['score'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
}
