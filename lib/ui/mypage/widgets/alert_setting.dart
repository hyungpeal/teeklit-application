import 'package:flutter/material.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class AlertSettingScreen extends StatefulWidget {
  const AlertSettingScreen({super.key});

  @override
  State<AlertSettingScreen> createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  bool globalNotification = true;
  bool communityNotification = false;
  bool teekleBefore5Min = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '알림 설정',
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

          Container(
            decoration: const BoxDecoration(
            ),
            child: Column(
              children: [
                _SettingRow(
                  title: '전체 알림',
                  value: globalNotification,
                  onChanged: (v) {
                    setState(() => globalNotification = v);
                  },
                ),
                const Divider(color: Color(0xff2C2C2E), height: 1),
                _SettingRow(
                  title: '커뮤니티 알림',
                  value: communityNotification,
                  onChanged: (v) {
                    setState(() => communityNotification = v);
                  },
                ),
                const Divider(color: Color(0xff2C2C2E), height: 1),
                _SettingRow(
                  title: '티클 5분 전 알림',
                  value: teekleBefore5Min,
                  onChanged: (v) {
                    setState(() => teekleBefore5Min = v);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xffB1C39F),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }
}
