import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:teeklit/utils/scroll_gradient_overlay.dart';
import 'package:teeklit/utils/colors.dart';
import 'bottom_sheet_header.dart';

enum SettingMode { select, edit, add }

Future<String?> showTeekleTagSetting(
  BuildContext context, {
  String? pickedTag,
}) async {
  String? lastSelectedTag = pickedTag;

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.BottomSheetBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => TagBottomSheet(
      initialTag: pickedTag,
      onTagChanged: (tag) {
        lastSelectedTag = tag;
      },
    ),
  );
  print('selectedTag in showTeekleTagSetting : ${lastSelectedTag}');
  return result ?? lastSelectedTag;
}

class TagBottomSheet extends StatefulWidget {
  final String? initialTag;
  final ValueChanged<String?>? onTagChanged;

  const TagBottomSheet({super.key, this.initialTag, this.onTagChanged});

  @override
  State<TagBottomSheet> createState() => _TagBottomSheetState();
}

class _TagBottomSheetState extends State<TagBottomSheet> {
  String? _selectedTag;
  final ScrollController _scrollController = ScrollController();
  bool _showTopGradient = false;
  SettingMode settingMode = SettingMode.select;

  /// 태그 리스트를 부모의 상태 변수로 중앙 관리합니다.
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _selectedTag = widget.initialTag;
    print('TagBottomSheet initState: $_selectedTag');

    _scrollController.addListener(_onScroll);
    _tags = List.from(dummyTags);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showGradient = _scrollController.position.pixels > 0;
    if (showGradient != _showTopGradient) {
      setState(() {
        _showTopGradient = showGradient;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (settingMode == SettingMode.add) {
      return PopScope(
        canPop: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TeekleBottomSheetHeader(
                title: "태그 추가하기",
                showLeading: true,
                onLeadingTap: () {
                  setState(() {
                    settingMode = SettingMode.edit;
                  });
                },
                onClose: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              TagAdd(
                onAdd: (newTag) {
                  setState(() {
                    _tags.add(newTag);
                    settingMode = SettingMode.edit;
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return PopScope(
        canPop: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.45,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (settingMode == SettingMode.select)
                  TeekleBottomSheetHeader(
                    title: "태그",
                    showEdit: true,
                    onEditTap: () {
                      setState(() {
                        settingMode = SettingMode.edit;
                      });
                    },
                    onClose: () => Navigator.pop(context, _selectedTag),
                  )
                else if (settingMode == SettingMode.edit)
                  TeekleBottomSheetHeader(
                    title: "태그 편집하기",
                    showLeading: true,
                    onLeadingTap: () {
                      setState(() {
                        settingMode = SettingMode.select;
                      });
                    },
                    onClose: () => Navigator.pop(context),
                  ),
                const SizedBox(height: 20),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (settingMode == SettingMode.select) {
                        return TagSelect(
                          tags: _tags, // 상태 리스트 전달
                          scrollController: _scrollController,
                          selectedTag: _selectedTag,
                          showTopGradient: _showTopGradient,
                          onTagTap: (tag) {
                            setState(() {
                              _selectedTag = (_selectedTag == tag) ? null : tag;
                            });
                            widget.onTagChanged?.call(_selectedTag);
                          },
                        );
                      } else if (settingMode == SettingMode.edit) {
                        return TagEdit(
                          tags: _tags, // 상태 리스트 전달
                          scrollController: _scrollController,
                          showTopGradient: _showTopGradient,
                          onAddPressed: () {
                            setState(() {
                              settingMode = SettingMode.add;
                            });
                          },
                          onDelete: (tagToDelete) {
                            setState(() {
                              _tags.remove(tagToDelete);
                            });
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TagSelect extends StatelessWidget {
  final List<String> tags;
  final ScrollController scrollController;
  final String? selectedTag;
  final bool showTopGradient;
  final ValueChanged<String> onTagTap;

  const TagSelect({
    super.key,
    required this.tags,
    required this.scrollController,
    required this.selectedTag,
    required this.showTopGradient,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            final isSelected = selectedTag == tag;
            return Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                title: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? AppColors.TxtDark : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tileColor: isSelected ? AppColors.Green : AppColors.StrokeGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onTap: () => onTagTap(tag),
              ),
            );
          },
        ),
        Visibility(
          visible: showTopGradient,
          child: const ScrollGradientOverlay(
            gradientColor: AppColors.BottomSheetBg,
            direction: GradientDirection.top,
          ),
        ),
        const ScrollGradientOverlay(
          gradientColor: AppColors.BottomSheetBg,
          direction: GradientDirection.bottom,
        ),
      ],
    );
  }
}

class TagEdit extends StatelessWidget {
  final List<String> tags;
  final ScrollController scrollController;
  final bool showTopGradient;
  final VoidCallback onAddPressed;
  final ValueChanged<String> onDelete;

  const TagEdit({
    super.key,
    required this.tags,
    required this.scrollController,
    required this.showTopGradient,
    required this.onAddPressed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            final tag = tags[index];
            return Card(
              elevation: 0,
              color: Colors.transparent,
              margin: const EdgeInsets.only(bottom: 10.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Slidable(
                /// 리스트에 고유 키를 부여 -> 삭제가 되어도 다음 리스트가 삭제된 ListView 상태를 물려받지 안도록 설정
                key: ValueKey(tag),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => onDelete(tag), // 콜백 호출
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.WarningRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  title: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  tileColor: AppColors.StrokeGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.DarkGreen, width: 1),
                  ),
                ),
              ),
            );
          },
        ),
        Visibility(
          visible: showTopGradient,
          child: const ScrollGradientOverlay(
            gradientColor: AppColors.BottomSheetBg,
            direction: GradientDirection.top,
          ),
        ),
        const ScrollGradientOverlay(
          gradientColor: AppColors.BottomSheetBg,
          direction: GradientDirection.bottom,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.Green,
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class TagAdd extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const TagAdd({super.key, required this.onAdd});

  @override
  State<TagAdd> createState() => _TagAddState();
}

class _TagAddState extends State<TagAdd> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '태그 이름',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller, // 컨트롤러 연결
            keyboardType: TextInputType.multiline,
            cursorColor: AppColors.Green,
            style: const TextStyle(color: Colors.white),
            autofocus: false,
            decoration: InputDecoration(
              hintText: '태그 이름을 입력해주세요.',
              hintStyle: const TextStyle(color: Color(0xff8E8E93)),
              filled: true,
              fillColor: const Color(0xff3A3A3C),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final newTag = _controller.text.trim();
                if (newTag.isNotEmpty) {
                  widget.onAdd(newTag); // 콜백 호출
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.Green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: const Text('저장', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

final List<String> dummyTags = [
  '운동하기 🏋',
  '집안일 🧼',
  '습관',
  '공부하기',
  '독서',
  '건강 관리',
  '운동하기 🏋',
  '집안일 🧼',
  '습관',
  '공부하기',
  '독서',
  '건강 관리',
];
