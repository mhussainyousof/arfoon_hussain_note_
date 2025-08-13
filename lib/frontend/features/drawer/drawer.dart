import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../widgets/widget.dart';
import '../features.dart';

class CustomDrawer extends StatelessWidget {
  final List<String> labels;
  final String userName;
  final String userGreeting;

  const CustomDrawer({
    super.key,
    required this.labels,
    required this.userName,
    required this.userGreeting,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/note_logo.svg',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arfoon Note',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Think. Note. Achieve.',
                        style:
                            TextStyle(fontSize: 12, color: Color(0XFF71717A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // All Notes item
            ListTile(
              horizontalTitleGap: 6,
              leading: SvgPicture.asset(
                'assets/images/all_notes.svg',
                width: 24,
                height: 24,
              ),
              title: const Text(
                'All Notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Labels',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0XFF71717A),
                  ),
                ),
              ),
            ),

            // Labels list
            Expanded(
              child: ListView.builder(
                itemCount: labels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    horizontalTitleGap: 6,
                    leading: SvgPicture.asset('assets/images/label.svg',
                        width: 24, height: 24),
                    title: Text(labels[index],
                        style: const TextStyle(
                            fontSize: 14, color: Color(0XFF73737E))),
                    trailing: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/edit.svg',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {},
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    horizontalTitleGap: 6,
                    leading: SvgPicture.asset('assets/images/Vector.svg',
                        width: 24, height: 24),
                    title:
                        const Text('Add Label', style: TextStyle(fontSize: 14)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NoteDialog(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'New Label',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Label Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                const NoteTextField(
                                  hintText: 'A creative label name',
                                ),
                                const SizedBox(height: 40),
                                dialogButtons(
                                  elevatedButtonOnpressed: () {},
                                  textButtonText: 'Delete',
                                  elevatedButtonText: 'Save Label',
                                  textButtonOnpressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          NoteDialog(children: [
                                        const Text(
                                          'Are you sure want to Delete?',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                            'Once Deleted a label cannot be undo, are you sure want to Delete?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 25),
                                        dialogButtons(
                                            textButtonElevation: 0,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            width: 15,
                                            elevatedButtonOnpressed: () {},
                                            textButtonText: 'Cancel',
                                            elevatedButtonText: 'Delete It.')
                                      ]),
                                    );
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
                  ListTile(
                    horizontalTitleGap: 6,
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                    title:
                        const Text('Settings', style: TextStyle(fontSize: 14)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SettingDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      userName.trim().isNotEmpty
                          ? userName
                              .trim()
                              .split(' ')
                              .where((part) => part.isNotEmpty)
                              .map((part) => part[0].toUpperCase())
                              .take(2)
                              .join('')
                          : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userGreeting,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.unfold_more),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
