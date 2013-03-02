from twisted.internet import reactor

from game import Game
from entities.client import *

game = Game()
reactor.listenTCP(1234, ClientFactory(game))
reactor.run()
