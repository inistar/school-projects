/**
 * Author: Louis Nguyen, 53838327
 * Author: Iniyavan Sathiamurthi, 26242138
 * DSensorAI
 */
import java.awt.Point;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;
import java.util.Stack;

import connectK.BoardModel;
import connectK.CKPlayer;


/**
 * This Class represents an AI that was built to play the connect-K game.
 */
public class DSensorAI extends CKPlayer {

	private boolean firstMove;
	private int firstMoveCount;
	private byte myPlayer;
	private byte opponentPlayer;
	private long tStart; 
	private long tEnd;
	
	public DSensorAI(byte player, BoardModel state) {
		super(player, state);
		teamName = "DSensorAI";
		this.firstMove = true;
		this.myPlayer = 0;
		this.opponentPlayer = 0;
		this.firstMoveCount = 0;
	}

	/**
	 * IDS increases the depth of the board each iteration and stores the best
	 * point to be made.
	 * @param state
	 * @return
	 */
	private Object[] iterativeDeepeningSearch(BoardModel state){
		int alpha = Integer.MIN_VALUE;
		int beta = Integer.MAX_VALUE;
		Object[] result = null;
		Stack<Point> relBestPath = null; //relative best path
		
		for(int i = 1; i < 100; i++){
			try{
				result = alphaBetaPruning(state, 0, i, alpha, beta, relBestPath);
				//set the relative best path at each iteration
				relBestPath = (Stack<Point>) result[2];
				//remove the duplicate point
				if(!relBestPath.isEmpty())
					relBestPath.remove(0);
			}
			catch(InterruptedException e){
				//when time is close to 5 seconds, return the best value
				return result;
			}
		}
		
		return result;
	}
	
