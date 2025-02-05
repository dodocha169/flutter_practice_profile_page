import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: theme.primaryIconTheme,
          backgroundColor: theme.primaryColor,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(110, 0, 30, 0),
            child: Text(
              style: theme.primaryTextTheme.titleLarge,
              'Profile Page',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        backgroundColor: Colors.grey.shade300,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(140),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/74857462?v=4'),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: Text('dodocha169',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.github,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black87),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        )),
                    label: Text('GitHub',
                        style: theme.primaryTextTheme.labelLarge),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue.shade600),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                    ),
                    label: Text(
                      style: theme.primaryTextTheme.labelLarge,
                      "Twitter",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
