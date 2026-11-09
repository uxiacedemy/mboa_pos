import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/models/staff_user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/sales/presentation/screens/pos_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/storyboard/presentation/screens/storyboard_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final staffUser = ref.watch(authProvider);
  final authStatus = ref.watch(authStatusProvider);
  return GoRouter(
    initialLocation: '/pos',
    redirect: (context, state) {
      final path = state.uri.path;
      final protected = path == '/pos' ||
          path == '/inventory' ||
          path == '/reports' ||
          path == '/settings' ||
          path.startsWith('/sales');
      if (authStatus == AuthStatus.restoring) {
        return path == '/login' || path == '/register' ? null : '/login';
      }
      if (protected && staffUser == null) return '/login';
      if (path == '/login' && staffUser != null) return '/pos';
      if (path == '/reports' &&
          staffUser != null &&
          !{
            StaffRole.owner,
            StaffRole.admin,
            StaffRole.manager,
            StaffRole.supervisor,
          }.contains(staffUser.role)) {
        return '/pos';
      }
      if (path == '/inventory' &&
          staffUser != null &&
          !{
            StaffRole.owner,
            StaffRole.admin,
            StaffRole.manager,
            StaffRole.supervisor,
          }.contains(staffUser.role)) {
        return '/pos';
      }
      if (path == '/settings' &&
          staffUser != null &&
          staffUser.role != StaffRole.owner &&
          staffUser.role != StaffRole.admin) {
        return '/pos';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationScreen()),
      GoRoute(
          path: '/storyboard',
          builder: (context, state) => const StoryboardScreen()),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/pos', builder: (context, state) => const PosScreen()),
          GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen()),
          GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen()),
          GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
