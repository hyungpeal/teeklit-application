import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/domain/model/community/report.dart';
import 'package:teeklit/ui/core/themes/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class ViewAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Future<void> Function() blockUser;
  final Future<bool> Function(String, String, String) reportPost;
  final Future<void> Function() hidePost;
  final Future<void> Function() deletePost;
  final String postId;
  final String myId;
  final String postHost;
  final bool isAdmin;

  const ViewAppBar({
    super.key,
    required this.blockUser,
    required this.reportPost,
    required this.postId,
    required this.myId,
    required this.isAdmin,
    required this.hidePost,
    required this.postHost,
    required this.deletePost,
  });

  @override
  State<ViewAppBar> createState() => _ViewAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ViewAppBarState extends State<ViewAppBar> {
  Future<void> _openModal() async {
    await showModalBottomSheet<String>(
      useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColors.bg,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20, left: 20, top: 20, right: 20),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.myId != widget.postHost) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '신고',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.reportPost(
                          widget.postId,
                          TargetType.post.value,
                          widget.myId,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                if (widget.myId != widget.postHost) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '차단',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.blockUser();
                        Navigator.pop(context);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.go('/community/');
                        });
                      },
                    ),
                  ),
                ],
                if (widget.isAdmin) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '숨기기',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.hidePost();
                        Navigator.pop(context);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.go('/community/');
                        });
                      },
                    ),
                  ),
                ],
                if (widget.myId == widget.postHost) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '수정하기',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () {
                        Navigator.pop(context);
                        context.push('/community/modify');
                      },
                    ),
                  ),
                ],
                if (widget.postHost == widget.myId) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.txtGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    child: CustomTextButton(
                      buttonText: Text(
                        '삭제',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      callback: () async {
                        await widget.deletePost();

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.go('/community/');
                        });
                      },
                    ),
                  ),
                ],
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.warningRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '취소',
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      leading: IconButton(
        onPressed: () {
          context.pop(context);
        },
        icon: Icon(Icons.chevron_left, color: AppColors.txtGray),
      ),
      actions: [
        CustomIconButton(
          buttonIcon: Icon(
            Icons.more_vert,
            size: 24,
            color: AppColors.txtGray,
          ),
          callback: _openModal,
        ),
      ],
      shape: Border(bottom: BorderSide(color: AppColors.txtLight, width: 0.5)),
    );
  }
}
