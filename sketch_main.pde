import processing.pdf.*;

boolean isPrinting = false;
boolean isPaused = false;

void setup() {
  size(1500, 1000);
}

void draw() {
  // Here it checks whether the application is not busy with printing, also if it is not paused by the user
  if (!isPrinting) {
    if (!isPaused) {
      drawScene();
    }
  }
}

void drawScene() {
    drawSky();
    drawSun();
    drawField();
    drawWindmill();
}


//////////////////////////////////////////////////////////////////////////
/////////////////       HANDLING KEYBOARD EVENTS        //////////////////
//////////////////////////////////////////////////////////////////////////
void keyPressed() {
  // Print the vector pdf by presing the P key
  if (key == 'p' || key == 'P') {
    println("Printing PDF...");
    isPrinting = true;
    beginRecord(PDF, "output.pdf");
    drawScene();
    endRecord();
    isPrinting = false;
    println("PDF saved as output.pdf");
  }
  
  
  // Animation pauses and resumes by pressing the spacebar
  if (key == ' ') {
    isPaused = !isPaused;
    println(isPaused ? "Animation Paused" : "Animation Resumed");
  }
}



//////////////////////////////////////////////////////////////////////////
/////////////////            DRAW THE SKY               //////////////////
//////////////////////////////////////////////////////////////////////////

void drawSky() {
  // inspired by: https://processing.org/examples/lineargradient.html
  color c1 = #90C8FF, c2 = #FDFFBF;
  for (int i = 0; i <= 400; i++) {
    stroke(lerpColor(c1, c2, map(i, 0, 400, 0, 1)));
    line(0, i, width, i);
  }
}


//////////////////////////////////////////////////////////////////////////
/////////////////            DRAW THE SUN               //////////////////
//////////////////////////////////////////////////////////////////////////

