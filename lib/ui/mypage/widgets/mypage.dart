import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/mypage/widgets/alert_setting.dart';
import 'package:teeklit/ui/mypage/widgets/public_data_source.dart';
import 'package:teeklit/ui/teekle/providers/teekle_stats_provider.dart';

import '../../core/providers/user_provider.dart';
import 'account_setting.dart';
import 'notice_list.dart';
import 'profile_edit.dart';
import 'terms_policy.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const background = AppColors.bg; // 전체 배경색
    const cardGreen = AppColors.green; // 프로필 카드 색

    final teekleProvider = context.watch<TeekleStatsProvider>();
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    final imageUrl = profile?.profileImage;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              /// 프로필 카드
              _ProfileCard(
                cardColor: cardGreen,
                nickname: profile?.nickname ?? '사용자',
                imageUrl: profile?.profileImage,
                streakDays: teekleProvider.streakDays,
                remainingMoves: teekleProvider.remainingCount,
                completedMoves: teekleProvider.doneCount,
                onEdit: () {
                  context.push('/profile-edit');
                }
              ),
              const SizedBox(height: 32),

              /// 메뉴 – 북마크 / 커뮤니티
              // _MenuItem(
              //   title: '북마크',
              //   onTap: () {},
              // ),
              // _MenuItem(
              //   title: '커뮤니티',
              //   onTap: () {},
              // ),
              const SizedBox(height: 24),

              /// 설정 섹션
              const _SectionTitle('설정'),
              const SizedBox(height: 8),
              _MenuItem(
                title: '알림 설정',
                onTap: () {
                  context.push('/alert-setting');
                },
              ),
              _MenuItem(
                title: '계정 설정',
                onTap: () {
                  context.push('/account-setting');
                },
              ),

              const SizedBox(height: 24),

              /// 앱 정보 섹션
              const _SectionTitle('앱 정보'),
              const SizedBox(height: 8),

              _VersionItem(
                title: '버전 정보',
                latestVersion: '1.0.0',
                currentVersion: '1.0.0',
                onTap: () {},
              ),
              _MenuItem(
                title: '공지사항',
                onTap: () {
                  context.push('/notice-list');
                },
              ),
              _MenuItem(
                title: '약관 및 정책',
                onTap: () {
                  context.push('/terms-policy');
                },
              ),
              _MenuItem(
                title: '공공데이터 출처',
                onTap: () {
                  context.push('/public-data-source');;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 프로필 카드 위젯
class _ProfileCard extends StatelessWidget {
  final Color cardColor;
  final String nickname;
  final String? imageUrl;
  final int streakDays;
  final int remainingMoves;
  final int completedMoves;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.cardColor,
    required this.nickname,
    required this.streakDays,
    required this.remainingMoves,
    required this.completedMoves,
    required this.onEdit,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.25),
                backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? NetworkImage(imageUrl!)
                    : null,
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? Image.asset('assets/images/default_profile.png')
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  nickname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  '수정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          /// 하단 - 통계 3개
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: '연속 달성',
                value: '$streakDays',
                unit: '일째',
              ),
              _StatItem(
                label: '남은 티클',
                value: '$remainingMoves',
                unit: '개',
              ),
              _StatItem(
                label: '완료 티클',
                value: '$completedMoves',
                unit: '개',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withOpacity(0.55),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 섹션 타이틀 (“설정”, “앱 정보” 등)
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// 일반 메뉴 아이템
class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionItem extends StatelessWidget {
  final String title;
  final String latestVersion;
  final String currentVersion;
  final VoidCallback? onTap;

  const _VersionItem({
    required this.title,
    required this.latestVersion,
    required this.currentVersion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '최신버전: $latestVersion',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              currentVersion,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
