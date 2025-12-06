import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();
    final formattedDate =
    DateFormat('EEEE, MMMM d, y').format(now);

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      const Icon(Icons.arrow_back, color: Colors.white),
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 28
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    HealthStatCard(
                      icon: Icons.directions_walk ,                    
                      iconColor: Colors.green,
                      title: 'Steps Today',
                      valueText: '8,555',
                      percentText: '75%',
                      goalText: 'of 10,000 goal',
                      progressColor: Colors.green,
                      progressValue: 0.75,
                    ),
                    const SizedBox(height: 16),
                    HealthStatCard(
                      icon: Icons.local_fire_department,
                      iconColor: Colors.redAccent,
                      title: 'Calories Today',
                      valueText: '1,660',
                      percentText: '79%',
                      goalText: 'of 2,000 goal',
                      progressColor: Colors.redAccent,
                      progressValue: 0.79,
                    ),
                    const SizedBox(height: 16),
                    HealthStatCard(
                      icon: Icons.water_drop,
                      iconColor: Colors.blue,
                      title: 'Water Intake',
                      valueText: '2,000',
                      percentText: '100%',
                      goalText: 'of 2,000 ml goal',
                      progressColor: Colors.blue,
                      progressValue: 1.0,
                    ),
                    const SizedBox(height: 24),

                    // Add New Record button
                    Container(
                      decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF425CFF), Color(0xFFE73AA9)],
                ),
                borderRadius: BorderRadius.all( Radius.circular(12)),
              ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {},
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
                          )
                        ),
                      ),
                    ),

                    // Edit Record button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Record'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        )
                      ),
                    ),

                    // Gradient background for button
                    
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


// Reusable stat card
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
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      percentText,
                      style: Theme.of(context).textTheme.titleSmall,
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
            const SizedBox(height: 12),
            Center(
              child: Text(
                valueText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
