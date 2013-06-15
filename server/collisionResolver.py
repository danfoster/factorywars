from entities.movement import Movement, MovementType
from entities.card import Program

class CollisionResolver:

    def resolveMovement(self, client, card):
        robot = client.robot
        self.movementList = buildMovementFromCard(robot, card)


    def checkMovement(self, client, movement):
        minX = min(movement.startX, movement.endX)
        maxX = max(movement.startX, movement.endX)
        minY = min(movement.startY, movement.endY)
        maxY = max(movement.startY, movement.endY)

        robotDistances = []
        # find the distances to all other robots that will be hit
        for otherClient in self.clients:
            if client.id != otherClient.id:
                robotX = otherClient.robot.x
                robotY = otherClient.robot.y
                if robotX <= maxX and robotX >= minX:
                    if robotY <= maxY and robotY >= minY:
                        # we have a collision
                        collisionDistance = abs(currentX - robotX) + abs(currentY - robotY)
                        robotDistances.append(otherClient, collisionDistance)

        ##no collisions
        #if len(robotDistances) == 0:

        ##sort by ascending distance
        #robotDistances = sorted(robotDistances, key=lambda distance: distance[1])
        #for i in range(distance):
        #    if robotDistances[0][1] > 1:
        #        # robot can move fine


    # returns a list of movements (where each movement is 1 tile)
    def buildMovementFromCard(self, robot, card):
        #newX = robot.x
        #newY = robot.y
        movement = Movement(robot.x, robot.y)
        movements = [movement]
        if card.program == Program.BackUp:
            movement.endX, movement.endY = robot.move(-1)
            movement.type = MovementType.Backward
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

            for i in range(extra):
                newMovement = Movement(robot.move(i+1))
                newMovement.endX, newMovement.endY = robot.move(i+2)
                newMovement.type = MovementType.Forward
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
