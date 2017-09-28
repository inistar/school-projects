#othello_game_logic
import othello_error

BLACK = 'B'
WHITE = 'W'
NONE = ' '

class game_state:
    '''controls the whole game board'''
    def __init__(self, row_input, column_input, player_input, game_type, corner_input):
        '''initializes the game board'''
        self._row_input = row_input
        self._column_input = column_input
        self._player_input = player_input
        self._game_type = game_type
        self._game_board = []
        self._pieces_flip = []
        self._both_valid_W = 0
        self._both_valid_B = 0
        self.status_update = ''
        self.score_w = 2
        self.score_b = 2
        self._corner_input = corner_input
        
    def new_game_board(self):
        '''sets up the game board'''
        for i in range(self._row_input):
            self._game_board.append(['.'] * (self._column_input))
                
    def setup_board(self):
        '''gets teh right set up of the game for the coins'''
        row = int(self._row_input/2 - 1)
        column = int(self._column_input/2 - 1)
        self._game_board[row][column] = self._corner_input
        self._game_board[row][column+1] = self.black_white(self._corner_input)
        self._game_board[row+1][column] = self.black_white(self._corner_input)
        self._game_board[row+1][column+1] = self._corner_input
        
                
    def is_valid(self, row, col):
        '''checks if the input is insdie the board'''
        try: 
            if self._game_board[row][col] == '.':
                return True
            raise othello_error.OutBoundError
        except othello_error.OutBoundError:
            return False
        except:
            return False
        
    def is_coin(self, row, col):
        '''checks if the input is a coin'''
        try: 
            if self._game_board[row][col] != WHITE and self._game_board[row][col] != BLACK:
                raise othello_error.CoinError
            return True
        except othello_error.CoinError:
            return False
        except:
            return False

    def flip_piece(self, row, col):
        '''checks all the possible pieces to flip'''
        self._pieces_flip = []
        valid = False
        
        for row_ch, col_ch in [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]:
            temp_list = []
            curr_row, curr_col = row, col
            curr_row += row_ch            
            curr_col += col_ch
      
            if self.is_coin(curr_row, curr_col):
                try:
                    while(self._player_input == self.black_white(self._game_board[curr_row][curr_col])):
                        temp_list.append([curr_row, curr_col])
                        curr_row += row_ch
                        curr_col += col_ch
                        if curr_row >= 0 and curr_col >= 0:
                            if self._player_input == self._game_board[curr_row][curr_col]:
                                self._pieces_flip.append(temp_list)
                                valid = True
                      
                except:
                    pass #print()
        return valid     
    
    def black_white(self, color):
        '''Switch the coin to another color'''
        if color == WHITE:
            return BLACK
        if color == BLACK:
            return WHITE
        return 0

    def place_coin(self, row, col):
        '''places the coin in the board'''
        self._game_board[row][col] = self._player_input
        self._player_input = self.black_white(self._player_input)

    def turn_piece(self):
        '''turns the piece'''
        for i in self._pieces_flip:
            for j in i:
                self._game_board[j[0]][j[1]] = self.black_white(self._player_input)
        
    def make_move(self, row, col):
        '''checks to see if the move is valid'''
        try:
            if self.is_valid(row, col) == False:
                raise othello_error.WrongMove        
            if self.flip_piece(row, col):
                self.place_coin(row, col)
                self.turn_piece()
            else:
                self.status_update = "Sorry Wrong Input"
            self.status_update = 'Valid Move'
        except othello_error.WrongMove:
            self.status_update = "Sorry Wrong Input"
            return False
    
    def pass_turn(self):
        '''switches the turn of the player'''
        self._player_input = self.black_white(self._player_input)

    def check(self):
        '''checks to see if the next move is valid'''
        count = 0 
        while(count < 2):
            count += 1 
            if self._future_valid():
                return False
            else:
                if self._both_valid():
                    self.end_game()
                    return True 
                self.status_update = "No Moves For " + str(self._player_input)
                self.pass_turn()
   
        
    def _both_valid(self):
        '''checks if there are no moves for both players'''
        if self._player_input == WHITE:
            self._both_valid_W = True
        if self._player_input == BLACK:
            self._both_valid_B = True
        if self._both_valid_B and self._both_valid_W:
            return True
        return False
        
    def future_piece(self, row, col):
        '''looks at all the possible pieces that can be flipped for the next turn'''
        valid = False

        for row_ch, col_ch in [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]:
            temp_list = []
            curr_row, curr_col = row, col
            curr_row += row_ch            
            curr_col += col_ch
      
            if self.is_coin(curr_row, curr_col):
                try:
                    while(self._player_input == self.black_white(self._game_board[curr_row][curr_col])):
                        temp_list.append([curr_row, curr_col])
                        curr_row += row_ch
                        curr_col += col_ch
                        if curr_row >= 0 and curr_col >= 0:
                            if self._player_input == self._game_board[curr_row][curr_col]:
                                self._pieces_flip.append(temp_list)
                                valid = True
                    if self._player_input == self._game_board[curr_row][curr_col] and valid:
                        return True
                
                except:
                    valid = False
        return False
    
    def _future_valid(self):
        '''calls the future valid and makes sure it is a valid input'''
        for i in range(self._row_input):
            for j in range(self._column_input):
                if self._game_board[i][j] == '.':
                    if self.future_piece(i, j):
                        return True
        return False
    
    def score(self):
        '''gets the score for the game'''
        temp_list = []
        self.score_w = 0
        self.score_b = 0
        for i in self._game_board:
            for j in i:
                if j == WHITE:
                    self.score_w += 1
                if j == BLACK:
                    self.score_b += 1
        temp_list.append(self.score_w)
        temp_list.append(self.score_b)
        return temp_list
        
    def end_game(self):
        '''ends the game'''
        temp_list = []
        temp_list = self.score()
        try:
            if self._game_type == 'M':
                if temp_list[0] > temp_list[1]:
                    most_white = 0
                    self.status_update = "Winner! WHITE"
                elif temp_list[0] == temp_list[1]:
                    raise othello_error.TieError
                else:
                    self.status_update = "Winner! BLACK"
            else:
                if temp_list[0] < temp_list[1]:
                    most_white = 0
                    self.status_update = "Winner! WHITE"
                elif temp_list[0] == temp_list[1]:
                    raise othello_error.TieError
                else:
                    self.status_update = "Winner! BLACK"
        except othello_error.TieError:
            self.status_update = "Tie Game"
            
