import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/pages/add_record.dart';
import 'package:flutter_application_1/pages/records_list.dart';
import 'package:flutter_application_1/services/Database/db_helper.dart';
import 'package:flutter_application_1/services/Database/health_record.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  HealthRecord? _todayRecord;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayRecord();
  }

  Future<void> _loadTodayRecord() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final record = await DBHelper.instance.getRecordByDate(todayStr); // SELECT by date [web:2][web:142]
    setState(() {
      _todayRecord = record;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now); // [web:13]

    final steps = _todayRecord?.steps ?? 0;
    final calories = _todayRecord?.calories ?? 0;
    final water = _todayRecord?.water ?? 0;

    const stepsGoal = 10000;
    const caloriesGoal = 2000;
    const waterGoal = 2000;

    final stepsProgress = (steps / stepsGoal).clamp(0.0, 1.0);
    final caloriesProgress = (calories / caloriesGoal).clamp(0.0, 1.0);
    final waterProgress = (water / waterGoal).clamp(0.0, 1.0);

    return Scaffold(
      
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Top gradient header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                            const SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dashboard',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                fontSize: 28,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Track your daily health activities',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          HealthStatCard(
                            icon: Icons.directions_walk,
                            iconColor: Colors.green,
                            title: 'Steps Today',
                            valueText: steps.toString(),
                            percentText:
                                '${(stepsProgress * 100).toStringAsFixed(0)}%',
                            goalText: 'of $stepsGoal goal',
                            progressColor: Colors.green,
                            progressValue: stepsProgress,
                          ),
                          const SizedBox(height: 16),
                          HealthStatCard(
                            icon: Icons.local_fire_department,
                            iconColor: Colors.redAccent,
                            title: 'Calories Today',
                            valueText: calories.toString(),
                            percentText:
                                '${(caloriesProgress * 100).toStringAsFixed(0)}%',
                            goalText: 'of $caloriesGoal goal',
                            progressColor: Colors.redAccent,
                            progressValue: caloriesProgress,
                          ),
                          const SizedBox(height: 16),
                          HealthStatCard(
                            icon: Icons.water_drop,
                            iconColor: Colors.blue,
                            title: 'Water Intake',
                            valueText: water.toString(),
                            percentText:
                                '${(waterProgress * 100).toStringAsFixed(0)}%',
                            goalText: 'of $waterGoal ml goal',
                            progressColor: Colors.blue,
                            progressValue: waterProgress,
                          ),
                          const SizedBox(height: 24),

                          // Add New Record button (gradient)
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF425CFF), Color(0xFFE73AA9)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AddHealthRecordPage(),
                                    ),
                                  ); // navigation pattern. [web:166][web:170]
                                  _loadTodayRecord(); // refresh after returning
                                },
                                icon: const Icon(Icons.add),
                                
                                label: const Text('Add New Record'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Health Records button (white)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const HealthRecordsPage(),
                                  ),
                                );
                                _loadTodayRecord();
                              },
                              icon: const Icon(Icons.list),
                              label: const Text('Health Records'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Reusable stat card widget
class HealthStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String valueText;
  final String percentText;
  final String goalText;
  final double progressValue;
  final Color progressColor;

  const HealthStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.valueText,
    required this.percentText,
    required this.goalText,
    required this.progressValue,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top row: icon + title + percent/goal
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 55),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        valueText,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      percentText,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      goalText,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // thin progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
