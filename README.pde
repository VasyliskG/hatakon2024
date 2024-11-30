boolean gameStarted = false; 
float energy = 100; // (голод)
float attention = 100; // Увага студента
int timePassed = 480; // Час у хвилинах (8:00 ранку)
int continuousRunning = 0; // Лічильник для безперервного бігу

int playerX, playerY;
int playerWidth = 20;
int playerHeight = 40;
float playerSpeed = 2; // Швидкість персонажа (зменшена)

boolean inClass = false; // Флаг для перевірки, чи в класі
boolean classChoiceMade = false; // Флаг для перевірки, чи був зроблений вибір у класі
boolean inDormitory = false; // Флаг для перевірки, чи в гуртожитку
boolean inCafeteria = false; // Флаг для перевірки, чи в їдальні
boolean buyingProduct = false; // Флаг для перевірки, чи купує продукт

color dormColor = color(0, 0, 255); // гуртожиток
color collegeColor = color(150, 150, 150); // коледж
color cafeteriaColor = color(255, 255, 0); // їдальня

void setup() {
  size(1200, 650); 
  playerX = 50; // студент біля гуртожитку
  playerY = height - 150; // Стартова позиція гравця
}

void draw() {
  if (!gameStarted) {
    drawMainScreen();
  } else {
    if (inClass) {
      drawClassScene();  // Якщо в класі, малюємо клас
    } else if (inDormitory) {
      drawDormitoryScene();  // Якщо в гуртожитку, малюємо сцену гуртожитку
    } else if (inCafeteria) {
      if (buyingProduct) {
        drawProductChoice();
      } else {
        drawCafeteriaScene();
      }
    } else {
      drawGameScene();
    }
    drawHUD();
    updateResources();
    checkEndOfDay();
  }
}

void drawHUD() {
  fill(0);
  textSize(16);
  textAlign(LEFT);
  text("Енергія: " + energy, 10, 20);
  text("Увага: " + attention, 10, 40);
  text("Час: " + (timePassed / 60) + ":" + nf(timePassed % 60, 2), 10, 60);
}

void drawMainScreen() {
  background(50, 100, 200);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  text("Студентська мурашина ферма", width / 2, height / 2 - 20);
  textSize(16);
  text("Натисніть 'R', щоб почати день", width / 2, height / 2 + 20);
}

void keyPressed() {
  if (!gameStarted && key == 'r') { // Початок гри на клавішу 'R'
    gameStarted = true;
  }
  
  if (gameStarted) {
    if (inDormitory) {
      if (key == '5') { // Вибір кави
        timePassed += 50; // Витрачається 50 хвилин
        energy += 10; // Підвищення енергії
        attention += 5; // Підвищення уваги
        inDormitory = false; // Повертаємось із гуртожитку
      } else if (key == '7') { // Вибір піти
        timePassed += 10; // Витрачається 10 хвилин
        inDormitory = false; // Повертаємось із гуртожитку
      }
    } else if (inClass && !classChoiceMade) {
      if (key == 'l') { // Вибір залишити клас
        leaveClass();
      } else if (key == 's') { // Вибір слухати вчительку
        listenToTeacher();
      }
    } else if (inCafeteria) {
      if (buyingProduct) {
        if (key == '1') { // Купити булочку
          timePassed += 60;
          buyingProduct = false;
        } else if (key == '2') { // Купити сік
          timePassed += 30;
          buyingProduct = false;
        } else if (key == '3') { // Купити морожинно
          timePassed += 120;
          buyingProduct = false;
        }
      } else {
        if (key == 'e') { // Вибір взаємодіяти з продавцем
          buyingProduct = true;
        } else if (key == 'l') { // Вибір залишити їдальню
          inCafeteria = false;
        }
      }
    } else {
      handlePlayerMovement();
    }
  }
}

void handlePlayerMovement() {
  boolean moved = false;
  if (key == 'w') { playerY -= 5 * playerSpeed; moved = true; }
  if (key == 's') { playerY += 5 * playerSpeed; moved = true; }
  if (key == 'a') { playerX -= 5 * playerSpeed; moved = true; }
  if (key == 'd') { playerX += 5 * playerSpeed; moved = true; }

  playerX = constrain(playerX, 0, width - playerWidth);
  playerY = constrain(playerY, 0, height - playerHeight);

  if (moved) {
    continuousRunning++;
  } else {
    continuousRunning = 0; 
  }

  // Вхід в гуртожиток
  if (playerX > 50 && playerX < 50 + 150 * 2.5 && playerY > height - 150 && playerY < height - 50) {
    inDormitory = true; // Заходимо в гуртожиток
  }

  // Вхід в коледж
  if (playerX > 350 && playerX < 350 + 250 * 1.25 && playerY > 120 && playerY < 120 + 200 * 1.25) {
    enterClass();
  }
  
  // Вхід в їдальню
  if (playerX > 800 && playerX < 800 + 150 * 2 && playerY > 350 && playerY < 350 + 150) {
    inCafeteria = true; // Заходимо в їдальню
  }
}

