import 'package:flutter/material.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_alarm_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_date_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_repeat_setting.dart';
import 'package:teeklit/ui/teekle/widgets/bottom_sheet_tag_setting.dart';
import 'package:teeklit/utils/colors.dart';
import 'package:intl/intl.dart';

enum TeeklePageType {
  addTodo,
  editTodo,
  addWorkout,
  editWorkout
}

class TeekleSettingPage extends StatefulWidget {
  final TeeklePageType? type;

  const TeekleSettingPage({super.key, required this.type});

  @override
  State<TeekleSettingPage> createState() => _TeekleSettingPage();
}

class _TeekleSettingPage extends State<TeekleSettingPage> {
  bool _hasTitle = false;
  DateTime _selectedDate = DateTime.now();
  bool _isAlarmOn = false;
  DateTime? _selectedAlarmTime;
  String? _selectedTag;

  bool _hasRepeat = false;
  RepeatPeriod? _repeatPeriod;
  int? _interval;
  DateTime? _repeatEndDate;
  List<DayOfWeek>? _selectedDaysOfWeek;

  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Bg,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: AppColors.Bg,
        foregroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(color: AppColors.StrokeGrey, width: 1),
        ),
        title: Text(
          widget.type == TeeklePageType.addTodo
            ? '투두 추가하기' : widget.type == TeeklePageType.editTodo
            ? '투두 수정하기' : widget.type == TeeklePageType.addWorkout
            ? '운동 추가하기' : widget.type == TeeklePageType.editWorkout
            ? '운동 수정하기' : '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: AppColors.TxtGrey, size: 24),
        ),
      ),

      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type == TeeklePageType.addTodo ||
                          widget.type == TeeklePageType.editTodo
                      ? '투두 이름'
                      : '운동 선택',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  focusNode: _titleFocusNode,
                  keyboardType: TextInputType.multiline,
                  cursorColor: AppColors.Green,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _hasTitle = value.trim().isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText:
                    widget.type == TeeklePageType.addTodo ||
                        widget.type == TeeklePageType.editTodo
                        ? '할일을 입력해주세요.'
                        : '운동을 선택해주세요.',
                    hintStyle: const TextStyle(color: Color(0xff8E8E93)),
                    filled: true,
                    fillColor: const Color(0xff3A3A3C),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 설정 박스
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3A3A3C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // 날짜
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        title: const Text(
                          '날짜',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('MM월 dd일').format(_selectedDate),
                              style: const TextStyle(
                                color: AppColors.TxtLight,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: -.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                        onTap: () async {
                          // 텍스트필드에 포커스가 있으면 실행 안 함
                          if (_titleFocusNode.hasFocus) {
                            return;
                          }
                          final lastSelectedDate = await showTeekleDateSetting(
                            context,
                            _selectedDate,
                          );
                          setState(() {
                            _selectedDate = lastSelectedDate;
                          });
                        },
                      ),
                      const Divider(color: Color(0xff2C2C2E), height: 1),

                      // 알림 (토글)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        title: const Text(
                          '알림',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isAlarmOn && _selectedAlarmTime != null)
                              GestureDetector(
                                onTap: () async {
                                  // 텍스트필드에 포커스가 있으면 실행 안 함
                                  if (_titleFocusNode.hasFocus) {
                                    return;
                                  }
                                  final pickedTime =
                                      await showTeekleAlarmSetting(
                                        context,
                                        initialTime: _selectedAlarmTime,
                                      );
                                  if (pickedTime != null) {
                                    setState(() {
                                      _selectedAlarmTime = pickedTime;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade700,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    DateFormat(
                                      'h:mm a',
                                    ).format(_selectedAlarmTime!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Switch.adaptive(
                              value: _isAlarmOn,
                              onChanged: (bool value) async {
                                // 텍스트필드에 포커스가 있으면 실행 안 함
                                if (_titleFocusNode.hasFocus) {
                                  return;
                                }
                                if (value) {
                                  final pickedTime =
                                      await showTeekleAlarmSetting(
                                        context,
                                        initialTime: _selectedAlarmTime,
                                      );
                                  if (pickedTime != null) {
                                    setState(() {
                                      _isAlarmOn = true;
                                      _selectedAlarmTime = pickedTime;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _isAlarmOn = false;
                                    _selectedAlarmTime = null;
                                  });
                                }
                              },
                              activeThumbColor: Colors.white,
                              activeTrackColor: const Color(0xffB1C39F),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xff2C2C2E), height: 1),

                      // 반복 (토글 스위치)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        title: const Text(
                          '반복',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Switch.adaptive(
                          value: _hasRepeat,
                          onChanged: (bool value) async {
                            // 텍스트필드에 포커스가 있으면 실행 안 함
                            if (_titleFocusNode.hasFocus) {
                              return;
                            }
                            if (value) {
                              await showTeekleRepeatSetting(
                                context,
                                hasRepeat: value,
                                period: _repeatPeriod,
                                interval: _interval,
                                repeatEndDate: _selectedDate,
                                daysOfWeek: _selectedDaysOfWeek,
                                onRepeatChanged:
                                    (hasRepeat,
                                    period,
                                    interval,
                                    repeatEndDate,
                                    daysOfWeek,) {
                                  setState(() {
                                    _hasRepeat = hasRepeat;
                                    _repeatPeriod = period;
                                    _interval = interval;
                                    _repeatEndDate = repeatEndDate;
                                    _selectedDaysOfWeek = daysOfWeek;
                                  });
                                },
                              );
                            } else {
                              setState(() {
                                _hasRepeat = value;
                                _repeatPeriod = null;
                                _interval = null;
                                _selectedDaysOfWeek = null;
                              });
                            }
                          },
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xffB1C39F),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade700,
                        ),
                        onTap: () async {
                          // 텍스트필드에 포커스가 있으면 실행 안 함
                          if (_titleFocusNode.hasFocus) {
                            return;
                          }
                          if (_hasRepeat) {
                            await showTeekleRepeatSetting(
                              context,
                              hasRepeat: _hasRepeat,
                              period: _repeatPeriod,
                              interval: _interval,
                              repeatEndDate: _repeatEndDate,
                              daysOfWeek: _selectedDaysOfWeek,
                              onRepeatChanged:
                                  (
                                    hasRepeat,
                                    period,
                                    interval,
                                    repeatEndDate,
                                    daysOfWeek,
                                  ) {
                                    setState(() {
                                      _hasRepeat = hasRepeat;
                                      _repeatPeriod = period;
                                      _interval = interval;
                                      _repeatEndDate = repeatEndDate;
                                      _selectedDaysOfWeek = daysOfWeek;
                                    });
                                  },
                            );
                          }
                        },
                      ),

                      const Divider(color: Color(0xff2C2C2E), height: 1),

                      // 태그 (화살표 아이콘)
                      if (widget.type == TeeklePageType.addTodo || widget.type == TeeklePageType.editTodo)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          title: const Text(
                            '태그',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_selectedTag != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Text(
                                    _selectedTag!,
                                    style: const TextStyle(
                                      color: AppColors.TxtLight,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                          onTap: () async {
                            // 텍스트필드에 포커스가 있으면 실행 안 함
                            if (_titleFocusNode.hasFocus) {
                              return;
                            }
                            final pickedTag = await showTeekleTagSetting(
                              context,
                              currentTag: _selectedTag,
                            );
                            setState(() {
                              _selectedTag = pickedTag;
                            });
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                //삭제버튼
                if (widget.type == TeeklePageType.editTodo || widget.type == TeeklePageType.editWorkout)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.WarningRed,
                        padding: EdgeInsets.all(16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 92,
          decoration: BoxDecoration(
            color: _hasTitle ? AppColors.Green : AppColors.InactiveGreyBg,
          ),
          child: Center(
            child: Text(
              '저장하기',
              style: TextStyle(
                color: _hasTitle ? AppColors.TxtDark : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
