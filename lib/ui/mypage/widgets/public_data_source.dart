import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class PublicDataSourceScreen extends StatelessWidget {
  const PublicDataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          '공공 데이터 출처',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '티클릿은 아래 공공데이터를 활용합니다.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            /// 1개 데이터셋 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff3A3A3C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoItem(
                    label: '데이터셋 이름',
                    value: '국민체력100 동영상 정보',
                  ),
                  SizedBox(height: 16),
                  _InfoItem(
                    label: '제공기관',
                    value: '국민체육진흥공단(KSPO)',
                  ),
                  SizedBox(height: 16),
                  _InfoItem(
                    label: '활용 목적',
                    value:
                    '사용자 운동 루틴 제공 및 운동 동작에 대한 가이드 제공',
                  ),
                  SizedBox(height: 16),
                  _InfoItem(
                    label: '라이선스(공공누리)',
                    value: '공공누리 제1유형(출처표시)',
                  ),
                  SizedBox(height: 16),
                  _InfoItem(
                    label: '자세히 보기',
                    value:
                    'https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15085751',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
