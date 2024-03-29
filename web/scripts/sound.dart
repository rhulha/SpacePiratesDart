library sound;

import "dart:html" as HTML;
import "dart:typed_data";
import "dart:web_audio";

// http://news.dartlang.org/2012/02/web-audio-api-and-dart.html

class Sound
{
  
  AudioContext context;
  Map<String, AudioBuffer> sounds = new Map<String, AudioBuffer>(); 
  
  Sound() {
    
    context = new AudioContext();
    
  }
  
  // "sounds/laser.wav"
  void loadSound( String url, String alias)
  {
    HTML.HttpRequest hr = new HTML.HttpRequest();
    hr.open("GET", url);
    hr.responseType = "arraybuffer";
    hr.onLoadEnd.listen( (e) {
      
      ByteBuffer audioData = hr.response as ByteBuffer;
      context.decodeAudioData(audioData).then( (AudioBuffer audioBuffer) {
        sounds[alias] = audioBuffer;        
      });
            
      //ByteBuffer bb =ist u = new Uint8List.view(bb);
    });
    hr.send('');
    
  }
  
  void playSound( String alias)
  {
    AudioBufferSourceNode source = context.createBufferSource();
    source.buffer = sounds[alias];
    source.connectNode(context.destination, 0, 0);
    source.start(0);
  }
  
}