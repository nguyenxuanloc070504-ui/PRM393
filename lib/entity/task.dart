class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Chuyển Task thành Map để lưu SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Chuyển dữ liệu SQLite thành Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: map['dueDate'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
}