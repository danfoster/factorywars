
class Card:
	def __init__(self, priority, action):
		self.id = priority
		self.priority = priority
		self.action = action

cards = []

for i in range(1,84):
	if i < 7:
		action = Program.UTurn
	elif i < 43:
		action = Program.RotateRight if i % 2 == 0 else Program.RotateLeft
	elif i < 49:
		action = Program.BackUp
	elif i < 67:
		action = Program.Move1
	elif i < 79:
		action = Program.Move2
	else:
		action = Program.Move3

	cards.append(Card(i * 10, action))

print cards
