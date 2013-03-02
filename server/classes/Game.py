from Robot import Robot

class Game:

    def __init__(self):
        # TODO: initialise the game object
        
        # test code
        robot = Robot(1, 1, Robot.Dir.RIGHT)
        print(robot.x)
        print(robot.move(1))

game = Game()
    
    