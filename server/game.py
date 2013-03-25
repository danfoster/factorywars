from entities.robot import Robot, Direction
from entities.deck import Deck
from entities.card import Program

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
        for (robot, cardId) in robotCards:
            # get card from card ID
            card = self.deck.getCard(cardId)
            if card.program >= 3:
                # if card requires a tile change then check if this is possible
                newX = robot.x
                newY = robot.y
                if card.program == Program.BackUp:
                    newX, newY = robot.move(-1)
                elif card.program == Program.Move1:
                    newX, newY = robot.move(1)
                elif card.program == Program.Move2:
                    newX, newY = robot.move(2)
                elif card.program == Program.Move3:
                    newX, newY = robot.move(3)
                # TODO: check that moving is legal, and find final position
                # check for any robot collisions (pushing)
                robot.x = newX
                robot.y = newY
            else:
                # just a rotation, which is always legal
                newO = robot.orient
                if card.program == Program.UTurn:
                    newO = robot.rotate(2)
                elif card.program == Program.RotateRight:
                    newO = robot.rotate(1)
                elif card.program == Program.RotateLeft:
                    newO = robot.rotate(-1)
                robot.orient = newO
            # TODO: send changes to clients
        # board elements move
        # lasers fire
        # touch checkpoints
