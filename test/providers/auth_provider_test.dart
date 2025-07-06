
import 'package:flutter_test/flutter_test.dart';
import 'package:brill_prime/providers/auth_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    test('initial state should be correct', () {
      expect(authProvider.isLoading, false);
      expect(authProvider.user, null);
      expect(authProvider.isAuthenticated, false);
    });

    test('should handle loading state correctly', () {
      authProvider.setLoading(true);
      expect(authProvider.isLoading, true);
      
      authProvider.setLoading(false);
      expect(authProvider.isLoading, false);
    });
  });
}
