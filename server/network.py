from utils import *

ServerCommands = enum(
    ServerMessage = 0,
    ChatMessage = 1,
    ProgramDeck = 10,
    DealProgramCards = 11,
    FinalPlayerChoosingProgramCards = 12,
    DealOptionCard = 13,
    PlayerSetRegister = 14,
    PlayerClearRegister = 15,
    PlayerClearRegisters = 16,
    DamageRobot = 20
)

ClientCommands = enum(
    MyNameIs = 0,
    SetRegister = 10,
    ClearRegister = 11,
    ClearRegisters = 12,
    PlayOptionCard = 20,
    PowerDownNextTurn = 30
)

class Command:
    def __init__(self, command, value):
        self.command = command
        self.value = value
