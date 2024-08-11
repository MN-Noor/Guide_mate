import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Trip Manager',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AddTripScreen(),
//     );
//   }
// }

class AddTripScreen extends StatefulWidget {
  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tripTitleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _guideIdController = TextEditingController();
  DateTime? _selectedTime;
  int _filledSeats = 13;
  int _totalSeats = 20;
  double _price = 1000;
  List<String> _uploadedFiles = [];
  List<String> _services = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trip'),
      ),
      body: Container(
        color: Colors.teal,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _tripTitleController,
                    decoration: InputDecoration(labelText: 'Trip Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a trip title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _destinationController,
                    decoration: InputDecoration(labelText: 'Destination'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a destination';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      'Time: ${_selectedTime != null ? _selectedTime!.toLocal().toString().split(' ')[1] : 'Select a time'}',
                    ),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _pickTime(context),
                  ),
                  Divider(),
                  Text('Services',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildServiceCheckbox('Accommodation'),
                  _buildServiceCheckbox('Transportation'),
                  _buildServiceCheckbox('Meals'),
                  _buildServiceCheckbox('Entrance Fees'),
                  _buildServiceCheckbox('Medical Coverage'),
                  _buildServiceCheckbox('Welcome Kits'),
                  _buildServiceCheckbox('Photography and Videography'),
                  _buildServiceCheckbox('Cultural Shows'),
                  _buildServiceCheckbox('Workshops'),
                  Divider(),
                  TextFormField(
                    initialValue: '$_filledSeats/$_totalSeats',
                    decoration: InputDecoration(
                        labelText: 'Filled Seats / Total Seats'),
                    enabled: false,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _guideIdController,
                    decoration: InputDecoration(labelText: 'Guide ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a guide ID';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Price: \$${_price.toStringAsFixed(2)}'),
                  Slider(
                    value: _price,
                    min: 0,
                    max: 5000,
                    divisions: 100,
                    label: _price.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _price = value;
                      });
                    },
                    activeColor: Colors.teal,
                    inactiveColor: Colors.teal.shade100,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _pickAndUploadMedia(),
                    icon: Icon(Icons.upload_file),
                    label: Text('Upload Photos/Videos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _uploadedFiles.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _uploadedFiles
                              .map((file) => Text(file,
                                  style: TextStyle(color: Colors.teal)))
                              .toList(),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _saveTrip(context),
                    child: Text('Save Trip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCheckbox(String service) {
    return CheckboxListTile(
      title: Text(service),
      value: _services.contains(service),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _services.add(service);
          } else {
            _services.remove(service);
          }
        });
      },
      activeColor: Colors.teal,
      checkColor: Colors.white,
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _pickAndUploadMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileName = basename(pickedFile.path);
      File file = File(pickedFile.path);
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('trips/$fileName')
            .putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          _uploadedFiles.add(downloadUrl);
        });
        // Update Firestore with the new download URL
        await FirebaseFirestore.instance
            .collection('Trips')
            .doc('your_trip_document_id')
            .update({
          'media_files': FieldValue.arrayUnion([downloadUrl]),
        });
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  Future<void> _saveTrip(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        CollectionReference trips = firestore.collection('Trips');
        await trips.add({
          'trip_name': _tripTitleController.text,
          'description': _descriptionController.text,
          'destination': _destinationController.text,
          'time': _selectedTime,
          'services': _services,
          'filled_seats': _filledSeats,
          'total_seats': _totalSeats,
          'guide_id': _guideIdController.text,
          'price': _price,
          'media_files': _uploadedFiles,
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
      } catch (e) {
        print('Error saving trip: $e');
      }
    }
  }
}
