import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/custom_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScreenTwoTaskList extends StatelessWidget {
  const ScreenTwoTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Colors.grey[800],
        leading: const Icon(Icons.arrow_back),
        backgroundColor: Colors.grey[50],
      ),
      body: _ScreenTwoBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add, color: Colors.white)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }
}

class _ScreenTwoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Task List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ScreenTwoListTile(
                      index: index,
                    );
                  }))
        ],
      ),
    );
  }
}

class ScreenTwoListTile extends StatelessWidget {
  const ScreenTwoListTile(
      {super.key,
      this.isSelected,
      this.timeAgo,
      this.title,
      required this.index});
  final int index;
  final bool? isSelected;
  final String? title;
  final String? timeAgo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            8.0), // Adjust the radius as per your preference
        color: Colors.grey[200], // Set the desired background color
      ),
      child: ListTile(
        style: ListTileStyle.list,
        leading: TaskCheckBox(
          index: index,
        ),
        title: const Text(
          'Tile Title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: const Text(
          'time ago',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}

class TaskCheckBox extends ConsumerWidget {
  const TaskCheckBox({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('rebuilding checkbox...');
    final selectedList = ref.watch(selectedIndicesProvider);
    bool isSelected = selectedList.contains(index);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            50.0), // Adjust the radius as per your preference
        color: isSelected
            ? Colors.green
            : Colors.white, // Set the desired background color
      ),
      child: InkWell(
        onTap: () {
          if (isSelected) {
            ref.read(selectedIndicesProvider.notifier).removeItem(index);
          } else {
            ref.read(selectedIndicesProvider.notifier).addItem(index);
          }
        },
        borderRadius: BorderRadius.circular(8.0),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}

final selectedIndicesProvider =
    StateNotifierProvider<CustomController<int>, List<int>>(
        (ref) => CustomController<int>());

final isTaskSelected = StateProvider<bool>((ref) => false);
