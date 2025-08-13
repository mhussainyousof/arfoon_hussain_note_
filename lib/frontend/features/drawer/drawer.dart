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
      //! SafeArea to avoid system UI overlaps
      child: SafeArea(
        child: Column(
          children: [
            //! Header section with app logo and name
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

            //! Drawer item for navigating to "All Notes"
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
              onTap: () {},  //! Navigation handler placeholder
            ),

            //! Section title for labels
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

            //! List of user-defined labels with edit and select functionality
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
                      onPressed: () {},  //! Edit label handler placeholder
                    ),
                    onTap: () {},  //! Select label handler placeholder
                  );
                },
              ),
            ),

            //! Bottom section with label adding and settings options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  //! Button to add a new label - opens dialog
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

                                //! Buttons for deleting or saving the label
                                dialogButtons(
                                  isTextButton: true,
                                  elevatedButtonOnpressed: () {},
                                  textButtonText: 'Delete',
                                  elevatedButtonText: 'Save Label',
                                  textButtonOnpressed: () {
                                    //! Confirmation dialog for delete
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

                                        //! Cancel and Delete buttons in confirmation dialog
                                        dialogButtons(
                                          isTextButton: true,
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

                  //! Settings button - opens settings dialog
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

            //! User info footer with initials, name, greeting, and a menu icon
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

                  //! User name and greeting text
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

                  //! Icon button for expanding additional options (functionality TBD)
                  IconButton(
                    icon: const Icon(Icons.unfold_more),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
