import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The presentation page for Flutter's native iOS-style date picker.
class PickerBasicsPage extends StatefulWidget {
  const PickerBasicsPage({super.key});

  @override
  State<PickerBasicsPage> createState() => _PickerBasicsPageState();
}

class _PickerBasicsPageState extends State<PickerBasicsPage> {
  // Each mode keeps its own value so changing one picker does not reset the others.
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  DateTime dateTime = DateTime.now();

  // Opens the Cupertino wheel picker in the selected mode.
  void showPicker(CupertinoDatePickerMode mode) {
    final initial = mode == CupertinoDatePickerMode.date
        ? date
        : mode == CupertinoDatePickerMode.time
        ? time
        : dateTime;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => PickerSheet(
        picker: CupertinoDatePicker(
          mode: mode,
          initialDateTime: initial,
          use24hFormat: true,
          showDayOfWeek: mode == CupertinoDatePickerMode.date,
          onDateTimeChanged: (value) => setState(() {
            if (mode == CupertinoDatePickerMode.date) date = value;
            if (mode == CupertinoDatePickerMode.time) time = value;
            if (mode == CupertinoDatePickerMode.dateAndTime) dateTime = value;
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PageLayout(
    title: 'CupertinoDatePicker',
    children: [
      PickerDemoCard(
        icon: Icons.calendar_today_outlined,
        color: const Color(0xFF5865F2),
        label: 'Date mode',
        description: 'Pick a calendar date',
        value: formatDate(date),
        onTap: () => showPicker(CupertinoDatePickerMode.date),
      ),
      const SizedBox(height: 12),
      PickerDemoCard(
        icon: Icons.schedule_outlined,
        color: const Color(0xFFEC7B45),
        label: 'Time mode',
        description: 'Pick a time of day',
        value: formatTime(time),
        onTap: () => showPicker(CupertinoDatePickerMode.time),
      ),
      const SizedBox(height: 12),
      PickerDemoCard(
        icon: Icons.event_available_outlined,
        color: const Color(0xFF23A88D),
        label: 'Date + time mode',
        description: 'Pick an exact moment',
        value: '${formatDate(dateTime)}  •  ${formatTime(dateTime)}',
        onTap: () => showPicker(CupertinoDatePickerMode.dateAndTime),
      ),
    ],
  );
}

/// Shared page spacing used by both presentation screens.
class PageLayout extends StatelessWidget {
  const PageLayout({
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.children,
    super.key,
  });

  final String? eyebrow, subtitle;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null) ...[
              Text(eyebrow!, style: eyebrowStyle),
              const SizedBox(height: 10),
            ],
            Text(title, style: titleStyle),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(subtitle!, style: subtitleStyle),
            ],
            const SizedBox(height: 26),
            ...children,
          ],
        ),
      ),
    ),
  );
}

/// Bottom-sheet container for the Cupertino wheel.
class PickerSheet extends StatelessWidget {
  const PickerSheet({required this.picker, super.key});

  final Widget picker;

  @override
  Widget build(BuildContext context) => Container(
    height: 280,
    padding: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: SafeArea(top: false, child: picker),
  );
}

/// Displays one picker mode and opens its wheel when tapped.
class PickerDemoCard extends StatelessWidget {
  const PickerDemoCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    required this.value,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String label, description, value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: EdgeInsets.zero,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: .12),
              foregroundColor: color,
              child: Icon(icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: sectionStyle),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF8B93A7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFADB4C5)),
          ],
        ),
      ),
    ),
  );
}

const titleStyle = TextStyle(
  fontSize: 32,
  height: 1.1,
  fontWeight: FontWeight.w800,
  color: Color(0xFF17203B),
);
const subtitleStyle = TextStyle(
  fontSize: 16,
  height: 1.45,
  color: Color(0xFF727C94),
);
const sectionStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: Color(0xFF25304C),
);
const eyebrowStyle = TextStyle(
  color: Color(0xFF5865F2),
  fontSize: 12,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.5,
);

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';

String formatTime(DateTime date) =>
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

String formatLongDate(DateTime date) =>
    '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';

const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
