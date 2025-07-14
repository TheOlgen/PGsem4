from util import *
import pandas as pd

# Load data correctly
data = pd.read_csv('dane_italy.txt', delim_whitespace=True)

def getCities():
    cities = []
    for _, row in data.iterrows():
        city = City(
            int(row['Id']),       # Correctly parsed column names
            row['Town'],
            int(row['Population']),
            float(row['Latitude']),
            float(row['Longitude'])
        )
        cities.append(city)
    return cities


if __name__ == '__main__':
    cities = getCities()
    N = 4  # Change to the desired number of cities in combinations
    result = []  # Temporary storage
    results = []  # Stores all valid routes with distances

    #kombinacje(N, cities, result, results)

    print("All Routes with Distances:")
    for route in results:
        print(route)

    findMin(results)  # Find the shortest route

