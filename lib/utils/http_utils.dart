import 'package:http/http.dart' as http;

class HttpUtils {
  static login(String username, String password) async {
    http.Response response = await http.get(
      Uri.parse('http://localhost:8080/auth/login'),
    );
    if (response.statusCode == 200) {}
  }
}
