from entities.robot import Robot, Direction
from entities.deck import Deck
from entities.card import Program
from network import ServerCommands, Command
import config

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

    def broadcastExcept(self, clientId, command):
        for client in self.clients:
            if client.id != clientId:
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
        # get a list of each client object and their robot's card for this register
        robotCards = [(cli, cli.robot.registers[regNum]) for cli in self.clients]
        # sort the list
        robotCards = sorted(robotCards, key=lambda robotCard: robotCard[1])
        # robots move
        for (client, cardId) in robotCards:
            # get card from card ID
            card = self.deck.getCard(cardId)
            if card.program >= 3:
                # if card requires a tile change then check if this is possible
                robot = client.robot
                newX = robot.x
                newY = robot.y
                if card.program == Program.BackUp:
                    newX, newY = robot.move(-1)
                    self.broadcast(Command(ServerCommands.RobotGracefulStartBackward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotGracefulStopBackward, { 'clientId': client.id }))
                elif card.program == Program.Move1:
                    newX, newY = robot.move(1)
                    self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
                elif card.program == Program.Move2:
                    newX, newY = robot.move(2)
                    self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
                elif card.program == Program.Move3:
                    newX, newY = robot.move(3)
                    self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
                    self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
                # TODO: check that moving is legal, and find final position
                # check for any robot collisions (pushing)
                robot.x = newX
                robot.y = newY
            else:
                # just a rotation, which is always legal
                newO = robot.orient
                if card.program == Program.UTurn:
                    newO = robot.rotate(2)
                    self.broadcast(Command(ServerCommands.RobotTurnAround, { 'clientId': client.id }))
                elif card.program == Program.RotateRight:
                    newO = robot.rotate(1)
                    self.broadcast(Command(ServerCommands.RobotTurnRight, { 'clientId': client.id }))
                elif card.program == Program.RotateLeft:
                    newO = robot.rotate(-1)
                    self.broadcast(Command(ServerCommands.RobotTurnLeft, { 'clientId': client.id }))
                robot.orient = newO
            # TODO: send changes to clients
        # board elements move
        # lasers fire
        # touch checkpoints

    def clientCommitRegisters(self, client):
        client.robot.commitRegisters()
        self.broadcast(Command(ServerCommands.PlayerCommitRegisters, { 'clientId': client.id }))

        clientsWhichHaveNotCommitted = [client for client in self.clients if not client.robot.registersCommitted]
        if len(clientsWhichHaveNotCommitted) == 0:
            if config.debug:
                print 'All players have committed their registers. Starting game.'
            self.start()
        elif len(clientsWhichHaveNotCommitted) == 1:
            if config.debug:
                print 'Final player is choosing their program cards!'
            self.broadcast(Command(ServerCommands.FinalPlayerChoosingProgramCards, { 'clientId': clientsWhichHaveNotCommitted[0].id }))
