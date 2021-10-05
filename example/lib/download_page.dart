import 'package:example/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DownloadPage extends StatelessWidget {
  final Stream<FileResponse>? fileStream;
  final VoidCallback? downloadFile;
  final VoidCallback? clearCache;
  const DownloadPage(
      {Key? key,
      required this.fileStream,
      required this.downloadFile,
      this.clearCache})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FileResponse>(
      stream: fileStream,
      builder: (context, snapshot) {
        print(snapshot);
        Widget body;

        var loading = !snapshot.hasData || snapshot.data is DownloadProgress;

        if (snapshot.hasError) {
          body = ListTile(
            title: const Text('Error'),
            subtitle: Text(snapshot.error.toString()),
          );
        } else if (loading) {
          body = ProgressIndicator(progress: snapshot.data as DownloadProgress);
        } else {
          body = FileInfoWidget(
            fileInfo: snapshot.data as FileInfo,
            clearCache: clearCache!,
          );
        }

        return Scaffold(
          appBar: _appBar(),
          body: body,
          floatingActionButton:
              !loading ? Fab(downloadFile: downloadFile!) : null,
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Flutter Cache Manager Demo'),
    );
  }
}



class ProgressIndicator extends StatelessWidget {
  final DownloadProgress? progress;
  const ProgressIndicator({Key? key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              value: progress?.progress,
            ),
          ),
          const SizedBox(width: 20.0),
          const Text('Downloading'),
        ],
      ),
    );
  }
}

class FileInfoWidget extends StatelessWidget {
  final FileInfo? fileInfo;
  final VoidCallback? clearCache;

  const FileInfoWidget({Key? key, this.fileInfo, this.clearCache})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Original URL'),
          subtitle: Text(fileInfo!.originalUrl),
        ),
        if (fileInfo?.file != null)
          ListTile(
            title: const Text('Local file path'),
            subtitle: Text(fileInfo!.file.path),
          ),
        ListTile(
          title: const Text('Loaded from'),
          subtitle: Text(fileInfo!.source.toString()),
        ),
        ListTile(
          title: const Text('Valid Until'),
          subtitle: Text(fileInfo!.validTill.toIso8601String()),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            child: const Text('CLEAR CACHE'),
            onPressed: clearCache,
          ),
        ),
      ],
    );
  }
}
