import java.awt.event.*;  

int SECS_IN_DAY=24*3600;

float xtrans=0;
float ytrans=0;
float xscale=20;
float yscale=20;

float time_speedup=1000.0;

ArrayList paths = new ArrayList();
Path path = null;

ArrayList foods = new ArrayList();

float days=0;

Person person;
Landscape landscape;

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

PFont font;
void setup() {
  size(1000,1000);
  background(255);
  smooth();
  strokeWeight(0.01);
  ellipseMode(CENTER);
  
  font = loadFont( "Calibri-25.vlw" );
  textFont(font);
  
  frame.addMouseWheelListener(new MouseWheelInput());  
  
  person = new Person(0,0,days);
  landscape = new Landscape(-500,-500,500,500,days);
}

float lastmillis=0;
void draw() {

  //advance the current time
  float thismillis = millis();
  float timediff = thismillis-lastmillis;
  days += timediff/1000.0/SECS_IN_DAY * time_speedup;
  lastmillis=thismillis;
  
  background(255);
  fill(0);

  
  translate(width/2,height/2);
  scale(xscale, yscale);
  pushMatrix();
  translate(xtrans,ytrans);

  noFill();
  
  stroke(255,0,0);
  if( path != null )
    path.draw();
 
  stroke(0);
  for(int i=0; i<paths.size(); i++) {
    ((Path)paths.get(i)).draw();
  }
  
  person.eat( foods );
  person.update( days, foods );
  foods.addAll( landscape.yield( days ) );
  
  landscape.draw();
  
  for(int i=0; i<foods.size(); i++) {
    ((Food)foods.get(i)).draw();
  }
  
  person.draw();
  
  popMatrix();
  
  resetMatrix();
  fill(0);
  text( "day "+str(round(days*1000.0)/1000.0), 10, 20 );
}

//void mousePressed() {
  //if( mouseButton==37 ) {
  //  path = new Path();
  //  path.add( screenX(), screenY() );
  //}
//}

void keyPressed() {
  if( key=='-' ) {
    time_speedup /= 1.5;
  } else if( key=='+' ) {
    time_speedup *= 1.5;
  }
  println( key ); 
}

void mouseReleased() {
  //if( mouseButton==37 ){
  //  paths.add( path );
  //  path=null;
  //}
}

void mousePressed() {
  if( mouseButton==37 ) {
    if( !person.attemptSelect( screenX(), screenY() ) ) {
      if( person.selected ) {
        person.setGoal(screenX(),screenY());
      }
    }
  }
  
  
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
