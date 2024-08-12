import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guide_mate_project/plan_trip/gemini.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'gemini_response_page.dart';

class PlanTripPage extends StatefulWidget {
  const PlanTripPage({super.key});

  @override
  _PlanTripPageState createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  final _formKey = GlobalKey<FormState>();
  double _currentBudget = 1000;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));
  bool _flexibleDates = false;
  String _userLocationCity = '';
  String _userLocationCountry = '';
  String _userLocationState = '';
  final List<String> _locationTypes = [];
  int _numberOfAdults = 1;
  int _numberOfChildren = 0;
  String _childrenAges = '';
  String _specialNeedsDietary = '';
  String _specialNeedsAccessibility = '';
  final List<String> _activitiesInterests = [];
  String _additionalNotes = '';
  String _result = '';
  final List<String> _specificLocations = [];
  bool _isSubmitting = false;

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });
    if (_formKey.currentState!.validate()) {
      _result = 'Budget: PKR$_currentBudget\n'
          'Travel Dates: ${DateFormat('yyyy-MM-dd').format(_startDate)} to ${DateFormat('yyyy-MM-dd').format(_endDate)}\n'
          'Flexibility in Dates: ${_flexibleDates ? 'Yes' : 'No'}\n'
          'User Location: $_userLocationCity,$_userLocationState $_userLocationCountry\n'
          'Location Types to Visit: ${_locationTypes.join(', ')}\n'
          'Specific Locations: ${_specificLocations.join(', ')}\n'
          'Activities and Interests: ${_activitiesInterests.join(', ')}\n'
          'Number of Travelers:\n'
          '  Adults: $_numberOfAdults\n'
          '  Children: $_numberOfChildren\n'
          '  Ages of Children: $_childrenAges\n'
          'Special Needs:\n'
          '  Dietary Restrictions: $_specialNeedsDietary\n'
          '  Accessibility Needs: $_specialNeedsAccessibility\n'
          'Additional Notes: $_additionalNotes';

      String? response = await GeminiService.generateContent(_result);
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeminiResponsePage(response: response),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const GeminiResponsePage(response: 'Failed to load content.'),
          ),
        );
      }
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _addSpecificLocation() {
    setState(() {
      _specificLocations.add('');
    });
  }

  void _removeSpecificLocation(int index) {
    setState(() {
      _specificLocations.removeAt(index);
    });
  }

  void _updateSpecificLocation(int index, String value) {
    setState(() {
      _specificLocations[index] = value;
    });
  }

  @override
  void dispose() {
    // Dispose of any controllers if you add any
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Budget',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                Slider(
                  value: _currentBudget,
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  label: _currentBudget.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentBudget = value;
                    });
                  },
                ),
                Text('PKR${_currentBudget.round()}'),
                const SizedBox(height: 16),
                const Text(
                  'User\'s Current Location',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                TextButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          _userLocationCountry = country.name;
                        });
                      },
                    );
                  },
                  child: Text(
                    _userLocationCountry.isEmpty
                        ? 'Pick your country'
                        : _userLocationCountry,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                CSCPicker(
                  onCountryChanged: (country) {
                    setState(() {
                      _userLocationCountry = country;
                    });
                  },
                  onStateChanged: (state) {
                    setState(() {
                      _userLocationState = state ?? '';
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      _userLocationCity = city ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Travel Dates',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: DateFormat('yyyy-MM-dd').format(_startDate),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectStartDate(context),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: DateFormat('yyyy-MM-dd').format(_endDate),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectEndDate(context),
                ),
                const SizedBox(height: 8),
                const Text('Flexibility in dates:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Yes'),
                        value: true,
                        groupValue: _flexibleDates,
                        onChanged: (bool? value) {
                          setState(() {
                            _flexibleDates = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: _flexibleDates,
                        onChanged: (bool? value) {
                          setState(() {
                            _flexibleDates = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Specific Locations in Mind',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                ..._specificLocations.asMap().entries.map((entry) {
                  int index = entry.key;
                  String location = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter specific location',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              _updateSpecificLocation(index, value),
                          initialValue: location,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _removeSpecificLocation(index),
                      ),
                    ],
                  );
                }),
                TextButton.icon(
                  onPressed: _addSpecificLocation,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Add another location'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location Types to Visit',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                CheckboxListTile(
                  title: const Text('Urban (e.g., cities)'),
                  value: _locationTypes.contains('Urban'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _locationTypes.add('Urban');
                      } else {
                        _locationTypes.remove('Urban');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Rural (e.g., countryside)'),
                  value: _locationTypes.contains('Rural'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _locationTypes.add('Rural');
                      } else {
                        _locationTypes.remove('Rural');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Coastal (e.g., beaches)'),
                  value: _locationTypes.contains('Coastal'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _locationTypes.add('Coastal');
                      } else {
                        _locationTypes.remove('Coastal');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Mountainous (e.g., hiking trails)'),
                  value: _locationTypes.contains('Mountainous'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _locationTypes.add('Mountainous');
                      } else {
                        _locationTypes.remove('Mountainous');
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Activities and Interests',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                CheckboxListTile(
                  title: const Text('Adventure Sports'),
                  value: _activitiesInterests.contains('Adventure Sports'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _activitiesInterests.add('Adventure Sports');
                      } else {
                        _activitiesInterests.remove('Adventure Sports');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Sightseeing'),
                  value: _activitiesInterests.contains('Sightseeing'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _activitiesInterests.add('Sightseeing');
                      } else {
                        _activitiesInterests.remove('Sightseeing');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Cultural Experiences'),
                  value: _activitiesInterests.contains('Cultural Experiences'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _activitiesInterests.add('Cultural Experiences');
                      } else {
                        _activitiesInterests.remove('Cultural Experiences');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Relaxation'),
                  value: _activitiesInterests.contains('Relaxation'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _activitiesInterests.add('Relaxation');
                      } else {
                        _activitiesInterests.remove('Relaxation');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Shopping'),
                  value: _activitiesInterests.contains('Shopping'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _activitiesInterests.add('Shopping');
                      } else {
                        _activitiesInterests.remove('Shopping');
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Number of Travelers',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Adults',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: '$_numberOfAdults',
                        onChanged: (value) {
                          setState(() {
                            _numberOfAdults = int.parse(value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Children',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: '$_numberOfChildren',
                        onChanged: (value) {
                          setState(() {
                            _numberOfChildren = int.parse(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ages of Children',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _childrenAges,
                  onChanged: (value) {
                    setState(() {
                      _childrenAges = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Special Needs',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Dietary Restrictions',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _specialNeedsDietary,
                  onChanged: (value) {
                    setState(() {
                      _specialNeedsDietary = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Accessibility Needs',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _specialNeedsAccessibility,
                  onChanged: (value) {
                    setState(() {
                      _specialNeedsAccessibility = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Additional Notes',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter any additional notes here',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _additionalNotes,
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _additionalNotes = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Submit'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
