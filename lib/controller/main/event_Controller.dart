import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final DatabaseReference database = FirebaseDatabase.instance.ref("events");
  final FirebaseStorage storage = FirebaseStorage.instance;
  var events = <Map<String, dynamic>>[].obs;
  var isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void fetchEvents() {
    database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      events.value = data.entries
          .map((e) => {"id": e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    });
  }

  Future<void> addEvent(String title, String description, DateTime dateTime,
      PlatformFile? file) async {
    if (title.isEmpty || description.isEmpty || file == null) {
      Get.snackbar("Error", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    String? fileUrl;
    if (file.bytes != null) {
      try {
        isUploading.value = true;
        final ref = storage.ref('events/${file.name}');
        await ref.putData(file.bytes!);
        fileUrl = await ref.getDownloadURL();
        Get.snackbar("Success", "PDF uploaded successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Error", "Failed to upload PDF",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } finally {
        isUploading.value = false;
      }
    }
    final newEvent = database.push();
    await newEvent.set({
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'fileUrl': fileUrl,
      'participants': [],
    });
  }

  Future<void> applyForEvent(String eventId, String studentId) async {
    final eventRef = database.child(eventId);
    final eventSnapshot = await eventRef.get();
    if (eventSnapshot.exists) {
      final data = eventSnapshot.value as Map<dynamic, dynamic>;
      List participants = List.from(data['participants'] ?? []);
      if (!participants.contains(studentId)) {
        participants.add(studentId);
        await eventRef.update({'participants': participants});
        Get.snackbar("Success", "Applied for event successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }
    }
  }

  Future<List<String>> getParticipants(String eventId) async {
    final eventSnapshot = await database.child(eventId).get();
    if (eventSnapshot.exists) {
      final data = eventSnapshot.value as Map<dynamic, dynamic>;
      return List<String>.from(data['participants'] ?? []);
    }
    return [];
  }
}
