class Landscape {
 float ll,bb,rr,tt;
 
 float area;
 float productivity, fertility;
 float packetsize;
 float lastYield;

 Landscape(float ll, float bb, float rr, float tt, float days) {
   this.ll = ll;
   this.bb = bb;
   this.rr = rr;
   this.tt = tt;
   
   this.fertility = 46000.0; //(kJ/day)/km^2
   this.area = ((rr-ll)/1000.0)*((tt-bb)/1000.0); // km^2
   this.productivity = this.fertility*this.area; // kJ/day
   this.packetsize=100.0; //kJ;
   
   this.lastYield = days;
 }
 
 void draw() {
   fill(240,255,240);
   rect(this.ll,this.bb,(this.rr-this.ll),(this.tt-this.bb));
 }
 
 ArrayList yield(float days) {
   float dt = days-lastYield;
   
   float yld = dt*this.productivity; //kJ
   
   if( yld < packetsize ) {
     return new ArrayList();
   }
   
   ArrayList ret = new ArrayList();
   if(yld<packetsize) {
       float x = random(this.ll,this.rr);
       float y = random(this.bb,this.tt);
     ret.add( new Food(x,y,yld) );
   } else {
     for(int i=0; i<yld/packetsize; i++) {
       float x = random(this.ll,this.rr);
       float y = random(this.bb,this.tt);
       ret.add( new Food(x,y,packetsize) );
     }
   }
   
   lastYield = days;
   return ret;
 }
}

class Food {
  float x,y;
  float energy;
  
  Food(float x, float y, float energy){
    this.x=x;
    this.y=y;
    this.energy = energy;
  }
  
  void draw() {
    strokeWeight(0.25);
    point( x, y);
  }
}
