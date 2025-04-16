import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/announcement_model.dart';

class AnnouncementController extends GetxController {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('announcements');
  var announcements = <Announcement>[].obs;

  get isLoading => null;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  void fetchAnnouncements() {
    dbRef.orderByChild('timestamp').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        announcements.value = data.entries
            .map((e) => Announcement.fromJson(
                Map<String, dynamic>.from(e.value), e.key))
            .toList()
            .reversed
            .toList();
      }
    });
  }

  void addAnnouncement(String title, String description, String createdBy) {
    final newRef = dbRef.push();
    String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    newRef.set({
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'date': date,
      'timestamp': timestamp,
    });
  }

  void deleteAnnouncement(String id) {
    dbRef.child(id).remove();
  }
}
