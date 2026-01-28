import 'package:flutter/material.dart';

class WorkDetailScreen extends StatelessWidget {
  final String boardName;
  const WorkDetailScreen({super.key, required this.boardName});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      TaskItem(
        status: 'URGENT',
        statusColor: Colors.orange,
        title: 'New Web UI Design',
        subtitle: 'New Web UI Design for \$500',
        time: '10:00 AM',
        persons: 4,
      ),
      TaskItem(
        status: 'Running',
        statusColor: Colors.green,
        title: 'Application Design',
        subtitle: 'Web Application UI Design for \$500',
        time: '03:30 PM',
        persons: 8,
      ),
      TaskItem(
        status: 'Ongoing',
        statusColor: Colors.blue,
        title: 'Devgenie App Design',
        subtitle: 'Devgenie App UI Design for \$500',
        time: '12:45 PM',
        persons: 2,
      ),
      TaskItem(
        status: 'Running',
        statusColor: Colors.teal,
        title: 'Healthcare UI Design',
        subtitle: 'Healthcare Website UI Design for \$500',
        time: '02:45 PM',
        persons: 4,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  boardName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TaskCard(task: tasks[index]),
                  childCount: tasks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem {
  final String status;
  final Color statusColor;
  final String title;
  final String subtitle;
  final String time;
  final int persons;

  TaskItem({
    required this.status,
    required this.statusColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.persons,
  });
}

class TaskCard extends StatelessWidget {
  final TaskItem task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.status,
                style: TextStyle(
                  color: task.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              task.subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.time,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${task.persons} Persons', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
