import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class WorkDetailScreen extends ConsumerStatefulWidget {
  final String memoId;
  final String memoName;

  const WorkDetailScreen({
    super.key,
    required this.memoId,
    required this.memoName,
  });

  @override
  ConsumerState<WorkDetailScreen> createState() => _WorkDetailScreenState();
}

class _WorkDetailScreenState extends ConsumerState<WorkDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      ref.read(taskNotifierProvider.notifier).setMemoId(widget.memoId)
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.memoName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: tasksAsync.when(
        data: (tasks) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color statusColor;
    switch (task.status.toLowerCase()) {
      case 'urgent': statusColor = Colors.redAccent; break;
      case 'running': statusColor = Colors.green; break;
      case 'ongoing': statusColor = Colors.blue; break;
      default: statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                task.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
                  }
                },
                child: Icon(Icons.more_vert, color: Colors.grey[400]),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            task.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(task.time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.people_outline, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text('${task.persons} Persons', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final personsCtrl = TextEditingController();
    String status = 'Running';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Task Title')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Time (e.g. 10 - 11 AM)')),
              TextField(controller: personsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Persons (e.g. 4)')),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Urgent', 'Running', 'Ongoing']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => status = v!,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                ref.read(taskNotifierProvider.notifier).addTask(
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  status: status,
                  time: timeCtrl.text,
                  persons: int.tryParse(personsCtrl.text) ?? 1,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
