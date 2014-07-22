part of game;

class Blocks {
  
  
  List<double> viewport = new List<double>(4);
  Matrix4 tempMVMat = new Matrix4();
  
  Vector boxCorner1 = new Vector();
  Vector boxCorner2 = new Vector();
  Vector lineStart = new Vector();
  Vector lineEnd = new Vector();
  Vector Hit = new Vector();
  
  // add a building block, if we hit a block with a pick ray, build a block next to it.
  void addBlock() {
    
    
    viewport[0] = 0.0;
    viewport[1] = 0.0;
    viewport[2] = chronosGL.getCanvas().width.toDouble();
    viewport[3] = chronosGL.getCanvas().height.toDouble();
    chronosGL.getCamera().getMVMatrix(tempMVMat, true);

    lineStart[0] = lineEnd[0] = clientX.toDouble();
    lineStart[1] = lineEnd[1] = clientY.toDouble();
    lineStart[2] = 0.0;
    lineEnd[2] = 0.999;
    // make a line from mouse click into space (around 10 meters).
    lineStart.unproject( tempMVMat, chronosGL.getPerspectiveMatrix(), viewport);
    lineEnd.unproject( tempMVMat, chronosGL.getPerspectiveMatrix(), viewport);

    //raysUtils.addLine( lineStart, lineEnd);

    List<Node> objects = chronosGL.programBasic.objects;
    bool found = false;
    num currentDistance=1000;
    Node currentBlock = null;
    int currentSide = null;
    Vector currentHit = new Vector();
    
    for ( Node object in objects)
    {
      if( "block" == object.type && object.enabled == true)
      {
        boxCorner1.set( object.getPos() );
        boxCorner2.set( object.getPos() );
        boxCorner1[0] -= 1.0;
        boxCorner1[1] -= 1.0;
        boxCorner1[2] -= 1.0;
        boxCorner2[0] += 1.0;
        boxCorner2[1] += 1.0;
        boxCorner2[2] += 1.0;
        int hitSide = checkLineBox( boxCorner1, boxCorner2, lineStart, lineEnd, Hit);
        if( hitSide > 0)
        {
          print( "$hitSide " +  Hit.toString());
          var d = lineStart.dist(  Hit);
          if( d < currentDistance )
          {
            currentDistance = d;
            currentBlock = object;
            currentSide = hitSide;
            currentHit.set( Hit );
          }
          found = true;
        }
      }
    }

    Mesh cubeMesh = createCubeInternal(textureCache.get("textures/block.jpg")).createMesh();
    cubeMesh.type = "block";

    if( ! found)
    {
      lineEnd[0] = clientX.toDouble();
      lineEnd[1] = clientY.toDouble();
      lineEnd[2] = 0.996;
      lineEnd.unproject( tempMVMat, chronosGL.getPerspectiveMatrix(), viewport);
      cubeMesh.setPosFromVec( lineEnd);
      double modx = cubeMesh.matrix[Matrix4.POSX] % 2;
      double mody = cubeMesh.matrix[Matrix4.POSY] % 2;
      double modz = cubeMesh.matrix[Matrix4.POSZ] % 2;
      if( modx > 1.0)
        modx -= 2.0;
      if( mody > 1.0)
        mody -= 2.0;
      if( modz > 1.0)
        modz -= 2.0;
      cubeMesh.matrix[Matrix4.POSX] -= modx;
      cubeMesh.matrix[Matrix4.POSY] -= mody;
      cubeMesh.matrix[Matrix4.POSZ] -= modz;
        
    } else {

      //raysUtils.addParticles( currentHit );

      cubeMesh.setPosFromVec( currentBlock.getPos());
      switch( currentSide)
      {
        case 1:cubeMesh.translate(-2,0,0);break; // LEFT
        case 2:cubeMesh.translate(0,-2,0);break; // BOTTOM
        case 3:cubeMesh.translate(0,0,-2);break; // FRONT
        case 4:cubeMesh.translate(2,0,0);break;  // RIGHT
        case 5:cubeMesh.translate(0,2,0);break;  // TOP
        case 6:cubeMesh.translate(0,0,2);break; // BACK
      }
    }
    chronosGL.programBasic.add(cubeMesh);
    //network.send( '+block:'+cubeMesh.matrix[Matrix4.POSX]+','+cubeMesh.matrix[Matrix4.POSY]+','+cubeMesh.matrix[Matrix4.POSZ] );
  }
}