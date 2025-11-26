import 'dart:async';
import 'dart:math'; // For randomizing mock data
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../../models/student_model.dart";
import '../../data/datasources/mock_data.dart';
import "../widgets/attendance_log_table.dart";
import '../widgets/qr_kiosk_view.dart'; // Import the new View

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

  final String _kioskId = "JHCSC-LIB-CODE-001";

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
      if (mounted) {
        setState(() {
          _currentTime = DateFormat('hh:mm:ss a').format(now);
          _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
        });
      }
    });
    final now = DateTime.now();
    _currentTime = DateFormat('hh:mm:ss a').format(now);
    _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
  }

  // --- SIMULATION LOGIC ---
  // In a real app, this function would be called by a WebSocket or Firebase Stream
  // listening for when a student scans the QR code.
  void _onStudentScannedQr() {
    // 1. Randomly pick a student to simulate a real scan
    final randomStudent = MockData
        .attendanceLogs[Random().nextInt(MockData.attendanceLogs.length)];

    // 2. Create a new log entry
    final newLog = randomStudent.copyWith(
      timeIn: DateTime.now(),
      // Toggle random status (In vs Out) for variety
      timeOut: Random().nextBool() ? null : DateTime.now(),
    );

    setState(() {
      logs.insert(0, newLog);
    });

    _showSuccessSnackBar(newLog);
  }

  void _showSuccessSnackBar(StudentModel student) {
    bool isOut = student.timeOut != null;
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
              child: Icon(
                isOut ? Icons.logout : Icons.login,
                color: isOut ? Colors.orange : Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOut ? "Student Departed" : "Student Arrived",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${student.name} - ${student.courseYear}"),
              ],
            ),
          ],
        ),
        backgroundColor: isOut ? Colors.orange.shade800 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        width: 400,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 32,
        title: Row(
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/2232/2232688.png', // Replace with local asset
              height: 40,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "JHCSC Library Kiosk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "System Online • $_kioskId",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _currentDate,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LEFT PANEL: The Kiosk QR ---
            SizedBox(
              width: 350,
              child: Column(
                children: [
                  QrKioskView(
                    kioskId: _kioskId,
                    onSimulateIncomingScan: _onStudentScannedQr,
                  ),
                  const SizedBox(height: 24),
                  // Decorative "Steps" Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildStep(1, "Open your Student App"),
                        const SizedBox(height: 16),
                        _buildStep(2, "Tap 'Scan QR'"),
                        const SizedBox(height: 16),
                        _buildStep(3, "Scan the code above"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 32),

            // --- RIGHT PANEL: The Live Table ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "LIVE ACTIVITY FEED",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(child: AttendanceLogTable(students: logs)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
