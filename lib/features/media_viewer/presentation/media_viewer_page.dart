import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/file_formatters.dart';
import '../../../../shared/widgets/bounded_text.dart';
import '../../file_manager/domain/entities/file_item.dart';

class MediaViewerPage extends StatelessWidget {
  const MediaViewerPage({super.key, required this.item});

  final FileItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: BoundedText(item.name, maxLines: 1)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BoundedText(item.mimeType, icon: Icons.category_rounded),
                BoundedText(
                  formatBytes(item.size),
                  icon: Icons.storage_rounded,
                ),
                BoundedText(
                  formatDate(item.modified),
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ),
          Expanded(child: _viewerFor(item)),
        ],
      ),
    );
  }

  Widget _viewerFor(FileItem item) {
    switch (item.category) {
      case FileCategory.image:
        return PhotoView(
          imageProvider: FileImage(File(item.path)),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        );
      case FileCategory.video:
        return _VideoViewer(path: item.path);
      case FileCategory.audio:
        return _AudioViewer(path: item.path, name: item.name);
      case FileCategory.pdf:
        return SfPdfViewer.file(File(item.path));
      case FileCategory.apk:
        return _InfoViewer(
          icon: Icons.android_rounded,
          title: 'APK package',
          detail:
              'Install otomatis tidak dijalankan. File ini hanya ditampilkan sebagai metadata.',
        );
      default:
        return _InfoViewer(
          icon: Icons.insert_drive_file_rounded,
          title: 'Preview tidak tersedia',
          detail:
              'File tetap bisa dikelola, dibagikan, dipindahkan, disalin, atau dihapus.',
        );
    }
  }
}

class _VideoViewer extends StatefulWidget {
  const _VideoViewer({required this.path});

  final String path;

  @override
  State<_VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<_VideoViewer> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            icon: Icon(
              _controller.value.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
            ),
            label: Text(_controller.value.isPlaying ? 'Pause' : 'Play'),
          ),
        ),
      ],
    );
  }
}

class _AudioViewer extends StatefulWidget {
  const _AudioViewer({required this.path, required this.name});

  final String path;
  final String name;

  @override
  State<_AudioViewer> createState() => _AudioViewerState();
}

class _AudioViewerState extends State<_AudioViewer> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.graphic_eq_rounded, size: 72),
              const SizedBox(height: 12),
              BoundedText(widget.name, maxLines: 2),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  if (_playing) {
                    await _player.pause();
                  } else {
                    await _player.play(DeviceFileSource(widget.path));
                  }
                  setState(() => _playing = !_playing);
                },
                icon: Icon(
                  _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(_playing ? 'Pause audio' : 'Play audio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoViewer extends StatelessWidget {
  const _InfoViewer({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72),
              const SizedBox(height: 12),
              BoundedText(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              BoundedText(detail, maxLines: 4),
            ],
          ),
        ),
      ),
    );
  }
}
