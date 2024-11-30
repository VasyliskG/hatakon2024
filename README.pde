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
boolean inCafeteria = false; // Флаг для перевірки, чи в їдальні
boolean classChoiceMade = false; // Флаг для перевірки, чи був зроблений вибір у класі
boolean loading = false; // Флаг для інтерфейсу загрузки
int loadingStartTime; // Час початку загрузки

color dormColor = color(0, 0, 255); //гуртожиток
color collegeColor = color(150, 150, 150); // коледж
color cafeteriaColor = color(255, 255, 0); // їдальня

String[] products = {"Яблуко", "Банан", "Сендвіч"}; // Продукти, що можна купити

void setup() {
  size(1200, 650); 
  playerX = 50; // студент біля гуртожитку
  playerY = height - 150; // Стартова позиція гравця
}

void draw() {
  if (!gameStarted) {
    drawMainScreen();
  } else if (loading) {
    drawLoadingScreen();
  } else {
    if (inClass) {
      drawClassScene();  // Якщо в класі, малюємо клас
    } else if (inCafeteria) {
      drawCafeteriaScene();
    } else {
      drawGameScene();
    }
    drawHUD();
    updateResources();
    checkEndOfDay();
  }
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
    if (inClass && !classChoiceMade) {
      if (key == 'l') { // Вибір залишити клас
        leaveClass();
      } else if (key == 's') { // Вибір слухати вчительку
        startListeningToTeacher();
      }
    } else if (inCafeteria) {
      if (key == 'e') { // Вибір взаємодіяти з продавцем
        interactWithSeller();
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

  if (playerX > 350 && playerX < 350 + 250 * 1.25 && playerY > 120 && playerY < 120 + 200 * 1.25) {
    enterClass();
  } else if (playerX > 600 && playerX < 600 + 200 && playerY > 200 - 75 && playerY < 200 + 125) {
    enterCafeteria();
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

void drawCafeteriaScene() {
  background(200);
  fill(cafeteriaColor);
  rect(0, 0, width, height);

  fill(255, 220, 150); // Продавець
  ellipse(600, 300, 40, 40);
  fill(0, 0, 0);
  rect(580, 320, 40, 60);

  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Ви в їдальні!", width / 2, height / 2 - 100);

  textSize(20);
  text("Натисніть 'E', щоб взаємодіяти з продавцем", width / 2, height / 2 + 20);
}

void drawLoadingScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Загрузка...", width / 2, height / 2);

  if (millis() - loadingStartTime >= 10000) { // 10 секунд пройшло
    loading = false;
    listenToTeacher();
  }
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

  fill(100, 50, 0);
  rect(450, 250, 60, 50);

  fill(0);
  textSize(18);
  textAlign(CENTER);
  text("Коледж", 475 + 250 * 0.625, 270);
}

void drawCafeteria() {
  fill(cafeteriaColor);
  rect(600 + 100, 200 - 75, 200, 200);

  fill(100, 50, 0);
  triangle(600 + 100, 200 - 75, 600 + 100 + 200, 200 - 75, 600 + 100 + 100, 200 - 75 - 30);

  fill(255);
  rect(650 + 100, 230 - 75, 40, 40);
  rect(750 + 100, 230 - 75, 40, 40);
  rect(650 + 100, 300 - 75, 40, 40);
  rect(750 + 100, 300 - 75, 40, 40);

  fill(100, 50, 0);
  rect(700 + 100, 350 - 75, 60, 50);

  fill(0, 0, 255);
  textSize(18);
  textAlign(CENTER);
  text("Їдальня", 700 + 100, 370 - 75);
}

void drawPlayer() {
  fill(255, 220, 150);
  ellipse(playerX, playerY - playerHeight / 2, playerWidth, playerWidth);
  fill(0, 0, 255);
  rect(playerX - playerWidth / 2, playerY - playerHeight / 2, playerWidth, playerHeight);
}

void drawHUD() {
  fill(0);
  textSize(16);
  textAlign(LEFT);
  text("Енергія: " + energy, 10, 20);
  text("Увага: " + attention, 10, 40);
  text("Час: " + (timePassed / 60) + ":" + nf(timePassed % 60, 2), 10, 60);
}

void updateResources() {
  if (frameCount % 60 == 0) {
    timePassed++;

    if (timePassed % 10 == 0) {
      attention = max(attention - 1, 0);
      energy = max(energy - 2, 0);
    }

    if (continuousRunning >= 15) {
      energy = max(energy - 0.1, 0);
      attention = max(attention - 0.035, 0);
      continuousRunning = 0;
    }
  }
}

void checkEndOfDay() {
  if (timePassed >= 1200) { 
    gameStarted = false; 
    drawEndScreen();
  }
}

void drawEndScreen() {
  background(0, 100, 200);
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("День завершено!", width / 2, height / 2 - 20);
  textSize(16);
  text("Дякуємо за гру!", width / 2, height / 2 + 20);
}

void enterClass() {
  inClass = true;
  classChoiceMade = false;
}

void leaveClass() {
  inClass = false;
  timePassed += 60;
  classChoiceMade = true;
  playerX = 50;
  playerY = height - 150;
}

void startListeningToTeacher() {
  loading = true;
  loadingStartTime = millis();
}

void listenToTeacher() {
  inClass = false;
  timePassed += 300;
  classChoiceMade = true;
  playerX = 50;
  playerY = height - 150;
}

void enterCafeteria() {
  inCafeteria = true;
}

void interactWithSeller() {
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text("Продукти:", width / 2, height / 2 - 50);
  for (int i = 0; i < products.length; i++) {
    text(products[i], width / 2, height / 2 - 20 + i * 30);
  }
}
