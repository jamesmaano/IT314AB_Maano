import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DbConnection {
  static Connection? _conn;

  static Future<Connection> get() async {
    if (_conn != null && _conn!.isOpen) return _conn!;
    _conn = await Connection.open(
      Endpoint(
        host: dotenv.env['DB_HOST']!,
        database: dotenv.env['DB_NAME']!,
        username: dotenv.env['DB_USER']!,
        password: dotenv.env['DB_PASS']!,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
        connectTimeout: Duration(seconds: 20), // Neon may need a few seconds to wake up
      ),
    );
    return _conn!;
  }

  static Future<bool> test() async {
    try {
      final c = await get();
      final r = await c.execute('SELECT 1');
      return r.isNotEmpty;
    } catch (e) {
      debugPrint('DB error: $e');
      return false;
    }
  }
}
