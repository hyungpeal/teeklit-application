import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';
import 'bottom_sheet_header.dart';
import '../../../utils/datetime_extension.dart';

Future<DateTime> showTeekleDateSetting(context, DateTime selectedDate) async {
  DateTime lastSelectedDate = selectedDate.toDateOnly();

  final result = await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DateBottomSheet(
      selectedDate: lastSelectedDate,
      onTimeChanged: (t) => lastSelectedDate = t,
    ),
  );

  return result ?? lastSelectedDate; // result가 null이면 마지막 선택된 값 반환
}

class DateBottomSheet extends StatefulWidget {
  final ValueChanged<DateTime>? onTimeChanged;
  final DateTime? selectedDate;

  const DateBottomSheet({this.onTimeChanged, this.selectedDate, super.key});

  @override
  State<DateBottomSheet> createState() => _DateBottomSheetState();
}

class _DateBottomSheetState extends State<DateBottomSheet> {
  late DateTime date;
  late DateTime minimumDate;
  late DateTime maximumDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toDateOnly();
    date = widget.selectedDate?.toDateOnly() ?? now;
    minimumDate = now;
    maximumDate = DateTime(2030, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeekleBottomSheetHeader(
            title: "날짜",
            showEdit: false,
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                minimumYear: 2025,
                maximumYear: 2026,
                initialDateTime: date,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => date = newDate.toDateOnly());
                  widget.onTimeChanged?.call(date);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}