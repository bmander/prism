class Path {
  ArrayList points;
  Path() {
    points = new ArrayList();
  }
  
  void add(float x, float y) {
    this.points.add( new PVector( x, y ) );
  }
  
  void draw() {
    beginShape();
    for(int i=0; i<this.points.size(); i++) {
      PVector pt = (PVector)this.points.get(i);
      vertex( pt.x, pt.y );
    }
    endShape();
  }
}
