import Foundation

//1.1
var num1 = 6
var num2 = 8
print("\(num1) + \(num2) = \(num1+num2)")

//1.2
var str = "Gdansk University of Technology"
var modifiedStr = ""
for char in str
{
  if char == "n"{
    modifiedStr += "⭐️"
  }
  else{
    modifiedStr += String(char)
  }
} 
print(modifiedStr)

//1.3
let name = "Olga Rodziewicz"
var rName = ""
for char in name
{
  rName = String(char) + rName
} 
print("\(name) -> \(rName)")

//2.1
for _ in 1...11{
  print("I will pass this course with best mark, because Swift is great!")
}

//2.2-3
let n = 5 //do zmiany wpływa na zadania 2.3 i 2.2
var malpas = ""
for i in 1..<n+1
{
  print(i*i)
  malpas += "@"
}
for _ in 1..<n+1
{
  print(malpas)
}

//3.1
var numbers = [5, 10, 20, 15, 80, 13]
let maks = numbers.max() ?? 0
print(maks)
//3.2
numbers.reverse()
print(numbers)
//3.3
var allNumbers = [10, 20, 10, 11, 13, 20, 10, 30]
var unique: [Int] = []
for num in allNumbers {
  if !unique.contains(num) {
    unique.append(num)
  }
}
print(unique)

//4.1
let num = 10
var dividors = Set<Int>()
for i in 1..<num+1
{
  if num%i == 0{
    dividors.insert(i)
  }
}
print(dividors)

//5.1
	var flights: [[String: String]] = [
    [
        "flightNumber" : "AA8025",
        "destination" : "Copenhagen"
    ],
    [
        "flightNumber" : "BA1442",
        "destination" : "New York"
    ],
    [
        "flightNumber" : "BD6741",
        "destination" : "Barcelona"
    ]
]
var flightNumbers: [String] = []
for i in flights
{
  if let n = i["flightNumber"] {
    flightNumbers.append(n)
  }
}
print(flightNumbers)

//5.2
var names = ["Hommer", "Lisa", "Bart"]
let surname = "Simpson"
var fullName: [[String: String]] = []

for name in names {
    fullName.append([
        "firstName": name,
        "lastName": surname
    ])
}

print(fullName)
