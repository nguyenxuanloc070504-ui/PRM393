import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/task.dart';
import '../viewmodel/task_view_model.dart';
import '../viewmodel/theme_view_model.dart';
import 'task_form_dialog.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  // Mở form thêm hoặc sửa
  void openTaskForm(BuildContext context, [Task? task]) {
    showDialog(
      context: context,
      builder: (_) => TaskFormDialog(task: task),
    );
  }

  // Hiển thị bảng chọn màu
  void showColorPicker(BuildContext context, WidgetRef ref) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.deepPurple,
      Colors.orange,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Chọn màu thanh ứng dụng'),
          content: Wrap(
            spacing: 15,
            runSpacing: 15,
            children: colors.map((color) {
              return InkWell(
                onTap: () {
                  ref
                      .read(themeViewModelProvider.notifier)
                      .changeColor(color);

                  Navigator.pop(dialogContext);
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 23,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskViewModelProvider);
    final themeAsync = ref.watch(themeViewModelProvider);

    final selectedColor = Color(
      themeAsync.valueOrNull ?? Colors.blue.toARGB32(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        backgroundColor: selectedColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng tìm kiếm có thể bổ sung'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              showColorPicker(context, ref);
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(
              child: Text('Chưa có công việc nào'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      ref
                          .read(taskViewModelProvider.notifier)
                          .toggleTask(task);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Column(
                    cross: CrossAxisAlignment.start,
                    children: [
                      if (task.description.isNotEmpty)
                        Text(task.description),
                      const SizedBox(height: 5),
                      if (task.dueDate.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(task.dueDate),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          openTaskForm(context, task);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (task.id != null) {
                            ref
                                .read(taskViewModelProvider.notifier)
                                .deleteTask(task.id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openTaskForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}