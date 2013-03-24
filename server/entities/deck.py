from entities.card import Card, Program

import random

class Deck:

    def __init__(self):
        self.deck = []
        self.dealt = []

        self.fullDeck = {}

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

            card = Card(i * 10, program)
            self.deck.append(card)
            self.fullDeck.update({i * 10 : card})

    def dealCard(self):
        if len(self.deck) < 1:
            raise 'Empty deck, this shouldn\'t happen!'

        card = self.deck.pop(random.randint(0, len(self.deck) - 1))
        self.dealt.append(card)
        return card

    def getDeck(self):
        return self.deck

    def newRound(self):
        self.deck = []
        self.dealt = []
        self.buildDeck()

    def getCard(self, cardId):
        return self.fullDeck[cardId]
