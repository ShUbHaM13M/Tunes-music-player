import 'package:flutter/material.dart';
import 'package:tunes/utils/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DarkModeSwitch(),
              const Divider(color: Colors.white60),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "About Tunes",
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const Text(
                "Version",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "V-1.0.1",
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 160.0),
            child: Column(
              children: [
                const Divider(color: Colors.white60),
                Text(
                  "Made with ❤ using Flutter",
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dark mode",
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
        Switch.adaptive(
          value: true,
          onChanged: null,
          inactiveTrackColor: Colors.white12,
          inactiveThumbColor: primaryDark.withOpacity(0.4),
        )
      ],
    );
  }
}
