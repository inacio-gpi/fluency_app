import 'package:fluency_app/features/path/presentation/controller/path_controller.dart';
import 'package:fluency_app/features/path/presentation/controller/path_state.dart';
import 'package:fluency_app/features/path/presentation/pages/path_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixtures.dart';
import 'path_page_test.mocks.dart';

@GenerateMocks([PathController])
void main() {
  late MockPathController mockController;

  setUp(() {
    mockController = MockPathController();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(home: PathPage(controller: mockController));
  }

  group('PathPage', () {
    final tPath = Fixtures.learningPath;

    testWidgets('should show loading indicator when state is Loading', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockController.state).thenReturn(PathLoading());
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is Error', (
      WidgetTester tester,
    ) async {
      // arrange
      when(
        mockController.state,
      ).thenReturn(const PathError(message: 'Error occurred'));
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('should show path content when state is Loaded', (
      WidgetTester tester,
    ) async {
      // arrange
      when(mockController.state).thenReturn(PathLoaded(path: tPath));
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test Path'), findsOneWidget);
    });

    testWidgets('should show refresh button', (WidgetTester tester) async {
      // arrange
      when(mockController.state).thenReturn(PathLoaded(path: tPath));
      when(mockController.addListener(any)).thenReturn(null);
      when(mockController.removeListener(any)).thenReturn(null);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
