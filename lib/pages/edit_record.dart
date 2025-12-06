import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/Database/db_helper.dart';
import 'package:flutter_application_1/services/Database/health_record.dart';

class EditRecordPage extends StatefulWidget {
  final HealthRecord record;

  const EditRecordPage({super.key, required this.record});

  @override
  State<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _waterController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.record.date);
    _stepsController =
        TextEditingController(text: widget.record.steps.toString());
    _caloriesController =
        TextEditingController(text: widget.record.calories.toString());
    _waterController =
        TextEditingController(text: widget.record.water.toString());
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
    final initial = DateTime.tryParse(_dateController.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ); // Flutter date picker. [web:29]

    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked); // [web:13]
    }
  }

  String? _numberValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final n = int.tryParse(value.trim());
    if (n == null || n < 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  Future<void> _updateRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = HealthRecord(
      id: widget.record.id,
      date: _dateController.text.trim(),
      steps: int.parse(_stepsController.text.trim()),
      calories: int.parse(_caloriesController.text.trim()),
      water: int.parse(_waterController.text.trim()),
    );

    await DBHelper.instance.updateHealthRecord(updated); // UPDATE row. [web:2]

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record updated')),
    ); // show confirmation. [web:81]
    Navigator.of(context).pop(true);
  }

  InputDecoration _fieldDecoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF425CFF), width: 1.5),
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
            // Gradient header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFA810B0), Color(0xFFFF0569)],
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
                    'Edit Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Update your health record',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Date
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: _fieldDecoration(
                          label: 'Date',
                          prefixIcon:
                              const Icon(Icons.calendar_today, size: 20),
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
                          prefixIcon: const Icon(Icons.water_drop,
                              size: 20, color: Colors.blue),
                        ),
                        validator: (v) => _numberValidator(v, 'Water'),
                      ),
                      const SizedBox(height: 24),

                      // Gradient Update button
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFA810B0), Color(0xFFFF0569)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _updateRecord,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Update Record'),
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

                      // Info card
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
                                color: Colors.lightBlue, size: 22),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Updating this record will replace the existing data for this date.',
                                style: TextStyle(fontSize: 13),
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
