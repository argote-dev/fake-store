import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String? baseURL = dotenv.env['BASE_URL'];
}
