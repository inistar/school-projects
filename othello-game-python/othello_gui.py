#othello_gui

import tkinter
import point
import othello_game_logic
#import coins

DEFAULT_FONT = ('Helvetica', 14)

class OthelloApplication:
    '''Continas the Othello GUI objects'''
    def __init__(self):
        '''Initialize the objects'''
        self._root_window = tkinter.Tk()

        self._row = 4
        self._col = 4
        self._player_type = 'B'
        self._corner_piece = 'B'
        self._most_least = 'M'
        self._end = False
        
        self._setup_game()        
        
        self._game_state = othello_game_logic.game_state(self._row, self._col, self._player_type, self._most_least, self._corner_piece)
        self._game_state.new_game_board()
        self._game_state.setup_board()
        
        self._state = self._game_state._game_board
        
        self._turn_text = tkinter.StringVar()
        self._turn_text.set('Ready!')

        self._score_white_black_text = tkinter.StringVar()
        self._score_white_black_text.set('White: 2 Black: 2')

        white_black_label = tkinter.Label(
            master = self._root_window, textvariable = self._score_white_black_text, font = DEFAULT_FONT)

        white_black_label.grid(
            row = 0, column = 0, padx = 10, pady = 10,
            sticky = tkinter.S)
            
        self._canvas = tkinter.Canvas(
            master = self._root_window, width = 400, height = 400,
            background = 'Green')
        
        self._canvas.grid(
            row = 1, column = 0, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)
        
        turn_label = tkinter.Label(
            master = self._root_window, textvariable = self._turn_text, font = DEFAULT_FONT)

        turn_label.grid(
            row = 2, column = 0, padx = 10, pady = 10,
            sticky = tkinter.S)
        
        self._root_window.rowconfigure(0, weight = 1)
        self._root_window.columnconfigure(0, weight = 1)
        self._root_window.rowconfigure(1, weight = 10)
        self._root_window.rowconfigure(2, weight = 1)

    
        self._canvas.bind('<Configure>', self._on_canvas_resized)
        self._canvas.bind('<Button-1>', self._on_canvas_clicked)

    def _setup_game(self):
        '''pops up the set up dialog'''
        setup_dialog = SetupDialog()
        setup_dialog.show()

        self._row = int(setup_dialog._row_num)
        self._col = int(setup_dialog._col_num)
        
        self._player_type = str(setup_dialog._player)
        self._corner_piece = str(setup_dialog._corner)
        self._most_least = str(setup_dialog._type)
    
        
    def _on_canvas_resized(self, event: tkinter.Event) -> None:
        '''Has all the things that need to be resized'''
        self._canvas.delete(tkinter.ALL)
        
        self._create_row_lines()
        self._create_col_lines()
        self._resize_game_coins()
        
    def _on_canvas_clicked(self, event: tkinter.Event) -> None:
        '''handles the function when a cell is being clicked'''
        canvas_width = self._canvas.winfo_width()
        canvas_height = self._canvas.winfo_height()

        click_point = point.from_pixel(
            event.x, event.y, canvas_width, canvas_height)

        temp_frac = click_point.frac()
        row = int(self._row*temp_frac[1])
        col = int(self._col*temp_frac[0])

        self._connect_logic(row, col)

        self._resize_game_coins()
        
        if self._end:
            self._end_game()
            self._root_window.destroy()
            raise SystemExit(0)
        
    def _resize_game_coins(self) -> None:
        '''Resizes the coins'''
        canvas_width = self._canvas.winfo_width()
        canvas_height = self._canvas.winfo_height()
        
        row_size = canvas_width/self._col
        col_size = canvas_height/self._row

        count = 0
        temp_count = 1
        
        for coin in self._state:
            temp_j = 1
            for j in range(len(coin)):
                
                if coin[j] != '.':
                    if coin[j] == 'B':
                        self._canvas.create_oval(
                            (row_size*j)+ canvas_width/100,
                            (col_size*count)+canvas_height/100,
                            (row_size*temp_j)-canvas_width/100,
                            (col_size*temp_count)- canvas_height/100, fill = 'Black')
                    if coin[j] == 'W':
                        self._canvas.create_oval(
                            (row_size*j)+ canvas_width/100,
                            (col_size*count)+canvas_height/100,
                            (row_size*temp_j)-canvas_width/100,
                            (col_size*temp_count)- canvas_height/100, fill = 'White')

                temp_j += 1
            count += 1
            temp_count += 1

    def _connect_logic(self, row: int, col: int):
        '''Connect to the game logic'''
        self._game_state.make_move(row ,col)
        self._end = self._game_state.check()
        self._game_state.score()
        self._turn_text.set('Turn: ' +self._game_state._player_input + '  Status: ' + self._game_state.status_update)
        self._score_white_black_text.set('White: ' + str(self._game_state.score_w) + '     Black: ' + str(self._game_state.score_b))

    def _end_game(self):
        '''Calls the end dialog'''
        end_dialog = EndDialog()
        end_dialog.show()
        
    def _create_row_lines(self) -> None:
        '''Creates the row of lines'''
        canvas_width = self._canvas.winfo_width()
        canvas_height = self._canvas.winfo_height()
        row = canvas_width/self._col
        col = canvas_height/self._row
        
        temp_col = col
        
        for i in range(self._row):
            self._canvas.create_line(0, col, canvas_width, col, fill='black')
            col += temp_col

    def _create_col_lines(self) -> None:
        '''creates teh column line'''
        canvas_width = self._canvas.winfo_width()
        canvas_height = self._canvas.winfo_height()
        
        row = canvas_width/self._col
        col = canvas_height/self._row
        
        temp_row = row

        for i in range(self._col):
            self._canvas.create_line(row, 0, row, canvas_height, fill='black')
            row += temp_row

