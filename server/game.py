from entities.robot import Robot, Direction
from entities.deck import Deck
from entities.card import Program
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
        #TODO: account for locked registers
        for client in self.clients:
            client.hand = [self.deck.dealCard().id for x in range(1,10)]
            client.send(Command(ServerCommands.DealProgramCards, client.hand))

    def resetRegisters(self):
        for client in self.clients:
            client.robot.resetRegisters()

    #def checkMovement(self, client, newX, newY):
    #    #TODO: refactor this function
    #    currentX = client.robot.x
    #    currentY = client.robot.y
    #    distance = abs(currentX - newX) + abs(currentY - newY)

    #    movementDirection = 0
    #    scanX = newX
    #    scanY = newY
    #    if newX < currentX:
    #        movementDirection = Direction.Left
    #        scanX -= distance
    #    elif newX > currentX:
    #        movementDirection = Direction.Right
    #        scanX += distance
    #    elif newY < currentY:
    #        movementDirection = Direction.Down
    #        scanY -= distance
    #    else:
    #        movementDirection = Direction.Up
    #        scanY += distance

    #    minX = min(currentX, scanX)
    #    maxX = max(currentX, scanX)
    #    minY = min(currentY, scanY)
    #    maxY = max(currentY, scanY)

    #    robotDistances = []
    #    for otherClient in self.clients:
    #        if client.id != otherClient.id:
    #            robotX = otherClient.robot.x
    #            robotY = otherClient.robot.y
    #            if robotX <= maxX and robotX >= minX:
    #                if robotY <= maxY and robotY >= minY:
    #                    # we have a collision
    #                    collisionDistance = abs(currentX - robotX) + abs(currentY - robotY)
    #                    robotDistances.append(otherClient, collisionDistance)

    #    #no collisions
    #    if len(robotDistances) == 0:

    #    #sort by ascending distance
    #    robotDistances = sorted(robotDistances, key=lambda distance: distance[1])
    #    commands = []
    #    for i in range(distance):
    #        if robotDistances[0][1] > 1:
    #            # robot can move fine

    #    # use a DS with {start position, end, movement type, being pushed, (animation)}?
    #    # where movement type is forward, back, strafe left, strafe right
        
    def executeRegister(self, regNum):
        self.broadcast(Command(ServerCommands.RegisterPhaseBegin, { 'register': regNum }))
        
        # find robot with the highest priority for this register
        # get a list of each client object and their robot's card for this register
        robotCards = [(cli, cli.robot.registers[regNum]) for cli in self.clients]
        # sort the list
        robotCards = sorted(robotCards, key=lambda robotCard: robotCard[1])
        # robots move
        for (client, cardId) in robotCards:
            # get card from card ID
            card = self.deck.getCard(cardId)
            robot = client.robot
            if card.program >= 3:
                # if card requires a tile change then check if this is possible
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
                #self.checkMovement(client, newX, newY)
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
