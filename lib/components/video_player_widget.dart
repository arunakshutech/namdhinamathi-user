import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String videoUrl;
  final String? thumbnailUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final PodPlayerController controller;

    bool isLoading = true;
  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  void loadVideo() async {
    final urls = await PodPlayerController.getYoutubeUrls(widget.videoUrl
    );
    setState(() => isLoading = false);
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: urls!),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [360],
      ),
    )..initialise();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(child: PodVideoPlayer(controller: controller));
  }
}
