class Person {
  float x;
  float y;
  boolean selected=false;
  
  float DIAMETER = 0.5;
  
  Person(float x, float y) {
    this.x = x;
    this.y = y; 
  }
  
  void draw() {
    if(this.selected){
      fill(255,220,220);
      
    }
    ellipse(this.x,this.y, DIAMETER, DIAMETER);
  }
  
  boolean inside(float x, float y) {
    return dist(x,y,this.x,this.y)<=DIAMETER/2;
  }
  
  void attemptSelect( float x, float y ) {
    if( inside( x, y ) ) {
      this.selected = !this.selected;
    }
  }
}
