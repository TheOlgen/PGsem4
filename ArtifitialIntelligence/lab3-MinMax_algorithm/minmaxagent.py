import random
from connect4 import Connect4
from copy import deepcopy
from exceptions import AgentException

class MinMaxAgent:
    def __init__(self, my_token, max_depth=4):
        self.my_token = my_token
        self.max_depth = max_depth

    def decide(self, connect4):
        best_move = 0
        best_score = float('-inf')

        for move in connect4.possible_drops():
            scenario = self.simulate_drop(connect4, move)
            if scenario is None:
                continue
            score = self.getMinMax(scenario, depth=self.max_depth, maximizing=False)

            if score > best_score:
                best_score = score
                best_move = move

        return best_move

    def evaluate(self, connect4):
        if connect4._check_game_over():
            if connect4.isTie():
                return 0
            else:
                return connect4.getWinEvaluation(self.my_token)
        #return self.heuristic_evaluation(connect4)
        return float(random.random() - 0.5)

    def getMinMax(self, connect4, depth, maximizing):
        if depth == 0 or connect4._check_game_over():
            return self.evaluate(connect4)

        if maximizing:
            max_eval = float('-inf')
            for move in connect4.possible_drops():
                scenario = self.simulate_drop(connect4, move)
                if scenario is None:
                    continue
                eval = self.getMinMax(scenario, depth-1, False)
                max_eval = max(max_eval, eval)
            return max_eval
        else:
            min_eval = float('inf')
            for move in connect4.possible_drops():
                scenario = self.simulate_drop(connect4, move)
                if scenario is None:
                    continue
                eval = self.getMinMax(scenario, depth-1, True)
                min_eval = min(min_eval, eval)
            return min_eval

    def heuristic_evaluation(self, connect4):
        score = 0
        center_column = connect4.center_column()
        score += center_column.count(self.my_token) * 0.2
        return max(-1, min(1, score))  # Ensure score is in (-1,1) range

    def simulate_drop(self, connect4, column):
        """ Returns a new Connect4 object with the move simulated. """
        new_game = deepcopy(connect4)
        new_game.drop_token(column)
        return new_game