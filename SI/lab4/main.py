import numpy as np

from decision_tree import DecisionTree
from random_forest_solution import RandomForest
from load_data import generate_data, load_titanic

def main():
    np.random.seed(123)

    train_data, test_data = load_titanic()

    for i in range(1, 15):
        print("\n testowanie dla depth = ", i)
        dt = DecisionTree({"depth": i})
        dt.train(*train_data)
        dt.evaluate(*train_data)
        dt.evaluate(*test_data)

        rf = RandomForest({"ntrees": 10, "feature_subset": 2, "depth": i})
        rf.train(*train_data)
        rf.evaluate(*train_data)
        rf.evaluate(*test_data)
    


if __name__=="__main__":
    main()