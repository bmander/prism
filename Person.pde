class Person {
  float DIAMETER = 0.5;
  float FAT_ENERGY_DENSITY = 37; //kJ/g

  float x;
  float y;
  float goalx;
  float goaly;
  float speed=0.9; //m/s
  PVector velocity=null;
  boolean selected=false;
  boolean dead=false;
  
  float base_weight;
  float fat_weight;
  float burnrate=10000.0; //kJ/day
  
  float lastUpdate;
  
  Person(float x, float y,float days,float weight, float bodyfat) {
    this.x = x;
    this.y = y;
    this.lastUpdate = days;
    
    this.base_weight = weight*(1-bodyfat);
    this.fat_weight = weight*(bodyfat);
  }
  
  Person(float x, float y,float days) {
    this( x, y, days, 75, 0.25 );
  }
  
  float bodyfat() {
    return fat_weight/weight();
  }
  float weight() {
    return base_weight+fat_weight;
  }
  
  void update(float days, ArrayList foods){
    if(dead)
      return;
    
    float elapsed = days-lastUpdate;
    
    //change fat
    float energy_out = burnrate*elapsed; //kJ
    float net_energy = -energy_out; //kJ
    float net_fat = net_energy/FAT_ENERGY_DENSITY; //kJ / (kJ/g) = g
        
    this.fat_weight += net_fat/1000.0; //kg
    
    if( fat_weight <= 0 ){
      dead=true;
    }
    
    //set goal
    if(velocity==null){
      setForageGoal( foods );
    }
    
    //move
    if(velocity != null) {
      float elapsedSeconds = elapsed * 3600*24.0;
      PVector displacement = PVector.mult( this.velocity, elapsedSeconds );
      float distFromGoal = dist(this.x,this.y,this.goalx,this.goaly);
      
      if( distFromGoal < displacement.mag() ) {
        this.x = this.goalx;
        this.y = this.goaly;
        velocity=null;
      } else {
        this.x += displacement.x;
        this.y += displacement.y;
      }
    }
    
    lastUpdate = days;
 }
  
  void draw() {
    strokeWeight(0.01);
    if(dead) {
      fill(255,0,0);
      ellipse(this.x,this.y,DIAMETER*0.25,DIAMETER*0.25);
      line(this.x-DIAMETER*0.5*0.25,this.y,this.x+DIAMETER*0.5*0.25,this.y);
      line(this.x,this.y-DIAMETER*0.5*0.25,this.x,this.y+DIAMETER*0.5*0.25);
      return;  
    }
    
    if(this.selected){
      fill(255,220,220);
    }
    
    //draw outer body
    ellipse(this.x,this.y, DIAMETER, DIAMETER);
    
    //draw body fat indicator
    stroke(0,255,0);
    ellipse(this.x,this.y, DIAMETER*bodyfat()*3.9, DIAMETER*bodyfat()*3.9);
    
    //draw goal line
    stroke(0,0,128);
    line(x,y,goalx,goaly);
  }
  
  boolean inside(float x, float y) {
    return dist(x,y,this.x,this.y)<=DIAMETER/2;
  }
  
  boolean attemptSelect( float x, float y ) {
    if( inside( x, y ) ) {
      this.selected = !this.selected;
      return true;
    }
    return false;
  }
  
  void setGoal( float x, float y ) {
    this.goalx = x;
    this.goaly = y;
    
    PVector goal = new PVector(this.goalx-this.x,this.goaly-this.y);
    goal.normalize();
    this.velocity = PVector.mult(goal,speed);
  }
  
  void eat( ArrayList foods ){
    for(int i=0; i<foods.size(); i++) {
      Food food = (Food)foods.get(i);
      if( dist(food.x,food.y,this.x,this.y) < 0.5) {
        float extra_fat = food.energy / FAT_ENERGY_DENSITY; //kJ / (kJ/g) = g
        this.fat_weight += (extra_fat/1000.0); //kg
        println( extra_fat + " " + this.fat_weight );
        foods.remove( food );
      }
    }
  }
  
  void setForageGoal( ArrayList foods ) {
    //find nearest food
    float nearest = 10000000000.0;
    Food winner = null;
    for(int i=0; i<foods.size(); i++) {
      Food food = (Food)foods.get(i);
      float fdist = dist(this.x,this.y,food.x,food.y);
      if( fdist < nearest ) {
        winner = food;
        nearest = fdist;
      } 
    }
    
    if( winner != null )
      this.setGoal(winner.x,winner.y);
  }
}
