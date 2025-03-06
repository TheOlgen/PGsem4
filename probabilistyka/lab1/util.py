import math

def findMin(roads):
    """Finds the shortest distance and its corresponding path."""
    best_distance = float('inf')
    best_path = None
    for path in roads:
        distance = path[-1]  # Last element is the distance
        if distance < best_distance:
            best_distance = distance
            best_path = path[:-1]  # Remove distance to get only the path

    print(f"Best Path: {best_path}, Distance: {best_distance}")


def countDistances(cities):
    total_distance = 0
    for i in range(len(cities) - 1):
        dist = cityDistance(cities[i], cities[i + 1])
        print(f" - {cities[i].name} → {cities[i+1].name}: {dist:.2f} km")
        total_distance += dist
    return total_distance


def kombinacje(length, source, result, results):
    if length == 0:
        distance = countDistances(result)  # Ensure `result` has correct cities
        results.append(result[:] + [distance])  # Copy `result` to avoid changes
        return

    for city in source:
        new_source = source[:]  # Copy list
        new_source.remove(city)

        result.append(city)
        kombinacje(length - 1, new_source, result, results)
        result.pop()  # Backtrack



class City:
    def __init__(self, city_id, name, population, latitude, longitude):
        self.city_id = city_id
        self.name = name
        self.population = population
        self.latitude = latitude
        self.longitude = longitude

    def __repr__(self):
        return f"'{self.name}'"

import math

def cityDistance(city1, city2):
    lat1, lon1 = math.radians(city1.latitude), math.radians(city1.longitude)
    lat2, lon2 = math.radians(city2.latitude), math.radians(city2.longitude)
    return math.acos(math.sin(lat1) * math.sin(lat2) + math.cos(lat1) * math.cos(lat2) * math.cos(lon2 - lon1)) * 6371


