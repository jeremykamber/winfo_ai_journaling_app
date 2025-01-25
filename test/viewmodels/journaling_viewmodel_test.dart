import 'package:flutter_test/flutter_test.dart';
import 'package:winfo_ai_journaling_app/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('JournalingViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