	/**
	 * alphaBetaPruning recurses through each depth to find the best heuritic value
	 * @param state
	 * @param depth
	 * @param maxDepth
	 * @param alpha
	 * @param beta
	 * @param relBestPath
	 * @return
	 * @throws InterruptedException
	 */
	private Object[] alphaBetaPruning(BoardModel state, int depth, int maxDepth, int alpha, int beta, Stack<Point> relBestPath) throws InterruptedException{
		BoardModel currClone = state.clone(); //modify the changes in the board
		ArrayList<Point> currList = null; // list of all valid moves
		Object[] currObj = null; //currObj details
		Object[] maxObj = new Object[3]; //best object found so far
		maxObj[2] = new Stack<Point>(); //best relative path
		boolean firstTime = true;
		int total = 0;
		
		//stops the function when getting close to 5 seconds. 
		if((System.currentTimeMillis() - tStart) > 4995)
			throw new InterruptedException();
		
		//base case when the depth is equal to teh maxDepth the calculate the value
		if(depth == maxDepth || check_state(state)){
			total = heuristicEvaluation(state, this.opponentPlayer);
			maxObj[0] = total - heuristicEvaluation(state, this.myPlayer);
			maxObj[1] = state.getLastMove();
			((Stack<Point>) maxObj[2]).push((Point) maxObj[1]);
			return maxObj;
		}
		else{
			//check whether gravity is enabled or not
			//find all the points that are valid using the pointListGravity
			//pop the relBestPath if there are any
			if(state.gravityEnabled()){ 
				if(relBestPath == null || relBestPath.empty())
					currList = pointListGravity(state, null);
				else
					currList = pointListGravity(state, (Point) relBestPath.pop());
			} 
			else{ 
				if(relBestPath == null || relBestPath.empty())
					currList = pointList(state, null);
				else
					currList = pointList(state, (Point) relBestPath.pop());
			}
			
			//This is the max
			if((depth % 2) == 0){				
				for(Point p : currList){
					if(state.getSpace(p.x, p.y) == 0){
						//prune
						if(alpha >= beta){
							((Stack<Point>) maxObj[2]).push((Point) maxObj[1]);
							return maxObj;
						} 
						
						currClone = currClone.placePiece(new Point(p.x, p.y), this.opponentPlayer);
						
						//if winner, reuturn this move
						if (currClone.winner() == this.opponentPlayer)
						{
							maxObj[0] = Integer.MAX_VALUE;
							maxObj[1] = new Point(p.x, p.y);
							return maxObj;
						}
						
						if(state.gravityEnabled()){ currObj = alphaBetaPruning(currClone, depth+1, maxDepth, alpha, beta,relBestPath); }
						else{ currObj = alphaBetaPruning(currClone, depth+1, maxDepth, alpha, beta, relBestPath); }
						currClone = currClone.placePiece(new Point(p.x, p.y), (byte)0);
						
						//update the maxObj
						if(firstTime){
							firstTime = false;
							maxObj[0] = (Integer)currObj[0];
							maxObj[1] = new Point(p.x, p.y);
							maxObj[2] = currObj[2];
							if((Integer)maxObj[0] > alpha)
								alpha = (Integer)maxObj[0];
						}
						else if((Integer)currObj[0] > (Integer)maxObj[0]){
							maxObj[0] = (Integer)currObj[0];
							maxObj[1] = new Point(p.x, p.y);
							maxObj[2] = currObj[2];
							if((Integer)maxObj[0] > alpha)
								alpha = (Integer)maxObj[0];
						}
					}
				}
			}
			//This is the min
			else{
				for(Point p : currList){
					if(state.getSpace(p.x, p.y) == 0){
						if(alpha >= beta){
							((Stack<Point>) maxObj[2]).push((Point) maxObj[1]);
							return maxObj;
						}
						currClone = currClone.placePiece(new Point(p.x, p.y), this.myPlayer);
						
						if (currClone.winner() == this.myPlayer)
						{
							maxObj[0] = Integer.MIN_VALUE;
							maxObj[1] = new Point(p.x, p.y);
							return maxObj;
						}

						if(state.gravityEnabled()){ currObj = alphaBetaPruning(currClone, depth+1, maxDepth, alpha, beta, relBestPath); }
						else{ currObj = alphaBetaPruning(currClone, depth+1, maxDepth, alpha, beta, relBestPath); }
						currClone = currClone.placePiece(new Point(p.x, p.y), (byte)0);

						//update the maxObj
						if(firstTime){
							firstTime = false;
							maxObj[0] = (Integer)currObj[0];
							maxObj[1] = new Point(p.x, p.y);
							maxObj[2] = currObj[2];
							if((Integer) maxObj[0] < beta)
								beta = (Integer)maxObj[0];
						}
						else if((Integer)currObj[0] < (Integer)maxObj[0]){
							maxObj[0] = (Integer)currObj[0];
							maxObj[1] = new Point(p.x, p.y);
							maxObj[2] = currObj[2];
							if((Integer)maxObj[0] < beta)
								beta = (Integer)maxObj[0];
						}
					}
				}
			}
		}
		
		((Stack<Point>) maxObj[2]).push((Point) maxObj[1]);
		
		return maxObj;
	}
	
	/**
	 * Check if the state still have any move left. Return false if there is move to make and False otherwise.
	 * @param state
	 * @return
	 */
	public boolean check_state(BoardModel state)
	{
		String str = state.toString();
		for (int i =0; i < str.length(); i++)
		{
			if (str.charAt(i) == '0')
				return false;
		}

		return true;
	}
	
	/**
	 * This method return the possible move on the state board when the game is playing on gravity mode.
	 * @param state
	 * @param bestPoint //best point from the relative best path
	 * @return
	 */
	private ArrayList<Point> pointListGravity(BoardModel state, Point bestPoint){
			
			ArrayList<Point> p = new ArrayList<Point>(); //valid moves
//			HashSet<Point> s = new HashSet<Point>();
			
			if(bestPoint != null)
				p.add(bestPoint);
			else
				bestPoint = new Point(-1,-1);
			
			for (int x = 0; x < state.getWidth(); x++){
				for (int y =0; y < state.getHeight(); y++){
					if(state.getSpace(x,y) == 0){
						if(x == bestPoint.x && y == bestPoint.y)
							break;
						p.add(new Point(x, y));
						break;
					}
				}
			}
			
			return p;
		}

