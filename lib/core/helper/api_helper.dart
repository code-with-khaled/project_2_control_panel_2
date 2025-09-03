import 'package:control_panel_2/core/api/api_client.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static ApiClient getClient() {
    return ApiClient(
      baseUrl: 'http://127.0.0.1:8000/api',
      httpClient: http.Client(),
    );
  }
}
