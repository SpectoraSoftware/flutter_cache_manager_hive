/// Flutter Cache Manager (Example App)
/// Copyright (c) 2019 Rene Floor
/// Released under MIT License.

import 'package:example/download_page.dart';
import 'package:example/fab.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager_hive/flutter_cache_manager_hive.dart';

void main() {
  Hive.initFlutter();
  Hive.registerAdapter(CacheObjectAdapter(typeId: 1));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cache Manager Demo',
      home: MyHomePage(),
    );
  }
}

const CACHE_BOX_NAME = 'image-cache-box';
const url = 'https://blurha.sh/assets/images/img1.jpg';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<FileResponse>? fileStream;

  Future<void> createFileStream() async {
    var result = HiveCacheManager(box: Hive.openBox(CACHE_BOX_NAME))
        .getFileStream(url, withProgress: true);
    setState(() {
      fileStream = result;
    });
  }

  void _downloadFile() {
    createFileStream().then(
      (_) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DownloadPage(
            fileStream: fileStream,
            downloadFile: _downloadFile,
            clearCache: _clearCache,
          ),
        ),
      ),
    );
  }

  void _clearCache() {
    HiveCacheManager(box: Hive.openBox(CACHE_BOX_NAME)).emptyCache();
    setState(() {
      fileStream = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const ListTile(
          title: Text('Tap the floating action button to download.')),
      floatingActionButton: Fab(
        downloadFile: _downloadFile,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Flutter Cache Manager Demo'),
    );
  }
}
