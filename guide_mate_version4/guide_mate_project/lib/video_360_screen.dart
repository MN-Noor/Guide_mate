import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_360/video_360.dart';
import 'guide_tts.dart';

class Video360Screen extends StatefulWidget {
  final String videoPath;
  final String location;

  const Video360Screen(
      {Key? key, required this.videoPath, required this.location})
      : super(key: key);

  @override
  _Video360ScreenState createState() => _Video360ScreenState();
}

class _Video360ScreenState extends State<Video360Screen> {
  final GuideTTS _guideTTS = GuideTTS();
  bool _isGuidePlaying = false;
  late Future<String> _videoUrlFuture;
  Video360Controller? _video360Controller;

  @override
  void initState() {
    super.initState();
    _videoUrlFuture = getVideoDownloadUrl(widget.videoPath);
  }

  @override
  void dispose() {
    _guideTTS.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('360 Video Player'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<String>(
              future: _videoUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                return Video360View(
                  url: snapshot.data!,
                  onVideo360ViewCreated: (controller) {
                    _video360Controller = controller;
                    controller.play();
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_guideTTS.ttsState == TtsState.paused) {
                        _resumeGuide();
                      } else if (!_isGuidePlaying) {
                        _startGuide();
                      } else {
                        _pauseGuide();
                      }
                    },
                    icon: Icon(_guideTTS.ttsState == TtsState.paused
                        ? Icons.play_arrow
                        : _isGuidePlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                    label: Text(_guideTTS.ttsState == TtsState.paused
                        ? 'Resume Guide'
                        : _isGuidePlaying
                            ? 'Pause Guide'
                            : 'Start Guide'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _stopGuide();
                    },
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Guide'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startGuide() {
    String city;

    switch (widget.location) {
      case 'HaLongBay':
        city = 'Vietnam';
        break;
      case 'Hagia Sophia Mosque':
        city = 'Istanbul';
        break;
      case 'Jheel Saif ul Malook':
        city = 'Naran';
        break;
      case 'Victoria Falls':
        city = 'Livingstone';
        break;
      case 'Taj Mahal Agra':
        city = 'Agra';
        break;
      default:
        city = 'Unknown';
    }
    _guideTTS.generateAndSpeakGuide(city);
    setState(() {
      _isGuidePlaying = true;
    });
  }

  void _pauseGuide() {
    _guideTTS.pause();
    setState(() {
      _isGuidePlaying = false;
    });
  }

  void _resumeGuide() {
    _guideTTS.resume();
    setState(() {
      _isGuidePlaying = true;
    });
  }

  void _stopGuide() {
    _guideTTS.stop();
    setState(() {
      _isGuidePlaying = false;
    });
  }

  Future<String> getVideoDownloadUrl(String gsUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      rethrow;
    }
  }
}
