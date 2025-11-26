import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../../models/student_model.dart";

class AttendanceLogTable extends StatelessWidget {
  final List<StudentModel> students;

  const AttendanceLogTable({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Real-time Logs",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Monitoring entry and exit times",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                // Example of a Desktop-only Filter button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text("Filter"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
          ),

          // The Table
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey.shade50,
                  ),
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 70,
                  columnSpacing: 24,
                  horizontalMargin: 24,
                  dividerThickness: 0.5,
                  columns: [
                    _buildHeader('STUDENT'),
                    _buildHeader('SCHOOL ID'),
                    _buildHeader('COURSE / YEAR'),
                    _buildHeader('TIME IN'),
                    _buildHeader('TIME OUT'),
                    _buildHeader('STATUS'),
                  ],
                  rows: students.map((student) => _buildRow(student)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _buildHeader(String title) {
    return DataColumn(
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  DataRow _buildRow(StudentModel student) {
    final dateFormat = DateFormat('hh:mm a');
    final isOut = student.timeOut != null;

    return DataRow(
      cells: [
        // 1. Student Name & Avatar
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: student.profileImageUrl != null
                    ? NetworkImage(student.profileImageUrl!)
                    : null,
                child: student.profileImageUrl == null
                    ? Text(
                        student.name[0],
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // 2. School ID (Monospace for readability)
        DataCell(
          Text(
            student.id,
            style: TextStyle(
              fontFamily: 'Courier', // Or any monospace font
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        // 3. Course / Year (Badge Style)
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blueGrey.shade100),
            ),
            child: Text(
              student.courseYear,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
        ),

        // 4. Time In
        DataCell(
          student.timeIn != null
              ? Row(
                  children: [
                    Icon(Icons.login, size: 16, color: Colors.green.shade400),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(student.timeIn!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : const Text("--"),
        ),

        // 5. Time Out
        DataCell(
          student.timeOut != null
              ? Row(
                  children: [
                    Icon(Icons.logout, size: 16, color: Colors.orange.shade400),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(student.timeOut!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : Text("--", style: TextStyle(color: Colors.grey.shade400)),
        ),

        // 6. Status
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOut ? Colors.grey.shade100 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOut ? Colors.grey.shade300 : Colors.green.shade200,
              ),
            ),
            child: Text(
              isOut ? "COMPLETED" : "ACTIVE",
              style: TextStyle(
                color: isOut ? Colors.grey.shade600 : Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
