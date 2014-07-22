part of game;

class Network {
  
  HTML.WebSocket ws;
  bool connected;
  
  Network() {
    
    String wsurl = ((HTML.window.location.protocol == 'http:') ? 'ws://' : 'wss://')
        + HTML.window.location.host 
        + ( (HTML.window.location.pathname.length == 0) || (HTML.window.location.pathname == '/') ? '' : '/' + HTML.window.location.pathname.split('/')[1]) 
        + '/websocket';
    
    ws = new HTML.WebSocket(wsurl);
    ws.binaryType = 'arraybuffer';
    
    ws.onOpen.listen((HTML.Event e) {
      print('WebSocket connected');
      connected = true;
    });

    ws.onError.listen((HTML.Event e) {
      //receivedData(e.data);
    });

    ws.onClose.listen((HTML.CloseEvent e) {
      print('WebSocket closed');
      connected = false;
    });

    //ws.onMessage.listen((HTML.MessageEvent e) {
      //receivedData(e.data);
    //});
  }
  
  void send( dynamic msg) {
    if( connected)
      ws.send( msg);
  }
  
}