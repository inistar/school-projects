#othello_error

class EvenError(Exception):
    '''raises for an even error'''
    pass

class BetweenError(Exception):
    '''raises for an between error'''
    pass

class PlayerError(Exception):
    '''raises for a palyer error'''
    pass

class GameTypeError(Exception):
    '''raises for an game type error'''
    pass

class PassError(Exception):
    '''raises for an pass error'''
    pass

class TieError(Exception):
    '''raise for an tie error'''
    pass

class CoinError(Exception):
    '''raise if there is a coin'''
    pass

class WrongMove(Exception):
    '''raise if there is a worng move'''
    pass

class OutBoundError(Exception):
    '''raises for a game board out of bounce'''
    pass

def input_error(row_input):
    '''checks if the input and raises the correct error'''
    if row_input % 2 != 0:
        raise EvenError
    if 4 > row_input or row_input > 16:
        raise BetweenError

def error_player(player_input):
    '''checks the player input and raises error'''
    if player_input != 'B' and player_input != 'W':
        raise PlayerError

def error_game_type(game_type):
    '''checks the game type and raises error'''
    if game_type != 'F' and game_type != 'M':
        raise GameTypeError
