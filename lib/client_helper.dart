import 'package:uuid/uuid.dart';

class ClientHelper {
  static ClientHelper? _instance;

  final String _clientId = 'flutter_client_${const Uuid().v4()}';

  static void initInstance() {
    _instance ??= ClientHelper();
  }

  static ClientHelper? instance() {
    if (_instance == null) {
      throw Exception("--- ClientHelper was not initialized ---");
    }
    return _instance;
  }

  String clientId () {
    return _clientId;
  }
}
