from entities.robot import Robot
from entities.deck import Deck

class Game:

    def __init__(self):
        self.deck = Deck()
        self.clients = []
        
        # test code
        robot = Robot(1, 1, Robot.Dir.RIGHT)
        print(robot.x)
        print(robot.move(1))

    def addClient(self,client):
        self.clients.append(client)