	/**
	 * This method return a list of possible move when the game is in gravity off mode.
	 * @param state
	 * @param bestPoint //best point from the relative best path
	 * @return
	 */
	public ArrayList<Point> pointList(BoardModel state, Point bestPoint)
	{
		ArrayList<Point> p = new ArrayList<Point>();
//		HashSet<Point> s = new HashSet<Point>();
		
		if(bestPoint != null)
			p.add(bestPoint);
		else
			bestPoint = new Point(-1,-1);
			
		for (int x = 0; x < state.getWidth(); x++){
			for (int y =0; y < state.getHeight(); y++){
				if(state.getSpace(x,y) == 0){
					if(!(x == bestPoint.x && y == bestPoint.y)){
						p.add(new Point(x, y));
					}
				}
			}
		}
		
//		p.addAll(s);
		return p;
	}
	
	/**
	 * This method calculate the heuristic value for the player.
	 * It takes in the start board and the player value. Return the AI heuristic value when the player is the opponent and vice versa.
	 * @param state
	 * @param player
	 * @return
	 */
	private int heuristicEvaluation(BoardModel state, byte player){
		int currValue = 0;
		int total = 0;
//		if (state.winner() == player)
//			return Integer.MAX_VALUE;
		// calculate value in horizontal direction
		for(int x = 0; x < state.getWidth(); x++){
			for(int y = 0; y < state.getHeight(); y++){
				if(state.getSpace(x, y) != player){
					
					currValue++;
				}
				else{
					if(currValue >= state.getkLength())
						total += (1 + currValue - state.getkLength());
		
					currValue = 0;
				}
			}
			if(currValue >= state.getkLength())
				total += (1 + currValue - state.getkLength());
			
			currValue = 0;
		}

		currValue = 0;
		
		// calculate value in vertical direction
		for(int y= 0; y < state.getHeight(); y++){
			for(int x = 0; x < state.getWidth(); x++){
				
				if(state.getSpace(x, y) != player){
					currValue++;}
				else{
					if(currValue >= state.getkLength())
						total += (1 + currValue - state.getkLength());
		
					currValue = 0;
				}
			}
			if(currValue >= state.getkLength())
				total += (1 + currValue - state.getkLength());
			
			currValue = 0;
		}

		currValue = 0;
		
		// diagonal line
		ArrayList<Point> startPoints = new ArrayList<Point>();
		
		for(int x = 0; x < state.getWidth(); x++){
			
			Point temp = new Point(x, state.getHeight()-1);
			startPoints.add(temp);
		}
		
		
		//Get the middle line starting from the left-top cell to the right-end cell
		ArrayList<Point> middleLine = new ArrayList<Point>();
		int x_iterator=0;
		int y_iterator=0;
		currValue = 0;
		for (int i = 0; i < Math.min(state.getHeight(), state.getWidth()); i++)
		{
			
			Point temp = new Point( (int)startPoints.get(0).getX() + x_iterator, (int)startPoints.get(0).getY() - y_iterator);
			middleLine.add(temp);
			
			if(state.getSpace(temp) != player)
				currValue++;
			else{
				if(currValue >= state.getkLength())
					total += (1 + currValue - state.getkLength());
	
				currValue = 0;
			}
			if(currValue >= state.getkLength() && (((int)temp.getX() + 1) >= state.getWidth() || ((int)temp.getY()- 1) < 0)){
				total += (1 + currValue - state.getkLength());
				currValue =0;
			}
			x_iterator +=1;
			y_iterator +=1;
		}

		currValue = 0;
		x_iterator = 0;
		y_iterator = 0;
		//-----------------------------------------------------
		//Get the opposite line
		
		ArrayList<Point> middleLine2 = new ArrayList<Point>();
		for (int i = 0; i < Math.min(state.getHeight(), state.getWidth()); i++){
			Point temp = new Point((int)startPoints.get(startPoints.size()-1).getX() - x_iterator, (int)startPoints.get(startPoints.size()-1).getY() - y_iterator);
			middleLine2.add(temp);
			if(state.getSpace(temp) != player)
				currValue++;
			else{
				if(currValue >= state.getkLength())
					total += (1 + currValue - state.getkLength());
	
				currValue = 0;
			}
			if(currValue >= state.getkLength() && (((int)temp.getX()- 1) < 0 || ((int)temp.getY()- 1) < 0)){
				total += (1 + currValue - state.getkLength());
				currValue =0;
			}
			x_iterator +=1;
			y_iterator +=1;
		}
		x_iterator = 0;
		y_iterator = 0;
		currValue = 0;
		
		//-------------------------------------------------\
		// Downward cells
		
		y_iterator = 1;
		while(true){
			int y_position;
			if (y_iterator == state.getHeight())
				break;
			for (Point p: middleLine)
			{
				y_position = (int)p.getY() - y_iterator;
				if(y_position >= 0 )
				{
					if(state.getSpace((int)p.getX(), y_position) != player)
						currValue++;
					else{
						if(currValue >= state.getkLength())
							total += (1 + currValue - state.getkLength());
			
						currValue = 0;
					}
					if(currValue >= state.getkLength() && ((y_position-1) < 0)){
						total += (1 + currValue - state.getkLength());
						currValue =0;
					}
				}
				
				
			}
			
			currValue =0;
			for (Point p: middleLine2)
			{
				y_position = (int)p.getY() - y_iterator;
				if(y_position >= 0 )
				{
					if(state.getSpace((int)p.getX(), y_position) != player)
					{
						currValue++;
					}
					else{
						
						if(currValue >= state.getkLength())
							total += (1 + currValue - state.getkLength());
						currValue = 0;
						

						
					}
					
					if(currValue >= state.getkLength() && ((y_position-1) < 0)){
						total += (1 + currValue - state.getkLength());
						currValue =0;
					}
				}
				
			}
			currValue =0;
			y_iterator += 1;
		}
		
		//---------------------------------------------------------
		// Upward cells
		x_iterator = 1;
		while(true){
			int x_position;
			if (x_iterator == state.getWidth())
				break;
			for (Point p: middleLine)
			{
				x_position = (int)p.getX() + x_iterator;
				if(x_position < state.getWidth())
				{
					if(state.getSpace(x_position, (int)p.getY()) != player)
						currValue++;
					else{
						if(currValue >= state.getkLength())
							total += (1 + currValue - state.getkLength());
			
						currValue = 0;
					}
					if(currValue >= state.getkLength() && (x_position + 1 >= state.getWidth())){
						total += (1 + currValue - state.getkLength());
						currValue =0;
					}
				}
				
				
			}
			currValue =0;
			for (Point p: middleLine2)
			{
				x_position = (int)p.getX() - x_iterator;
				if(x_position >= 0 )
				{
					if(state.getSpace(x_position, (int)p.getY()) != player)
						currValue++;
					else{
						if(currValue >= state.getkLength())
							total += (1 + currValue - state.getkLength());
			
						currValue = 0;
					}
					if(currValue >= state.getkLength() && (x_position-1 < 0 )){
						total += (1 + currValue - state.getkLength());
						currValue =0;
					}
				}
			}
			currValue =0;
			x_iterator += 1;
		}
		
		
		
		return total;
		
	}
	
	@Override
	public Point getMove(BoardModel state) {
		int x, y;
		
		if(this.firstMove == true)
		{
			this.firstMove = false;
			
			if(state.getLastMove() == null){
				this.myPlayer = 1;
				this.opponentPlayer = 2;
			}
			else{
				this.opponentPlayer = 1;
				this.myPlayer = 2;
			}
			
			x = state.getWidth()/2;
			y = state.getHeight()/2;
			
			if(state.getSpace(state.getWidth()/2, state.getHeight()/2) == 0)
				return new Point(x, y);
	
		}
		
		Object[] tempObj = null;
		
		if(state.spacesLeft == 1){
			for(int i = 0; i < state.getWidth(); i++){
				for(int j = 0; j < state.getHeight(); j++){
					if(state.getSpace(i, j) == 0)
						return new Point(i, j);
				}
			}
		}

			tempObj = iterativeDeepeningSearch(state);
			
	
		return (Point) tempObj[1];
	}

	@Override
	public Point getMove(BoardModel state, int deadline) {
		tStart = System.currentTimeMillis();
		Point p = getMove(state);
		tEnd = System.currentTimeMillis();
		System.out.println("Total time: " + (tEnd - tStart)/1000.0);
		return p;
	}
}
