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

    def send(self, obj):
        json = utils.toJSON(obj)
        if config.debug:
            print 'sending to <%s>: %s' % (self.nickname, json)
        self.sendLine(json)

    def connectionLost(self, reason):
        if config.debug:
            print 'lost connection'
        self.game.removeClient(self)

        self.game.broadcastExcept(self.id, Command(ServerCommands.ClientLeft, { 'clientId': self.id }))

    def lineReceived(self, line):
        if config.debug:
            print '\'<%s>: %s\'' % (self.nickname, line)

        message = utils.evalJSON(line)

        if message.command == ClientCommands.MyNameIs:
            self.nickname = message.value
            self.game.broadcast(Command(ServerCommands.ClientChangedNickname, { 'clientId': self.id, 'nickname': self.nickname }))

        elif message.command == ClientCommands.SetRegister:
            cardId = message.value['programCardId']
            if cardId not in self.hand:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to send card ID \'%s\'. This card was never in your hand.' % cardId))
                return

            if cardId in self.robot.registers:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to use the same card ID \'%s\' in 2 different registers.' % cardId))
                return

            register = message.value['register']
            self.robot.registers[register] = cardId
            self.game.broadcast(Command(ServerCommands.PlayerSetRegister, { 'clientId': self.id, 'register': register }))

        elif message.command == ClientCommands.ClearRegister:
            if self.robot.registersCommitted:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to clear a register, but you have committed your registers'))
                return

            register = message.value['register']
            self.robot.registers[register] = None
            self.game.broadcast(Command(ServerCommands.PlayerClearRegister, { 'clientId': self.id, 'register': register }))

        elif message.command == ClientCommands.ClearRegisters:
            if self.robot.registersCommitted:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to clear your registers, but you have committed them'))
                return

            for register in self.robot.registers:
                register = None
            self.game.broadcast(Command(ServerCommands.PlayerClearRegisters, { 'clientId': self.id }))

        elif message.command == ClientCommands.CommitRegisters:
            if len(self.robot.registers) != 5:
                self.send(Command(ServerCommands.ServerMessage, 'You just tried to commit your registers, but you haven\'t selected all 5 cards yet'))
                return

            self.game.clientCommitRegisters(self)
                

class ClientFactory(Factory):
    def __init__(self,game):
        self.connectionCount = 0
        self.game = game

    def buildProtocol(self, addr):
        newClient = Client(self.game, self.connectionCount)
        self.connectionCount = self.connectionCount + 1
        return newClient
