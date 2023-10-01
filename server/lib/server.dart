import 'dart:io';

class Database {
  var _counter = 0;

  Future<int> getCount() async => _counter;
  Future<int> incrementCount() async => ++_counter;
}

class Server {
  static Future<void> start() async {
    final database = Database();
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8000);

    server.listen((request) => _onRequest(request, database));

    print('Server is running on PORT ${server.port}.');
  }

  static void _onRequest(HttpRequest request, Database database) async {
    final response = request.response;

    switch (request.uri.path) {
      case '/counter/increment':
        final newCount = await database.incrementCount();
        response.statusCode = 200;
        response.writeln(newCount);
        response.close();
      case '/counter':
        final count = await database.getCount();
        response.statusCode = 200;
        response.writeln(count);
        response.close();
      default:
        response.statusCode = 404;
        response.close();
    }
  }
}
