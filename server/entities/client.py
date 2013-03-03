import config
import utils
from network import ClientCommands, ServerCommands

import json
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver

class Client(LineReceiver):
    def __init__(self, game):
        self.game = game
        self.nickname = '<new client>'
        self.robot = None

    def connectionMade(self):
        if config.debug:
            print 'new connection'
        self.game.addClient(self)
        self.sendLine(utils.toJSON({ 'command': ServerCommands.ProgramDeck, 'value': self.game.deck.getDeck() }))
        hand = [self.game.deck.dealCard() for x in range(1,10)]
        self.sendLine(utils.toJSON({ 'command': ServerCommands.DealProgramCards, 'value': hand }))

    def connectionLost(self, reason):
        if config.debug:
            print 'lost connection'

    def lineReceived(self, line):
        if config.debug:
            print '<%s>: %s' % (self.nickname, line)

        message = json.loads(line)

        if message['command'] == ClientCommands.MyNameIs:
            self.nickname = message['value']


class ClientFactory(Factory):
    def __init__(self,game):
        self.game = game

    def buildProtocol(self, addr):
        return Client(self.game)


