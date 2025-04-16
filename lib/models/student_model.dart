import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentModel {
  String uid;
  String firstName;
  String lastName;
  String surName;
  String spid;
  String phoneNumber;
  String email;
  String stream;
  String semester;
  String division;
  String profileImageUrl;
  String status;

  StudentModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.surName,
    required this.spid,
    required this.phoneNumber,
    required this.email,
    required this.stream,
    required this.semester,
    required this.division,
    required this.profileImageUrl,
    this.status = 'unpaid',
  });

  factory StudentModel.fromMap(Map<dynamic, dynamic> map) {
    return StudentModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      surName: map['surName'] ?? '',
      spid: map['spid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      stream: map['stream'] ?? '',
      semester: map['semester'] ?? '',
      division: map['division'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      status: map['status'] ?? 'unpaid', // Map field with default
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'surName': surName,
      'spid': spid,
      'phoneNumber': phoneNumber,
      'email': email,
      'stream': stream,
      'semester': semester,
      'division': division,
      'profileImageUrl': profileImageUrl,
      'status': status,
    };
  }

  Future<void> updateStudent(Map<String, dynamic> data) async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('student').child(uid).update(data);
    } catch (e) {
      print('Error updating student: $e');
      rethrow;
    }
  }

  Future<void> deleteStudent() async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('student').child(uid).remove();

      // Delete user from Authentication
      final auth = FirebaseAuth.instance;
      await auth.currentUser?.delete();
    } catch (e) {
      print('Error deleting student: $e');
      rethrow;
    }
  }
}
