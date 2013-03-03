from entities.card import Card, Program

class Deck:

    def __init__(self):
        self.deck = []
        self.dealt = []

        self.newRound()

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

            self.deck.append(Card(i * 10, program))

    def dealCard(self):
        card = self.deck.pop()
        self.dealt.append(card)
        return card

    def getDeck(self):
        return self.deck

    def newRound(self):
        self.deck = []
        self.dealt = []
        self.buildDeck()
