// Configuració del Canvas
const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

// Elements de la interfície
const scoreEl = document.getElementById('score');
const highScoreEl = document.getElementById('high-score');
const overlay = document.getElementById('overlay');
const overlayTitle = document.getElementById('overlay-title');
const overlayMsg = document.getElementById('overlay-msg');
const startBtn = document.getElementById('start-btn');

// Constants del Joc
const GRID_SIZE = 20;
const TILE_COUNT = canvas.width / GRID_SIZE;
const INITIAL_SPEED = 120; // ms per moviment

// Variables de l'Estat del Joc
let snake = [];
let food = { x: 0, y: 0 };
let dx = 1;
let dy = 0;
let nextDx = 1;
let nextDy = 0;
let score = 0;
let highScore = localStorage.getItem('snake_high_score') || 0;
let gameInterval = null;
let isRunning = false;

highScoreEl.textContent = highScore;

// --- Efectes de So amb Web Audio API ---
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

function playSound(type) {
  if (audioCtx.state === 'suspended') {
    audioCtx.resume();
  }
  const osc = audioCtx.createOscillator();
  const gain = audioCtx.createGain();
  osc.connect(gain);
  gain.connect(audioCtx.destination);

  if (type === 'eat') {
    osc.type = 'square';
    osc.frequency.setValueAtTime(300, audioCtx.currentTime);
    osc.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.08);
    gain.gain.setValueAtTime(0.1, audioCtx.currentTime);
    gain.gain.linearRampToValueAtTime(0.01, audioCtx.currentTime + 0.08);
    osc.start();
    osc.stop(audioCtx.currentTime + 0.08);
  } else if (type === 'die') {
    osc.type = 'sawtooth';
    osc.frequency.setValueAtTime(180, audioCtx.currentTime);
    osc.frequency.exponentialRampToValueAtTime(40, audioCtx.currentTime + 0.3);
    gain.gain.setValueAtTime(0.2, audioCtx.currentTime);
    gain.gain.linearRampToValueAtTime(0.01, audioCtx.currentTime + 0.3);
    osc.start();
    osc.stop(audioCtx.currentTime + 0.3);
  }
}

// --- Lògica del Joc ---

function initGame() {
  snake = [
    { x: 10, y: 10 },
    { x: 9, y: 10 },
    { x: 8, y: 10 }
  ];
  dx = 1;
  dy = 0;
  nextDx = 1;
  nextDy = 0;
  score = 0;
  scoreEl.textContent = score;
  spawnFood();
}

function spawnFood() {
  let valid = false;
  while (!valid) {
    food.x = Math.floor(Math.random() * TILE_COUNT);
    food.y = Math.floor(Math.random() * TILE_COUNT);
    valid = !snake.some(segment => segment.x === food.x && segment.y === food.y);
  }
}

function startGame() {
  initGame();
  overlay.classList.add('hidden');
  isRunning = true;
  if (gameInterval) clearInterval(gameInterval);
  gameInterval = setInterval(gameLoop, INITIAL_SPEED);
}

function gameOver() {
  isRunning = false;
  clearInterval(gameInterval);
  playSound('die');

  if (score > highScore) {
    highScore = score;
    localStorage.setItem('snake_high_score', highScore);
    highScoreEl.textContent = highScore;
  }

  overlayTitle.textContent = "GAME OVER";
  overlayTitle.style.color = "#ff0055";
  overlayMsg.textContent = `PUNTUACIÓ: ${score}`;
  startBtn.textContent = "TORNAR A JUGAR";
  overlay.classList.remove('hidden');
}

function gameLoop() {
  dx = nextDx;
  dy = nextDy;

  const head = { x: snake[0].x + dx, y: snake[0].y + dy };

  // Col·lisió amb les parets
  if (head.x < 0 || head.x >= TILE_COUNT || head.y < 0 || head.y >= TILE_COUNT) {
    return gameOver();
  }

  // Col·lisió amb el propi cos
  if (snake.some(segment => segment.x === head.x && segment.y === head.y)) {
    return gameOver();
  }

  snake.unshift(head);

  // Menjar la poma
  if (head.x === food.x && head.y === food.y) {
    score += 10;
    scoreEl.textContent = score;
    playSound('eat');
    spawnFood();
  } else {
    snake.pop();
  }

  draw();
}

// --- Dibuix i Gràfics ---

