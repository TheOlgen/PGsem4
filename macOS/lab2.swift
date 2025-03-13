//1.1
func minValue(a: Int, b: Int) -> Int {
    return a < b ? a : b
}

//1.2
func lastDigit(_ num: Int) -> Int {
    return num % 10
}

//1.3
func divides(a: Int, b: Int) -> Bool {
    return a % b == 0
}

func countDivisors(number: Int) -> Int {
    var count = 0
    for i in 1...number {
        if divides(a: number, b: i) {
            count += 1
        }
    }
    return count
}

func isPrime(number: Int) -> Bool {
    return countDivisors(number: number) == 2
}

// Testing 1
print(minValue(a: 5, b: 3))  
print(lastDigit(1234))        
print(divides(a: 7, b: 3))  
print(countDivisors(number: 12)) 
print(isPrime(number: 3))    


//2.1
var text: () -> () = {
    print("I will pass this course with best mark, because Swift is great!")
}
func smartBart(n: Int) -> () {
    for _ in 1...n {
        text()
    }
}
smartBart(n: 7)

//2.2
let numbers = [10, 16, 18, 30, 38, 40, 44, 50]
print(numbers.filter{($0)%4 == 0} ) //tylko wielokrotności 4

//2.3
print(numbers.reduce(Int.min) { max($0, $1) })  

//2.4
let strings = ["Gdansk", "University", "of", "Technology"]
let joinedString = strings.reduce("") { $0.isEmpty ? $1 : $0 + " " + $1 }

print(joinedString)  

//2.5
let numbers2 = [1, 2 ,3 ,4, 5, 6]
let sumOfSquares = numbers2
    .filter { $0 % 2 != 0 }  // Keep only odd numbers
    .map { $0 * $0 }         // Square each number
    .reduce(0, +)            // Sum up all squared values
print(sumOfSquares)  


//3.1
func minmax(a: Int, b: Int) -> (min: Int, max: Int) {
    return (min(a, b), max(a, b))
}
let result = minmax(a: 10, b: 25)
print(result)  // Output: (10, 25)
print("Min: \(result.min), Max: \(result.max)")  // Min: 10, Max: 25

//3.2
let stringsArray = ["gdansk", "university", "gdansk", "university", "university", "of", "technology", "technology", "gdansk", "gdansk"]

var counts: [String: Int] = [:]

for string in stringsArray {
    counts[string, default: 0] += 1
}
print(counts.map { ($0.key, $0.value) })  


//4.1
enum Day: Int {
    case Monday = 1, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    func emoji() -> String {
        switch self {
        case .Monday: return "😴"
        case .Tuesday: return "📚"
        case .Wednesday: return "🙌"
        case .Thursday: return "🍾"
        case .Friday: return "🎉"
        case .Saturday: return "🏖"
        case .Sunday: return "🏆"
        }
    }
}

let today = Day.Thursday
print("Today is \(today.rawValue) and emoji is \(today.emoji())")  







