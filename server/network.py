from utils import *

ServerCommands = enum(
    ServerMessage = 0,
    ChatMessage = 1,
    ClientJoined = 2,
    ClientLeft = 3,
    ClientChangedNickname = 4,
    YourClientIdIs = 5,

    ProgramDeck = 10,
    DealProgramCards = 11,
    FinalPlayerChoosingProgramCards = 12,
    DealOptionCard = 13,
    PlayerSetRegister = 14,
    PlayerClearRegister = 15,
    PlayerClearRegisters = 16,
    PlayerCommitRegisters = 17,
    YourStartPositionIs = 18,
    StartPosition = 19,

    RegisterPhaseBegin = 30,
    CurrentProgramCard = 31,
    DamageRobot = 32,
    TurnBegin = 33,

    RobotTurnRight = 40,
    RobotTurnLeft = 41,
    RobotTurnAround = 42,
    RobotGracefulStartForward = 43,
    RobotGracefulStartBackward = 44,
    RobotGracefulStopForward = 45,
    RobotGracefulStopBackward = 46,
    RobotContinueForward = 47,
    RobotContinueBackward = 48,

    RegisterPhaseEnd = 70,
    TurnEnd = 71
)

ClientCommands = enum(
    MyNameIs = 0,
    SetRegister = 10,
    ClearRegister = 11,
    ClearRegisters = 12,
    CommitRegisters = 13,
    PlayOptionCard = 20,
    PowerDownNextTurn = 30
)

class Command:
    def __init__(self, command, value):
        self.command = command
        self.value = value
