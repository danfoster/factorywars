

MovementType = enum(Forward=1, Backward=2, StrafeLeft=3, StrafeRight=4)

class movement:

    def __init__(self, startX, startY):
        self.startX = startX
        self.startY = startY
        self.endX = startX
        self.endY = startY
        self.type = MovementType.Forward
        self.beingPushed = False
        self.order = 1
