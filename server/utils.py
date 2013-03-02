import config

# see http://stackoverflow.com/questions/36932/whats-the-best-way-to-implement-an-enum-in-python
def enum(**enums):
    return type('Enum', (), enums)

from json import JSONEncoder
class MyEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__  
jsonEncoder = MyEncoder(separators = (',', ':'))

def toJSON(obj):
    return jsonEncoder.encode(obj)
