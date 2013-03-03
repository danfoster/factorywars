from utils import *

Direction = enum(Right=1, Up=2, Left=3, Down=4)

class Robot:
    
    def __init__(self, x, y, orientation):
        self.x = x
        self.y = y
        self.orient = orientation
        self.damage = 0
        self.lives = 3
        self.powerDown = False

    # returns the position the robot would be in if the given forward distance were applied
    def move(self, distance):
        x = self.x
        y = self.y
        if self.orient == Direction.Down:
            y = self.y - distance
        elif self.orient == Direction.Left:
            x = self.x - distance
        elif self.orient == Direction.Up:
            y = self.y + distance
        elif self.orient == Direction.Right:
            x = self.x + distance
            
        return x,y

    # returns the orientation the robot would be in if rotated by the given amount
    def rotate(self, amount):
        return ((self.orient + amount - 1) % 4) + 1
