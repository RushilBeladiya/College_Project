// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/utils/colors.dart';

// class SetPaymentAmountScreen extends StatefulWidget {
//   @override
//   _SetPaymentAmountScreenState createState() => _SetPaymentAmountScreenState();
// }

// class _SetPaymentAmountScreenState extends State<SetPaymentAmountScreen> {
//   String? selectedStream;
//   String? selectedSemester;
//   final TextEditingController _amountController = TextEditingController();

//   final List<String> streams = ['BCA', 'BCOM', 'BBA'];
//   final List<String> semesters =
//   List.generate(8, (index) => 'Semester ${index + 1}');

//   final DatabaseReference _databaseRef =
//   FirebaseDatabase.instance.ref().child('payments');

//   Map<String, dynamic> paymentData = {};
//   bool isSettingAmount = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRealTimeData();
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }

//   void _fetchRealTimeData() {
//     _databaseRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;

//       if (data != null) {
//         setState(() {
//           paymentData = Map<String, dynamic>.from(data);
//         });
//       } else {
//         setState(() {
//           paymentData = {};
//         });
//       }
//     });
//   }

//   Future<void> _savePayment() async {
//     if (selectedStream != null &&
//         selectedSemester != null &&
//         _amountController.text.isNotEmpty) {
//       setState(() => isSettingAmount = true);

//       final newPayment = {
//         "amount": _amountController.text,
//         "timestamp": DateTime.now().toIso8601String(),
//       };

//       try {
//         await _databaseRef
//             .child(selectedStream!)
//             .child('semesters')
//             .child(selectedSemester!)
//             .set(newPayment);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Payment data saved successfully!')),
//         );

//         setState(() {
//           selectedStream = null;
//           selectedSemester = null;
//           _amountController.clear();
//           isSettingAmount = false;
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save data: $e')),
//         );
//         setState(() {
//           isSettingAmount = false;
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//     }
//   }

//   Future<void> _deletePayment(String stream, String semester) async {
//     try {
//       await _databaseRef
//           .child(stream)
//       // .child('semesters')
//           .child(semester)
//           .remove();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment data deleted successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete data: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Payment Collection',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColor.primaryColor,
//         elevation: 3,
//       ),
//       body: Container(
//         color: AppColor.appBackGroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               /// Stream Dropdown
//               _buildDropdown(
//                 label: 'Select Stream',
//                 value: selectedStream,
//                 items: streams,
//                 onChanged: (value) => setState(() => selectedStream = value),
//               ),
//               const SizedBox(height: 15),

//               /// Semester Dropdown
//               _buildDropdown(
//                 label: 'Select Semester',
//                 value: selectedSemester,
//                 items: semesters,
//                 onChanged: (value) => setState(() => selectedSemester = value),
//               ),
//               const SizedBox(height: 15),

//               /// Amount TextField
//               TextField(
//                 controller: _amountController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Amount',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 20),

//               /// Save Button
//               ElevatedButton(
//                 onPressed: _savePayment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.primaryColor,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: isSettingAmount
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                   'Set Amount',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               /// Display payment data
//               Expanded(
//                 child: paymentData.isEmpty
//                     ? const Center(
//                   child: Text('No Payment Data Available'),
//                 )
//                     : ListView.builder(
//                   itemCount: paymentData.length,
//                   itemBuilder: (context, index) {
//                     final stream = paymentData.keys.elementAt(index);
//                     final semesters = paymentData[stream]['semesters']
//                     as Map<dynamic, dynamic>?;

//                     if (semesters == null) {
//                       return const SizedBox
//                           .shrink(); // Skip if semesters is null
//                     }

//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ExpansionTile(
//                         title: Text(
//                           'Stream: $stream',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColor.primaryColor,
//                           ),
//                         ),
//                         children: semesters.entries.map((entry) {
//                           return ListTile(
//                             title: Text(
//                               'Semester: ${entry.key}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Amount: ₹${entry.value['amount']}',
//                                   style: const TextStyle(
//                                       color: Colors.green, fontSize: 16),
//                                 ),
//                                 Text(
//                                   'Timestamp: ${entry.value['timestamp']}',
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete,
//                                   color: Colors.red),
//                               onPressed: () => _deletePayment(
//                                   stream, entry.key.toString()),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(labelText: label),
//       items: items
//           .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class SetPaymentAmountScreen extends StatefulWidget {
  @override
  _SetPaymentAmountScreenState createState() => _SetPaymentAmountScreenState();
}

class _SetPaymentAmountScreenState extends State<SetPaymentAmountScreen> {
  String? selectedStream;
  String? selectedSemester;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _editAmountController = TextEditingController();

