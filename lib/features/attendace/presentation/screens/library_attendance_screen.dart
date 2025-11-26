import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../../models/student_model.dart";
import '../../data/datasources/mock_data.dart';
import "../widgets/attendance_log_table.dart";
import '../widgets/face_scanner_view.dart';

class LibraryAttendanceScreen extends StatefulWidget {
  const LibraryAttendanceScreen({super.key});

  @override
  State<LibraryAttendanceScreen> createState() =>
      _LibraryAttendanceScreenState();
}

class _LibraryAttendanceScreenState extends State<LibraryAttendanceScreen> {
  List<StudentModel> logs = [];
  String _currentTime = "";
  String _currentDate = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    logs = List.from(MockData.attendanceLogs);
    _startClock();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _currentTime = DateFormat('hh:mm:ss a').format(now);
        _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
      });
    });
    // Init values
    final now = DateTime.now();
    _currentTime = DateFormat('hh:mm:ss a').format(now);
    _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
  }

  void _simulateFaceDetection() {
    final newStudent = MockData.scannedStudent.copyWith(timeIn: DateTime.now());

    setState(() {
      logs.insert(0, newStudent);
    });

    // Custom "Toast" overlay using SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Attendance Recorded",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${newStudent.name} - ${newStudent.courseYear}"),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        width: 450,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Light dashboard background
      // Top App Bar
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.school,
                color: Colors.blueAccent,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "JHCSC Library",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Attendance Monitoring System",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Clock Section
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Monospace', // Digital clock feel
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _currentDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT PANEL: Scanner (Fixed Width ~350-400px)
            SizedBox(
              width: 380,
              child: Column(
                children: [
                  FaceScannerView(onSimulateScan: _simulateFaceDetection),

                  const SizedBox(height: 24),

                  // Helper / Instructions Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Guidelines",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildGuideline(
                          Icons.visibility,
                          "Look directly at the camera",
                        ),
                        _buildGuideline(
                          Icons.masks,
                          "Remove face masks/glasses",
                        ),
                        _buildGuideline(
                          Icons.light_mode,
                          "Ensure adequate lighting",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // RIGHT PANEL: Table (Takes remaining space)
            Expanded(child: AttendanceLogTable(students: logs)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideline(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
