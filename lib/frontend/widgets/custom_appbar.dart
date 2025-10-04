import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingTitleWidget;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onMenuPressed;
  final String title;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;
  final double? titleSize;
  final FontWeight? titleFontWeight;
  final bool? isLocalTitle;

  const CustomAppBar({
    super.key,
    this.titleFontWeight,
    this.centerTitle = true,
    this.titleSize,
    this.leading,
    this.leadingTitleWidget,
    this.trailing,
    this.onMenuPressed,
    required this.title, this.bottom,  this.isLocalTitle = true,

  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      title:  InkWell(
        onTap: () {
          if (kDebugMode) {
            Navigator.maybePop(context);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingTitleWidget != null) ...[
              leadingTitleWidget!,
              const SizedBox(width: 4),
            ],
            Flexible(
              child: isLocalTitle! ? LocaleText(
                title,
                style:  TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: titleSize ?? 16,
                  fontWeight: titleFontWeight
                ),
              ) : Text(
                 title,
                style:  TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: titleSize ?? 16,
                  fontWeight: titleFontWeight
                ),
              )
            ),
          ],
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
