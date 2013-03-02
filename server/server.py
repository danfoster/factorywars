import config
from game import Game
import utils

game = Game()

from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
from twisted.internet import reactor

class Client(LineReceiver):
    def connectionMade(self):
        if config.debug:
            print 'new connection'
        self.sendLine(utils.toJSON({ 'command': 'programDeck', 'value': game.programCards }))

    def connectionLost(self, reason):
        if config.debug:
            print 'lost connection'

    def lineReceived(self, line):
        if config.debug:
            print 'received \'%s\'' % line

class ClientFactory(Factory):
    def buildProtocol(self, addr):
        return Client()

reactor.listenTCP(1234, ClientFactory())
reactor.run()
