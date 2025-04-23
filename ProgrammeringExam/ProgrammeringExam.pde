// Klimaspil i Processing - Forbedret version

// Globale variabler
float penge = 100;
float co2 = 0;
ArrayList<String> energikilder;

void setup() {
  size(1000, 800);
  frameRate(60);
  energikilder = new ArrayList<String>();
  energikilder.add("solcelle"); // Starter med én solcelle
}

void draw() {
  background(227);
  opdaterSpil();
  tegnGUI();
}

void opdaterSpil() {
  for (String e : energikilder) {
    if (e.equals("solcelle")) {
      penge += 0.5;
      co2 += 0.01;
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
  textSize(32);
  text("CO2-udslip: " + nf(co2, 1, 2), width - 350, 40);
  text("Penge: " + int(penge), 50, 40);
  text("Antal solceller: " + energikilder.size(), 50, 90);

  // Knap til at købe ny solcelle
  fill(150, 200, 150);
  rect(50, height - 100, 200, 60, 10); // Rund hjørner
  fill(0);
  textSize(20);
  text("Køb Solcelle (100 kr)", 60, height - 60);
}

void mousePressed() {
  if (mouseX > 50 && mouseX < 250 && mouseY > height - 100 && mouseY < height - 40) {
    if (penge >= 100) {
      penge -= 100;
      energikilder.add("solcelle");
      println("Solcelle tilføjet! Antal: " + energikilder.size());
    } else {
      println("Ikke nok penge!");
    }
  }
}
