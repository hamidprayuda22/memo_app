import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/memos.dart';
import '../providers/memo_provider.dart';
import 'add_memo_screen.dart';
import 'work_detail_screen.dart';

class MemoScreen extends ConsumerWidget {
  const MemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(memoNotifierProvider);

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
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text(
                    'Memo',
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
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: memosAsync.when(
                  data: (memos) => SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          MemoCard(memo: memos[index]),
                      childCount: memos.length,
                    ),
                  ),
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e')),
                  ),
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

  Widget _buildFab(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient:
              const RadialGradient(colors: [Colors.orange, Colors.deepOrange]),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MemoFormScreen(),
                ),
              );
            },
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.menu, color: Colors.white, size: 28),
            Icon(Icons.search, color: Colors.white, size: 28),
          ],
        ),
      );
}

class MemoCard extends StatelessWidget {
  final Memo memo;
  const MemoCard({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkDetailScreen(memoId: memo.id, memoName: memo.title,),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: memo.color.withOpacity(0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Icon(Icons.note, color: memo.color, size: 28),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${memo.tasks} Task',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
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