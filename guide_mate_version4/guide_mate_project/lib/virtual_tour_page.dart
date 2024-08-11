import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'video_360_screen.dart';

class VirtualTourPage extends StatefulWidget {
  const VirtualTourPage({super.key});

  @override
  _VirtualTourPageState createState() => _VirtualTourPageState();
}

class _VirtualTourPageState extends State<VirtualTourPage> {
  String _selectedLocation = 'Select Location';
  final List<String> _locations = [
    'Select Location',
    'HaLongBay',
    'Hagia Sophia Mosque',
    'Jheel Saif ul Malook',
    'Victoria Falls',
    'Taj Mahal Agra'
  ];
  String? _videoPath;

  @override
  void dispose() {
    super.dispose();
  }

  void _startVirtualTour() async {
    if (_selectedLocation != 'Select Location') {
      String videoPath = await _loadVideoForLocation(_selectedLocation);
      setState(() {
        _videoPath = videoPath;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Video360Screen(
              videoPath: _videoPath!, location: _selectedLocation),
        ),
      );
    } else {
      print("No location selected");
    }
  }

  Future<String> _loadVideoForLocation(String location) async {
    try {
      // Construct Firebase Storage reference
      String videoFileName =
      _getVideoFileName(location); // Get video file name based on location
      final ref = FirebaseStorage.instance.ref('3d videos/$videoFileName');

      // Get download URL for the video
      String downloadUrl = await ref.getDownloadURL();
      print("Download URL for $location: $downloadUrl");

      return downloadUrl; // Return the download URL of the video
    } catch (e) {
      print('Error getting download URL: $e');
      // Handle error gracefully, possibly show a message to the user
      rethrow;
    }
  }

  // Helper function to get video file name based on location
  String _getVideoFileName(String location) {
    switch (location) {
      case 'HaLongBay':
        return 'HaLongBayProject.mp4';
      case 'Hagia Sophia Mosque':
        return 'HagiaSophiaProject_injected.mp4';
      case 'Jheel Saif ul Malook':
        return 'JheelSaifulMalookvid_injected.mp4';
      case 'Victoria Falls':
        return 'victoriafallsvid_injected.mp4';
      case 'Taj Mahal Agra':
        return 'Tajmahalvid_injected.mp4';
      default:
        return 'HaLongBayProject.mp4';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items:
                _locations.map<DropdownMenuItem<String>>((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startVirtualTour,
                child: const Text('Start Virtual Tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