void drawGameScene() {
  background(200);
  drawDormitory();
  drawCollege();
  drawCafeteria();
  drawPlayer();
}

void drawClassScene() {
  background(200);
  fill(255, 100, 100);
  rect(0, 0, width, height);

  fill(173, 216, 230);
  for (int i = 0; i < 3; i++) {
    rect(100 + i * 250, 50, 200, 100);
  }

  fill(0, 128, 0);
  rect(width / 4, 200, width / 2, 100);

  fill(255, 220, 150);
  ellipse(width / 2, 150, 40, 40);
  fill(0, 0, 0);
  rect(width / 2 - 20, 170, 40, 60);

  fill(139, 69, 19);
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
      rect(150 + j * 200, 350 + i * 100, 150, 50);
    }
  }

  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Ви в класі!", width / 2, height / 2 - 100);

  textSize(20);
  text("Вчителька: ...........", width / 2, height / 2 - 50);

  textSize(16);
  text("Натисніть 'L', щоб піти геть або 'S', щоб слухати", width / 2, height / 2 + 20);
}

void drawDormitoryScene() {
  background(200);
  fill(255, 255, 0);
  textAlign(CENTER);
  textSize(32);
  text("Ви в гуртожитку!", width / 2, height / 2 - 100);

  textSize(20);
  text("Ого, давно не бачились, поп'ємо кави?", width / 2, height / 2);
  
  textSize(16);
  text("Натисніть '5', щоб піти на каву (50 хвилин)", width / 2, height / 2 + 40);
  text("Натисніть '7', щоб піти з гуртожитку (10 хвилин)", width / 2, height / 2 + 60);
}

void drawDormitory() {
  fill(dormColor);
  rect(50, height - 150, 150 * 2.5, 150 * 1.5);

  fill(100, 50, 0);
  triangle(50, height - 150, 50 + 150 * 2.5, height - 150, 50 + 150 * 1.25, height - 150 - 30);

  fill(255);
  rect(80, height - 130, 30, 30);
  rect(120, height - 130, 30, 30);
  rect(80, height - 90, 30, 30);
  rect(120, height - 90, 30, 30);

  fill(100, 50, 0);
  rect(100, height - 50, 30, 50);

  fill(255, 255, 255);
  textSize(18);
  textAlign(CENTER);
  text("Гуртожиток", 125 + 150 * 1.25, height - 160);
}

void drawCollege() {
  fill(collegeColor);
  rect(350, 120, 250 * 1.25, 200 * 1.25);

  fill(100, 50, 0);
  triangle(350, 120, 350 + 250 * 1.25, 120, 350 + 250 * 0.625, 120 - 30);

  fill(255);
  rect(400, 150, 40, 40);
  rect(500, 150, 40, 40);
  rect(400, 200, 40, 40);
  rect(500, 200, 40, 40);

  fill(255, 255, 255);
  textSize(18);
  textAlign(CENTER);
  text("Коледж", 500, 120);
}

void drawCafeteria() {
  fill(cafeteriaColor);
  rect(800, 350, 150 * 2, 150);

  fill(0);
  textAlign(CENTER);
  textSize(18);
  text("Їдальня", 875 + 150, 350 + 10);
}

void drawCafeteriaScene() {
  background(200);
  fill(cafeteriaColor);
  rect(0, 0, width, height);

  fill(255, 220, 150); // Продавець
  ellipse(600, 300, 40, 40);
  fill(0, 0, 0);
  rect(580, 320, 40, 60);

  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Ви в їдальні!", width / 2, height / 2 - 100);

  textSize(20);
  text("Натисніть 'E', щоб взаємодіяти з продавцем", width / 2, height / 2);
  text("Натисніть 'L', щоб залишити їдальню", width / 2, height / 2 + 40);
}

void drawProductChoice() {
  background(200);
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Обери продукт:", width / 2, height / 2 - 100);

  textSize(20);
  text("1. Булочка (60 хв)", width / 2, height / 2 - 50);
  text("2. Сік (30 хв)", width / 2, height / 2);
  text("3. Морожинно (120 хв)", width / 2, height / 2 + 50);
}

void drawPlayer() {
  fill(0, 128, 0);
  rect(playerX, playerY, playerWidth, playerHeight);
}

void updateResources() {
  if (timePassed <= 0) {
    timePassed = 0;
  }
}

void checkEndOfDay() {
  if (timePassed >= 960) { // 16:00
    gameStarted = false;
    textSize(32);
    fill(255, 0, 0);
    text("День закінчено!", width / 2, height / 2);
  }
}

void enterClass() {
  inClass = true;
  classChoiceMade = false;
}

void listenToTeacher() {
  attention += 20;
  timePassed += 20;
  inClass = false;
}

void leaveClass() {
  timePassed += 20;
  inClass = false;
}
