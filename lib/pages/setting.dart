import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:app_installer/app_installer.dart';
import 'dart:io';
import '../units/units.dart';

class Setting extends StatelessWidget {
  Setting({super.key});
  Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    bool initExpandState =
        (context.watch<AppUpdate>().updataAppinfo?['updatestatus']) != 0
            ? true
            : false;
    String? downloadurl =
        context.watch<AppUpdate>().updataAppinfo?['downloadurl'];
    return Scaffold(
      appBar: AppBar(),
      body: ExpansionTile(
        leading: const Icon(
          Icons.system_security_update,
          color: Colors.blueAccent,
        ),
        title: const Center(
            child: Text('更新检查',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SmileySans',
                ))),
        backgroundColor: Colors.greenAccent,
        initiallyExpanded: initExpandState,
        children: [
          _builPanel(context),
          initExpandState
              ? ElevatedButton(
                  onPressed: () async {
                    context.read<AppUpdate>().downloadProgress(downloadurl!);
                    await _showDialog(context);
                  },
                  child: const Text('更新'),
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('返回'),
                ),
        ],
      ),
    );
  }
}

Widget _builPanel(BuildContext context) {
  return Column(
    children: [
      Text(context.watch<AppUpdate>().updataAppinfo?['version'] ?? 'version'),
      Text(context.watch<AppUpdate>().updataAppinfo?['versionName'] ??
          'versionName'),
      Text(context.watch<AppUpdate>().updataAppinfo?['content'] ?? 'content'),
      Text(
          (context.watch<AppUpdate>().updataAppinfo?['apksize'] ?? '0') + 'MB'),
    ],
  );
}

Future _showDialog(context) async {
  Directory? storageDir = await getExternalStorageDirectory();
  String? storagePath = storageDir!.path;
  String apkPath = '$storagePath/receipt.apk';
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: (context.watch<AppUpdate>().progressValue) == 1
              ? const Text('下载中......')
              : const Text('下载完成'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                  value: context.watch<AppUpdate>().progressValue,
                )
              ],
            ),
          ),
          actions: [
            (context.watch<AppUpdate>().progressValue) == 1
                ? ElevatedButton(
                    onPressed: () {
                      AppInstaller.installApk(apkPath);
                      Navigator.pop(context);
                    },
                    child: const Text('确认'))
                : ElevatedButton(
                    onPressed: () {
                      CancelToken().cancel('cancelled');
                      Navigator.pop(context);
                    },
                    child: const Text('取消'))
          ],
        );
      });
}
