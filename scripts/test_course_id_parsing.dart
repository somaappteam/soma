// Mock Supabase init partial
const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

void main() async {
  // We can't easily run full Flutter app logic in script without proper setup.
  // But we can test the parsing logic if we extract it or run a unit test.
  // Instead, let's just create a minimal test of _parseCourseLangs logic
  // by copy-pasting the logic here to verify it works as expected.

  _testParse('solo_en_es');
  _testParse('en-es');
  _testParse('en_es'); // Just in case
  _testParse('solo_fr_en');
}

void _testParse(final String id) {
  print('Testing ID: "$id"');
  final res = _parseCourseLangs(id);
  if (res != null) {
    print('  ✅ Parsed: ${res.source} -> ${res.target}');
  } else {
    print('  ❌ Failed to parse');
  }
}

class _LangPair {
  final String source;
  final String target;
  _LangPair({required this.source, required this.target});
}

_LangPair? _parseCourseLangs(final String courseId) {
  if (courseId.contains('-')) {
    final parts = courseId.split('-');
    if (parts.length == 2) {
      return _LangPair(source: parts[0].trim(), target: parts[1].trim());
    }
  }
  final parts = courseId.split('_');
  if (parts.length >= 3) {
    final source = parts[1].trim();
    final target = parts[2].trim();
    if (source.isNotEmpty && target.isNotEmpty) {
      return _LangPair(source: source, target: target);
    }
  }
  return null;
}
