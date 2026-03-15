import 'dart:convert';
import 'package:dominos_counter/models/log.dart';
import 'package:dominos_counter/services/storage_service.dart';
import 'package:flutter/material.dart';

class LogsDrawer extends StatefulWidget {
  final StorageService storageService;
  List<String> logs;
  int score;
  LogsDrawer({
    super.key,
    required this.storageService,
    required this.logs,
    required this.score,
  });

  @override
  State<LogsDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<LogsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text('Logs')),
          Expanded(
            child: ListView.separated(
              itemCount: widget.logs.length,
              separatorBuilder: (index, context) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                Log item = Log.fromJson(jsonDecode(widget.logs[index]));
                return ListTile(
                  title: Text(item.count.toString()),
                  trailing: Text(
                    '${((item.time.hour) - 12).abs().toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}',
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.storageService.saveLogs([]);
              setState(() {
                widget.logs = widget.storageService.getLogs();
              });
            },
            child: Text('Reset Logs'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.storageService.saveScore(0);
              setState(() {
                widget.score = widget.storageService.getScore();
              });
            },
            child: Text('Reset Score'),
          ),
        ],
      ),
    );
  }
}
