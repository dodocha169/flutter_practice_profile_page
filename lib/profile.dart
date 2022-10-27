import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'settings.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(110, 0, 0, 0),
            child: Text('Profile Page'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) => Settings()),
                );
                },
            ),
            const SizedBox(
                width: 24),
          ],
        ),
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
                      color: Colors.grey.withOpacity(0.5),
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
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold)
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.black87),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20),
                        )
                    ),
                    label: const Text('GitHub'),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                    onPressed: () {},
                    style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade600),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20),
                      ),
                    ),
                    label: const Text(
                      "Twitter",
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
