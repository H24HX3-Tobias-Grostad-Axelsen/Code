// Klimaspil med grid-baseret placering

float penge = 100;
float co2 = 0;

int gridSize = 5;
int cellSize = 120;
EnergyCell[][] grid = new EnergyCell[gridSize][gridSize];

boolean køberSolcelle = false;

void setup() {
  size(1000, 800);
  frameRate(60);

  // Initialiser grid
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j] = new EnergyCell(i, j);
    }
  }
}

void draw() {
  background(227);
  opdaterSpil();
  tegnGUI();
  tegnGrid();
}

void opdaterSpil() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j].generate();
    }
  }

  if (co2 >= 1000) {
    textSize(80);
    fill(255, 0, 0);
    text("Jorden er ødelagt!", width/2 - 300, height/2);
    noLoop();
  }
}

void tegnGUI() {
  fill(0);
  textSize(28);
  text("CO2-udslip: " + nf(co2, 1, 2), width - 300, 40);
  text("Penge: " + int(penge), 50, 40);

  // Køb-knap
  fill(køberSolcelle ? color(255, 200, 200) : color(150, 200, 150));
  rect(50, height - 100, 200, 60, 10);
  fill(0);
  textSize(20);
  text(køberSolcelle ? "Klik på felt!" : "Køb Solcelle (100 kr)", 60, height - 60);
}

void tegnGrid() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      grid[i][j].display();
    }
  }
}

void mousePressed() {
  // Køb solcelle-knap
  if (!køberSolcelle && mouseX > 50 && mouseX < 250 && mouseY > height - 100 && mouseY < height - 40) {
    if (penge >= 100) {
      køberSolcelle = true;
    } else {
      println("Ikke nok penge!");
    }
  }
  // Hvis man vil placere en solcelle
  else if (køberSolcelle) {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j].isHovered(mouseX, mouseY) && !grid[i][j].occupied) {
          grid[i][j].place("solcelle");
          penge -= 100;
          køberSolcelle = false;
          return;
        }
      }
    }
  }
}

// Klasse til grid-celler
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
    if (occupied && type.equals("solcelle")) {
      penge += 0.5;
      co2 += 0.01;
    }
  }

  void display() {
    stroke(0);
    fill(occupied ? color(255, 255, 100) : 240);
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
