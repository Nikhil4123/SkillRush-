// Environment configuration file
// This is for API keys and secrets that should NOT be hardcoded in source code

// In a real production app, these values would be loaded from:
// 1. Secure environment variables
// 2. A secure backend service
// 3. Flutter's --dart-define flags
// 4. A properly encrypted local storage
// 5. Firebase Remote Config

class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  // IMPORTANT: Do not hardcode actual API keys here!
  // This is just a placeholder example of how to structure the file

  // These should be filled at runtime or build time
  static String? _apiKey;
  static String? _appId;

  // Initialize with values (from a secure source)
  static void initialize({required String apiKey, required String appId}) {
    _apiKey = apiKey;
    _appId = appId;
  }

  // Getters with null safety
  static String get apiKey {
    if (_apiKey == null) {
      throw Exception('API Key not initialized');
    }
    return _apiKey!;
  }

  static String get appId {
    if (_appId == null) {
      throw Exception('App ID not initialized');
    }
    return _appId!;
  }
}
