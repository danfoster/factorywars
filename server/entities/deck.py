from entities.card import Card, Program

class Deck:

    def __init__(self):
        self.cards = []
        self.buildDeck()

    def buildDeck(self):
        for i in range(1,85):
            if i < 7:
                program = Program.UTurn
            elif i < 43:
                program = Program.RotateRight if i % 2 == 0 else Program.RotateLeft
            elif i < 49:
                program = Program.BackUp
            elif i < 67:
                program = Program.Move1
            elif i < 79:
                program = Program.Move2
            else:
                program = Program.Move3

            self.cards.append(Card(i * 10, program))

    def getDeck(self):
        #Test code
        return self.cards
