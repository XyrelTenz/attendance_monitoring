import "../../models/student_model.dart";

class MockData {
  static List<StudentModel> attendanceLogs = [
    StudentModel(
      id: "2023-001",
      name: "Juan Dela Cruz",
      courseYear: "BSIT - 4A",
      timeIn: DateTime.now().subtract(const Duration(hours: 2)),
      timeOut: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    StudentModel(
      id: "2023-055",
      name: "Maria Santos",
      courseYear: "BSCS - 2B",
      timeIn: DateTime.now().subtract(const Duration(minutes: 45)),
      timeOut: null,
    ),
    StudentModel(
      id: "2023-102",
      name: "Pedro Penduko",
      courseYear: "BSIT - 1A",
      timeIn: DateTime.now().subtract(const Duration(minutes: 10)),
      timeOut: null,
    ),
  ];

  static StudentModel scannedStudent = StudentModel(
    id: "2024-888",
    name: "Ana Reyes",
    courseYear: "BSEd - 3C",
    timeIn: DateTime.now(),
    timeOut: null,
  );
}
