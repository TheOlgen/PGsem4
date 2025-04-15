from connect4 import Connect4
from copy import deepcopy
from exceptions import GameplayException

class AlphaBetaAgent:
    def __init__(self, my_token='o', max_depth=4):
        self.my_token = my_token
        self.max_depth = max_depth

    def decide(self, connect4):
        if connect4.who_moves != self.my_token:
            raise GameplayException('not my round')

        best_move = 0
        best_score = float('-inf')

        for move in connect4.possible_drops():
            scenario = self.simulate_drop(connect4, move)
            if scenario is None:
                continue
            score = self.getMinMax(scenario, depth=self.max_depth, alpha=float('-inf'), beta=float('inf'), maximizing=False)
            if score > best_score:
                best_score = score
                best_move = move
        return best_move

    def getMinMax(self, connect4, depth, alpha, beta, maximizing):
        if depth == 0 or connect4._check_game_over():
            return self.evaluate(connect4)

        if maximizing:
            max_eval = float('-inf')
            for move in connect4.possible_drops():
                scenario = self.simulate_drop(connect4, move)
                if scenario is None:
                    continue
                eval = self.getMinMax(scenario, depth - 1, alpha, beta, False)
                max_eval = max(max_eval, eval)
                alpha = max(alpha, eval)
                if beta <= alpha:
                    break  # Alpha-beta pruning
            return max_eval
        else:
            min_eval = float('inf')
            for move in connect4.possible_drops():
                scenario = self.simulate_drop(connect4, move)
                if scenario is None:
                    continue
                eval = self.getMinMax(scenario, depth - 1, alpha, beta, True)
                min_eval = min(min_eval, eval)
                beta = min(beta, eval)
                if beta <= alpha:
                    break  # Alpha-beta pruning
            return min_eval

    def evaluate(self, connect4):
        if connect4._check_game_over():
            if connect4.isTie():
                return 0
            else:
                return connect4.getWinEvaluation(self.my_token) * 100  # Wzmocniona wartość wygranej/przegranej

        # Heurystyczna ocena planszy: więcej tokenów w środku = lepsza pozycja
        score = 0
        center_column = connect4.center_column()
        score += center_column.count(self.my_token) * 3  # Zachęta do zajmowania środka

        return score

    def simulate_drop(self, connect4, column):
        """ Returns a new Connect4 object with the move simulated. """
        new_game = Connect4(connect4.width, connect4.height)
        new_game.board = [row[:] for row in connect4.board]  # Deep copy board
        new_game.who_moves = connect4.who_moves
        new_game.game_over = connect4.game_over
        new_game.wins = connect4.wins

        try:
            new_game.drop_token(column)
        except GameplayException:
            return None  # Niepoprawny ruch

        return new_game
