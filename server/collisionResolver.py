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
        self.checkContinuingMotions(movementList)
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
        client.robot.x = movement.endX
        client.robot.y = movement.endY
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
                    otherClient.robot.x = newMove.endX
                    otherClient.robot.y = newMove.endY
        return movements

    def checkContinuingMotions(self, movementList):
        # check if movement is the end of motion
        lastIndex = len(movementList) - 1
        finalMovements = movementList[lastIndex]
        for movement in finalMovements:
            movement.endOfMotion = True
        for i in range(0,lastIndex):
            for movement in movementList[i]:
                # list comprehension determines if there are any movements for this robot in the next stage
                moreMovements = [anotherMove for anotherMove in movementList[i+1] if anotherMove.client == movement.client]
                movement.endOfMotion = (len(moreMovements) == 0)
        # check in movement is the start of motion
        firstMovements = movementList[0]
        for movement in firstMovements:
            movement.startOfMotion = True
        for i in range(1,lastIndex+1):
            for movement in movementList[i]:
                previousMovements = [priorMove for priorMove in movementList[i-1] if priorMove.client == movement.client]
                movement.startOfMotion = (len(previousMovements) == 0)

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
        movement = Movement(robot.x, robot.y, client)
        movements = [movement]
        if card.program == Program.BackUp:
            movement.endX, movement.endY = robot.move(-1)
            movement.type = MovementType.Backward
            movement.direction = ((robot.orient - 3) % 4) + 1
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
            
        return movements

    # returns an animation command corresponding to the given movement
    def getAnimation(self, movement):
        #TODO: resolve the fact that this doesn't work when moving more than 1 tile at a time
        animations = []
        json = { 'clientId': movement.client.id }
        if movement.type == MovementType.Forward:
            if movement.beingPushed == False:
                if movement.startOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStartForward, json))
                else:
                    animations.append(Command(ServerCommands.RobotContinueForward, json))
                if movement.endOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStopForward, json))
            else:
                #TODO: pushing animations here
                if movement.startOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStartForward, json))
                else:
                    animations.append(Command(ServerCommands.RobotContinueForward, json))
                if movement.endOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStopForward, json))
        elif movement.type == MovementType.Backward:
            if movement.beingPushed == False:
                if movement.startOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStartBackward, json))
                else:
                    animations.append(Command(ServerCommands.RobotContinueBackward, json))
                if movement.endOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStopBackward, json))
            else:
                #TODO: pushing animations here
                if movement.startOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStartBackward, json))
                else:
                    animations.append(Command(ServerCommands.RobotContinueBackward, json))
                if movement.endOfMotion:
                    animations.append(Command(ServerCommands.RobotGracefulStopBackward, json))
        #TODO: rest of animations here

        return animations