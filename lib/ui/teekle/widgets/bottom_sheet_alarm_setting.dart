import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';
import 'bottom_sheet_header.dart';

Future<DateTime?> showTeekleAlarmSetting(BuildContext context, {DateTime? initialTime}) async {
  DateTime selectedTime = initialTime ?? DateTime.now();

  final result = await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AlarmBottomSheet(
      initialTime: initialTime,
      onTimeChanged: (t) => selectedTime = t, // 시간이 바뀔 때마다 selectedTime 업데이트
    ),
  );

  return result ?? selectedTime;
}

class AlarmBottomSheet extends StatefulWidget {
  final DateTime? initialTime;
  final ValueChanged<DateTime>? onTimeChanged;
  const AlarmBottomSheet({this.initialTime, this.onTimeChanged, super.key});

  @override
  State<AlarmBottomSheet> createState() => _AlarmBottomSheetState();
}

class _AlarmBottomSheetState extends State<AlarmBottomSheet> {
  late DateTime time;

  @override
  void initState() {
    super.initState();
    time = widget.initialTime ?? DateTime.now();
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
            title: "알림",
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
                initialDateTime: time,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() => time = newTime);
                  widget.onTimeChanged?.call(time);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