void drawSun() {
  noStroke();
  fill(#F6FF0A, 300);
  circle(width / 2, 400, 100);
  
  // I used this trick to create the sun halo, starts from biggest halo and increases the circle size and the opacity
  int opacity = 10;
  for (int i = 1000; i >= 100; i -= 60) {
    fill(#F6FF0A, opacity++);
    circle(width / 2, 400, i);
  }
}


//////////////////////////////////////////////////////////////////////////
/////////////    DRAW THE FLOWER THE FIELDS & STREET    //////////////////
//////////////////////////////////////////////////////////////////////////
void drawField() {
  noStroke();
  
  color[] fieldColors = {
    #0D930C, #FFC95D, #FF0A99, #0D930C, #AD0303, #FF7CC8, #6E60AD, #0FA22B
  };
  
  int[] fieldHeights = {15, 40, 45, 20, 70, 70, 80, 40};
  int yPosition = 400;
  
  for (int i = 0; i < fieldColors.length; i++) {
    randomSeed(i + 1);
    drawFlowerLane(0, yPosition, width, fieldHeights[i], fieldColors[i]);
    yPosition += fieldHeights[i];
  }
  
  drawStreet(760);
  
  randomSeed(9);
  drawFlowerLane(0, 910, width, 90, #0FA22B);
}


//////////////////////////////////////////////////////////////////////////
/////////////////        DRAW EACH FLOWER LANE          //////////////////
//////////////////////////////////////////////////////////////////////////
void drawFlowerLane(int x, int y, int w, int h, color laneColor) {
  fill(laneColor);
  rect(x, y, w, h);
  
  addNoise(x, y, w, h, #FFFFFF, 100);
  addNoise(x, y, w, h, #0B6F1E, 100);
  
  if (h > 50) {
    addSeparator(y, w, h, true);
  }
  addSeparator(y, w, h, false);
}

//////////////////////////////////////////////////////////////////////////
///////////////       ADD THE NOISE TO LOOK NATURAL        ///////////////
//////////////////////////////////////////////////////////////////////////
void addNoise(int x, int y, int w, int h, color c, int alphaValue) {
  // This part is inspired from https://processing.org/examples/pointillism.html
  fill(c, alphaValue);
  noStroke();
  for (int i = 0; i < 1000; i++) {
    ellipse(random(x, x + w), random(y, y + h), 2, 3);
  }
}


// This add noise between the lanes
void addSeparator(int y, int w, int h, boolean central) {
  fill(0, 50);
  noStroke();
  int count = 500;
  float centerY = y + h / 2;

  for (int i = 0; i < count; i++) {
    float px = random(0, w);
    float py;

    // Here, I used randomGaussian function to distribute noise arround a line
    // The if statement check whether to apply it in the center or in the margin of the field
    // Also, used constrain function to add a boundary for the generated dots 
    if (central) {
      py = constrain(centerY + randomGaussian() * 4, y, y + h);
    } else {
      py = constrain(y + randomGaussian() * 5, y, y + h);
    }

    ellipse(px, py, 3, 3);
  }
}


//////////////////////////////////////////////////////////////////////////
/////////////////          DRAW THE STREET          //////////////////
//////////////////////////////////////////////////////////////////////////
void drawStreet(int y) {
  // Draw left bike lane
  fill(#B24242);
  rect(0, y, width, 25);
  drawDashedLine(-4, y + 20, 15, 3, #FFFFFF);

  // Draw main car lane
  fill(#989898);
  rect(0, y + 25, width, 100);
  drawDashedLine(1, y + 67, 15, 7, #FFFFFF);

  // Draw right bike lane
  fill(#B24242);
  rect(0, y + 120, width, 30);
  drawDashedLine(2, y + 122, 15, 3, #FFFFFF);
}

//////////////////////////////////////////////////////////////////////////
/////////////////        DRAW THE STREET LINES          //////////////////
//////////////////////////////////////////////////////////////////////////

void drawDashedLine(int startX, int y, int segmentWidth, int segmentHeight, int lineColor) {
  fill(lineColor);
  for (int i = startX; i < width; i += 25) {
    rect(5 + i, y, segmentWidth, segmentHeight);
  }
}


//////////////////////////////////////////////////////////////////////////
/////////////////          DRAW THE WINDMILL            //////////////////
//////////////////////////////////////////////////////////////////////////

float angle = 0;
void drawWindmill() {
  int baseX = width - 300;
  int baseY = 400;
  int towerWidth = 60;
  int towerHeight = 150;
  int bladeLength = 100;
  
  fill(#504A4A);
  rect(baseX, baseY - towerHeight, towerWidth, towerHeight);
  
  triangle(baseX - 20, baseY, baseX + towerWidth / 2, towerHeight + 70, baseX + towerWidth + 20, baseY);
  triangle(baseX, towerHeight + 100, baseX + towerWidth / 2, towerHeight + 70, baseX + towerWidth, towerHeight + 100);
  
  drawWindmillWindow(baseX, baseY);
  
  pushMatrix();
  translate(baseX + towerWidth / 2, baseY - towerHeight);
  rotate(angle);
  drawBlade(0, 0, bladeLength);
  popMatrix();
  
  fill(#6D6D6D);
  ellipse(baseX + towerWidth / 2, baseY - towerHeight, 10, 10);
  
  angle += 0.02;
}


//////////////////////////////////////////////////////////////////////////
/////////////////      DRAW THE WINDMILL'S WINDOW       //////////////////
//////////////////////////////////////////////////////////////////////////

void drawWindmillWindow(int baseX, int baseY) {
  stroke(#FFFFFF);
  fill(#124AB7);
  rect(baseX + 15, baseY - 100, 30, 30);
  line(baseX + 30, baseY - 100, baseX + 30, baseY - 70);
  line(baseX + 15, baseY - 85, baseX + 45, baseY - 85);
}


//////////////////////////////////////////////////////////////////////////
////////////////       DRAW THE WINDMILL'S BLADES       //////////////////
//////////////////////////////////////////////////////////////////////////

void drawBlade(float x, float y, int length) {
  // This part is inspired from the clock exercise from the class
  fill(#FFFFFF);
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    rotate(PI / 2 * i);
    stroke(0);
    fill(#FFFFFF, 300);
    rect(x, y - 2, length, 10);
    fill(#FFFFFF, 100);
    rect(x + 20, y - 20, length - 20, 20);
    popMatrix();
  }
}
