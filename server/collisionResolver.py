from entities.movement import Movement, MovementType

class CollisionResolver:

    def resolveMovement(self, client, card):
        #newX = robot.x
        #newY = robot.y
        robot = client.robot
        movement = Movement(robot.x, robot.y)
        if card.program == Program.BackUp:
            movement.endX, movement.endY = robot.move(-1)
            movement.type = MovementType.Backward
            #newX, newY = robot.move(-1)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartBackward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopBackward, { 'clientId': client.id }))
        elif card.program == Program.Move1:
            movement.endX, movement.endY = robot.move(1)
            movement.type = MovementType.Forward
            #newX, newY = robot.move(1)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
        elif card.program == Program.Move2:
            movement.endX, movement.endY = robot.move(2)
            movement.type = MovementType.Forward
            #newX, newY = robot.move(2)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
        elif card.program == Program.Move3:
            movement.endX, movement.endY = robot.move(3)
            movement.type = MovementType.Forward
            #newX, newY = robot.move(3)
            #self.broadcast(Command(ServerCommands.RobotGracefulStartForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotContinueForward, { 'clientId': client.id }))
            #self.broadcast(Command(ServerCommands.RobotGracefulStopForward, { 'clientId': client.id }))
        # TODO: check that moving is legal, and find final position
        # check for any robot collisions (pushing)
        self.checkMovement(client, movement)
        #robot.x = newX
        #robot.y = newY
