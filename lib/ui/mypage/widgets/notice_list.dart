import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import '../../../domain/model/user/notice.dart';
import 'notice_detail.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  List<Notice> get _dummyNotices => List.generate(
    1,
        (i) => Notice(
      id: 'n$i',
      title: '11월 25일 업데이트 알림',
      content:
      '업데이트 알림 입니다.',
      date: DateTime(2025, 11, 25),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final notices = _dummyNotices;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '공지사항',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: notices.length,
        separatorBuilder: (_, __) =>
        const Divider(color: Color(0xff2C2C2E), height: 1),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoticeDetailScreen(notice: notice),
                ),
              );
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notice.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('yyyy.MM.dd').format(notice.date),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
