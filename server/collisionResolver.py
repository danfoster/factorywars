from entities.movement import Movement, MovementType
from entities.card import Program
from entities.robot import Direction
from network import ServerCommands, Command

class CollisionResolver:

    # returns a list of the animations that result from the given client executing the given card
    def resolveMovement(self, client, card, clients):
        cardMovements = self.buildMovementFromCard(client, card)
        movementList = []
        for movement in cardMovements:
            movementList.append(self.checkMovement(client, movement, clients))
        animationList = []
        for list in movementList:
            for movement in list:
                animations = self.getAnimation(movement)
                for animation in animations:
                    animationList.append(animation)
        return animationList
        

    # returns a list of movements that will occur as the given movement is executed
    def checkMovement(self, client, movement, clients):
        movements = [movement]
        for otherClient in clients:
            if client.id != otherClient.id:
                robotX = otherClient.robot.x
                robotY = otherClient.robot.y
                if robotX == movement.endX and robotY == movement.endY:
                    # we have a collision
                    newMove = Movement(robotX, robotY, otherClient)
                    newMove.endX, newMove.endY = self.positionAfterPush(movement)
                    newMove.type = self.typeDuringPush(otherClient.robot, movement.direction)
                    newMove.direction = movement.direction
                    newMove.beingPushed = True
                    newMove.order = movement.order
                    movements.append(newMove)
        return movements


    # returns the MovementType resulting from the given robot being pushed in the given direction
    def typeDuringPush(self, robot, direction):
        if robot.orient == direction:
            return MovementType.Forward
        elif (robot.orient % 4) + 1 == direction:
            return MovementType.StrafeLeft
        elif ((robot.orient + 1) % 4) + 1 == direction:
            return MovementType.Backward
        elif ((robot.orient + 2) % 4) + 1 == direction:
            return MovementType.StrafeRight

    # returns the position after a robot has been pushed by a robot with the given movement
    def positionAfterPush(self, movement):
        x = movement.endX
        y = movement.endY
        if movement.direction == Direction.Down:
            y = y + 1
        elif movement.direction == Direction.Left:
            x = x - 1
        elif movement.direction == Direction.Up:
            y = y - 1
        elif movement.direction == Direction.Right:
            x = x + 1

        return x,y


    # returns a list of movements (where each movement is 1 tile)
    def buildMovementFromCard(self, client, card):
        robot = client.robot
        #newX = robot.x
        #newY = robot.y
        movement = Movement(robot.x, robot.y, client)
        movements = [movement]
        if card.program == Program.BackUp:
            movement.endX, movement.endY = robot.move(-1)
            movement.type = MovementType.Backward
            movement.direction = ((robot.orient - 3) % 4) + 1
            #newX, newY = robot.move(-1)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartBackward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopBackward, { 'clientId': client.id }))
        else:
            extra = 0
            if card.program == Program.Move2:
                extra = 1
            elif card.program == Program.Move3:
                extra = 2

            movement.endX, movement.endY = robot.move(1)
            movement.type = MovementType.Forward
            movement.direction = robot.orient

            for i in range(extra):
                newX, newY = robot.move(i+1)
                newMovement = Movement(newX, newY, client)
                newMovement.endX, newMovement.endY = robot.move(i+2)
                newMovement.type = MovementType.Forward
                newMovement.direction = movement.direction
                movements.append(newMovement)
            
            #newX, newY = robot.move(1)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
            
            #newX, newY = robot.move(2)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
        
            #newX, newY = robot.move(3)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
        return movements
        #robot.x = newX
        #robot.y = newY

    # returns an animation command corresponding to the given movement
    def getAnimation(self, movement):
        #TODO: resolve the fact that this doesn't work when moving more than 1 tile at a time
        animations = []
        json = { 'clientId': movement.client.id }
        if movement.type == MovementType.Forward:
            if movement.beingPushed == False:
                animations.append(Command(ServerCommands.RobotGracefulStartForward, json))
                animations.append(Command(ServerCommands.RobotGracefulStopForward, json))
            else:
                #TODO: pushing animations here
                animations.append(Command(ServerCommands.RobotGracefulStartForward, json))
                animations.append(Command(ServerCommands.RobotGracefulStopForward, json))
        elif movement.type == MovementType.Backward:
            if movement.beingPushed == False:
                animations.append(Command(ServerCommands.RobotGracefulStartBackward, json))
                animations.append(Command(ServerCommands.RobotGracefulStopBackward, json))
            else:
                #TODO: pushing animations here
                animations.append(Command(ServerCommands.RobotGracefulStartBackward, json))
                animations.append(Command(ServerCommands.RobotGracefulStopBackward, json))
        #TODO: rest of animations here

        return animations