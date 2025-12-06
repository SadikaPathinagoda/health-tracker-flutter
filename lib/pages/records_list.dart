import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_record.dart';
import 'package:flutter_application_1/pages/edit_record.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/Database/db_helper.dart';
import 'package:flutter_application_1/services/Database/health_record.dart';

//import 'add_health_record_page.dart';
//import 'edit_record_page.dart';

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({super.key});

  @override
  State<HealthRecordsPage> createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  String? _selectedDate; // yyyy-MM-dd
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickFilterDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ); // standard showDatePicker. [web:29]

    if (picked != null) {
      _selectedDate = DateFormat('yyyy-MM-dd').format(picked); // [web:13]
      _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      setState(() {});
    }
  }

  Future<List<HealthRecord>> _loadRecords() {
    return DBHelper.instance.getRecords(date: _selectedDate);
    // getRecords(date) is the helper shown earlier that SELECTs from SQLite. [web:2][web:142]
  }

  Future<bool> _confirmDelete(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete record?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  ); // standard confirm dialog pattern. [web:195][web:197][web:203]

  return result ?? false;
}


  Future<void> _deleteRecord(HealthRecord r) async {
  final confirm = await _confirmDelete(context);
  if (!confirm) return;

  await DBHelper.instance.deleteRecord(r.id!); // actual DELETE. [web:2][web:201]

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Record deleted')),
  ); // user feedback. [web:200][web:203]
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient header like Add/Edit
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF31AD04), Color(0xFF00D18F)], // greenish
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
                    'Health Records',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'View and manage your records',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Column(
                children: [
                  // Date filter field
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.calendar_today, size: 20),
                        hintText: 'mm/dd/yyyy',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: _selectedDate != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _selectedDate = null;
                                  _dateController.clear();
                                  setState(() {});
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.edit_calendar),
                                onPressed: _pickFilterDate,
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      onTap: _pickFilterDate,
                    ),
                  ),

                  // Records list
                  Expanded(
                    child: FutureBuilder<List<HealthRecord>>(
                      future: _loadRecords(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        final records = snapshot.data ?? [];
                        if (records.isEmpty) {
                          return const Center(
                              child: Text('No records found'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final r = records[index];
                            final isToday = r.date == todayStr;

                            final dt = DateTime.tryParse(r.date);
                            final niceDate = dt != null
                                ? DateFormat('EEE, MMM dd, yyyy')
                                    .format(dt) // readable date. [web:13]
                                : r.date;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // top row: date + Today
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 18),
                                            const SizedBox(width: 6),
                                            Text(
                                              niceDate,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        if (isToday)
                                          const Text(
                                            'Today',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // stats row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _StatPill(
                                          icon: Icons.directions_walk,
                                          color: Colors.green,
                                          value: r.steps.toString(),
                                          label: 'steps',
                                        ),
                                        _StatPill(
                                          icon: Icons.local_fire_department,
                                          color: Colors.red,
                                          value: r.calories.toString(),
                                          label: 'calories',
                                        ),
                                        _StatPill(
                                          icon: Icons.water_drop,
                                          color: Colors.blue,
                                          value: r.water.toString(),
                                          label: 'ml',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // edit / delete
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            final changed =
                                                await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => EditRecordPage(
                                                    record: r),
                                              ),
                                            ); // navigate to Edit page. [web:166]
                                            if (changed == true) {
                                              setState(() {});
                                            }
                                          },
                                          icon: const Icon(Icons.edit, size: 18),
                                          label: const Text('Edit'),
                                        ),
                                        TextButton.icon(
                                          onPressed: () => _deleteRecord(r),
                                          icon: const Icon(Icons.delete,
                                              size: 18),
                                          label: const Text('Delete'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Add Record floating bottom button (optional)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddHealthRecordPage(),
                            ),
                          ); // open Add page. [web:166]
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Record'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.green.shade200),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small pill widget for steps / calories / water
class _StatPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatPill({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
