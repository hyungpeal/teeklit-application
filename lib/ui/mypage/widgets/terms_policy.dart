import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

import 'terms_detail.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '약관 및 정책',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(color: Color(0xff2C2C2E), height: 1),

          _TermsItem(
            title: '서비스 이용약관',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsDetailScreen(
                    title: '서비스 이용약관',
                    fileName: 'terms_service.txt',
                  ),
                ),
              );
            },
          ),

          const Divider(color: Color(0xff2C2C2E), height: 1),

          _TermsItem(
            title: '운영정책',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsDetailScreen(
                    title: '운영정책',
                    fileName: 'terms_operation.txt',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TermsItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TermsItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }
}
