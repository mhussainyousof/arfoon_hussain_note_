import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? textNaighbor;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onMenuPressed;
  final String title;

  const HomeAppBar({
    super.key,
    this.leading,
    this.textNaighbor,
    this.trailing,
    this.onMenuPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: InkWell(
        onTap: () {
          if (kDebugMode) {
            Navigator.maybePop(context);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (textNaighbor != null) ...[
              textNaighbor!,
              const SizedBox(width: 4),
            ],
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      centerTitle: true,
      leading: leading,
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
