from __future__ import annotations
import random

class Maze:
    DEF_SIZE = 10
    BLOCKED_CELL = '#'
    FREE_CELL = '0' #if you wanna change what is printed on screen, change it in the print method
    START_CELL = 'A'
    GOAL_CELL = 'T'
    MOVED_CELL = '.'
    CARDINALS = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    #make a default blank maze
    def __init__(self, size = DEF_SIZE, start_pos=(0,0), goal_pos=None) -> None:   
        self.size:int = size
        self.start_pos:tuple = start_pos
        if goal_pos is None:
            self.goal_pos:tuple = (size-1, size-1)
        else:
            self.goal_pos:tuple = goal_pos
        self.agent_pos:tuple = start_pos
        self.maze = [[Maze.FREE_CELL for i in range(self.size)] for j in range(self.size)]
        self.__og_startpos = self.start_pos
        self.__og_goalpos = self.goal_pos
        self.__og_agentpos = self.agent_pos
        # print("Ac", self.start_pos, self.agent_pos, self.goal_pos)
        # print("OG", self.__og_startpos, self.__og_agentpos, self.goal_pos)
    def reset_maze(self):
        for i in range(self.size):
            for j in range(self.size):
                if self.maze[i][j] == Maze.MOVED_CELL:
                    self.maze[i][j] = Maze.FREE_CELL
        self.agent_pos = self.__og_agentpos
        self.start_pos = self.__og_startpos
        self.goal_pos = self.__og_goalpos
        # print("OG", self.__og_startpos, self.__og_agentpos, self.__og_goalpos)
    def generate_fog_maze(self) -> Maze:
        fog_maze = Maze(size=self.size,
                    start_pos=self.start_pos, 
                    goal_pos=self.goal_pos)

        #let it know its intial neighbors
        for neighbor in self.get_neighbors(self.start_pos):
            fog_maze.set_cell(neighbor, self.get_cell(neighbor))
        return fog_maze
    @classmethod
    def generate_maze(cls, size) -> Maze:
        maze = Maze(size=size)
        visited = set()
        stack = []
        startCell = (random.randint(0, size - 1), random.randint(0, size - 1))
        maze.start_pos = startCell
        maze.agent_pos = startCell
        visited.add(startCell)
        stack.append(startCell)
        
        while len(visited) < size ** 2:
            currentCell = stack[-1]
            neighbors = maze.get_neighbors(currentCell)
            unvisited_neighbors = [n for n in neighbors if n not in visited]
            
            if unvisited_neighbors:
                nextCell = random.choice(unvisited_neighbors)
                visited.add(nextCell)
                
                if random.random() < 0.3:
                    maze.maze[nextCell[0]][nextCell[1]] = Maze.BLOCKED_CELL
                else:
                    maze.maze[nextCell[0]][nextCell[1]] = Maze.FREE_CELL
                    stack.append(nextCell)
            else:
                stack.pop()
                
            if not stack:  # if the stack is empty
                unvisitedCells = [(i, j) for i in range(size) for j in range(size) if (i, j) not in visited]

                if unvisitedCells:
                    nextCell = random.choice(unvisitedCells)
                    visited.add(nextCell)
                    stack.append(nextCell)

        goalCell = (random.randint(0, size - 1), random.randint(0, size - 1))
        
        while goalCell == startCell or maze.maze[goalCell[0]][goalCell[1]] == Maze.BLOCKED_CELL:
            goalCell = (random.randint(0, size - 1), random.randint(0, size - 1))
            
        maze.goal_pos = goalCell

        maze.__og_startpos = maze.start_pos
        maze.__og_agentpos = maze.agent_pos
        maze.__og_goalpos = maze.goal_pos
        return maze

    @classmethod
    def load_maze(cls, maze_path: str) -> Maze:
        maze_file = open(maze_path)
        size = int(maze_file.readline())
        maze = Maze(size=size)

        lines = maze_file.read().splitlines()
        for i in range(size):
            for j in range(size):
                cell_val = lines[i][j]
                if cell_val == maze.START_CELL:
                    maze.start_pos = (i, j)
                    cell_val = Maze.FREE_CELL
                if cell_val == maze.GOAL_CELL:
                    maze.goal_pos = (i, j)
                    cell_val = Maze.FREE_CELL  
                maze.maze[i][j] = cell_val                  
        maze_file.close()
        return maze
    def get_neighbors(self, pos):
        x, y = pos
        neighbors = []
        for dx, dy in Maze.CARDINALS:
            neighbor = (x-dx, y-dy)
            if self.is_valid_pos(neighbor):
                neighbors.append(neighbor)
        return neighbors
        
    def export_maze(self, f) -> None:
        f.write('_%s_\n' % ('_' * self.size))
        for i in range(self.size):
            f.write("|")
            for j in range(self.size):
                print_val = self.maze[i][j]
                if print_val == Maze.FREE_CELL:
                    print_val = ' '  # change this char to change what is printed as blank space
                if (i, j) == self.start_pos:
                    print_val = Maze.START_CELL
                if (i, j) == self.goal_pos:
                    print_val = Maze.GOAL_CELL
                f.write("%s" % print_val)
            f.write("|\n")
        f.write('‾%s‾\n' % ('‾' * self.size))
        f.flush()

    def print_maze(self) -> None:
        # print("size", self.size)
        print('_%s_' % ('_'*self.size))
        for i in range(self.size):
            print("|", end='')
            for j in range(self.size):
                print_val = self.maze[i][j]
                if print_val == Maze.FREE_CELL:
                    print_val = ' ' # change this char to change what is printed as blank space
                if (i,j) == self.start_pos:
                    print_val = Maze.START_CELL
                if (i,j) == self.goal_pos:
                    print_val = Maze.GOAL_CELL
                print("%s" % print_val, end='')
            print("|")
        print('‾%s‾' % ('‾'*self.size))
    def move_agent_to(self, pos) -> bool:
        if not self.is_valid_pos(pos):
            return False
        if self.is_blocked(pos):
            return False
        self.agent_pos = pos
        self.set_cell(pos, Maze.MOVED_CELL)
        return True
    def is_valid_pos(self, pos) -> bool:
        x, y = pos
        return x >= 0 and x < self.size and y >= 0 and y < self.size
    def is_blocked(self, pos) -> bool:
        return self.get_cell(pos) == Maze.BLOCKED_CELL
    def is_goal(self, pos) -> bool:
        return pos == self.goal_pos
    def swap_goal_and_start(self):
        self.start_pos, self.goal_pos = self.goal_pos, self.start_pos
        self.agent_pos = self.start_pos
    def get_cell(self, pos):
        x, y = pos
        return self.maze[x][y]
    def set_cell(self, pos, value):
        x, y = pos
        self.maze[x][y] = value
    def goal_reached(self) -> bool:
        return self.agent_pos == self.goal_pos