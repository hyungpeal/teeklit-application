import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teeklit/config/colors.dart';
import 'package:teeklit/ui/community/widgets/community_custom_buttons.dart';

class ViewAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ViewAppBar({super.key});

  @override
  State<ViewAppBar> createState() => _ViewAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ViewAppBarState extends State<ViewAppBar> {
  Future<void> _openModal() async {
    await showModalBottomSheet<String>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      backgroundColor: AppColors.Bg,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.TxtGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '신고',
                      style: TextStyle(
                        color: AppColors.Ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () {},
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.TxtGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '차단',
                      style: TextStyle(
                        color: AppColors.Ivory,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    callback: () {},
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.WarningRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: CustomTextButton(
                    buttonText: Text(
                      '취소',
                      style: TextStyle(
                        color: AppColors.Ivory,
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
      backgroundColor: AppColors.Bg,
      leading: IconButton(
        onPressed: () {
          GoRouter.of(context).pop();
        },
        icon: Icon(Icons.chevron_left, color: AppColors.TxtGrey),
      ),
      actions: [
        CustomIconButton(
          buttonIcon: Icon(
            Icons.more_vert,
            size: 24,
            color: AppColors.TxtGrey,
          ),
          callback: _openModal,
        ),
      ],
      shape: Border(bottom: BorderSide(color: AppColors.TxtLight, width: 0.5)),
    );
  }
}
