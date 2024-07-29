import 'package:flutter/material.dart';
import 'package:healthcare/models/department.dart';
import 'package:healthcare/models/shift.dart';
import 'package:healthcare/my_page.dart';
import 'package:healthcare/screen/booking/confirmation_screen.dart';
import 'package:healthcare/screen/home/home_screen.dart';
import 'package:healthcare/services/department_service.dart';
import 'package:healthcare/services/shift_service.dart';
class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}
class _BookingScreenState extends State<BookingScreen> {
  int activeDay = 0;
  late DateTime? selectedDate;
  String? activeTiming;
  List<String> dateList = [];
  late List<Shift> shifts = [];
  late DateTime today;
  int? selectedDepartmentId;
  bool departmentSelected = false;
  final TextEditingController departmentController = TextEditingController(text: "Select Department");
  final TextEditingController dateController = TextEditingController(text: "Select Date");
  final TextEditingController timeController = TextEditingController(text: "Select Time");
  bool _hasInitialValue(TextEditingController controller, String initialValue) {
    return controller.text == initialValue;
  }
  bool canProceedToConfirmation() {
    return selectedDepartmentId != null && selectedDate != null && activeTiming != null;
  }
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    selectedDate = null;
    _fetchShifts(selectedDate, selectedDepartmentId);
  }
  void _color() async {
        setState((){});
  }
  void _fetchShifts(DateTime? selectedDate, int? selectedDepartmentId) async {
    if (selectedDate != null && selectedDepartmentId != null) {
      try {
        final fetchedShifts = await ShiftService.fetchShifts(selectedDate, selectedDepartmentId);
        setState(() {
          shifts = fetchedShifts;
        });
      } catch (e) {
        print("Error fetching shifts: $e");
      }
    }
  }
  List<Widget> _buildTimeSlots(String session) {
    List<Widget> timeSlots = [];
    for (var shift in shifts) {
      if (shift.session.toLowerCase() == session.toLowerCase()) {
        bool isActive = shift.status != 1;
        timeSlots.add(
          GestureDetector(
            onTap: isActive
                ? () async {
              _selectTime(shift.time);
            }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: activeTiming == shift.time ? Colors.blue : isActive ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                shift.time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeTiming == shift.time ? Colors.white : isActive ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }
    }
    return timeSlots;
  }

  void _navigateToConfirmation() async {
    if (canProceedToConfirmation()) {
      final department = await DepartmentService.fetchDepartmentById(selectedDepartmentId!);
      final selectedShift = shifts.firstWhere((shift) => shift.time.contains(activeTiming!));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(
              DepartmentId: selectedDepartmentId!,
              DepartmentName: department.name!,
              Date: selectedDate.toString().substring(0, 10),
              Session:selectedShift.session,
              TimeId: selectedShift.id,
              Time: activeTiming!,
            ),
          ),
        );
    } else {
      String message;
      if (selectedDepartmentId == null) {
        message = 'Please select a department';
      } else if (selectedDate == null) {
        message = 'Please select a date';
      } else if (activeTiming == null) {
        message = 'Please select a time slot';
      } else {
        message = 'Invalid selection';
      }
      _showSnackbar(message);
    }
  }
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  void _showTimePickerBottomSheet() {
    if (selectedDepartmentId != null) {
      if (selectedDate != null) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(26.0),
              height: MediaQuery.of(context).size.height / 1.5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '*Note',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Available'),
                        SizedBox(width: 16),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Booked'),
                        SizedBox(width: 16),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Selected'),
                      ],
                    ),
                    SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ['Morning', 'Afternoon'].map((session) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Wrap(
                              spacing: 8.0, // khoảng cách ngang giữa các phần tử
                              runSpacing: 8.0, // khoảng cách dọc giữa các dòng
                              children: _buildTimeSlots(session),
                            ),
                            SizedBox(height: 24),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a department')),
      );
    }
  }




  void _selectTime(String selectedTime) {
    setState(() {
      activeTiming = selectedTime;
    });
    Navigator.pop(context);
    timeController.text = selectedTime;
  }
  void _showDepartmentPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              String searchKeyword = '';

              return FutureBuilder<List<Department>>(
                future: DepartmentService.fetchDepartments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Department> departments = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: departments.length,
                            itemBuilder: (context, index) {
                              final department = departments[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDepartmentId = department.id;
                                      departmentController.text = department.name ?? 'Unknown';
                                      selectedDate = null;
                                      dateController.text = "Select Date";
                                      activeTiming = null;
                                      departmentSelected = true;
                                      timeController.text = "Select Time";
                                      _color();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          department.name ?? '',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          department.description ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Select medical examination information',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Department',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: _showDepartmentPickerBottomSheet,
                child: IgnorePointer(
                  child: TextField(
                    controller: departmentController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.segment,
                        color: _hasInitialValue(departmentController, "Select Department") ? Colors.grey : Colors.blueAccent,
                      ),
                      labelStyle: TextStyle(
                        color: _hasInitialValue(departmentController, "Select Department") ? Colors.black : Colors.blueAccent,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasInitialValue(departmentController, "Select Department") ? Colors.grey : Colors.blueAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: _hasInitialValue(departmentController, "Select Department") ? Colors.black : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Date',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  if (selectedDepartmentId != null) {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: today.add(Duration(days: 1)),
                      lastDate: today.add(Duration(days: 7)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blueAccent,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.blue[50],
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        activeTiming = null;
                        timeController.text = "Select Time";
                        _fetchShifts(selectedDate, selectedDepartmentId);
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a department')),
                    );
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: _hasInitialValue(dateController, "Select Date") ? Colors.grey : Colors.blueAccent,
                      ),
                      labelStyle: TextStyle(
                        color: _hasInitialValue(dateController, "Select Date") ? Colors.black : Colors.blueAccent,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasInitialValue(dateController, "Select Date") ? Colors.grey : Colors.blueAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: _hasInitialValue(dateController, "Select Date") ? Colors.black : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Time',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  _showTimePickerBottomSheet();
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.access_time,
                        color: _hasInitialValue(timeController, "Select Time") ? Colors.grey : Colors.blueAccent,
                      ),
                      labelStyle: TextStyle(
                        color: _hasInitialValue(timeController, "Select Time") ? Colors.black : Colors.blueAccent,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasInitialValue(timeController, "Select Time") ? Colors.grey : Colors.blueAccent,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: _hasInitialValue(timeController, "Select Time") ? Colors.black : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _navigateToConfirmation(),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Image.asset(
                    'assets/images/people-hospital-hall-patients-doctors-team-clinic-waiting-room-horizontal-banner-people-hospital-hall-patients-114188432.webp',
                    width: 500,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}