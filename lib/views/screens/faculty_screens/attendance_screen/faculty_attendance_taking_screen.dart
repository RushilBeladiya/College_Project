import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/colors.dart';

class ClassDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> classData;

  const ClassDetailsScreen({super.key, required this.classData});

  @override
  _ClassDetailsScreenState createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  DateTime selectedDate = DateTime.now();
  Map<String, String> attendanceStatus = {};
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeAttendanceStatus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeAttendanceStatus() {
    setState(() {
      for (var student in widget.classData['students']) {
        String spid = student['spid']?.toString() ?? '';
        if (spid.isNotEmpty) {
          attendanceStatus[spid] = 'Absent';
        }
      }
    });
  }

  Future<void> _fetchAttendance() async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('attendance')
        .child(widget.classData['stream'])
        .child(widget.classData['semester'])
        .child(widget.classData['division'])
        .child(widget.classData['subject'])
        .child(date);

    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);

      setState(() {
        attendanceStatus = data.map((key, value) =>
            MapEntry(key.toString(), value['status'].toString()));
      });
    } else {
      _initializeAttendanceStatus();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColor.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _fetchAttendance();
    }
  }

  bool isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  void _toggleAttendance(String spid) {
    if (!isToday()) return;

    setState(() {
      attendanceStatus[spid] =
          attendanceStatus[spid] == 'Present' ? 'Absent' : 'Present';
    });
  }

  Future<void> _confirmSubmission() async {
    if (!isToday()) return;

    try {
      String date = DateFormat('yyyy-MM-dd').format(selectedDate);

      for (var student in widget.classData['students']) {
        String spid = student['spid']?.toString() ?? '';
        if (spid.isEmpty) continue;

        await FirebaseDatabase.instance
            .ref()
            .child('attendance')
            .child(widget.classData['stream'])
            .child(widget.classData['semester'])
            .child(widget.classData['division'])
            .child(widget.classData['subject'])
            .child(date)
            .child(spid)
            .set({
          'status': attendanceStatus[spid] ?? 'Absent',
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Attendance submitted successfully.'),
          backgroundColor: AppColor.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit attendance: $e'),
          backgroundColor: AppColor.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'Present') return AppColor.successColor;
    if (status == 'Absent') return AppColor.errorColor;
    return AppColor.warningColor;
  }

  List<dynamic> _getFilteredStudents() {
    if (_searchQuery.isEmpty) {
      return widget.classData['students'];
    }
    return widget.classData['students'].where((student) {
      String firstName = student['firstName']?.toString().toLowerCase() ?? '';
      String lastName = student['lastName']?.toString().toLowerCase() ?? '';
      String spid = student['spid']?.toString().toLowerCase() ?? '';
      String query = _searchQuery.toLowerCase();

      return firstName.contains(query) ||
          lastName.contains(query) ||
          spid.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentDate = isToday();
    int presentCount =
        attendanceStatus.values.where((status) => status == 'Present').length;
    int totalCount = widget.classData['students'].length;
    List<dynamic> filteredStudents = _getFilteredStudents();

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: BackButton(
          color: AppColor.whiteColor,
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isSearchExpanded
                ? MediaQuery.of(context).size.width * 0.7
                : 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isSearchExpanded
                  ? Colors.white.withOpacity(0.2)
                  : AppColor.primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (!_isSearchExpanded)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
              ],
            ),
            child: _isSearchExpanded
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Search students...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close,
                                size: 18, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                      ],
                    ),
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _isSearchExpanded = true;
                          _searchFocusNode.requestFocus();
                        });
                      },
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
          ),
          if (!_isSearchExpanded) SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.classData['stream']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor,
                          ),
                        ),
                        Text(
                          '${widget.classData['semester']} | Div ${widget.classData['division']}',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '${widget.classData['subject']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('dd MMM yyyy').format(selectedDate),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Attendance Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Present',
                        presentCount,
                        AppColor.successColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Absent',
                        totalCount - presentCount,
                        AppColor.errorColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Total',
                        totalCount,
                        AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off,
                          size: 48,
                          color: AppColor.warningColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? "No Students Found"
                              : "No matching students found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.warningColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      var student = filteredStudents[index];
                      var firstName = student['firstName'] ?? 'Unknown';
                      var lastName = student['lastName'] ?? 'Unknown';
                      var spid = student['spid']?.toString() ?? 'N/A';

                      String status = attendanceStatus[spid] ?? 'Absent';
                      Color statusColor = _getStatusColor(status);

                      // Highlight if matches search
                      bool isHighlighted = _searchQuery.isNotEmpty &&
                          ('$firstName $lastName $spid'
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()));

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? AppColor.primaryColor.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isHighlighted
                              ? Border.all(
                                  color: AppColor.primaryColor,
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: 6, // Blur radius
                              offset: Offset(0, 5), // Offset for the shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? AppColor.primaryColor.withOpacity(0.8)
                                  : AppColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            '$firstName $lastName',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isHighlighted
                                  ? AppColor.primaryColor
                                  : AppColor.textColor,
                            ),
                          ),
                          subtitle: Text(
                            'ID: $spid',
                            style: TextStyle(
                              color: isHighlighted
                                  ? AppColor.primaryColor.withOpacity(0.8)
                                  : AppColor.textColor.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          trailing: isCurrentDate
                              ? Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: status == 'Present',
                                    onChanged: (value) =>
                                        _toggleAttendance(spid),
                                    activeColor: AppColor.successColor,
                                    inactiveThumbColor: AppColor.errorColor,
                                    inactiveTrackColor:
                                        AppColor.errorColor.withOpacity(0.2),
                                    activeTrackColor:
                                        AppColor.successColor.withOpacity(0.4),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),

          // Submit Button
          if (isCurrentDate)
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmSubmission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
