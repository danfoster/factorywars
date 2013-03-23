import config
import utils
from network import ClientCommands, ServerCommands, Command

import json
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver

class Client(LineReceiver):
    def __init__(self, game, clientId):
        self.id = clientId
        self.game = game
        self.nickname = '<new client>'
        self.hand = []
        self.robot = None

    def connectionMade(self):
        if config.debug:
            print 'new connection'
        self.game.addClient(self)
        self.send(Command(ServerCommands.ProgramDeck, self.game.deck.getDeck()))
        self.hand = [self.game.deck.dealCard().id for x in range(1,10)]
        self.send(Command(ServerCommands.DealProgramCards, self.hand))

    def send(self, obj):
        self.sendLine(utils.toJSON(obj))

        # TODO: remove this test code
        # set the first register to move 1
        self.robot.registers[0] = 66
        self.game.start()

    def connectionLost(self, reason):
        if config.debug:
            print 'lost connection'

    def lineReceived(self, line):
        if config.debug:
            print '<%s>: %s' % (self.nickname, line)

        message = utils.evalJSON(line)

        if message.command == ClientCommands.MyNameIs:
            self.nickname = message.value

        elif message.command == ClientCommands.SetRegister:
            cardId = message.value['programCardId']
            if cardId not in self.hand:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to send card ID \'%s\'. This card was never in your hand.' % cardId))
                return

            if cardId in self.robot.registers.values():
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to use the same card ID \'%s\' in 2 different registers.' % cardId))
                return

            self.robot.registers[message.value['register']] = cardId
            self.game.broadcast(Command(ServerCommands.PlayerSetRegister, { clientId: self.id, programCardId: cardId }))

        elif message.command == ClientCommands.ClearRegister:
            registerId = message.value['register']
            self.robot.registers[registerId] = None
            self.game.broadcast(Command(ServerCommands.PlayerClearRegister, { clientId: self.id, register: registerId }))

        elif message.command == ClientCommands.ClearRegisters:
            for register in self.robot.registers:
                register = None
            self.game.broadcast(Command(ServerCommands.PlayerClearRegisters, { clientId: self.id }))

        elif message.command == ClientCommands.CommitRegisters:
            if len(self.robot.registers.keys() != 5):
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to commit your registers, but you haven\'t selected all 5 cards yet'))
                return

            self.robot.commitRegisters()
            self.game.broadcast(Command(ServerCommands.PlayerCommitRegisters, { clientId: self.id }))
                


class ClientFactory(Factory):
    def __init__(self,game):
        self.connectionCount = 0
        self.game = game

    def buildProtocol(self, addr):
        newClient = Client(self.game, self.connectionCount)
        self.connectionCount = self.connectionCount + 1
        return newClient
