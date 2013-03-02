# see http://stackoverflow.com/questions/36932/whats-the-best-way-to-implement-an-enum-in-python
def enum(**enums):
	return type('Enum', (), enums)
