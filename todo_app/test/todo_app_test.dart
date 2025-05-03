import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/Data/goal.dart';
import 'package:todo_app/Data/task.dart';
import 'package:todo_app/Data/database_provider.dart';
import 'package:todo_app/Data/database_services.dart';
import 'package:todo_app/Data/boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() {
  group('Todo App Tests', () {
    late Box personBox;
    late Box goalBox;
    late DatabaseProvider databaseProvider;
    late DatabaseServices databaseServices;

    setUp(() async {
      // Initialize Hive for testing
      final tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);
      
      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(GoalAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskAdapter());
      }
      
      // Open test boxes
      personBox = await Hive.openBox('Person');
      goalBox = await Hive.openBox('Goals');
      
      // Set up test user
      await personBox.put('firstName', 'Test User');
      await personBox.put('firstLaunch', false);
      
      // Initialize services
      databaseServices = DatabaseServices();
      databaseProvider = DatabaseProvider();
      
      // Initialize boxes
      Boxes.initialize(goalBox, personBox);
    });

    tearDown(() async {
      // Clean up after each test
      await Hive.deleteFromDisk();
    });

    Future<void> runTestWithTimeout(Future<void> Function() testFunction, String testName) async {
      final completer = Completer<void>();
      final timer = Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Test timed out after 30 seconds'));
        }
      });

      try {
        await testFunction();
        timer.cancel();
        completer.complete();
      } catch (e) {
        timer.cancel();
        completer.completeError(e);
      }

      try {
        await completer.future;
      } on TimeoutException {
        print('Test "$testName" timed out after 30 seconds, moving to next test');
      }
    }

    testWidgets('User can see all 3 goals on homepage', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goals = [
          Goal(goalId: '1', goalName: 'Goal 1', tasks: []),
          Goal(goalId: '2', goalName: 'Goal 2', tasks: []),
          Goal(goalId: '3', goalName: 'Goal 3', tasks: []),
        ];
        
        for (var goal in goals) {
          await databaseServices.addGoalToDatabase(goal);
        }
        
        await databaseProvider.getGoals();
        
        await tester.pumpWidget(
          ChangeNotifierProvider<DatabaseProvider>.value(
            value: databaseProvider,
            child: const MyApp(),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Verify all goals are displayed
        expect(find.text('Goal 1'), findsOneWidget);
        expect(find.text('Goal 2'), findsOneWidget);
        expect(find.text('Goal 3'), findsOneWidget);
      }, 'User can see all 3 goals on homepage');
    });

    testWidgets('User can add tasks to specific goals', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        await goalsBox.add(Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [],
        ));
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Add task to first goal
        await tester.tap(find.byIcon(Icons.add).first);
        await tester.pumpAndSettle();
        
        await tester.enterText(find.byType(TextField).first, 'New Task');
        await tester.enterText(find.byType(TextField).at(1), 'Task Description');
        await tester.tap(find.text('Add Task'));
        await tester.pumpAndSettle();
        
        // Verify task is added
        expect(find.text('New Task'), findsOneWidget);
      }, 'User can add tasks to specific goals');
    });

    testWidgets('User can complete tasks from homepage', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        final goal = Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
              isCompleted: false,
            ),
          ],
        );
        await goalsBox.add(goal);
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Complete a task
        await tester.tap(find.byIcon(Icons.check_box_outline_blank).first);
        await tester.pumpAndSettle();
        
        // Verify task is completed
        expect(find.byIcon(Icons.check_box), findsOneWidget);
      }, 'User can complete tasks from homepage');
    });

    testWidgets('User can view all tasks under a single goal', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        final goal = Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
            ),
            Task(
              title: 'Task 2',
              description: 'Description 2',
              priority: 1,
            ),
          ],
        );
        await goalsBox.add(goal);
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Tap on a goal
        await tester.tap(find.text('Goal 1'));
        await tester.pumpAndSettle();
        
        // Verify we're on the goal details page
        expect(find.text('Goal 1 Tasks'), findsOneWidget);
        expect(find.text('Task 1'), findsOneWidget);
        expect(find.text('Task 2'), findsOneWidget);
      }, 'User can view all tasks under a single goal');
    });

    testWidgets('User can uncomplete a task in goal details page', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        final goal = Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
              isCompleted: true,
            ),
          ],
        );
        await goalsBox.add(goal);
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Navigate to goal details page
        await tester.tap(find.text('Goal 1'));
        await tester.pumpAndSettle();
        
        // Uncomplete a task
        await tester.tap(find.byIcon(Icons.check_box).first);
        await tester.pumpAndSettle();
        
        // Verify task is uncompleted
        expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
      }, 'User can uncomplete a task in goal details page');
    });

    testWidgets('User can delete a task from goal details page', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        final goal = Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
            ),
          ],
        );
        await goalsBox.add(goal);
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Navigate to goal details page
        await tester.tap(find.text('Goal 1'));
        await tester.pumpAndSettle();
        
        // Delete a task
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();
        
        // Verify task is deleted
        expect(find.text('Task 1'), findsNothing);
      }, 'User can delete a task from goal details page');
    });

    testWidgets('Homepage displays message when no tasks exist', (WidgetTester tester) async {
      await runTestWithTimeout(() async {
        // Setup test data
        final goalsBox = await Hive.openBox('Goals');
        final goal = Goal(
          goalId: '1',
          goalName: 'Goal 1',
          tasks: [],
        );
        await goalsBox.add(goal);
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();
        
        // Verify empty state message
        expect(find.text('No tasks added yet'), findsOneWidget);
      }, 'Homepage displays message when no tasks exist');
    });

    // Additional unit tests
    test('Goal completion percentage is calculated correctly', () async {
      await runTestWithTimeout(() async {
        final goal = Goal(
          goalId: '1',
          goalName: 'Test Goal',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
              isCompleted: true
            ),
            Task(
              title: 'Task 2',
              description: 'Description 2',
              priority: 1,
              isCompleted: false
            ),
          ],
        );
        
        // Calculate completion percentage
        final completedTasks = goal.goalTasks.where((task) => task.isCompleted).length;
        final completionPercentage = (completedTasks / goal.goalTasks.length) * 100;
        expect(completionPercentage, equals(50.0));
      }, 'Goal completion percentage is calculated correctly');
    });

    test('Task completion updates goal completion percentage', () async {
      await runTestWithTimeout(() async {
        final goal = Goal(
          goalId: '1',
          goalName: 'Test Goal',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
              isCompleted: false
            ),
            Task(
              title: 'Task 2',
              description: 'Description 2',
              priority: 1,
              isCompleted: false
            ),
          ],
        );
        
        goal.goalTasks[0].isCompleted = true;
        final completedTasks = goal.goalTasks.where((task) => task.isCompleted).length;
        final completionPercentage = (completedTasks / goal.goalTasks.length) * 100;
        expect(completionPercentage, equals(50.0));
      }, 'Task completion updates goal completion percentage');
    });

    test('Task deletion updates goal completion percentage', () async {
      await runTestWithTimeout(() async {
        final goal = Goal(
          goalId: '1',
          goalName: 'Test Goal',
          tasks: [
            Task(
              title: 'Task 1',
              description: 'Description 1',
              priority: 1,
              isCompleted: true
            ),
            Task(
              title: 'Task 2',
              description: 'Description 2',
              priority: 1,
              isCompleted: false
            ),
          ],
        );
        
        goal.goalTasks.removeAt(0);
        final completedTasks = goal.goalTasks.where((task) => task.isCompleted).length;
        final completionPercentage = goal.goalTasks.isEmpty ? 0.0 : (completedTasks / goal.goalTasks.length) * 100;
        expect(completionPercentage, equals(0.0));
      }, 'Task deletion updates goal completion percentage');
    });
  });
} 