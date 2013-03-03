from entities.robot import Robot, Direction
from entities.deck import Deck

class Game:

    def __init__(self):
        self.deck = Deck()
        self.clients = []
        self.robots = []

    def addClient(self, client):
        robot = Robot(1, 1, Direction.Right)

        self.robots.append(robot)
        client.robot = robot

        self.clients.append(client)
