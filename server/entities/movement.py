from utils import *
from robot import Direction

MovementType = enum(Forward=1, Backward=2, StrafeLeft=3, StrafeRight=4)

class Movement:

    def __init__(self, startX, startY, client):
        self.client = client
        self.startX = startX
        self.startY = startY
        self.endX = startX
        self.endY = startY
        self.type = MovementType.Forward
        self.direction = Direction.Right
        self.beingPushed = False
        self.order = 1
        self.startOfMotion = True
        self.endOfMotion = True
