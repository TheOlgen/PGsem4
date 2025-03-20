import Foundation

struct Location {
    let id: Int
    let type: String // "restaurant", "pub", "museum"
    let name: String
    let rating: Int // 1 to 5
}

struct City {
    let id: Int
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let keywords: [String]
    var locations: [Location] = []
}
// dane z chat gpt
let cities: [City] = [
    City(id: 1, name: "Barcelona", description: "A city by the sea", latitude: 41.3851, longitude: 2.1734, keywords: ["seaside", "party", "music"], locations: [
        Location(id: 1, type: "restaurant", name: "El Celler de Can Roca", rating: 5),
        Location(id: 2, type: "pub", name: "Paradiso", rating: 4),
        Location(id: 3, type: "museum", name: "Picasso Museum", rating: 5)
    ]),
    
    City(id: 2, name: "Paris", description: "City of love", latitude: 48.8566, longitude: 2.3522, keywords: ["romantic", "culture", "museums"], locations: [
        Location(id: 4, type: "restaurant", name: "Le Meurice", rating: 5),
        Location(id: 5, type: "pub", name: "Harry's New York Bar", rating: 4),
        Location(id: 6, type: "museum", name: "Louvre Museum", rating: 5)
    ]),
    
    City(id: 3, name: "New York", description: "The Big Apple", latitude: 40.7128, longitude: -74.0060, keywords: ["business", "music", "food"], locations: [
        Location(id: 7, type: "restaurant", name: "Eleven Madison Park", rating: 5),
        Location(id: 8, type: "pub", name: "McSorley's Old Ale House", rating: 4),
        Location(id: 9, type: "museum", name: "Metropolitan Museum of Art", rating: 5)
    ]),
    City(id: 4, name: "Bydgoszcz", description: "City of water, rowing, and industry", latitude: 53.1235, longitude: 18.0084, keywords: ["culture", "nature", "rowing"]),
    City(id: 5, name: "Gdańsk", description: "Port city on the Baltic coast", latitude: 54.3520, longitude: 18.6466, keywords: ["seaside", "history", "culture"], locations: [
        Location(id: 10, type: "restaurant", name: "Brovarnia Gdańsk", rating: 4),
        Location(id: 11, type: "pub", name: "Red Light Pub", rating: 4),
        Location(id: 12, type: "museum", name: "European Solidarity Centre", rating: 5)
    ]),
    City(id: 6, name: "Lębork", description: "A town in northern Poland", latitude: 54.5394, longitude: 17.7506, keywords: ["history", "nature"]),
    City(id: 7, name: "Białystok", description: "Largest city in northeastern Poland", latitude: 53.1325, longitude: 23.1612, keywords: ["culture", "business", "education"]),
    City(id: 8, name: "Radom", description: "An industrial city in central Poland", latitude: 51.4027, longitude: 21.1471, keywords: ["industry", "history"]),
    City(id: 9, name: "Szczecin", description: "A port city in northwest Poland", latitude: 53.4285, longitude: 14.5528, keywords: ["seaside", "history", "business"]),
    City(id: 10, name: "Warszawa", description: "Capital city of Poland", latitude: 52.2298, longitude: 21.0122, keywords: ["business", "culture", "history"], locations: [
        Location(id: 13, type: "restaurant", name: "Atelier Amaro", rating: 5),
        Location(id: 14, type: "pub", name: "PiwPaw", rating: 4),
        Location(id: 15, type: "museum", name: "POLIN Museum", rating: 5)
    ]),
    City(id: 11, name: "Kraków", description: "Cultural capital of Poland", latitude: 50.0647, longitude: 19.9450, keywords: ["culture", "history", "tourism"]),
    City(id: 12, name: "Wrocław", description: "City of bridges", latitude: 51.1079, longitude: 17.0385, keywords: ["culture", "history", "education"]),
    City(id: 13, name: "Poznań", description: "One of Poland's oldest cities", latitude: 52.4064, longitude: 16.9252, keywords: ["business", "history", "education"]),
    City(id: 14, name: "Łódź", description: "Industrial and creative hub", latitude: 51.7592, longitude: 19.4560, keywords: ["industry", "culture", "education"]),
    City(id: 15, name: "Katowice", description: "Center of Silesia", latitude: 50.2706, longitude: 19.0396, keywords: ["industry", "business", "culture"]),
    City(id: 16, name: "Lublin", description: "Eastern Poland's cultural gem", latitude: 51.2465, longitude: 22.5684, keywords: ["culture", "history", "education"]),
    City(id: 17, name: "Toruń", description: "City of Copernicus", latitude: 53.0138, longitude: 18.5984, keywords: ["history", "culture", "tourism"]),
    City(id: 18, name: "Rzeszów", description: "Capital of southeastern Poland", latitude: 50.0413, longitude: 21.9990, keywords: ["business", "education", "culture"]),
    City(id: 19, name: "Opole", description: "Music capital of Poland", latitude: 50.6751, longitude: 17.9213, keywords: ["music", "culture", "history"]),
    City(id: 20, name: "Gdynia", description: "A modern seaport city", latitude: 54.5189, longitude: 18.5305, keywords: ["seaside", "business", "tourism"])
]

