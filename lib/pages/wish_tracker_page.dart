import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/tracker_service.dart';
import '../widgets/clock_wheel.dart';
import '../utils/timezones.dart';
import '../theme/app_theme.dart';

// New DigitalCountdown widget (moved here)
// ... (previous imports and DigitalCountdown class definition remain the same)

class DigitalCountdown extends StatelessWidget {
  final Duration remainingTime;

  const DigitalCountdown({required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    // Calculate years (approximate, based on 365 days per year)
    final totalDays = remainingTime.inDays;
    final years = totalDays ~/ 365;
    final remainingDays = totalDays % 365;
    final hours = remainingTime.inHours % 24;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment
          .baseline, // Align numbers and subscripts on baseline
      textBaseline: TextBaseline.alphabetic, // Ensure proper alignment
      children: [
        // Years
        _buildTimeUnit(years, 'years'),
        Text(' : '),
        // Days
        _buildTimeUnit(remainingDays, 'days'),
        Text(' : '),
        // Hours
        _buildTimeUnit(hours, 'hours'),
        Text(' : '),
        // Minutes
        _buildTimeUnit(minutes, 'minutes'),
        Text(' : '),
        // Seconds
        _buildTimeUnit(seconds, 'seconds'),
      ],
    ).animate().fadeIn(duration: 800.ms);
  }

  // Helper method to build each time unit with large number and small subscript
  Widget _buildTimeUnit(int value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15, // Large number
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8, // Small subscript
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ... (rest of the WishTrackerPage class remains the same)

class WishTrackerPage extends StatefulWidget {
  final String wishDescription;
  final double initialYears;

  WishTrackerPage({required this.wishDescription, required this.initialYears});

  @override
  _WishTrackerPageState createState() => _WishTrackerPageState();
}

class _WishTrackerPageState extends State<WishTrackerPage> {
  late TrackerService _trackerService;
  late Duration _totalTime;
  String _currentTheme = 'neonPurple';

  @override
  void initState() {
    super.initState();
    _totalTime = Duration(days: (widget.initialYears * 365).round());
    _trackerService = TrackerService(onUpdate: () {
      if (mounted) setState(() {});
    });
    _trackerService.startTracking(widget.wishDescription, widget.initialYears);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _currentTheme = await AppTheme.loadTheme();
    setState(() {});
  }

  Future<void> _toggleTheme() async {
    _currentTheme = _currentTheme == 'neonPurple' ? 'darkBlue' : 'neonPurple';
    await AppTheme.saveTheme(_currentTheme);
    setState(() {});
  }

  @override
  void dispose() {
    _trackerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _trackerService.getRemainingTime();
    final currentTime = _trackerService.getCurrentTime();
    final availableTimeZones =
        TimeZone.availableTimeZones.map((tz) => tz.timeZone).toList();
    String selectedTimeZone = _trackerService.getTimeZone();
    if (!availableTimeZones.contains(selectedTimeZone)) {
      selectedTimeZone = availableTimeZones.first;
      _trackerService.setTimeZone(selectedTimeZone);
    }

    return Theme(
      data: _currentTheme == 'neonPurple'
          ? AppTheme.neonPurpleTheme
          : AppTheme.darkBlueTheme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align title to the left
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Space between title and icon
                      children: [
                        Text(
                          "Wish Tracker",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.palette, color: Colors.white),
                          onPressed: _toggleTheme,
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Space between title/icon and time zone section
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align time zone section
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Select Time Zone:",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            DropdownButton<String>(
                              value: selectedTimeZone,
                              items: TimeZone.availableTimeZones
                                  .map((tz) => DropdownMenuItem(
                                        value: tz.timeZone,
                                        child: Text(tz.country),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null)
                                  _trackerService.setTimeZone(value);
                              },
                              style: TextStyle(color: Colors.white),
                              dropdownColor: Theme.of(context)
                                      .dropdownMenuTheme
                                      .menuStyle
                                      ?.backgroundColor
                                      ?.resolve({}) ??
                                  Color(0xFF9B00FF),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _trackerService.getWishDescription(),
                        style: GoogleFonts.poppins(
                            fontSize: 22, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 800.ms),
                      SizedBox(height: 15),
                      Text(
                        "Current Time (${_trackerService.getTimeZone()}):\n"
                        "${currentTime.hour.toString().padLeft(2, '0')}:"
                        "${currentTime.minute.toString().padLeft(2, '0')}:"
                        "${currentTime.second.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 800.ms),
                      SizedBox(height: 10),
                      ClockWheel(
                        remainingTime: remainingTime,
                        totalTime: _totalTime,
                        currentTime: currentTime,
                      ),

                      SizedBox(height: 20),
                      Text(
                        "Times left: ",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ), // Space before countdown
                      DigitalCountdown(
                          remainingTime:
                              remainingTime), // Added countdown below current time
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
