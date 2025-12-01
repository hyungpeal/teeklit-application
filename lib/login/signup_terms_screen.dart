import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/login/terms/terms_bottom_sheet.dart';
import 'package:teeklit/utils/fullscreen.dart';
import '../ui/core/themes/app_text.dart';
import '../ui/core/themes/colors.dart';

class SignupTermsScreen extends StatefulWidget {
  const SignupTermsScreen({super.key});

  @override
  State<SignupTermsScreen> createState() => _SignupTermsScreenState();
}

class _SignupTermsScreenState extends State<SignupTermsScreen> {
  bool agreeAll = false;
  bool agree1 = false; // 서비스 이용약관 (필수)
  bool agree2 = false; // 개인정보 처리방침 (필수)
  bool agree3 = false; // 마케팅 (선택)

  bool get isButtonEnabled => agree1 && agree2;

  @override
  void initState() {
    super.initState();
    Fullscreen.enable();
  }

  @override
  void dispose() {
    Fullscreen.disable();
    super.dispose();
  }

  /// 체크박스 + 보기 버튼 UI
  Widget _checkItemWithView({
    required String text,
    required bool checked,
    required VoidCallback onTap,
    required VoidCallback onViewTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Image.asset(
                checked
                    ? 'assets/images/green_check.png'
                    : 'assets/images/grey_check.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: AppText.Body1.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onViewTap,
          child: Text(
            "보기",
            style: AppText.Body2.copyWith(
              color: AppColors.green,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  /// 모드 동의 UI
  Widget _checkAllItem() {
    return InkWell(
      onTap: () {
        setState(() {
          agreeAll = !agreeAll;
          agree1 = agreeAll;
          agree2 = agreeAll;
          agree3 = agreeAll;
        });
      },
      child: Row(
        children: [
          Image.asset(
            agreeAll
                ? 'assets/images/green_check.png'
                : 'assets/images/grey_check.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          Text(
            "모두 동의하기",
            style: AppText.Body1.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (!agree1 || !agree2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("필수 약관에 동의해야 회원가입을 진행할 수 있습니다."),
        ),
      );
      return;
    }

    context.push('/signup-email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, size: 28, color: AppColors.strokeGray),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 80,
        child: ElevatedButton(
          onPressed: _onNextPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isButtonEnabled ? AppColors.green : AppColors.txtGray,
            elevation: 0,
          ),
          child: Text(
            "다음",
            style: AppText.Button.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "서비스 이용을 위한\n",
                    style: AppText.H1.copyWith(fontSize: 22, color: Colors.white),
                  ),
                  TextSpan(
                    text: "약관동의",
                    style: AppText.H1.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: "의 안내예요.",
                    style: AppText.H1.copyWith(fontSize: 22, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _checkAllItem(),
            const SizedBox(height: 16),

            // 서비스 이용약관 (필수)
            _checkItemWithView(
              text: "서비스 이용 약관 (필수)",
              checked: agree1,
              onTap: () {
                setState(() {
                  agree1 = !agree1;
                  if (!agree1) agreeAll = false;
                });
              },
              onViewTap: () async {
                final ok = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => TermsBottomSheet(
                    filePath: "assets/terms/service_terms.md",
                    title: "서비스 이용 약관",
                  ),
                );

                if (ok == true) {
                  setState(() => agree1 = true);
                }
              },
            ),

            const SizedBox(height: 12),

            // 개인정보 처리방침 (필수)
            _checkItemWithView(
              text: "개인정보 처리방침 (필수)",
              checked: agree2,
              onTap: () {
                setState(() {
                  agree2 = !agree2;
                  if (!agree2) agreeAll = false;
                });
              },
              onViewTap: () async {
                final ok = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => TermsBottomSheet(
                    filePath: "assets/terms/privacy_policy.md",
                    title: "개인정보 처리방침",
                  ),
                );

                if (ok == true) {
                  setState(() => agree2 = true);
                }
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