func searchByName(name: String) -> [City] {
    return cities.filter { $0.name.lowercased().contains(name.lowercased()) }
}

func searchByKeyword(keyword: String) -> [City] {
    return cities.filter { $0.keywords.contains(keyword) }
}

func distanceBetween(city1: City, city2: City) -> Double {
    let lat1 = city1.latitude * Double.pi / 180
    let lon1 = city1.longitude * Double.pi / 180
    let lat2 = city2.latitude * Double.pi / 180
    let lon2 = city2.longitude * Double.pi / 180
    
    let dlon = lon2 - lon1
    let dlat = lat2 - lat1
    let a = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    let r = 6371.0 // Radius of Earth in km
    return r * c
}

func closestAndFarthestCity(userLatitude: Double, userLongitude: Double) -> (City, City) {
    let userCity = City(id: 0, name: "User Location", description: "", latitude: userLatitude, longitude: userLongitude, keywords: [])
    let sortedCities = cities.sorted { distanceBetween(city1: userCity, city2: $0) < distanceBetween(city1: userCity, city2: $1) }
    return (sortedCities.first!, sortedCities.last!)
}

func twoFarthestCities() -> (City, City) {
    var maxDistance = 0.0
    var farthestCities: (City, City)? = nil
    
    for i in 0..<cities.count {
        for j in i + 1..<cities.count {
            let dist = distanceBetween(city1: cities[i], city2: cities[j])
            if dist > maxDistance {
                maxDistance = dist
                farthestCities = (cities[i], cities[j])
            }
        }
    }
    return farthestCities!
}

func citiesWithFiveStarRestaurants() -> [City] {
    return cities.filter { city in
        city.locations.contains { $0.type == "restaurant" && $0.rating == 5 }
    }
}

func locationsSortedByRating(city: City) -> [Location] {
    return city.locations.sorted { $0.rating > $1.rating }
}

func citiesWithFiveStarLocationCounts() {
    for city in cities {
        let fiveStarLocations = city.locations.filter { $0.rating == 5 }
        if !fiveStarLocations.isEmpty {
            print("\nCity: \(city.name) has \(fiveStarLocations.count) five-star locations:")
            for location in fiveStarLocations {
                print("  - \(location.name) (Type: \(location.type), Rating: \(location.rating))")
            }
        }
    }
}


//main
print("\nSearch results for cities named 'Paris':")
for city in searchByName(name: "Paris") {
    print("  - \(city.name): \(city.description)")
}
print("\n \n")

print("\nSearch results for cities with keyword 'history':")
for city in searchByKeyword(keyword: "history") {
    print("  - \(city.name): Keywords - \(city.keywords.joined(separator: ", "))")
}
print("\n \n")

print("\nSearch results for cities with keyword 'music':")
for city in searchByKeyword(keyword: "music") {
    print("  - \(city.name): Keywords - \(city.keywords.joined(separator: ", "))")
}
print("\n \n")

let (closest, farthest) = closestAndFarthestCity(userLatitude: 54.22, userLongitude: 18.37)
print("\nClosest city to user location: \(closest.name)")
print("Farthest city from user location: \(farthest.name)")
print("\n \n")

print("Two farthest cities: ")
let (farthest3, farthest2) = twoFarthestCities()
print(" \(farthest3.name) - \(farthest2.name)")
print("\n \n")

print("Distance between Bydgoszcz an Torun: ")
let distance = distanceBetween(city1: cities[3],city2: cities[16])
print(distance)
print("\n \n")

print("Cities with five stars locations:")
citiesWithFiveStarLocationCounts()
print("\n \n")

print("Best loactions in New York:")
for location in locationsSortedByRating(city: cities[2]){
    print("   - \(location.name) rating: \(location.rating)")
}

print("\n \n")