function draw() {
  // Fons fosc estil pantalla arcade
  ctx.fillStyle = '#020617';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Grella de fons molt subtil
  ctx.strokeStyle = '#0f172a';
  ctx.lineWidth = 1;
  for (let i = 0; i < TILE_COUNT; i++) {
    ctx.beginPath();
    ctx.moveTo(i * GRID_SIZE, 0);
    ctx.lineTo(i * GRID_SIZE, canvas.height);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(0, i * GRID_SIZE);
    ctx.lineTo(canvas.width, i * GRID_SIZE);
    ctx.stroke();
  }

  // Dibuixar la serp
  snake.forEach((segment, index) => {
    const isHead = index === 0;
    
    // Cos verd retro
    ctx.fillStyle = isHead ? '#00ff66' : '#00aa44';
    ctx.fillRect(
      segment.x * GRID_SIZE + 1,
      segment.y * GRID_SIZE + 1,
      GRID_SIZE - 2,
      GRID_SIZE - 2
    );

    // Si és el cap, dibuixar els ulls segons la direcció
    if (isHead) {
      ctx.fillStyle = '#000000';
      const eyeSize = 3;
      let eye1X, eye1Y, eye2X, eye2Y;

      if (dx === 1) { // Dreta
        eye1X = segment.x * GRID_SIZE + 14; eye1Y = segment.y * GRID_SIZE + 4;
        eye2X = segment.x * GRID_SIZE + 14; eye2Y = segment.y * GRID_SIZE + 12;
      } else if (dx === -1) { // Esquerra
        eye1X = segment.x * GRID_SIZE + 3;  eye1Y = segment.y * GRID_SIZE + 4;
        eye2X = segment.x * GRID_SIZE + 3;  eye2Y = segment.y * GRID_SIZE + 12;
      } else if (dy === -1) { // Amunt
        eye1X = segment.x * GRID_SIZE + 4;  eye1Y = segment.y * GRID_SIZE + 3;
        eye2X = segment.x * GRID_SIZE + 12; eye2Y = segment.y * GRID_SIZE + 3;
      } else { // Avall
        eye1X = segment.x * GRID_SIZE + 4;  eye1Y = segment.y * GRID_SIZE + 14;
        eye2X = segment.x * GRID_SIZE + 12; eye2Y = segment.y * GRID_SIZE + 14;
      }

      ctx.fillRect(eye1X, eye1Y, eyeSize, eyeSize);
      ctx.fillRect(eye2X, eye2Y, eyeSize, eyeSize);
    }
  });

  // Dibuixar la poma (Vermell vermellós amb efecte píxel)
  ctx.fillStyle = '#ff0055';
  ctx.fillRect(
    food.x * GRID_SIZE + 2,
    food.y * GRID_SIZE + 2,
    GRID_SIZE - 4,
    GRID_SIZE - 4
  );

  // Fulla de la poma
  ctx.fillStyle = '#00ff66';
  ctx.fillRect(
    food.x * GRID_SIZE + 8,
    food.y * GRID_SIZE,
    4,
    3
  );
}

// --- Control d'Entrades ---

function changeDirection(dir) {
  if (!isRunning) return;
  if (dir === 'UP' && dy === 0) { nextDx = 0; nextDy = -1; }
  if (dir === 'DOWN' && dy === 0) { nextDx = 0; nextDy = 1; }
  if (dir === 'LEFT' && dx === 0) { nextDx = -1; nextDy = 0; }
  if (dir === 'RIGHT' && dx === 0) { nextDx = 1; nextDy = 0; }
}

window.addEventListener('keydown', e => {
  switch (e.key) {
    case 'ArrowUp':
    case 'w':
    case 'W':
      changeDirection('UP');
      break;
    case 'ArrowDown':
    case 's':
    case 'S':
      changeDirection('DOWN');
      break;
    case 'ArrowLeft':
    case 'a':
    case 'A':
      changeDirection('LEFT');
      break;
    case 'ArrowRight':
    case 'd':
    case 'D':
      changeDirection('RIGHT');
      break;
  }
});

// Controls tàctils
document.getElementById('btn-up').addEventListener('click', () => changeDirection('UP'));
document.getElementById('btn-down').addEventListener('click', () => changeDirection('DOWN'));
document.getElementById('btn-left').addEventListener('click', () => changeDirection('LEFT'));
document.getElementById('btn-right').addEventListener('click', () => changeDirection('RIGHT'));

startBtn.addEventListener('click', startGame);

// Estat inicial
initGame();
draw();