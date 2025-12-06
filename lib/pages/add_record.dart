// add_health_record_page.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/Database/db_helper.dart';
import '../services/Database/health_record.dart';

class AddHealthRecordPage extends StatefulWidget {
  const AddHealthRecordPage({super.key});

  @override
  State<AddHealthRecordPage> createState() => _AddHealthRecordPageState();
}

class _AddHealthRecordPageState extends State<AddHealthRecordPage> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(today);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ); // built‑in date picker. [web:29]

    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked); // [web:13]
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final record = HealthRecord(
      date: _dateController.text.trim(),
      steps: int.parse(_stepsController.text.trim()),
      calories: int.parse(_caloriesController.text.trim()),
      water: int.parse(_waterController.text.trim()),
    );

    await DBHelper.instance.insertHealthRecord(record); // insert into SQLite. [web:2]

    _stepsController.clear();
    _caloriesController.clear();
    _waterController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Health record saved')),
    ); // feedback via SnackBar. [web:81]
  }

  String? _numberValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    final n = int.tryParse(value.trim());
    if (n == null || n < 0) return 'Enter a valid number';
    return null;
  }

  InputDecoration _fieldDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? helperText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: helperText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF425CFF), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient header like the design
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF425CFF), Color(0xFFE73AA9)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Health Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Record your daily health activities',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: _fieldDecoration(
                          label: 'Date',
                          prefixIcon:
                              const Icon(Icons.calendar_today, size: 20),
                          helperText: 'Auto-filled with today\'s date',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.edit_calendar),
                            onPressed: _pickDate,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Steps
                      TextFormField(
                        controller: _stepsController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration(
                          label: 'Steps',
                          hint: 'e.g. 1,500',
                          prefixIcon: const Icon(Icons.directions_walk,
                              size: 20, color: Colors.green),
                        ),
                        validator: (v) => _numberValidator(v, 'Steps'),
                      ),
                      const SizedBox(height: 16),

                      // Calories
                      TextFormField(
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration(
                          label: 'Calories',
                          hint: 'e.g. 1,000',
                          prefixIcon: const Icon(Icons.local_fire_department,
                              size: 20, color: Colors.red),
                        ),
                        validator: (v) => _numberValidator(v, 'Calories'),
                      ),
                      const SizedBox(height: 16),

                      // Water
                      TextFormField(
                        controller: _waterController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration(
                          label: 'Water Intake (ml)',
                          hint: 'e.g. 1,500',
                          prefixIcon: const Icon(Icons.water_drop,
                              size: 20, color: Colors.blue),
                        ),
                        validator: (v) => _numberValidator(v, 'Water'),
                      ),
                      const SizedBox(height: 24),

                      // Gradient Save button
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF425CFF), Color(0xFFE73AA9)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: _saveRecord,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Save Record'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tip card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.lightBlueAccent.shade100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline,
                                color: Colors.lightBlue, size: 28),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tip: Stay hydrated! Aim for 2000ml of water daily for optimal health.',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
