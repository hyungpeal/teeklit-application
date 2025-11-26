import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:teeklit/ui/core/themes/colors.dart';

class TermsBottomSheet extends StatefulWidget {
  final String filePath;
  final String title;

  const TermsBottomSheet({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  State<TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<TermsBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  String content = "";
  bool isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _loadFile();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!isScrolledToEnd) {
          setState(() => isScrolledToEnd = true);
        }
      }
    });
  }

  Future<void> _loadFile() async {
    final data = await rootBundle.loadString(widget.filePath);
    setState(() {
      content = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bottomSheetBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              /// ────────────────
              /// 타이틀 + X 버튼
              /// ────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// ────────────────
              /// 본문
              /// ────────────────
              Expanded(
                child: content.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Markdown(
                  controller: _scrollController,
                  data: content,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: Colors.white, fontSize: 14),
                    h1: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    h2: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ────────────────
              /// 확인(동의) 버튼
              /// ────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isScrolledToEnd
                      ? () => Navigator.pop(context, true)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isScrolledToEnd
                        ? AppColors.darkGreen
                        : AppColors.inactiveGrayBg,
                    elevation: 0,
                  ),
                  child: Text(
                    isScrolledToEnd
                        ? "동의"
                        : "약관 내용을 모두 확인해주세요",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
