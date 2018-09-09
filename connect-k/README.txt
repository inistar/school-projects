## Connect-k AI poject CS171

Developed an artificial intelligence Connect-K player using Iterative Deepening Search(IDS) and Alpha-beta
pruning to search for the optimal move to be played.

Java (Eclpise)

- Program starts with getMove() method. (The move has a limited amount of time. If time has excedeed, then the best possbile move found so far will be returned.)

State of the board will be passed to the methods. The clas only keeps the track of the best path so far.

Iterative Deepening Search:
Searchs through the tree 1 at a time using depth first. Takes the advantage of exploring each branch as well as breath first seach of exploring all the available branches. The max depth fo the tree will increase after each iteration.

Alpha Beta Pruning:
While doing IDS and calculating the Heuristic value of each branch, alpha beta pruning allows to search deeper into the branch only if there is a potential for finding a higher heurisitc value then the other branches.

Heuristic Evaluation:
Using the current state of the board, how many ways can you win (positive) vs how many ways can your opponent win (negative). This evaluates to a score and I just pick the highest score. 