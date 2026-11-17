import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_pos/features/auth/presentation/providers/auth_provider.dart';

void main() {
  test('device identity survives provider recreation and uses one stable key',
      () async {
    final values = <String, String>{};
    final writes = <String>[];

    Future<String?> read(String key) async => values[key];
    Future<void> write(String key, String value) async {
      writes.add(key);
      values[key] = value;
    }

    final first = await loadOrCreateDeviceId(read: read, write: write);
    final second = await loadOrCreateDeviceId(read: read, write: write);

    expect(second, first);
    expect(writes, [deviceIdStorageKey]);
    expect(values.keys, [deviceIdStorageKey]);
  });
}
