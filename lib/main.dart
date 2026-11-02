import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/task_list_screen.dart';
import 'viewmodel/theme_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeViewModelProvider);

    final selectedColor = Color(
      themeAsync.valueOrNull ?? Colors.blue.toARGB32(),
    );

    return MaterialApp(
      title: 'Quản lý công việc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor,
        ),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}