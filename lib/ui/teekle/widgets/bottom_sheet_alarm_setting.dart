import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';
import 'bottom_sheet_header.dart';

Future<DateTime?> showTeekleAlarmSetting(BuildContext context, {DateTime? selectedAlarmTime}) async {
  /// 기존: 바텀시트 바깥을 클릭해도 마지막 선택된 시간을 반환해야 됐어서 OnTimeChanged로
  /// 부모에서 가져온 변수 실시간으로 변경하는 방식
  ///
  /// 변경: PopScope으로 바텀시트 바깥 터치 아예 비활성화하고,
  /// showModalBottomSheet는 바텀시트가 닫힐 때 값을 반환게끔
  final result = await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => AlarmBottomSheet(
      selectedAlarmTime: selectedAlarmTime,
    ),
  );

  return result ?? selectedAlarmTime;
}

class AlarmBottomSheet extends StatefulWidget {
  final DateTime? selectedAlarmTime;

  const AlarmBottomSheet({this.selectedAlarmTime, super.key});

  @override
  State<AlarmBottomSheet> createState() => _AlarmBottomSheetState();
}

class _AlarmBottomSheetState extends State<AlarmBottomSheet> {
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedAlarmTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      /// 바텀시트 바깥 터치 시 바텀시트 close 방지
      canPop: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).viewInsets.bottom + 40,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TeekleBottomSheetHeader(
              title: "알림",
              showEdit: false,
              onClose: () => Navigator.pop(context, _selectedTime),
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
                  initialDateTime: _selectedTime,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => _selectedTime = newTime);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