  final List<String> streams = ['BCA', 'BCOM', 'BBA'];
  final List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8"
  ];

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('payments');

  Map<String, dynamic> paymentData = {};
  bool isSettingAmount = false;
  bool isEditing = false;
  String? currentEditKey;
  String? currentEditSemester;

  @override
  void initState() {
    super.initState();
    _fetchRealTimeData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _editAmountController.dispose();
    super.dispose();
  }

  void _fetchRealTimeData() {
    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          paymentData = Map<String, dynamic>.from(data);
        });
      } else {
        setState(() {
          paymentData = {};
        });
      }
    });
  }

  Future<void> _savePayment() async {
    if (selectedStream != null &&
        selectedSemester != null &&
        _amountController.text.isNotEmpty) {
      setState(() => isSettingAmount = true);

      final newPayment = {
        "amount": _amountController.text,
        "timestamp": DateTime.now().toIso8601String(),
      };

      try {
        await _databaseRef
            .child(selectedStream!)
            .child('semesters')
            .child(selectedSemester!)
            .set(newPayment);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment data saved successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColor.primaryColor,
          ),
        );

        setState(() {
          selectedStream = null;
          selectedSemester = null;
          _amountController.clear();
          isSettingAmount = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save data: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isSettingAmount = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _deletePayment(String stream, String semester) async {
    try {
      await _databaseRef
          .child(stream)
          .child('semesters')
          .child(semester)
          .remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment data deleted successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColor.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete data: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startEditing(String stream, String semester, String amount) {
    setState(() {
      isEditing = true;
      currentEditKey = stream;
      currentEditSemester = semester;
      _editAmountController.text = amount;
    });
  }

  Future<void> _updatePayment() async {
    if (currentEditKey != null &&
        currentEditSemester != null &&
        _editAmountController.text.isNotEmpty) {
      setState(() => isSettingAmount = true);

      final updatedPayment = {
        "amount": _editAmountController.text,
        "timestamp": DateTime.now().toIso8601String(),
      };

      try {
        await _databaseRef
            .child(currentEditKey!)
            .child('semesters')
            .child(currentEditSemester!)
            .update(updatedPayment);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment data updated successfully!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColor.primaryColor,
          ),
        );

        setState(() {
          isEditing = false;
          currentEditKey = null;
          currentEditSemester = null;
          _editAmountController.clear();
          isSettingAmount = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update data: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isSettingAmount = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      currentEditKey = null;
      currentEditSemester = null;
      _editAmountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Collection',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.whiteColor,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEditing) ...[
                // Stream Dropdown
                _buildDropdown(
                  label: 'Select Stream',
                  value: selectedStream,
                  items: streams,
                  onChanged: (value) => setState(() => selectedStream = value),
                ),
                const SizedBox(height: 15),

                // Semester Dropdown
                _buildDropdown(
                  label: 'Select Semester',
                  value: selectedSemester,
                  items: semesters,
                  onChanged: (value) =>
                      setState(() => selectedSemester = value),
                ),
                const SizedBox(height: 15),

                // Amount TextField
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    labelStyle: TextStyle(color: AppColor.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColor.primaryColor, width: 2),
                    ),
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  style: TextStyle(color: Colors.black87),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: _savePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: AppColor.primaryColor.withOpacity(0.3),
                  ),
                  child: isSettingAmount
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Set Amount',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ] else ...[
                // Edit UI
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editing: $currentEditKey - $currentEditSemester',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _editAmountController,
                          decoration: InputDecoration(
                            labelText: 'Edit Amount',
                            labelStyle: TextStyle(color: AppColor.primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: AppColor.primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColor.primaryColor, width: 2),
                            ),
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextStyle(color: Colors.black87),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _cancelEditing,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _updatePayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isSettingAmount
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Update',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Display payment data
              Expanded(
                child: paymentData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment,
                              size: 60,
                              color: AppColor.primaryColor.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Payment Data Available',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: paymentData.length,
                        itemBuilder: (context, index) {
                          final stream = paymentData.keys.elementAt(index);
                          final semestersData = paymentData[stream]['semesters']
                              as Map<dynamic, dynamic>?;

                          if (semestersData == null) {
                            return const SizedBox.shrink();
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              leading: Icon(
                                Icons.school,
                                color: AppColor.primaryColor,
                              ),
                              title: Text(
                                stream,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              children: semestersData.entries.map((entry) {
                                final semester = entry.key.toString();
                                final amount =
                                    entry.value['amount']?.toString() ?? '';
                                final timestamp =
                                    entry.value['timestamp']?.toString() ?? '';

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      semester,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amount: ₹$amount',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          'Updated: ${_formatTimestamp(timestamp)}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () => _startEditing(
                                                stream, semester, amount),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () => _deletePayment(
                                                stream, semester),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColor.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      style: TextStyle(color: Colors.black87, fontSize: 16),
      icon: Icon(Icons.arrow_drop_down, color: AppColor.primaryColor),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black87),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
