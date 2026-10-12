import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cupertino_date_picker_page.dart';

/// A practical screen that uses the selected date to filter schedule data.
class EmployeeFilterPage extends StatefulWidget {
  const EmployeeFilterPage({super.key});

  @override
  State<EmployeeFilterPage> createState() => _EmployeeFilterPageState();
}

class _EmployeeFilterPageState extends State<EmployeeFilterPage> {
  // The selected date and team drive the list shown below the filter controls.
  DateTime selectedDate = DateTime.now();
  bool showAllDates = true;
  String department = 'All teams';

  List<Employee> get filteredEmployees => employees.where((employee) {
    final sameDay =
        employee.nextShift.year == selectedDate.year &&
        employee.nextShift.month == selectedDate.month &&
        employee.nextShift.day == selectedDate.day;
    return (showAllDates || sameDay) &&
        (department == 'All teams' || employee.department == department);
  }).toList();

  void pickDate() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => PickerSheet(
        picker: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          showDayOfWeek: true,
          onDateTimeChanged: (value) => setState(() {
            selectedDate = value;
            showAllDates = false;
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PageLayout(
    title: 'Team schedule',
    children: [
      DateFilterCard(
        date: selectedDate,
        showAllDates: showAllDates,
        onTap: pickDate,
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 42,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: ['All teams', 'Design', 'Engineering', 'Marketing']
              .map(
                (team) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(team),
                    selected: department == team,
                    onSelected: (_) => setState(() => department = team),
                    selectedColor: const Color(0xFFDDE2FF),
                    side: BorderSide.none,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 22),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${filteredEmployees.length} employees scheduled',
            style: sectionStyle,
          ),
          Text(
            showAllDates ? 'All dates' : formatLongDate(selectedDate),
            style: const TextStyle(color: Color(0xFF76809A), fontSize: 12),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (filteredEmployees.isEmpty)
        EmptyState(date: selectedDate)
      else
        ...filteredEmployees.map(
          (employee) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: EmployeeTile(employee: employee),
          ),
        ),
    ],
  );
}

/// Shows the active schedule date and opens the date picker when tapped.
class DateFilterCard extends StatelessWidget {
  const DateFilterCard({
    required this.date,
    required this.showAllDates,
    required this.onTap,
    super.key,
  });

  final DateTime date;
  final bool showAllDates;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: EdgeInsets.zero,
    color: const Color(0xFF202A55),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showAllDates ? 'Showing all shifts' : 'Showing shifts for',
                    style: const TextStyle(
                      color: Color(0xFFB8C1E8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    showAllDates ? 'All dates' : formatLongDate(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.tune, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

/// Renders one employee's role, team, date, and working hours.
class EmployeeTile extends StatelessWidget {
  const EmployeeTile({required this.employee, super.key});

  final Employee employee;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: EdgeInsets.zero,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: employee.color.withValues(alpha: .16),
            foregroundColor: employee.color,
            child: Text(
              employee.initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.name, style: sectionStyle),
                const SizedBox(height: 3),
                Text(
                  employee.role,
                  style: const TextStyle(
                    color: Color(0xFF8B93A7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                employee.department,
                style: TextStyle(
                  color: employee.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatDate(employee.nextShift),
                style: const TextStyle(
                  color: Color(0xFF76809A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                employee.shift,
                style: const TextStyle(color: Color(0xFF5F6880), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        const Icon(Icons.event_busy, color: Color(0xFF9BA4B7), size: 38),
        const SizedBox(height: 10),
        Text('No shifts on ${formatLongDate(date)}', style: sectionStyle),
        const SizedBox(height: 4),
        const Text(
          'Try another date or team.',
          style: TextStyle(color: Color(0xFF8B93A7)),
        ),
      ],
    ),
  );
}

class Employee {
  const Employee(
    this.name,
    this.role,
    this.department,
    this.shift,
    this.nextShift,
    this.initials,
    this.color,
  );

  final String name, role, department, shift, initials;
  final DateTime nextShift;
  final Color color;
}

final today = DateTime.now();
final employees = <Employee>[
  Employee(
    'Maya Patel',
    'Product designer',
    'Design',
    '09:00 – 17:00',
    today,
    'MP',
    const Color(0xFFEC7B45),
  ),
  Employee(
    'Jordan Lee',
    'Mobile engineer',
    'Engineering',
    '10:00 – 18:00',
    today,
    'JL',
    const Color(0xFF5865F2),
  ),
  Employee(
    'Amara Okafor',
    'Marketing lead',
    'Marketing',
    '08:00 – 16:00',
    today,
    'AO',
    const Color(0xFF23A88D),
  ),
  Employee(
    'Liam Smith',
    'Frontend engineer',
    'Engineering',
    '09:30 – 17:30',
    today.add(const Duration(days: 1)),
    'LS',
    const Color(0xFF5865F2),
  ),
  Employee(
    'Sofia Rossi',
    'Visual designer',
    'Design',
    '11:00 – 19:00',
    today.add(const Duration(days: 1)),
    'SR',
    const Color(0xFFEC7B45),
  ),
  Employee(
    'Ethan Brown',
    'QA engineer',
    'Engineering',
    '09:00 – 17:00',
    today.add(const Duration(days: 2)),
    'EB',
    const Color(0xFF5865F2),
  ),
  Employee(
    'Nandi Mokoena',
    'Product manager',
    'Marketing',
    '08:30 – 16:30',
    today.add(const Duration(days: 3)),
    'NM',
    const Color(0xFF23A88D),
  ),
  Employee(
    'Oliver Chen',
    'UX researcher',
    'Design',
    '10:00 – 18:00',
    today.add(const Duration(days: 4)),
    'OC',
    const Color(0xFFEC7B45),
  ),
  Employee(
    'Priya Shah',
    'Backend engineer',
    'Engineering',
    '09:30 – 17:30',
    today.add(const Duration(days: 5)),
    'PS',
    const Color(0xFF5865F2),
  ),
  Employee(
    'Daniel Kim',
    'Content strategist',
    'Marketing',
    '11:00 – 19:00',
    today.add(const Duration(days: 6)),
    'DK',
    const Color(0xFF23A88D),
  ),
];
