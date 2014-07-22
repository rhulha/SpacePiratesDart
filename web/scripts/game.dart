library game;

import 'dart:math' as Math;
import "dart:html" as HTML;
import "dart:async" as Async;

import 'package:chronosgl/chronosgl.dart';
import "sound.dart";

//part "network.dart";
part "blocks.dart";
part "player_ship.dart";
part "laser.dart";


Sound sounds = new Sound();
ChronosGL chronosGL = new ChronosGL('#webgl-canvas', far: 2004.0);
TextureCache textureCache = chronosGL.getTextureCache();
Camera camera = chronosGL.getCamera();
Utils utils = chronosGL.getUtils();
//Network network = new Network();
Blocks blocks = new Blocks();

void init2()
{
  camera.setPos(0.0,0.0,150.0);
  PlayerShip myPlayerShip = new PlayerShip(camera);
  
  chronosGL.addAnimatable( "myPlayerShip", myPlayerShip);
  
  //webSocket.send('send blocks');
  
  //camera.lookAt( [0,0,0] );

  //Line.addGuideLines( 30);

  //var lines = Line.addGuideLines( 30);
  //Line.setGuideLinesToDirectionalVectors( camera, lines);



  //raysWebGL.addPhysicsObject(new PlayerShip(camera));

  utils.addSkybox( "textures/skybox_", ".png", "nx", "px", "nz", "pz", "ny", "py");
  
  //raysWebGL.programs['normal'].add(utils.getWall(textureCache.get( "red"), 20));
  
  utils.addCube( textureCache.getTW( "textures/block.jpg"));
  

  utils.addPointSprites(2000, textureCache.get( "textures/particle.bmp"));
  
  // raysWebGL.programs['normal'].add(new Mesh(asteroidModel));

  // raysWebGL.programs['normal'].add(enemyShip.create()).setPos(0,0,-30);

  // utils.addParticles( 2000);

  //var debugTex = raysUtils.textureFromCanvas(raysUtils.createGradientImage());
  //var blueTex = raysUtils.createSolidTexture("rgba(0,0,255,255)");
  //raysWebGL.add(raysUtils.getWall(blueTex, 20));

  print("game starting");
  chronosGL.run(0.0);
}


void checkTextureCache()
{
  //console.log("checkTextureCache");
  int notReadyCount = textureCache.check();
  if( notReadyCount > 0)
  {
    HTML.querySelector("#topLeftDiv").text = "Loading " + notReadyCount.toString() + " Textures";
    new Async.Timer( const Duration(milliseconds: 300), checkTextureCache);
  } else {
    HTML.querySelector("#topLeftDiv").text = "";
  }
}

void init() {
  
  sounds.loadSound("sounds/laser.wav", "laser1");
  
  textureCache.addSolidColor("red", "rgba(255,0,0,255)");
  textureCache.addSolidColor("black", "rgba(0,0,0,255)");
  textureCache.add("textures/skybox_nx.png");
  textureCache.add("textures/skybox_px.png");
  textureCache.add("textures/skybox_ny.png");
  textureCache.add("textures/skybox_py.png");
  textureCache.add("textures/skybox_nz.png");
  textureCache.add("textures/skybox_pz.png");
  textureCache.add("textures/block.jpg");
  //textureCache.add(shipModel.hull.texture, false);
  //textureCache.add(asteroidModel.texture, false);
  textureCache.add("textures/particle.bmp");

  textureCache.loadAllThenExecute(init2);
  
  new Async.Timer(const Duration(milliseconds: 1000), checkTextureCache);

}