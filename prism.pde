import java.awt.event.*;  

float xtrans=0;
float ytrans=0;
float xscale=20;
float yscale=20;

ArrayList paths = new ArrayList();
Path path = null;

Person person;

class Button {
  int x;
  int y;
  int width;
  int height;
}

class MouseWheelInput implements MouseWheelListener{

  void mouseWheelMoved(MouseWheelEvent e) {
    int step=e.getWheelRotation();
    xscale = xscale*pow(1.1,step);
    yscale = yscale*pow(1.1,step);
  }

}

float screenX() {
  return (mouseX-(width/2))/xscale - xtrans;
}

float screenY() {
  return (mouseY-(height/2))/yscale - ytrans;
}

void setup() {
  size(1000,1000);
  background(255);
  smooth();
  strokeWeight(0.01);
  ellipseMode(CENTER);
  
  frame.addMouseWheelListener(new MouseWheelInput());  
  
  person = new Person(0,0);
}

void draw() {  
  translate(width/2,height/2);
  scale(xscale, yscale);
  pushMatrix();
  translate(xtrans,ytrans);

  background(255);
  noFill();
  
  stroke(255,0,0);
  if( path != null )
    path.draw();
 
  stroke(0);
  for(int i=0; i<paths.size(); i++) {
    ((Path)paths.get(i)).draw();
  }
  
  person.draw();
  
  popMatrix();

}

//void mousePressed() {
  //if( mouseButton==37 ) {
  //  path = new Path();
  //  path.add( screenX(), screenY() );
  //}
//}

void mouseReleased() {
  //if( mouseButton==37 ){
  //  paths.add( path );
  //  path=null;
  //}
}

void mousePressed() {
  person.attemptSelect( screenX(), screenY() );
  //println( person.inside( screenX(), screenY() ) );
}
  
void mouseDragged() {
  //if( mouseButton==37 ) {
  //  path.add( screenX(), screenY() );
  //}
  if( mouseButton==39 ) {
    xtrans += (mouseX-pmouseX)/xscale;
    ytrans += (mouseY-pmouseY)/yscale;
  }
}
