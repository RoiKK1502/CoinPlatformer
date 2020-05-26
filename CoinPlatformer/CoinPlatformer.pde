BlockGrid blockGrid;
Player player;
Block[][] blockArray;

float spawnX;
float spawnY;
float backgroundTransparency;
float hue;
int difficulty;
int playerBlockCounter;
int coinLocationsRandomizer;
boolean isEditor;
boolean isCoinEquipped;
boolean isDifficultySet;
boolean isGameSet;
ArrayList<Coin> coinLocations = new ArrayList<Coin>();

boolean[][] grid = new boolean[][]
  {
  {true , true , true , true , true , false, false, false, false, true , true , true , true , true , true , true , true , true , true , true }, 
  {true , true , true , false, false, false, false, false, false, true , true , true , true , true , true , true , true , true , true , true }, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, true , false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, true , false, false, false, false, false, true , true , false, false, false, false, false}, 
  {true , true , true , true , true , true , true , true , false, true , false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, true , false, true , false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, true , true , false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, true , false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, true , false, false, true , true , true , true , false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, true , false, false, true , true , false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, true , true , true , false, false, true , false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, true , false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, true , true , true , true , true , true , true }, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true }, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true }, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
  {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}, 
};

  void setup()
{
  size(800, 800);
  frameRate(60);

  coinLocationsRandomizer = int(random(-2, 2) * 1.45);
  isGameSet = false;
  isDifficultySet = false;
  isEditor = false;
  isCoinEquipped = false;
  backgroundTransparency = 0;
  float playerHeight = 70;
  spawnX = 20;
  spawnY = 200;
  player = new Player(30, playerHeight, spawnX, spawnY, 4, #FF0000);
}

void setupGame()
{
  if (isDifficultySet)
  {
    loadLevel();
    isGameSet = true;
  } else {
    setDifficulty();
  }
}

void draw()
{
  if (isDifficultySet && isGameSet)
  {
    if (!isEditor)
    {
      noStroke();
    }
    if ((calculateCoinCounter(coinLocations) != (coinLocations.size())) || (isEditor))
    {
      if (!(player.isPlayerDead()) || (isEditor))
      {
        background(255);
        player.draw();
        player.update();
        blockGrid.draw();
        printInstructions();
      } else
      {
        lose();
      }
    } else
    {
      win();
    }
  } else
  {
    setupGame();
  }
}


void keyPressed()
{
  if (isDifficultySet)
  {
    if (isEditor)
    {
      if (keyCode == 'S')
      {
        isCoinEquipped = !isCoinEquipped;
      } else if(keyCode == 'C')
      {
        coinLocations.clear();
      } else if (keyCode == 'L')
      {
        isCoinEquipped = false;
        for (int i = 0; i < grid.length; i++)
        {
          for (int j = 0; j < grid[i].length; j++)
          {
            grid[i][j] = blockArray[i][j].isFull;
          }
        }
        isGameSet = false;
        isEditor = false;
        playerBlockCounter = 3;
        loadLevel();
      }
    }
    if (keyCode == 'D')
    {
      player.setMovingRightState();
    } else if (keyCode == 'A')
    {
      player.setMovingLeftState();
    } else if (keyCode == 'W')
    {
      player.setJumpingState();
    } else if (keyCode == 'R')
    {
      setup();
    }
  } else if (keyCode == '1')
  {
    setDifficulty1();
  } else if (keyCode == '2')
  {
    setDifficulty2();
  } else if (keyCode == '3')
  {
    setDifficulty3();
  }
}

void keyReleased()
{
  if (isDifficultySet)
  {
    if (keyCode == 'A' || keyCode == 'D')
    {
      player.setNotMovingState();
    }
  }
}

void mousePressed()
{
  if (isDifficultySet)
  {
    togglePlayerBlock(mouseX, height - mouseY);
    if (playerBlockCounter < 0)
    {
      togglePlayerBlock(mouseX, height - mouseY);
    }
  }
}

void togglePlayerBlock(float x, float y)
{
  if (blockArray[blockGrid.getGridParameter(y, true)][blockGrid.getGridParameter(x, true)].isPlayerBlock && !player.mouseOnPlayer())
  {
    if (!isCoinEquipped)
    {
      if (blockGrid.togglePositionBlockState(x, y))
      {
        playerBlockCounter--;
      } else
      {
        playerBlockCounter++;
      }
    } else
    {
      Coin coin = new Coin(blockGrid.getGridParameter(y, true), blockGrid.getGridParameter(x, true));
      if (blockGrid.togglePositionBlockState(x, y))
      {
        coinLocations.add(coin);
      } else
      {
        for(int i = 0; i < coinLocations.size(); i++)
        {
          if((coin.getX() == coinLocations.get(i).getX()) && coin.getY() == coinLocations.get(i).getY())
          {
            coinLocations.remove(i);
          }
        }
      }
    }
  }
}

BlockGrid loadLevel()
{
  player.prepLevel();
  float blockSize = 40;
  blockArray = convertToBlockArray(grid, isEditor);
  blockArray = createCoins(coinLocations, blockArray);
  blockGrid = new BlockGrid(blockArray, blockSize);
  return blockGrid;
}

Block[][] convertToBlockArray (boolean[][] grid, boolean isEditor)
{
  Block[][] blockArray = new Block[grid.length][];
  for (int i = 0; i < grid.length; i++)
  {
    blockArray[i] = new Block[grid[i].length];
    for (int j = 0; j < grid[i].length; j++)
    {
      blockArray[i][j] = new Block();
      blockArray[i][j].isFull = grid[i][j];
      if (!isEditor)
      {
        blockArray[i][j].isPlayerBlock = !grid[i][j];
      } else
      {
        blockArray[i][j].isPlayerBlock = true;
      }
    }
  }
  return blockArray;
}

int calculateCoinCounter(ArrayList<Coin> coinLocations)
{
  int coinCounter = 0;
  for (int i = 0; i < coinLocations.size(); i++)
  {
    if (blockArray[coinLocations.get(i).xIndex][coinLocations.get(i).yIndex].isReached)
    {
      coinCounter++;
    }
  }
  return coinCounter;
}

Block[][] createCoins(ArrayList<Coin> coinLocations, Block[][] blockArray)
{
  for (int i = 0; i < coinLocations.size(); i++)
  {
    blockArray[coinLocations.get(i).xIndex][coinLocations.get(i).yIndex].isCoin = true;
  }
  return blockArray;
}

void setDifficulty()
{
  background(255);
  noFill();
  stroke(0);
  rect(width / 5 - 20, height / 2 - 150, 100, 100);
  rect(width / 5 * 2 + 30, height / 2 - 150, 100, 100);
  rect(width / 5 * 3 + 80, height / 2 - 150, 100, 100);
  rect(width / 5 * 2 - 140, (height / 4 * 3 - 150), 440, 100);

  fill(0);
  textSize(20);
  textAlign(CORNER);
  text("Made by Roi Kellner", 5, 20);
  
  textAlign(CENTER);
  textSize(60);
  text("Choose Difficulty:", width / 2, height / 2 - 250);
  text("1", width / 5 + 30, height / 2 - 80);
  text("2", width / 5 + 240, height / 2 - 80);
  text("3", width / 5 + 450, height / 2 - 80);
  text("Creative Mode", width / 5 * 2 + 80, height / 4 * 3 - 80);

  if (mousePressed)
  {
    if ((mouseY < height / 2 - 50) && (mouseY > height / 2 - 150))
    {
      if ((mouseX < (width / 5 + 50) + 30) && (mouseX > width / 5 - 20))
      {
        setDifficulty1();
      } else if ((mouseX < (width / 5 + 50) * 2 + 30) && (mouseX > width / 5 * 2 + 30))
      {
        setDifficulty2();
      } else if ((mouseX < (width / 5 + 50) * 3 + 30) && (mouseX > width / 5 * 3 + 80))
      {
        setDifficulty3();
      }
    } else if ((mouseY < (height / 4 * 3 - 50)) && (mouseY > (height / 4 * 3 - 150)) && (mouseX < (width / 5 * 2 + 300)) && (mouseX > (width / 5 * 2 - 140)))
    {
      setDifficulty0();
    }
  }
}

void setDifficulty0()
{
  difficulty = 0;
  playerBlockCounter = 1000;
  isDifficultySet = true;
  isEditor = true;
}

void setDifficulty1()
{
  coinLocations.clear();
  coinLocations.add(new Coin(1, 6 + coinLocationsRandomizer));
  coinLocations.add(new Coin(4 + coinLocationsRandomizer, 11 + coinLocationsRandomizer));
  coinLocations.add(new Coin(3 - coinLocationsRandomizer, 3));
  coinLocations.add(new Coin(9, 2 + coinLocationsRandomizer));
  difficulty = 1;
  playerBlockCounter = 3;
  isDifficultySet = true;
  isEditor = false;
}

void setDifficulty2()
{
  coinLocations.clear();
  coinLocations.add(new Coin(9, 8));
  coinLocations.add(new Coin(10, 18));
  coinLocations.add(new Coin(11, 8));
  coinLocations.add(new Coin(14, 13));
  coinLocations.add(new Coin(17, 18));
  coinLocations.add(new Coin(18, 3));
  difficulty = 2;
  playerBlockCounter = 2;
  isDifficultySet = true;
  isEditor = false;
}

void setDifficulty3()
{
  coinLocations.clear();
  coinLocations.add(new Coin(1, 6 + coinLocationsRandomizer));
  coinLocations.add(new Coin(4 + coinLocationsRandomizer, 11 + coinLocationsRandomizer));
  coinLocations.add(new Coin(3 - coinLocationsRandomizer, 3));
  coinLocations.add(new Coin(9, 2 + coinLocationsRandomizer));
  coinLocations.add(new Coin(9, 8));
  coinLocations.add(new Coin(10, 18));
  coinLocations.add(new Coin(11, 8));
  coinLocations.add(new Coin(14, 13));
  coinLocations.add(new Coin(17, 18));
  coinLocations.add(new Coin(18, 3));
  difficulty = 3;
  playerBlockCounter = 1;
  isDifficultySet = true;
  isEditor = false;
}

void printInstructions()
{
  fill(0);
  textSize(20);
  textAlign(LEFT);
  if (!isEditor)
  {
    if (calculateCoinCounter(coinLocations) < 3)
    {
      text("Instructions:", 10, 90);
      if (calculateCoinCounter(coinLocations) == 0)
      {
        text("A - Move Left.", 10, 130);
        text("D - Move Right.", 10, 160);
        text("Collect All " + coinLocations.size() + " Coins To Win.", 10, 190);
      } else if (calculateCoinCounter(coinLocations) > 0)
      {
        text("W - Jump.", 10, 130);
        text("Left Click - Create/Remove Blocks.", 10, 160);
      }
      if (calculateCoinCounter(coinLocations) == 2)
      {
        text("You Can Create Up To " + (4 - difficulty) + " Blocks", 10, 190);
        text("At The Same Time.", 10, 210);
      }
    }
    text("Remaining Coins: " + ((coinLocations.size()) - calculateCoinCounter(coinLocations)), 5, 20);
    textAlign(RIGHT);
    text("Remaining Blocks: " + playerBlockCounter, width - 5, 20);
  } else
  {
    text("R - Restart to the difficulty menu.", 10, 20);
    text("S - Switch between Coins and Blocks.", 10, 50);
    text("L - Load the current level onto the game.", 10, 80);
    text("C - Clear all coins.", 10, 110);
    text("Remember to create Coins :)", 10, 150);
  }
}

void gameEnded()
{
  fill(255);
  rect(width / 2 - 130, height / 2 + 180, 280, 80);
  
  fill(0, backgroundTransparency * 10);
  textAlign(CENTER);
  textSize(80);
  text("Restart", width / 2 + 10, height / 2 + 250);
  backgroundTransparency += 0.4;

  if ((mousePressed) && (mouseX > width / 2 - 130) && (mouseX < width / 2 + 150) && (mouseY > height / 2 + 180) && (mouseY < height / 2 + 260))
  {
    setup();
  }
}

void win()
{
  colorMode(HSB);
  fill(hue % 256, 100, 200, backgroundTransparency * 4);
  rect(0, 0, width, height);
  hue += 0.7;
  colorMode(RGB);

  gameEnded();

  strokeWeight(1);
  fill(255);
  rect(width / 5, height / 7, 480, 100);

  fill(255, 215, 0, backgroundTransparency * 10);
  textSize(100);
  text("You Won!", width / 2, height / 4);
}

void lose()
{
  fill(50 - backgroundTransparency, backgroundTransparency);
  rect(0, 0, width, height);

  gameEnded();

  fill(255, 0, 0, backgroundTransparency);
  textSize(100);
  text("YOU DIED!", width / 2, (height / 2) - 100);

  textSize(20);
  text("(You should click on Restart now, or simply press R)", width / 2, height / 2);
}
