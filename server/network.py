from utils import *

ServerCommands = enum(ProgramDeck = 0,
                      DealProgramCards = 1,
                      FinalPlayerChoosingOptionCards = 2,
                      DealOptionCard = 3,
                      DamageRobot = 4)

ClientCommands = enum(MyNameIs = 0,
                      ArrangeProgramCard = 1,
                      ClearProgramCardArrangement = 2,
                      PlayOptionCard = 3,
                      PowerDownNextTurn = 4)

class Command:
    def __init__(self, command, value):
        self.command = command
        self.value = value
