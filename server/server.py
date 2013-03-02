import config
from game import Game
from network import ClientCommands
import utils

game = Game()

import json
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor

class Client(LineReceiver):
    def __init__(self):
        self.nickname = '<new client>'

    def connectionMade(self):
        if config.debug:
            print 'new connection'
        self.sendLine(utils.toJSON({ 'command': 'programDeck', 'value': game.deck.getDeck() }))

    def connectionLost(self, reason):
        if config.debug:
            print 'lost connection'

    def lineReceived(self, line):
        if config.debug:
            print '<%s>: %s' % (self.nickname, line)

        message = json.loads(line)

        if message.command == ClientCommands.MyNameIs:
            self.nickname = message.value

class ClientFactory(Factory):
    def buildProtocol(self, addr):
        return Client()

reactor.listenTCP(1234, ClientFactory())
reactor.run()