class EndDialog:
    '''Contains the end dialog objects'''
    def __init__(self):
        '''initializes the end dialog'''
        self._end_window = tkinter.Toplevel()
        
        end_game_label = tkinter.Label(
            master = self._end_window, text = 'Othello Game Ended',
            font = DEFAULT_FONT)

        end_game_label.grid(
            row = 0, column = 0, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        #For the YES and NO buttons
        button_frame = tkinter.Frame(master = self._end_window)

        button_frame.grid(
            row = 1, column = 0, padx = 10, pady = 10,
            sticky = tkinter.E + tkinter.S)

        no_button = tkinter.Button(
            master = button_frame, text = 'EXIT', font = DEFAULT_FONT,
            command = self._on_no_button)

        no_button.grid(row = 0, column = 1, padx = 10, pady = 10)

        self._yes_clicked = False
        self._no_clicked = False
        self._end_game = False

    def _on_no_button(self) -> None:
        '''if the exit button is clicked then destroys the window'''
        self._no_clicked = True
        self._end_game = True
        self._end_window.destroy()
        
    def show(self) -> None:
        '''shows the window'''
        self._end_window.grab_set()
        self._end_window.wait_window()
            
class SetupDialog:
    '''contains the setup dialog objects'''
    def __init__(self):
        '''initializes the setup dialog'''
        self._dialog_window = tkinter.Toplevel()
        
        game_name = tkinter.Label(
            master = self._dialog_window, text = 'Othello Game',
            font = DEFAULT_FONT)

        game_name.grid(
            row = 0, column = 0, columnspan = 2, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        row_label = tkinter.Label(
            master = self._dialog_window, text = 'Select the number of rows',
            font = DEFAULT_FONT)

        row_label.grid(
            row = 1, column = 0, padx = 10, pady = 10,
            sticky = tkinter.W)
        
        self._row_spinbox = tkinter.Spinbox(master = self._dialog_window, values=(4,6,8,10,12,14,16))        

        self._row_spinbox.grid(
            row = 1, column = 1, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        col_label = tkinter.Label(
            master = self._dialog_window, text = 'Select the number of columns',
            font = DEFAULT_FONT)

        col_label.grid(
            row = 2, column = 0, padx = 10, pady = 10,
            sticky = tkinter.W)
        
        self._col_spinbox = tkinter.Spinbox(master = self._dialog_window, values=(4,6,8,10,12,14,16))        

        self._col_spinbox.grid(
            row = 2, column = 1, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        player_label = tkinter.Label(
            master = self._dialog_window, text = 'Player 1 Black(B), White(W)',
            font = DEFAULT_FONT)

        player_label.grid(
            row = 3, column = 0, padx = 10, pady = 10,
            sticky = tkinter.W)
        
        self._player_spinbox = tkinter.Spinbox(master = self._dialog_window, values=('B', 'W'))        

        self._player_spinbox.grid(
            row = 3, column = 1, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        corner_label = tkinter.Label(
            master = self._dialog_window, text = 'Corner piece Black(B), White(W)',
            font = DEFAULT_FONT)

        corner_label.grid(
            row = 4, column = 0, padx = 10, pady = 10,
            sticky = tkinter.W)
        
        self._corner_spinbox = tkinter.Spinbox(master = self._dialog_window, values=('B', 'W'))        

        self._corner_spinbox.grid(
            row = 4, column = 1, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        type_label = tkinter.Label(
            master = self._dialog_window, text = 'Game type Most(M), Least(L)',
            font = DEFAULT_FONT)

        type_label.grid(
            row = 5, column = 0, padx = 10, pady = 10,
            sticky = tkinter.W)
        
        self._game_type_spinbox = tkinter.Spinbox(master = self._dialog_window, values=('M', 'L'))        

        self._game_type_spinbox.grid(
            row = 5, column = 1, padx = 10, pady = 10,
            sticky = tkinter.N + tkinter.S + tkinter.E + tkinter.W)

        #For the OK and CANCEL buttons
        button_frame = tkinter.Frame(master = self._dialog_window)

        button_frame.grid(
            row = 6, column = 0, columnspan = 2, padx = 10, pady = 10,
            sticky = tkinter.E + tkinter.S)
        
        ok_button = tkinter.Button(
            master = button_frame, text = 'OK', font = DEFAULT_FONT,
            command = self._on_ok_button)

        ok_button.grid(row = 0, column = 0, padx = 10, pady = 10)

        cancel_button = tkinter.Button(
            master = button_frame, text = 'Cancel', font = DEFAULT_FONT,
            command = self._on_cancel_button)

        cancel_button.grid(row = 0, column = 1, padx = 10, pady = 10)

        self._ok_clicked = False
        
        self._row_num = 4
        self._col_num = 4
        self._player = 'B'
        self._type = 'M'
        self._corner = 'B'

    def was_ok_clicked(self) -> bool:
        '''returs if the ok was clicked'''
        return self._ok_clicked

    def get_row_num(self) -> str:
        '''return the number of rows'''
        return self._row_num

    def get_col_num(self) -> str:
        '''returns the number of cols'''
        return self._col_num

    def get_player(self) -> str:
        '''returns the player'''
        return self._player
    
    def get_type(self) -> str:
        '''returns if it is most of least'''
        return self._type
    
    def get_corner(self) -> str:
        '''gets the corner variable'''
        return self._corner
    
    def _on_ok_button(self) -> None:
        '''gets the ok button and gets all the values of the dialog'''
        self._ok_clicked = True
        self._row_num = self._row_spinbox.get()
        self._col_num = self._col_spinbox.get()
        self._player = self._player_spinbox.get()
        self._corner = self._corner_spinbox.get()
        self._type = self._game_type_spinbox.get()
        self._dialog_window.destroy()

    def _on_cancel_button(self) -> None:
        '''destroys the box'''
        self._dialog_window.destroy()
        
    def show(self) -> None:
        '''shows the dialog box'''
        self._dialog_window.grab_set()
        self._dialog_window.wait_window()
            
if __name__ == '__main__':
    '''Starts the Othello GUI'''
    OthelloApplication()
