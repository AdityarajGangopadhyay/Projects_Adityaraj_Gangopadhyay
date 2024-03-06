from maze import Maze
from A_star import repeated_a_star

with open("Demo Output", 'w', encoding='utf-8') as f2:
    print("Demo Maze")
    f2.write("Demo Maze\n")
    maze = Maze.generate_maze(101)

    maze.print_maze()
    maze.export_maze(f2)

    temp = repeated_a_star(maze, max_num_of_steps_to_print=5, f=f2)
    print("Forwards Repeated A* took:", str(temp))
    f2.write("Forwards Repeated A* took: " + str(temp) + "\n")
    maze.print_maze()
    maze.export_maze(f2)

    maze.reset_maze()
f2.close()

# Terminal Can't Save all this (not on PyCharm at least)
# Need to export to a txt file to read full thing

# TODO
# 3 algos: forward, backwards, adaptive
# 2 tie/per algo: favor higher g values, or favor lower g values

sumRepForTime, sumRepBacTime, sumAdapForTime = 0,0,0
sumRepForExpanded, sumRepBacExpanded, sumAdapForExpanded = 0,0,0
sumRepForTimeSmallerGval, sumRepBacTimeSmallerGval, sumAdapForTimeSmallerGval = 0,0,0
sumRepForExpandedSmallerGval, sumRepBacExpandedSmallerGval, sumAdapForExpandedSmallerGval = 0,0,0
with open("50 Mazes Report Output", 'w', encoding='utf-8') as f:
    for i in range(50):
        maze = Maze.generate_maze(101)

        f.write("Maze Number: " + str((i + 1)) + "\n")
        f.flush()
        temp = repeated_a_star(maze, favor_larger_g=True)
        f.write("Forwards Repeated A* took, Large Values: " + str(temp) + "\n")
        if temp[0] != False:
            sumRepForTime += temp[1]
            sumRepForExpanded += temp[2]
        f.flush()
        maze.reset_maze()
        temp = repeated_a_star(maze, favor_larger_g=False)
        if temp[0] != False:
            sumRepForTimeSmallerGval += temp[1]
            sumRepForExpandedSmallerGval += temp[2]
        f.write("Forwards Repeated A* took, Small Values: " + str(temp) + "\n")

        f.flush()
        maze.reset_maze()

        temp = repeated_a_star(maze, backwards=True, favor_larger_g=True)
        f.write("Backwards Repeated A* took, Large Values: " + str(temp) + "\n")
        if temp[0] != False:
            sumRepBacTime += temp[1]
            sumRepBacExpanded += temp[2]
        f.flush()
        maze.reset_maze()

        temp = repeated_a_star(maze, adaptive=True, favor_larger_g=True)
        if temp[0] != False:
            sumAdapForTime += temp[1]
            sumAdapForExpanded += temp[2]
        f.write("Adaptive Repeated A* took, Large Values: " + str(temp) + "\n")
        f.flush()
        maze.reset_maze()

        

        temp = repeated_a_star(maze, backwards=True, favor_larger_g=False)
        f.write("Backwards Repeated A* took, Small Values: " + str(temp) + "\n")
        if temp[0] != False:
            sumRepBacTimeSmallerGval += temp[1]
            sumRepBacExpandedSmallerGval += temp[2]
        f.flush()
        maze.reset_maze()

        temp = repeated_a_star(maze, adaptive=True, favor_larger_g=False)
        if temp[0] != False:
            sumAdapForTimeSmallerGval += temp[1]
            sumAdapForExpandedSmallerGval += temp[2]
        f.write("Adaptive Repeated A* took, Small Values: " + str(temp) + "\n")
        f.flush()

        f.write("\n")
        f.flush()
    print("Average Run Times: Algo Name: Larger vs Smaller")
    print("Repeated Forwards", sumRepForTime/50, "ms", "vs", sumRepForTimeSmallerGval/50, "ms")
    print("Repeated Backwards", sumRepBacTime/50, "ms", "vs", sumRepBacTimeSmallerGval/50, "ms")
    print("Repeated Adaptive", sumAdapForTime/50, "ms", "vs", sumAdapForTimeSmallerGval/50, "ms")
    print("Average Run Num Of Nodes Expanded: Algo Name: Larger vs Smaller")
    print("Repeated Forwards", sumRepForExpanded/50, "nodes", "vs", sumRepForExpandedSmallerGval/50, "nodes")
    print("Repeated Backwards", sumRepBacExpanded/50, "nodes", "vs", sumRepBacExpandedSmallerGval/50, "nodes")
    print("Repeated Adaptive", sumAdapForExpanded/50, "nodes", "vs", sumAdapForExpandedSmallerGval/50, "nodes")
    f.write("Average Run Times: Algo Name: Larger vs Smaller\n")
    f.write("Repeated Forwards "+str(sumRepForTime/50)+" ms vs " + str(sumRepForTimeSmallerGval/50) + " ms\n")
    f.write("Repeated Backwards "+str(sumRepBacTime/50)+" ms vs " + str(sumRepBacTimeSmallerGval/50) + " ms\n")
    f.write("Repeated Adaptive "+str(sumAdapForTime/50)+" ms vs " + str(sumAdapForTimeSmallerGval/50) + " ms\n")
    f.write("Average Run Num Of Nodes Expanded: Algo Name: Larger vs Smaller\n")
    f.write("Repeated Forwards "+str(sumRepForExpanded/50) +" nodes " + str(sumRepForExpandedSmallerGval/50) + " nodes\n")
    f.write("Repeated Backwards "+str(sumRepBacExpanded/50)+" nodes " + str(sumRepBacExpandedSmallerGval/50) + " nodes\n")
    f.write("Repeated Adaptive "+str(sumAdapForExpanded/50)+" nodes " + str(sumAdapForExpandedSmallerGval/50) + " nodes\n")

f.close()

