class Announcement {
  String id;
  String title;
  String description;
  String createdBy;
  String date;
  String timestamp;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.date,
    required this.timestamp,
  });

  factory Announcement.fromJson(Map<String, dynamic> json, String id) {
    return Announcement(
      id: id,
      title: json['title'],
      description: json['description'],
      createdBy: json['createdBy'],
      date: json['date'],
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'date': date,
      'timestamp': timestamp,
    };
  }
}