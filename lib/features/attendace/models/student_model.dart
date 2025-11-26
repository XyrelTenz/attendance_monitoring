class StudentModel {
  final String id;
  final String name;
  final String courseYear;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? profileImageUrl;

  StudentModel({
    required this.id,
    required this.name,
    required this.courseYear,
    this.timeIn,
    this.timeOut,
    this.profileImageUrl,
  });

  StudentModel copyWith({
    String? id,
    String? name,
    String? courseYear,
    DateTime? timeIn,
    DateTime? timeOut,
    String? profileImageUrl,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseYear: courseYear ?? this.courseYear,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
