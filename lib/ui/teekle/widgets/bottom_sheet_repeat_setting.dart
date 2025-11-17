import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teeklit/utils/colors.dart';
import 'bottom_sheet_header.dart';
import 'package:intl/intl.dart';
import '../../../utils/datetime_extension.dart';

enum RepeatPeriod { weekly, monthly }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

typedef OnRepeatChanged =
    void Function(
      bool hasRepeat,
      RepeatPeriod? period,
      int? interval,
      DateTime? repeatEndDate,
      List<DayOfWeek>? daysOfWeek,
    );

Future<void> showTeekleRepeatSetting(
  BuildContext context, {
  required bool hasRepeat,
  required RepeatPeriod? period,
  required int? interval,
  required DateTime? repeatEndDate,
  required List<DayOfWeek>? daysOfWeek,
  required OnRepeatChanged onRepeatChanged,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => RepeatBottomSheet(
      initialHasRepeat: hasRepeat,
      initialPeriod: period,
      initialInterval: interval,
      initialRepeatEndDate: repeatEndDate,
      initialDaysOfWeek: daysOfWeek,
      onStateChanged: onRepeatChanged,
    ),
  );
}

class RepeatBottomSheet extends StatefulWidget {
  final bool initialHasRepeat;
  final RepeatPeriod? initialPeriod;
  final int? initialInterval;
  final DateTime? initialRepeatEndDate;
  final List<DayOfWeek>? initialDaysOfWeek;
  final OnRepeatChanged onStateChanged;

  const RepeatBottomSheet({
    required this.initialHasRepeat,
    required this.initialPeriod,
    required this.initialInterval,
    required this.initialRepeatEndDate,
    required this.initialDaysOfWeek,
    required this.onStateChanged,
    super.key,
  });

  @override
  State<RepeatBottomSheet> createState() => _RepeatBottomSheetState();
}

class _RepeatBottomSheetState extends State<RepeatBottomSheet> {
  late bool _hasRepeat;
  late RepeatPeriod? _repeatPeriod;
  late int _interval;
  late DateTime _repeatEndDate;
  late List<DayOfWeek> _selectedDaysOfWeek;

  bool _showRepeatPicker = false;
  bool _showRepeatEndPicker = false;

  final List<String> _daysOfWeekLabels = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    _hasRepeat = widget.initialHasRepeat;
    _repeatPeriod = widget.initialPeriod ?? RepeatPeriod.weekly;
    _interval = widget.initialInterval ?? 1;
    _repeatEndDate = widget.initialRepeatEndDate ?? DateTime.now().toDateOnly();
    _selectedDaysOfWeek = List.from(widget.initialDaysOfWeek ?? []);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyStateChange();
    });
  }

  void _notifyStateChange() {
    widget.onStateChanged(
      _hasRepeat,
      _hasRepeat ? _repeatPeriod : null,
      _hasRepeat ? _interval : null,
      _repeatEndDate,
      _hasRepeat ? _selectedDaysOfWeek : null,
    );
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
            title: "반복",
            showEdit: false,
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),

          // 주간/월간 슬라이드 토글
          GestureDetector(
            onTap: () {
              setState(() {
                _hasRepeat = true;
                _notifyStateChange();
              });
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.TxtGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _hasRepeat ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _repeatPeriod == RepeatPeriod.weekly
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      curve: Curves.easeInOut,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: AppColors.LightGreen,
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() {
                            _hasRepeat = true;
                            _repeatPeriod = RepeatPeriod.weekly;
                            _notifyStateChange();
                          }),
                          child: Center(
                            child: Text(
                              '주간',
                              style: TextStyle(
                                color:
                                    _hasRepeat &&
                                        _repeatPeriod == RepeatPeriod.weekly
                                    ? AppColors.TxtDark
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() {
                            _hasRepeat = true;
                            _repeatPeriod = RepeatPeriod.monthly;
                            _notifyStateChange();
                          }),
                          child: Center(
                            child: Text(
                              '월간',
                              style: TextStyle(
                                color:
                                    _hasRepeat &&
                                        _repeatPeriod == RepeatPeriod.monthly
                                    ? AppColors.TxtDark
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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

          IgnorePointer(
            ignoring: !_hasRepeat,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _hasRepeat ? 1.0 : 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 반복 종료 날짜
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '반복 종료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showRepeatEndPicker = !_showRepeatEndPicker;
                            if (_showRepeatEndPicker) {
                              _showRepeatPicker = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              DateFormat('MM월 dd일').format(_repeatEndDate),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_showRepeatEndPicker)
                    SizedBox(
                      height: 150,
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
                          minimumYear: DateTime.now().year,
                          maximumYear: DateTime.now().year + 5,
                          initialDateTime: _repeatEndDate,
                          minimumDate: _repeatEndDate,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              _repeatEndDate = newDate;
                              _notifyStateChange();
                            });
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // 반복 주기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '반복 주기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showRepeatPicker = !_showRepeatPicker;
                            if (_showRepeatPicker) {
                              _showRepeatEndPicker = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _repeatPeriod == RepeatPeriod.weekly
                                  ? '$_interval주마다'
                                  : '$_interval달마다',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_showRepeatPicker)
                    SizedBox(
                      height: 110,
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: _interval - 1,
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _interval = index + 1;
                            _notifyStateChange();
                          });
                        },
                        children: List.generate(
                          3, (index) => Center(
                            child: Text(
                              _repeatPeriod == RepeatPeriod.weekly
                                  ? '${index + 1}주마다'
                                  : '${index + 1}달마다',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  const Text(
                    '요일 선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_daysOfWeekLabels.length, (index) {
                      final dayOfWeek = DayOfWeek.values[index];
                      final isSelected = _selectedDaysOfWeek.contains(
                        dayOfWeek,
                      );
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDaysOfWeek.remove(dayOfWeek);
                            } else {
                              _selectedDaysOfWeek.add(dayOfWeek);
                            }
                            _notifyStateChange();
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: isSelected
                              ? AppColors.LightGreen
                              : AppColors.TxtGrey,
                          child: Text(
                            _daysOfWeekLabels[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.TxtDark
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
