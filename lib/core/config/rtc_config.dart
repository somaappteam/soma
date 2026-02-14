class RtcConfig {
  static const List<Map<String, String>> stunServers = [
    {'urls': 'stun:stun.l.google.com:19302'},
    {'urls': 'stun:stun1.l.google.com:19302'},
  ];

  static const String turnUrl = String.fromEnvironment('TURN_URL', defaultValue: '');
  static const String turnUsername = String.fromEnvironment('TURN_USERNAME', defaultValue: '');
  static const String turnCredential = String.fromEnvironment('TURN_CREDENTIAL', defaultValue: '');

  /// Optional Supabase Edge Function to mint short-lived TURN credentials.
  static const String turnCredentialsFunction =
      String.fromEnvironment('TURN_CREDENTIALS_FUNCTION', defaultValue: '');

  /// Soft cap to keep mesh affordable in circles.
  static const int maxMeshPeers = int.fromEnvironment('RTC_MAX_MESH_PEERS', defaultValue: 6);

  /// Soft cap for active speakers before auto-demoting non-priority publishers.
  static const int maxActiveSpeakers =
      int.fromEnvironment('RTC_MAX_ACTIVE_SPEAKERS', defaultValue: 4);

  static const int audioSampleRate =
      int.fromEnvironment('RTC_AUDIO_SAMPLE_RATE', defaultValue: 16000);

  static const int audioChannelCount =
      int.fromEnvironment('RTC_AUDIO_CHANNEL_COUNT', defaultValue: 1);

  static List<Map<String, String>> iceServers({required bool useTurn}) {
    if (!useTurn || turnUrl.isEmpty) {
      return stunServers;
    }

    return [
      ...stunServers,
      {
        'urls': turnUrl,
        if (turnUsername.isNotEmpty) 'username': turnUsername,
        if (turnCredential.isNotEmpty) 'credential': turnCredential,
      },
    ];
  }
}
