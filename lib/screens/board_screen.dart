import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BoardScreen extends ConsumerWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = _getSampleBoards();  // Hardcode → nanti Riverpod

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Catatan Saya',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: false,
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Badge(
                      label: Text('114'),
                      backgroundColor: Colors.redAccent,
                      largeSize: 20,
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: boards.map((board) => BoardCard(board: board)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  List<BoardItem> _getSampleBoards() => [
        BoardItem(icon: Icons.person, name: 'Personal', tasks: 17, color: Colors.purple),
        BoardItem(icon: Icons.work_outline, name: 'Work', tasks: 10, color: Colors.green),
        BoardItem(icon: Icons.lock_outline, name: 'Private', tasks: 2, color: Colors.blue),
        BoardItem(icon: Icons.groups_outlined, name: 'Meeting', tasks: 5, color: Colors.purpleAccent),
        BoardItem(icon: Icons.event, name: 'Events', tasks: 3, color: Colors.orange),
        BoardItem(icon: Icons.add, name: 'Create\nBoard', tasks: 0, color: Colors.grey),
      ];

  Widget _buildFab(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: const RadialGradient(colors: [Colors.orange, Colors.deepOrange]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _showCreateDialog(context),
            splashColor: Colors.orangeAccent.withOpacity(0.3),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
        ),
      );

  Widget _buildBottomNav() => Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF667EEA).withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 28), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 28), onPressed: () {}),
          ],
        ),
      );

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    String? selectedStatus;
    Color selectedColor = Colors.green;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 450),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_circle_outline, color: Colors.orange, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Buat Catatan Baru',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Catatan',
                  hintText: 'Masukkan nama catatan',
                  prefixIcon: const Icon(Icons.title_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF667EEA)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(Icons.flag_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: [ 'Mendesak', 'Sedang Berjalan', 'Selesai']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => selectedStatus = value,
              ),
              const SizedBox(height: 20),
              // Picker Warna
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Warna Catatan'),
                trailing: GestureDetector(
                  onTap: () {},  
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Batal'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: nameController.text.isEmpty
                        ? null
                        : () {
                            // Riverpod
                            debugPrint('Buat Catatan: ${nameController.text} - $selectedStatus');
                            Navigator.pop(ctx);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Buat Catatan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoardCard extends StatelessWidget {
  final BoardItem board;

  const BoardCard({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to board details
      },
      child: Container(
        decoration: BoxDecoration(
          color: board.color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: board.color.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(board.icon, color: Colors.white, size: 48),
            const SizedBox(height: 12),
            Text(
              board.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${board.tasks} tasks',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardItem {
  final IconData icon;
  final String name;
  final int tasks;
  final Color color;
  
  BoardItem({required this.icon, required this.name, required this.tasks, required this.color});
}
  