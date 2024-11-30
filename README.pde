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

color dormColor = color(0, 0, 255); //гуртожиток
color collegeColor = color(150, 150, 150); // коледж
color cafeteriaColor = color(255, 255, 0); // їдальня

// Початковий екран
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
    } else {
      drawGameScene();
    }
    drawHUD();
    updateResources();
    checkEndOfDay();
  }
}

// Малювання головного екрану
void drawMainScreen() {
  background(50, 100, 200);
  textAlign(CENTER);
  fill(255);
  textSize(32);
  text("Студентська мурашина ферма", width / 2, height / 2 - 20);
  textSize(16);
  text("Натисніть 'R', щоб почати день", width / 2, height / 2 + 20);
}

// Запуск гри та обробка руху гравця
void keyPressed() {
  if (!gameStarted && key == 'r') { // Початок гри на клавішу 'R'
    gameStarted = true;
  }
  
  if (gameStarted) {
    boolean moved = false;
    if (key == 'w') { playerY -= 5 * playerSpeed; moved = true; } // Рух вгору
    if (key == 's') { playerY += 5 * playerSpeed; moved = true; } // Рух вниз
    if (key == 'a') { playerX -= 5 * playerSpeed; moved = true; } // Рух вліво
    if (key == 'd') { playerX += 5 * playerSpeed; moved = true; } // Рух вправо

    // Обмеження руху на межах екрану
    playerX = constrain(playerX, 0, width - playerWidth);
    playerY = constrain(playerY, 0, height - playerHeight);

    if (moved) {
      continuousRunning++;
    } else {
      continuousRunning = 0; 
    }

    // Перевірка на дотик до коледжу
    if (playerX > 350 && playerX < 350 + 250 * 1.25 && playerY > 120 && playerY < 120 + 200 * 1.25) {
      enterClass();
    }
  }
}

void drawGameScene() {
  background(200);

  // Гуртожиток
  drawDormitory();
  // Коледж
  drawCollege();
  // Їдальня
  drawCafeteria();

  // Малювання персонажа
  drawPlayer();
}

void drawClassScene() {
  background(200);  // Після переходу в клас, замальовуємо старий фон

  fill(255, 100, 100); // Колір класу (або будь-який інший)
  rect(0, 0, width, height);  // Малюємо фон класу

  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("Ви в класі!", width / 2, height / 2);
}

// Малювання гуртожитку
void drawDormitory() {
  fill(dormColor);
  rect(50, height - 150, 150 * 2.5, 150 * 1.5); // Збільшений гуртожиток

  // Дах гуртожитку
  fill(100, 50, 0); // Колір даху
  triangle(50, height - 150, 50 + 150 * 2.5, height - 150, 50 + 150 * 1.25, height - 150 - 30);

  // Декор гуртожитку
  fill(255); // Вікна
  rect(80, height - 130, 30, 30);
  rect(120, height - 130, 30, 30);
  rect(80, height - 90, 30, 30);
  rect(120, height - 90, 30, 30);

  fill(100, 50, 0); // Двері
  rect(100, height - 50, 30, 50);

  // Назва будівлі
  fill(255, 255, 255); // Колір тексту
  textSize(18);
  textAlign(CENTER);
  text("Гуртожиток", 125 + 150 * 1.25, height - 160);
}

// Малювання коледжу
void drawCollege() {
  fill(collegeColor);
  rect(350, 120, 250 * 1.25, 200 * 1.25); // Збільшений коледж

  // Дах коледжу
  fill(100, 50, 0); // Колір даху
  triangle(350, 120, 350 + 250 * 1.25, 120, 350 + 250 * 0.625, 120 - 30);

  // Декор коледжу
  fill(255); // Вікна
  rect(400, 150, 40, 40);
  rect(500, 150, 40, 40);
  rect(400, 200, 40, 40);
  rect(500, 200, 40, 40);

  fill(100, 50, 0); // Двері
  rect(450, 250, 60, 50);

  // Назва будівлі
  fill(0); // Колір тексту
  textSize(18);
  textAlign(CENTER);
  text("Коледж", 475 + 250 * 0.625, 270);
}

// Малювання їдальні
void drawCafeteria() {
  fill(cafeteriaColor);
  rect(600 + 100, 200 - 75, 200, 200); // Їдальня

  // Дах їдальні
  fill(100, 50, 0); // Колір даху
  triangle(600 + 100, 200 - 75, 600 + 100 + 200, 200 - 75, 600 + 100 + 100, 200 - 75 - 30);

  // Декор їдальні
  fill(255); // Вікна
  rect(650 + 100, 230 - 75, 40, 40);
  rect(750 + 100, 230 - 75, 40, 40);
  rect(650 + 100, 300 - 75, 40, 40);
  rect(750 + 100, 300 - 75, 40, 40);

  fill(100, 50, 0); // Двері
  rect(700 + 100, 350 - 75, 60, 50);

  // Назва будівлі
  fill(0, 0, 255); // Колір тексту
  textSize(18);
  textAlign(CENTER);
  text("Їдальня", 700 + 100, 370 - 75);
}

// Малювання персонажа (студент)
void drawPlayer() {
  fill(255, 220, 150); // Голова
  ellipse(playerX, playerY - playerHeight / 2, playerWidth, playerWidth);
  fill(0, 0, 255); // Тіло
  rect(playerX - playerWidth / 2, playerY - playerHeight / 2, playerWidth, playerHeight);
}

// Панель ресурсів (HUD)
void drawHUD() {
  fill(0);
  textSize(16);
  textAlign(LEFT);
  text("Енергія: " + energy, 10, 20);
  text("Увага: " + attention, 10, 40);
  text("Час: " + (timePassed / 60) + ":" + nf(timePassed % 60, 2), 10, 60);
}

// Оновлення ресурсів кожні 10 хвилин
void updateResources() {
  if (frameCount % 60 == 0) { // Лічильник часу (1 сек = 1 хв у грі)
    timePassed++;

    // Зменшуємо увагу і енергію кожні 10 ігрових хвилин
    if (timePassed % 10 == 0) {
      attention = max(attention - 1, 0); // Зменшується на 1
      energy = max(energy - 2, 0); // Зменшується на 2
    }

    // Якщо персонаж безперервно рухався 15 хвилин, витрачаємо додаткову енергію
    if (continuousRunning >= 15) {
      energy = max(energy - 0.1, 0);
      attention = max(attention - 0.035, 0);
      continuousRunning = 0; // Скидаємо лічильник бігу
    }
  }
}

// Перевірка завершення дня
void checkEndOfDay() {
  if (timePassed >= 1200) { 
    gameStarted = false; 
    drawEndScreen();
  }
}

// Екран завершення дня
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
  inClass = true;  // Перемикаємо флаг, щоб показати клас
}
