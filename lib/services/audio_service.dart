import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

class AudioService {
  static Future<String?> getStreamUrl(String audioUrl) async {
    String? url;
    final client = SoundcloudClient();
    final track = await client.tracks.getByUrl(audioUrl);
    final streams = await client.tracks.getStreams(track.id);
    final stream = streams.firstWhere((s) => s.container == Container.mp3);
    url = stream.url;
    return url;
  }
}