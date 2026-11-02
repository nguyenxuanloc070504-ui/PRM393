import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/task.dart';
import '../service/task_database_service.dart';

part 'task_view_model.g.dart';

@riverpod
class TaskViewModel extends _$TaskViewModel {
  @override
  Future<List<Task>> build() async {
    return await TaskDatabaseService.instance.getTasks();
  }

  // Thêm công việc
  Future<void> addTask(Task task) async {
    state = await AsyncValue.guard(() async {
      await TaskDatabaseService.instance.insertTask(task);
      return await TaskDatabaseService.instance.getTasks();
    });
  }

  // Sửa công việc
  Future<void> updateTask(Task task) async {
    state = await AsyncValue.guard(() async {
      await TaskDatabaseService.instance.updateTask(task);
      return await TaskDatabaseService.instance.getTasks();
    });
  }

  // Xóa công việc
  Future<void> deleteTask(int id) async {
    state = await AsyncValue.guard(() async {
      await TaskDatabaseService.instance.deleteTask(id);
      return await TaskDatabaseService.instance.getTasks();
    });
  }

  // Cập nhật trạng thái hoàn thành
  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }
}