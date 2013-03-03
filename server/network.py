from utils import *

ServerCommands = enum(ProgramDeck = 0,
                      DealProgramCards = 1,
                      FinalPlayerChoosingOptionCards = 2,
                      DealOptionCard = 3,
                      DamageRobot = 4)

ClientCommands = enum(MyNameIs = 0,
                      SetRegister = 10,
                      ClearRegister = 11,
                      ClearRegisters = 12,
                      PlayOptionCard = 20,
                      PowerDownNextTurn = 30)

class Command:
    def __init__(self, command, value):
        self.command = command
        self.value = value
