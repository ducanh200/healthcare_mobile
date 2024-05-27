import 'package:flutter/material.dart';
import 'package:healthcare/models/department.dart';
import 'package:healthcare/models/shift.dart';
import 'package:healthcare/screen/booking/confirmation_screen.dart';
import 'package:healthcare/services/department_service.dart';
import 'package:healthcare/services/shift_service.dart';
import 'package:healthcare/services/booking_service.dart';

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
  late int maxBooking = 0;
  int? selectedDepartmentId;
  bool departmentSelected = false;
  bool dateVisible = false;
  bool isNextButtonVisible = true;
  bool showMaxBookingMessage = false;
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
    _fetchShifts();
    _fetchMaxBooking();
    ;
  }

  void _fetchShifts() async {
    try {
      final fetchedShifts = await ShiftService.fetchShifts();
      setState(() {
        shifts = fetchedShifts;
      });
    } catch (e) {
      print("Error fetching shifts: $e");
    }
  }

  void _fetchMaxBooking() async {
    if (selectedDepartmentId != null) {
      try {
        final department = await DepartmentService.fetchDepartmentById(selectedDepartmentId!);
        setState(() {
          maxBooking = department.maxBooking ?? 0;
        });
      } catch (e) {
        print("Error fetching max booking: $e");
      }
    }
  }

  Future<void> _checkBookingCount(String time, int shiftId) async {
    if (selectedDepartmentId != null) {
      final bookingCountForCurrentDepartment = await BookingService()
          .getBookingCountForDepartment(selectedDate!, selectedDepartmentId!, shiftId);
      final totalBookings = bookingCountForCurrentDepartment + 1;

      setState(() {
        isNextButtonVisible = totalBookings <= maxBooking;
        showMaxBookingMessage = !isNextButtonVisible;
      });
    }
  }


  List<Widget> _buildTimeSlots(String session) {
    List<Widget> timeSlots = [];
    for (var shift in shifts) {
      if (shift.session.toLowerCase() == session.toLowerCase()) {
        timeSlots.add(
          GestureDetector(
            onTap: () async {
              await _checkBookingCount(shift.time, shift.id);
              _selectTime(shift.time);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: activeTiming == shift.time ? Colors.blue : Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                shift.time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: activeTiming == shift.time ? Colors.white : Colors.black,
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
      final bookingCountForCurrentDepartment =
      await BookingService().getBookingCountForDepartment(selectedDate!, selectedDepartmentId!, selectedShift.id);
      final totalBookings = bookingCountForCurrentDepartment + 1;

      if (totalBookings <= maxBooking) {
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
        _showSnackbar('Maximum booking limit reached for this department, time slot, and date.');
      }
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
    if (selectedDepartmentId != null ) {
      if (selectedDate != null ) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(26.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ['Morning', 'Afternoon', 'Evening'].map((session) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight
                            .bold),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _buildTimeSlots(session),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a date')),
        );
      }
    }else {
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
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              String searchKeyword = '';

              List<Department> _searchDepartments(String keyword, List<Department> departments) {
                return departments.where((department) =>
                    department.name!.toLowerCase().contains(keyword.toLowerCase())).toList();
              }

              return FutureBuilder<List<Department>>(
                future: DepartmentService.fetchDepartments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Lấy danh sách phòng ban
                    List<Department> departments = snapshot.data!;
                    // Lọc danh sách phòng ban dựa trên từ khóa tìm kiếm
                    if (searchKeyword.isNotEmpty) {
                      departments = _searchDepartments(searchKeyword, departments);
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by department name',
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchKeyword = value;
                              });
                            },
                          ),
                        ),
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
                                      _fetchMaxBooking();
                                      selectedDate = null;
                                      dateController.text = "Select Date";
                                      activeTiming = null;
                                      departmentSelected = true;
                                      timeController.text = "Select Time";
                                      isNextButtonVisible = true;
                                      showMaxBookingMessage = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          department.description ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
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
    Color nextButtonColor = canProceedToConfirmation() ? Colors.blueAccent : Colors.white54;
    Color nextButtonTextColor = canProceedToConfirmation() ? Colors.white : Colors.black38;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Select medical examination information',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
                              primary: Colors.lightBlueAccent,
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
                        isNextButtonVisible = true;
                        showMaxBookingMessage = false;
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
              if (showMaxBookingMessage)
                Center(
                  child: Text(
                    'Maximum booking limit reached for this department, time slot, and date.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              if (isNextButtonVisible)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: nextButtonColor,
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
                          color: nextButtonTextColor,
                        ),
                      ),
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
