import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'package:flutter_application_1/services/Database/health_record.dart';

class RecordListPage extends StatelessWidget {
  const RecordListPage({super.key});

  Future<List<HealthRecord>> _loadRecords() {
    return DBHelper.instance.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: FutureBuilder<List<HealthRecord>>(
        future: _loadRecords(),                    // load data from SQLite [web:2][web:143]
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No records yet'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final r = records[index];
              return ListTile(
                title: Text('${r.date}  •  ${r.steps} steps'),
                subtitle: Text(
                    'Calories: ${r.calories}  |  Water: ${r.water} ml'),
              );
            },
          ); // standard ListView.builder for dynamic lists. [web:145][web:154]
        },
      ),
    );
  }
}
