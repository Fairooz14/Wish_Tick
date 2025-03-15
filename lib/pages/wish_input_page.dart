import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wish_tracker_page.dart';

class WishInputPage extends StatefulWidget {
  @override
  _WishInputPageState createState() => _WishInputPageState();
}

class _WishInputPageState extends State<WishInputPage> {
  final TextEditingController _wishController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  void _navigateToTracker(BuildContext context) {
    double? years = double.tryParse(_yearsController.text);
    if (years != null && years > 0 && _wishController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishTrackerPage(
            wishDescription: _wishController.text,
            initialYears: years,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid wish and time")),
      );
    }
  }

  @override
  void dispose() {
    _wishController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Make a Wish",
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _wishController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Your Wish",
                hintText: "e.g., Become a millionaire",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _yearsController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Time to Fulfill (years)",
                hintText: "e.g., 5",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _navigateToTracker(context),
              child: Text("Start Tracking", style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }
}