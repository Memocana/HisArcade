import processing.serial.*;
Ball ball;
Pong pong1 = new Pong('R', 'L', 0); //Arduino'ya attığınız koddaki print bu harfleri print etmeli
Pong pong2 = new Pong('R', 'L', 1); //Harfleri değiştirebilirsiniz klavyede kolay olur diye bunlar
int points[] = {
  0, 0
};

Serial myPort;
Serial myPort2;
String val[] = {
  "null", "null"
};

class Pong {
  int y = 210;
  char up, down; //atadığınız harfleri handle eder
  int player; // 0 Player1, 1 Player2 için
  Pong (char tup, char tdown, int tp) {
    up = tup;
    down = tdown;
    player = tp;
  }

  void move () {
    if (keyPressed || !(val[player].charAt(0) == 'n')) {
      if ((key == down || val[player].charAt(0) == down) && y < height - 40)
        y+=6;
      if ((key == up || val[player].charAt(0) == up) && y > -10)
        y-=6;
    }
  }
  void drawPong () {
    rect(50 + player * (width - 110), y, 15, 80);
  }
}

class Ball {
  int x;
  int y;
  int moveUp = -4; 
  int moveRight = 4;  
  Ball () {
    x = width / 2;
    y = (int) random (50, height - 50);
  }
  void check(Pong pong1, Pong pong2) {
    if ((x < 76 && x > 68 && y > pong1.y && y < pong1.y + 85)|| (x < width - 68 && x > width - 76 && y > pong2.y && y < pong2.y + 85)) {
      moveRight *= -1;
      if (x < width / 2) {
        if ((key == pong1.down || val[pong1.player].charAt(0) == pong1.down) && moveUp > 0) {
          moveUp++;
        }
        if ((key == pong1.up || val[pong1.player].charAt(0) == pong1.up) && moveUp > 3) {
          moveUp--;
        }
        if ((key == pong1.down || val[pong1.player].charAt(0) == pong1.down) && moveUp < 0) {
          moveUp++;
        }
        if ((key == pong1.up || val[pong1.player].charAt(0) == pong1.up) && moveUp < -3) {
          moveUp--;
        }
      } else {
        if ((key == pong2.down || val[pong2.player].charAt(0) == pong2.down) && moveUp > 0) {
          moveUp++;
        }
        if ((key == pong2.up || val[pong2.player].charAt(0) == pong2.up) && moveUp > 1) {
          moveUp--;
        }
        if ((key == pong2.down || val[pong2.player].charAt(0) == pong2.down) && moveUp < 0) {
          moveUp++;
        }
        if ((key == pong2.up || val[pong2.player].charAt(0) == pong2.up) && moveUp < -1) {
          moveUp--;
        }
      }
    } else if  (x < 30) {
      x = width /2;
      y = (int) random (50, height - 50);
      moveUp = 4;
      moveRight *= -1;
      points[pong2.player]++;
      delay(1000);
    } else if  (x > width - 30) {
      x = width /2;
      y = (int) random (50, height - 50);
      moveUp = 4;
      moveRight *= -1;
      points[pong1.player]++;
      delay(1000);
    }
    if (y < 20 || y > height - 20) {
      moveUp *= -1;
    }
  }
  void move(Pong pong1, Pong pong2) {
    check(pong1, pong2);
    if (y < height) {
      y += moveUp;
      x += moveRight;
    }
  }
  void drawBall () {
    ellipse(x, y, 20, 20);
  }
  void didWin() {
    if (points[0] == 3) {
      textSize(44);
      text ("Player 1 Wins!", width / 2 - 140, height / 2);
    }
    if (points[1] == 3) {
      textSize(44);
      text ("Player 2 Wins!", width / 2 - 140, height / 2);
    }
  }
  void didQuit() {
    if (points[0] == 3) {
      delay(1000);
      exit();
    }
    if (points[1] == 3) {
      delay(1000);
      exit();
    }
  }
}

//öncesi kurulma

void setup() {
  size(1280, 720);
  String portName = Serial.list()[1]; //bunu 0 - 1 -2 diye deneriz
  myPort = new Serial(this, portName, 9600);
 
  portName = Serial.list()[0]; //bunu 0 - 1 -2 diye deneriz
  myPort2 = new Serial(this, portName, 9600);
  
  
  ball = new Ball();
}

//oyun

void draw() {
  //noLoop();
  if (myPort.available() > 0) {
    val[0] = myPort.readStringUntil('\n') + 'a';
  }
  
  if (myPort2.available() > 0) {
    val[1] = myPort2.readStringUntil('\n') + 'a';
  }
  

  

  ball.didQuit();
  background(0);
  
  for (int i = 0; i < height; i += height / 24) {
    if (((i / 10) % 2) == 0) {
      rect (width / 2 - 10, i, 20, height / 24);
    }
  }
  
  textSize(24);
  pong1.drawPong();
  pong2.drawPong();
  ball.drawBall();
  pong1.move();
  pong2.move();
  ball.move(pong1, pong2);
  textSize(30);
  text(points[0], 180, 30);
  text(points[1], width - 210, 30);

  ball.didWin();
}
