from utils import *

Program = enum(UTurn = 0,
               RotateRight = 1,
               RotateLeft = 2,
               BackUp = 3,
               Move1 = 4,
               Move2 = 5,
               Move3 = 6)

class Card:
    def __init__(self, priority, program):
        self.id = priority
        self.priority = priority
        self.program = program
