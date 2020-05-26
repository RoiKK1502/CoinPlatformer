public class BlockGrid
{
  private Block[][] grid;
  private float blockSize;

  public BlockGrid(Block[][] grid, float blockSize)
  {
    this.grid = grid;
    this.blockSize = blockSize;
  }

  public int getGridParameter(float gridParameter, boolean shouldRoundUp)
  {
    if (shouldRoundUp)
    {
      return (int)(ceil((gridParameter - 1) / blockSize) - 1);
    } else
    {
      return (int)(floor((gridParameter + 1) / blockSize));
    }
  }

  public boolean isPositionBlockFull(float xPos, float yPos, boolean isHeadingLeft, boolean isHeadingDown)
  {
    return grid[getGridParameter(yPos, isHeadingDown)][getGridParameter(xPos, isHeadingLeft)].isFull;
  }

  public float getVerticalSurface(float xPos, float yPos, boolean isHeadingLeft, boolean isHeadingDown)
  {
    float currentVerticalSurface;

    if (isPositionBlockFull(xPos, yPos, isHeadingLeft, isHeadingDown))
    {
      currentVerticalSurface = map(getGridParameter(yPos, isHeadingDown), 0, grid.length, 0, grid.length * blockSize);
    } else
    {
      currentVerticalSurface = 0;
    }

    if (isHeadingDown)
    {
      currentVerticalSurface += blockSize;
    }

    return currentVerticalSurface;
  }

  public float getHorizontalSurface(float xPos, float yPos, boolean isHeadingLeft, boolean isHeadingDown)
  {
    float currentHorizontalSurface;

    if (isPositionBlockFull(xPos, yPos, isHeadingLeft, isHeadingDown))
    {
      currentHorizontalSurface = map(getGridParameter(xPos, isHeadingLeft), 0, grid[getGridParameter(yPos, isHeadingDown)].length, 0, grid[getGridParameter(yPos, isHeadingDown)].length * blockSize);
    } else
    {
      currentHorizontalSurface = 0;
    }

    if (isHeadingLeft)
    {
      currentHorizontalSurface += blockSize;
    }

    return currentHorizontalSurface;
  }

  public boolean togglePositionBlockState(float x, float y)
  {
    Block selectedBlock = grid[getGridParameter(y, true)][getGridParameter(x, true)];
    if (isCoinEquipped)
    {
      selectedBlock.isCoin = !selectedBlock.isCoin;
      return selectedBlock.isCoin;
    } else
    {
      selectedBlock.isFull = !selectedBlock.isFull;
      return selectedBlock.isFull;
    }
  }

  public void reachLocation(float xPos, float yPos)
  {
    grid[getGridParameter(yPos, true)][getGridParameter(xPos, true)].isReached = true;
  }

  public void draw()
  {
    ellipseMode(CORNER);
    for (int y = 0; y < grid.length; y++)
    {
      for (int x = 0; x < grid[y].length; x++)
      {
        float screenY = map(y, 0, grid.length, 0, grid.length * blockSize);
        float screenX = map(x, 0, grid[y].length, 0, grid[y].length * blockSize);

        if (grid[y][x].isFull)
        {
          fill(0, 50);
          rect(screenX, height - screenY, blockSize, -blockSize);
        }

        if (grid[y][x].isCoin)
        {
          if (grid[y][x].isReached)
          {
            fill(255, 215, 0, 20);
          } else
          {
            fill(255, 215, 0);
          }
          ellipse(screenX, height - screenY, blockSize, -blockSize);
        }

        if (!grid[y][x].isPlayerBlock)
        {
          fill(0, 150);
          rect(screenX, height - screenY, blockSize, -blockSize);
        }
      }
    }
  }
}
