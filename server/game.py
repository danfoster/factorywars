from entities.robot import Robot, Direction
from entities.deck import Deck
from entities.card import Program
from collisionResolver import CollisionResolver
from network import ServerCommands, Command
import config
import tmxlib

class Game:

    def __init__(self):
        self.deck = Deck()
        self.clients = []
        self.robots = []
        self.robotStartY = 1
        #TODO: move this into a level file
        tmxFilePath = '../client/data/boards/cross.tmx'
        map = tmxlib.Map.open(tmxFilePath)
        self.collisionResolver = CollisionResolver()
        
    def start(self):
        self.executeRegister(0)
        self.executeRegister(1)
        self.executeRegister(2)
        self.executeRegister(3)
        self.executeRegister(4)
        #TODO: deal with end of turn effects

    def startNewTurn(self):
        self.broadcast(Command(ServerCommands.TurnEnd, {}))
        self.resetRegisters()
        self.deck.reset()
        self.dealCards()
        self.broadcast(Command(ServerCommands.TurnBegin, {}))

    def addClient(self, client):
        #TODO: get start positions from board
        robot = Robot(1, self.robotStartY, Direction.Down)
        self.robotStartY = self.robotStartY + 1
        client.robot = robot

        client.send(Command(ServerCommands.ProgramDeck, self.deck.getDeck()))
        client.hand = [self.deck.dealCard().id for x in range(1,10)]
        client.send(Command(ServerCommands.DealProgramCards, client.hand))
        #sync client IDs
        client.send(Command(ServerCommands.YourClientIdIs, { 'clientId': client.id }))
        self.broadcastExcept(client.id, Command(ServerCommands.ClientJoined, { 'clientId': client.id }))
        for existingClient in self.clients:
            client.send(Command(ServerCommands.ClientJoined, { 'clientId': existingClient.id }))
        #sync robot start positions
        client.send(Command(ServerCommands.YourStartPositionIs, { 'coords': [client.robot.x,client.robot.y] }))
        self.broadcastExcept(client.id, Command(ServerCommands.StartPosition, { 'clientId': client.id, 'coords': [client.robot.x,client.robot.y] }))
        for existingClient in self.clients:
            client.send(Command(ServerCommands.StartPosition, { 'clientId': existingClient.id, 'coords': [existingClient.robot.x,existingClient.robot.y] }))
        #inform new client of existing nicknames
        for existingClient in self.clients:
            client.send(Command(ServerCommands.ClientChangedNickname, { 'clientId': existingClient.id, 'nickname': existingClient.nickname }))

        self.robots.append(robot)
        self.clients.append(client)

    def removeClient(self, client):
        self.robots.remove(client.robot)
        self.clients.remove(client)

    def broadcast(self, command):
        for client in self.clients:
            client.send(command)

    def broadcastExcept(self, clientId, command):
        for client in self.clients:
            if client.id != clientId:
                client.send(command)

    def dealCards(self):
        for client in self.clients:
            client.hand = [self.deck.dealCard().id for x in range(1,10)]
            client.send(Command(ServerCommands.DealProgramCards, client.hand))

    def resetRegisters(self):
        for client in self.clients:
            client.robot.resetRegisters()
        
    def executeRegister(self, regNum):
        self.broadcast(Command(ServerCommands.RegisterPhaseBegin, { 'register': regNum }))
        
        # find robot with the highest priority for this register
        # get a list of each client object and their robot's card for this register
        robotCards = [(cli, cli.robot.registers[regNum]) for cli in self.clients]
        # sort the list
        robotCards = sorted(robotCards, key=lambda robotCard: robotCard[1], reverse=True)
        # robots move
        for (client, cardId) in robotCards:
            # get card from card ID
            card = self.deck.getCard(cardId)
            robot = client.robot
            if card.program >= 3:
                # if card requires a tile change then use the collisionResolver
                animationList = self.collisionResolver.resolveMovement(client, card, self.clients)
                for animation in animationList:
                    self.broadcast(animation)
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

        self.broadcast(Command(ServerCommands.RegisterPhaseEnd, { 'register': regNum }))

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

    def clientReadyForNextTurn(self, client):
        clientsWhichAreNotReady = [client for client in self.clients if not client.readyForNextTurn]
        if len(clientsWhichAreNotReady) == 0:
            self.startNewTurn()
