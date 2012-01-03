class Person {
  float x;
  float y;

  Person(float x, float y) {
    this.x = x;
    this.y = y; 
  }
  
  void draw() {
    ellipse(this.x,this.y, 0.5, 0.5);
  }
}
