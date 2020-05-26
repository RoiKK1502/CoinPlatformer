public class Player
{
  private float playerWidth;
  private float playerHeight;
  private float xPos;
  private float yPos;
  private float spawnX;
  private float spawnY;
  private float xMovingSpeed;
  private float xSpeed;
  private float ySpeed;
  private float yAcceleration;
  private int iFrames;
  private boolean isDead;
  private color Color;

  public Player(float playerWidth, float playerHeight, float spawnX, float spawnY, float xMovingSpeed, color Color)
  {
    this.playerWidth = playerWidth;
    this.playerHeight = playerHeight;
    this.spawnX = spawnX;
    this.spawnY = spawnY;
    this.xMovingSpeed = xMovingSpeed;
    this.Color = Color;
  }

  public void draw()
  {
    fill(Color);
    ellipse(xPos, height - yPos - playerHeight, playerWidth, 30);
    rect(xPos, height - yPos, playerWidth, 27 - playerHeight);
  }

  public void update()
  {
    xPos += xSpeed;
    ySpeed += yAcceleration;
    yPos = round(yPos) + ySpeed;

    fixBlockGridLimits();
    if (isDead) return;

    applyCollisions();
    stayDown();
  }

  public void prepLevel()
  {
    ySpeed = 0;
    xPos = spawnX;
    yPos = spawnY;
  }

  private void stayDown()
  {
    if (isOnGround())
    {
      yAcceleration = 0;
      ySpeed = 0;
    } else
    {
      yAcceleration = -1;
    }
  }

  private void verticalBlockCollision(float xCollision, float yCollision, boolean isHeadingLeft, boolean isHeadingDown)
  {
    float currentVeticalSurface = blockGrid.getVerticalSurface(xCollision, yCollision, !isHeadingLeft, isHeadingDown);
    float yDiff = currentVeticalSurface - yCollision;

    if (blockGrid.isPositionBlockFull(xCollision, yCollision, !isHeadingLeft, isHeadingDown))
    {
      yPos += yDiff;
      if (ySpeed > 0)
      {
        ySpeed = 0;
      }
    }
  }

  private void horizontalBlockCollision(float xCollision, float yCollision, boolean isHeadingLeft, boolean isHeadingDown)
  {
    float currentHorizontalSurface = blockGrid.getHorizontalSurface(xCollision, yCollision, isHeadingLeft, !isHeadingDown);
    float xDiff = currentHorizontalSurface - xCollision;

    if (blockGrid.isPositionBlockFull(xCollision, yCollision, isHeadingLeft, !isHeadingDown))
    {
      xPos += xDiff;
      xSpeed = 0;
    }
  }

  private float getRightFootX()
  {
    return xPos + playerWidth;
  }

  private float getRightFootY()
  {
    return yPos;
  }

  private float getLeftFootX()
  {
    return xPos;
  }

  private float getLeftFootY()
  {
    return yPos;
  }

  private float getRightTopX()
  {
    return xPos + playerWidth;
  }

  private float getRightTopY()
  {
    return yPos + playerHeight;
  }

  private float getLeftTopX()
  {
    return xPos;
  }

  private float getLeftTopY()
  {
    return yPos + playerHeight;
  }

  private float getRightKidneyX()
  {
    return xPos + playerWidth;
  }

  private float getRightKidneyY()
  {
    return yPos + (playerHeight / 2);
  }

  private float getLeftKidneyX()
  {
    return xPos;
  }

  private float getLeftKidneyY()
  {
    return yPos + (playerHeight / 2);
  }

  private boolean isTouchingRightWall()
  {
    return blockGrid.isPositionBlockFull(getRightTopX(), getRightTopY(), false, true) || blockGrid.isPositionBlockFull(getRightFootX(), getRightFootY(), false, false);
  }

  private boolean isTouchingLeftWall()
  {
    return blockGrid.isPositionBlockFull(getLeftTopX(), getLeftTopY(), true, true) || blockGrid.isPositionBlockFull(getLeftFootX(), getLeftFootY(), true, false);
  }

  public void setMovingRightState()
  {
    if (!isPlayerTooRight() && !isTouchingRightWall())
    {
      xSpeed = xMovingSpeed;
    }
  }

  public void setMovingLeftState()
  {
    if (!isPlayerTooLeft() && !isTouchingLeftWall())
    {
      xSpeed = -xMovingSpeed;
    }
  }

  public void setNotMovingState()
  {
    xSpeed = 0;
  }

  private boolean isPlayerTooLeft()
  {
    return xPos <= 0;
  }

  private boolean isPlayerTooRight()
  {
    return xPos >= (width - playerWidth);
  }

  private boolean isPlayerTooDown()
  {
    return yPos <= 1;
  }

  private boolean isPlayerTooUp()
  {
    return yPos >= (height - playerHeight);
  }

  private void fixBlockGridLimits()
  {
    if (isPlayerTooDown())
    {
      if (!isEditor)
      {
        setNotMovingState();
        yPos = 0;
        ySpeed = 0;
        yAcceleration = 0;
        isDead = true;
      } else
      {
        prepLevel();
      }
    }

    if (isPlayerTooLeft())
    {
      setNotMovingState();
      xPos = 0;
    }

    if (isPlayerTooRight())
    {
      setNotMovingState();
      xPos = width - playerWidth;
    }

    if (isPlayerTooUp())
    {
      ySpeed = 0;
      yPos = height - playerHeight;
    }
  }

  private void applyCollisions()
  {
    if (!isPlayerTooLeft() && !isPlayerTooDown())
    {
      verticalBlockCollision(getLeftFootX(), getLeftFootY(), true, true);
      horizontalBlockCollision(getLeftFootX(), getLeftFootY(), true, true);
      blockGrid.reachLocation(getLeftFootX(), getLeftFootY());
    }

    if (!isPlayerTooRight() && !isPlayerTooDown())
    {
      verticalBlockCollision(getRightFootX(), getRightFootY(), false, true);
      horizontalBlockCollision(getRightFootX(), getRightFootY(), false, true);
      blockGrid.reachLocation(getRightFootX(), getRightFootY());
    }

    if (!isPlayerTooLeft() && !isPlayerTooUp())
    {
      verticalBlockCollision(getLeftTopX(), getLeftTopY(), true, false);
      horizontalBlockCollision(getLeftTopX(), getLeftTopY(), true, false);
      blockGrid.reachLocation(getLeftTopX(), getLeftTopY());
    }

    if (!isPlayerTooRight() && !isPlayerTooUp())
    {
      verticalBlockCollision(getRightTopX(), getRightTopY(), false, false);
      horizontalBlockCollision(getRightTopX(), getRightTopY(), false, false);
      blockGrid.reachLocation(getRightTopX(), getRightTopY());
    }

    if (!isPlayerTooLeft())
    {
      blockGrid.reachLocation(getLeftKidneyX(), getLeftKidneyY());
    }

    if (!isPlayerTooRight())
    {
      blockGrid.reachLocation(getRightKidneyX(), getRightKidneyY());
    }
  }

  private boolean isRightFootOnGround()
  {
    return blockGrid.isPositionBlockFull(getRightFootX(), getRightFootY(), !false, true);
  }

  private boolean isLeftFootOnGround()
  {
    return blockGrid.isPositionBlockFull(getLeftFootX(), getLeftFootY(), !true, true);
  }

  private boolean isOnGround()
  {
    if (!isPlayerTooDown() && (isRightFootOnGround() || isLeftFootOnGround()))
    {
      iFrames = frameCount;
      return true;
    } else
    {
      return false;
    }
  }

  public void setJumpingState()
  {
    int numOfIFrames = frameCount - iFrames;
    if (isOnGround() || (numOfIFrames < 6 && xSpeed != 0))
    {
      ySpeed = 20;
      yAcceleration = -1;
    }
  }

  private boolean mouseTooLeft()
  {
    return blockGrid.getGridParameter(mouseX, true) <= blockGrid.getGridParameter(xPos + playerWidth, true);
  }

  private boolean mouseTooRight()
  {
    return blockGrid.getGridParameter(mouseX, true) >= blockGrid.getGridParameter(xPos, true);
  }

  private boolean mouseTooDown()
  {
    return blockGrid.getGridParameter(height - mouseY, true) >= blockGrid.getGridParameter(yPos, false);
  }

  private boolean mouseTooUp()
  {
    return blockGrid.getGridParameter(height - mouseY, true) <= blockGrid.getGridParameter(yPos + playerHeight, true);
  }

  public boolean mouseOnPlayer()
  {
    return (mouseTooLeft() && mouseTooRight()) && mouseTooDown() && mouseTooUp();
  }

  public boolean isPlayerDead()
  {
    return isDead;
  }
}
