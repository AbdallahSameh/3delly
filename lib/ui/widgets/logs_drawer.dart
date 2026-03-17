import 'dart:convert';
import 'package:dominos_counter/models/log.dart';
import 'package:dominos_counter/ui/shared/golden_button.dart';
import 'package:flutter/material.dart';

class LogsDrawer extends StatelessWidget {
  List<String> logs;
  int score;
  final Function() onResetLogs;
  final Function() onResetScore;
  LogsDrawer({
    super.key,
    required this.logs,
    required this.score,
    required this.onResetLogs,
    required this.onResetScore,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/dark-brown-wood-texture-background-with-design-space(scaled_down).png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DrawerHeader(
              child: Text(
                'Logs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.separated(
                itemCount: logs.length,
                separatorBuilder: (index, context) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  Log item = Log.fromJson(jsonDecode(logs[index]));
                  return ListTile(
                    title: Text(
                      item.count.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '${item.time.hour % 12 == 0 ? 12 : item.time.hour % 12}:${item.time.minute.toString().padLeft(2, '0')} ${item.time.hour >= 12 ? 'PM' : 'AM'}',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  GoldenButton(
                    size: Size(0, 35),
                    onPressed: onResetLogs,
                    child: Text(
                      'Reset Logs',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GoldenButton(
                    size: Size(0, 35),
                    onPressed: onResetScore,
                    child: Text(
                      'Reset Score',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
