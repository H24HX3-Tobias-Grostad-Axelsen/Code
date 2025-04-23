float penge = 100;
float co2 = 0;
float skovEffekt = 0;

int gridSize = 5;
int cellSize = 120;
EnergyCell[][] grid = new EnergyCell[gridSize][gridSize];

String købsValg = "";
boolean gameOver = false;

void setup() {
  size(1000, 800);
  frameRate(60);

  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j] = new EnergyCell(i, j);
    }
  }
}

void draw() {
  background(227);

  if (!gameOver) {
    opdaterSpil();
  }

  tegnGUI();
  tegnGrid();

  if (gameOver) {
    fill(255, 0, 0);
    textSize(80);
    textAlign(CENTER);
    text("JORDEN ER ØDELAGT!", width / 2, height / 2);
    textAlign(LEFT);
  }
}

void opdaterSpil() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j].generate();
    }
  }

  co2 -= skovEffekt;
  if (co2 < 0) co2 = 0;

  if (co2 >= 1000) {
    gameOver = true;
    noLoop();
  }
}

void tegnGUI() {
  fill(0);
  textSize(28);
  text("CO2-udslip: " + nf(co2, 1, 2), width - 300, 40);
  text("Penge: " + int(penge), 50, 40);

  String[] energikilder = {
    "solcelle", "vindmolle", "vandkraft", "kulkraft", "atomkraft"
  };

  float[] priser = {
    100, 150, 200, 80, 300
  };

  for (int i = 0; i < energikilder.length; i++) {
    fill(købsValg.equals(energikilder[i]) ? color(255, 200, 200) : color(150, 200, 150));
    rect(50, 100 + i * 70, 200, 50, 10);
    fill(0);
    textSize(18);
    text("Køb " + energikilder[i] + " (" + int(priser[i]) + " kr)", 60, 130 + i * 70);
  }

  // Knap til at plante skov
  fill(color(180, 255, 180));
  rect(50, 100 + energikilder.length * 70, 200, 50, 10);
  fill(0);
  textSize(18);
  text("Plant skov (-CO2) (200 kr)", 60, 130 + energikilder.length * 70);

  if (!købsValg.equals("")) {
    fill(0);
    textSize(16);
    text("Klik på et felt i griden for at placere din " + købsValg, 50, 500);
  }
}

void tegnGrid() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j].display();
    }
  }
}

void mousePressed() {
  if (gameOver) return;

  String[] energikilder = {
    "solcelle", "vindmolle", "vandkraft", "kulkraft", "atomkraft"
  };
  float[] priser = {
    100, 150, 200, 80, 300
  };

  for (int i = 0; i < energikilder.length; i++) {
    if (mouseX > 50 && mouseX < 250 && mouseY > 100 + i * 70 && mouseY < 150 + i * 70) {
      if (penge >= priser[i]) {
        købsValg = energikilder[i];
      } else {
        println("Ikke nok penge til " + energikilder[i]);
      }
      return;
    }
  }

  // Klik på skov-knappen
  if (mouseX > 50 && mouseX < 250 && mouseY > 100 + energikilder.length * 70 && mouseY < 150 + energikilder.length * 70) {
    if (penge >= 200) {
      penge -= 200;
      skovEffekt += 0.5;
    } else {
      println("Ikke nok penge til at plante skov");
    }
    return;
  }

  if (!købsValg.equals("")) {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isHovered(mouseX, mouseY) && !grid[i][j].occupied) {
          grid[i][j].place(købsValg);
          float pris = 100;
          if (købsValg.equals("vindmolle")) pris = 150;
          if (købsValg.equals("vandkraft")) pris = 200;
          if (købsValg.equals("kulkraft")) pris = 80;
          if (købsValg.equals("atomkraft")) pris = 300;

          penge -= pris;
          købsValg = "";
          return;
        }
      }
    }
  }
}

class EnergyCell {
  int x, y;
  boolean occupied = false;
  String type = "";

  EnergyCell(int gridX, int gridY) {
    x = gridX * cellSize + 300;
    y = gridY * cellSize + 100;
  }

  void place(String t) {
    type = t;
    occupied = true;
    println("Placerede " + type + " på (" + x + ", " + y + ")");
  }

  void generate() {
    if (occupied) {
      switch (type) {
        case "solcelle":
          penge += 0.5;
          co2 += 0.005;
          break;
        case "vindmolle":
          penge += 1;
          co2 += 0.002;
          break;
        case "vandkraft":
          penge += 1.5;
          co2 += 0.001;
          break;
        case "kulkraft":
          penge += 3;
          co2 += 0.5;
          break;
        case "atomkraft":
          penge += 4;
          co2 += 0.05;
          break;
      }
    }
  }

  void display() {
    stroke(0);
    color farve;

    switch (type) {
      case "solcelle":
        farve = color(255, 255, 100);
        break;
      case "vindmolle":
        farve = color(200, 220, 255);
        break;
      case "vandkraft":
        farve = color(100, 200, 255);
        break;
      case "kulkraft":
        farve = color(100, 100, 100);
        break;
      case "atomkraft":
        farve = color(255, 255, 180);
        break;
      default:
        farve = color(240);
    }

    fill(farve);
    rect(x, y, cellSize - 10, cellSize - 10);

    if (occupied) {
      fill(0);
      textSize(16);
      text(type, x + 10, y + 20);
    }
  }

  boolean isHovered(float mx, float my) {
    return mx > x && mx < x + cellSize - 10 && my > y && my < y + cellSize - 10;
  }
}
