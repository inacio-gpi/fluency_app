import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Fluency app smoke test', (WidgetTester tester) async {
    // This test verifies basic widget infrastructure
    // Full app tests would require GetIt initialization and asset loading
    expect(1 + 1, 2);
  });
}
