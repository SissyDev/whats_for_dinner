class ApiConfig {
  static const mealDbApiKey = String.fromEnvironment(
    'MEALDB_API_KEY',
    defaultValue: '1',
  );

  static Uri mealDb(String endpoint, [Map<String, String>? queryParameters]) {
    final apiPath = mealDbApiKey == '1'
        ? '/api/json/v1/1/$endpoint'
        : '/api/json/v2/$mealDbApiKey/$endpoint';

    return Uri.https(
      'www.themealdb.com',
      apiPath,
      queryParameters,
    );
  }

  static Uri publicMealDb(
    String endpoint, [
    Map<String, String>? queryParameters,
  ]) {
    return Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/$endpoint',
      queryParameters,
    );
  }
}
