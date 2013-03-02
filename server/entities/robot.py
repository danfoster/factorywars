from utils import *

class Robot:
    
    Dir = enum(RIGHT=1, UP=2, LEFT=3, DOWN=4)
    
    def __init__(self, x, y, orientation):
        self.x = x
        self.y = y
        self.orient = orientation

    # returns the position the robot would be in if the given forward distance were applied
    def move(self, distance):
        x = self.x
        y = self.y
        if self.orient == self.Dir.DOWN:
            y = self.y - distance
        elif self.orient == self.Dir.LEFT:
            x = self.x - distance
        elif self.orient == self.Dir.UP:
            y = self.y + distance
        elif self.orient == self.Dir.RIGHT:
            x = self.x + distance
            
        return x,y
