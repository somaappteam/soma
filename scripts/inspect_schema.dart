import 'dart:convert';
import 'dart:io';
import 'package:soma/core/services/app_logger.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('$supabaseUrl/rest/v1/'));
    request.headers.add('apikey', serviceRoleKey);
    request.headers.add('Authorization', 'Bearer $serviceRoleKey');

    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      final spec = jsonDecode(body);
      final definitions = spec['definitions'];
      if (definitions != null) {
        appLogger.info('Tables found: ${definitions.keys.toList()}');
        for (var tableName in [
          'vocabulary',
          'sentences',
          'profiles',
          'courses'
        ]) {
          if (definitions[tableName] != null) {
            appLogger.info(
                '$tableName columns: ${definitions[tableName]['properties'].keys.toList()}');
          } else {
            appLogger.info('$tableName table not found.');
          }
        }
      } else {
        appLogger.info('Definitions not found in spec.');
      }
    } else {
      appLogger.info('Failed to fetch spec: ${response.statusCode} $body');
    }
  } finally {
    client.close();
  }
}
