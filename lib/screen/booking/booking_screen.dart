import 'package:flutter/material.dart';
import 'package:healthcare/models/shift.dart';
import 'package:healthcare/models/booking.dart';
import 'package:healthcare/services/department_service.dart';
import 'package:healthcare/services/shift_service.dart';
import 'package:healthcare/services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final int departmentId;

  const BookingScreen({Key? key, required this.departmentId}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int activeDay = 0;
  late DateTime selectedDate;
  String? activeTiming;
  List<String> dateList = [];
  late List<Shift> shifts = []; // Initialize shifts as an empty list
  late DateTime today; // Declare the variable today here
  late int maxBooking = 0; // Declare maxBooking here

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    _loadDateList();
    _fetchShifts();
    _fetchMaxBooking();
  }

  void _fetchShifts() async {
    try {
      final fetchedShifts = await ShiftService.fetchShifts();
      setState(() {
        shifts = fetchedShifts;
      });
    } catch (e) {
      // Handle error
      print("Error fetching shifts: $e");
    }
  }

  void _fetchMaxBooking() async {
    try {
      final department = await DepartmentService.fetchDepartmentById(widget.departmentId);
      setState(() {
        maxBooking = department.maxBooking ?? 0;
      });
    } catch (e) {
      // Handle error
      print("Error fetching max booking: $e");
    }
  }

  void _loadDateList() {
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    for (int i = 0; i < 7; i++) {
      final date = today.add(Duration(days: i + 1));
      final dayOfWeek = daysOfWeek[date.weekday - 1];
      dateList.add('$dayOfWeek, ${date.day} ${_getMonthAbbreviation(date.month)}');
    }
    selectedDate = today.add(Duration(days: 1));
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Available Slots'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        activeDay = index;
                        selectedDate = today.add(Duration(days: index + 1));
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: activeDay == index ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dateList[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: activeDay == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var session in ['Morning', 'Afternoon', 'Evening'])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$session',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: shifts.where((s) => s.session.toLowerCase() == session.toLowerCase()).length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final sessionShifts = shifts.where((s) => s.session.toLowerCase() == session.toLowerCase()).toList();
                              final time = sessionShifts[index].time;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeTiming = time;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: activeTiming == time ? Colors.blue : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: activeTiming == time ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (activeTiming != null) {
                  final selectedShift = shifts.firstWhere((shift) => shift.time.contains(activeTiming!));
                  final bookingCountForCurrentDepartment = await BookingService().getBookingCountForDepartment(selectedDate, widget.departmentId, selectedShift.id);
                  final totalBookings = bookingCountForCurrentDepartment + 1; // Add 1 for the current booking

                  if (totalBookings <= maxBooking) {
                    final booking = Booking(
                      bookingAt: DateTime.now(),
                      status: 1,
                      date: selectedDate.toString().substring(0, 10),
                      patientId: 1, // Replace with actual patient ID
                      departmentId: widget.departmentId,
                      shiftId: selectedShift.id,
                    );

                    final createdBooking = await BookingService().createBooking(booking);
                    print('Booking created: $createdBooking');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Maximum booking limit reached for this department, time slot, and date.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a time slot')),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
