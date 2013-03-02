import config
import utils

from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver


class Client(LineReceiver):
    def __init__(self,game):
        self.game = game
        self.nickname = '<new client>'

    def connectionMade(self):
        if config.debug:
            print 'new connection'
        self.game.addClient(self)
        self.sendLine(utils.toJSON({ 'command': 'programDeck', 'value': self.game.deck.getDeck() }))

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
    def __init__(self,game):
        self.game = game

    def buildProtocol(self, addr):
        return Client(self.game)


