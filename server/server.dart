import 'dart:io';

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String basePath) {
  HttpServer.bind('0.0.0.0', 8080).then((server) {
    server.listen((HttpRequest request) {
      final String path =
          request.uri.path == '/' ? '/index.html' : request.uri.path;
      final File file = new File('${basePath}${path}');
      print( file);
      if (file.existsSync()) {
          file.openRead()
          .pipe(request.response)
          .catchError((e) { print(e);});
      } else {
        print( "not found");
        _sendNotFound(request.response);
      }
      
    });
  });
}

main() {
  File script = new File(Platform.script.toFilePath());
  Directory d = script.parent.parent;
  FileSystemEntity web = d.listSync().where( (FileSystemEntity fse) => fse.path.endsWith("web")).first;
  print( web );
  startServer(web.path);
}
