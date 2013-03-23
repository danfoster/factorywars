from entities.robot import Robot, Direction
from entities.deck import Deck

class Game:

    def __init__(self):
        self.deck = Deck()
        self.clients = []
        self.robots = []
        
    def start(self):
        self.executeRegister(0)

    def addClient(self, client):
        robot = Robot(1, 1, Direction.Right)

        self.robots.append(robot)
        client.robot = robot

        self.clients.append(client)

    def broadcast(self, command):
        for client in self.clients:
            client.send(command)
    
    #def turn(self):
        # distribute cards
        # receive arranged cards
        # receive any intent to power down
        # execute registers (card movements, board movements, interactions)
        # end of turn effects
        
    def executeRegister(self, regNum):
        # reveal program cards
        
        # find robot with the highest priority for this register
        # get a list of each robot object and their card for this register
        robotCards = [(rob, rob.registers[regNum]) for rob in self.robots]
        # sort the list
        robotCards = sorted(robotCards, key=lambda robotCard: robotCard[1])

        # robots move
        
        # board elements move
        # lasers fire
        # touch checkpoints
