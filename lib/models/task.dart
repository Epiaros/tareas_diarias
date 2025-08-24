class Task {
  int? id;
  String title;
  String description;
  String date;      // guardada como texto (YYYY-MM-DD)
  String priority;  // Alta, Media, Baja

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'date': date,
      'priority': priority,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      priority: map['priority'],
    );
  }
}
