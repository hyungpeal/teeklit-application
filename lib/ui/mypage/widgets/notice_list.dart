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
      title: '🌿 티클릿 첫 번째 공지사항',
      content:
      '안녕하세요, 티클릿 팀입니다.\n티클릿을 드디어 여러분께 소개할 수 있게 되어 정말 기쁩니다.\n\n티클릿은 ‘아주 작은 움직임이 큰 변화를 만든다’는 믿음에서 시작된 앱입니다.\n하루에 단 몇 분이라도 스스로에게 친절해지는 행동을 할 수 있다면,\n그게 결국 삶을 조금씩 바꾸는 힘이 되리라 믿습니다.\n\n여러분이 앱을 통해\- 작은 티클 하나를 실천하고\n- 혼자가 아니라는 느낌을 얻고\n- 안전하고 따뜻한 커뮤니티에서 위로받을 수 있다면\n그것만으로도 티클릿의 존재 이유가 충분합니다.\n\n지금은 아주 작은 출발이지만,\n여러분의 피드백을 바탕으로 꾸준히 성장하고 싶습니다.\n부족한 점이 있다면 언제든 편하게 알려주세요.\n\n티클릿은 여러분의 ‘작은 한 걸음’을 항상 응원합니다.\n함께 천천히, 그러나 꾸준히 나아가요.\n감사합니다 🌱\n',
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
