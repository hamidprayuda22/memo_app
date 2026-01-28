import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/memo_provider.dart';

class MemoFormScreen extends ConsumerStatefulWidget {
  const MemoFormScreen({super.key});

  @override
  ConsumerState<MemoFormScreen> createState() => _MemoFormScreenState();
}

class _MemoFormScreenState extends ConsumerState<MemoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedStatus = 'Running';
  Color _selectedColor = Colors.green;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Memo title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Title required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const ['Running', 'URGENT', 'Ongoing', 'Completed']
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedStatus = v ?? 'Running';
                }),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Color'),
                trailing: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                ),
                onTap: () {
                  // Bisa ganti ke color picker beneran nanti
                  setState(() {
                    _selectedColor = _selectedColor == Colors.green
                        ? Colors.orange
                        : Colors.green;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Memo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(memoNotifierProvider.notifier).createMemo(
          _titleController.text,
          _selectedStatus,
          _selectedColor.value,
        );

    if (mounted) Navigator.pop(context);
  }
}