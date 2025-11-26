import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../../models/student_model.dart";
import '../../data/datasources/mock_data.dart';
import "package:attendance_monitoring/features/attendace/presentation/widgets/attendance_log_table.dart";
import "package:attendance_monitoring/features/attendace/presentation/widgets/face_scanner_view.dart";

class LibraryAttendanceScreen extends StatefulWidget {
  const LibraryAttendanceScreen({super.key});

  @override
  State<LibraryAttendanceScreen> createState() =>
      _LibraryAttendanceScreenState();
}

class _LibraryAttendanceScreenState extends State<LibraryAttendanceScreen> {
  List<StudentModel> logs = [];
  String _currentTime = "";
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
      setState(() {
        _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
    _currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  void _simulateFaceDetection() {
    final newStudent = MockData.scannedStudent.copyWith(timeIn: DateTime.now());

    setState(() {
      logs.insert(0, newStudent);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text("Attendance Recorded: ${newStudent.name}"),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        width: 400, // Fixed width for desktop snackbar look
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.library_books, size: 28),
            const SizedBox(width: 10),
            const Text(
              "Library Attendance Kiosk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                _currentTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT PANEL: Scanner & Info (40% width)
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  FaceScannerView(onSimulateScan: _simulateFaceDetection),

                  const SizedBox(height: 20),

                  // Instructions Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instructions",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInstructionRow(
                          Icons.looks_one,
                          "Remove face mask and glasses.",
                        ),
                        const SizedBox(height: 8),
                        _buildInstructionRow(
                          Icons.looks_two,
                          "Look directly at the camera.",
                        ),
                        const SizedBox(height: 8),
                        _buildInstructionRow(
                          Icons.looks_3,
                          "Wait for the green confirmation.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            Expanded(flex: 3, child: AttendanceLogTable(students: logs)),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
