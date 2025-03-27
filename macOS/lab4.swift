//działa tylko w programiz
import Foundation

class Swiftle {
    let wordToGuess: String
    var guessedWord: [Character]
    var attemptsLeft: Int
    let maxAttempts: Int = 6
    
    init(word: String, level: Int) {
        self.wordToGuess = word.uppercased()
        self.guessedWord = Array(repeating: "_", count: word.count)
        if level == 1{
            self.attemptsLeft = 10
        }
        else if level == 2{
            self.attemptsLeft = 6
        }
        else {
            self.attemptsLeft = 3
        }
    }
    
    func drawBoard() {
        print("Word: ", guessedWord.map { String($0) }.joined(separator: " "))
        print("Attempts left: \(attemptsLeft)")
    }
    
    func guessLetter(letter: Character) {
        let upperLetter = Character(letter.uppercased())
        var found = false
        
        for (index, char) in wordToGuess.enumerated() {
            if char == upperLetter {
                guessedWord[index] = upperLetter
                found = true
            }
        }
        
        if !found {
            attemptsLeft -= 1
        }
        drawBoard()
    }
    
    func play() {
        while attemptsLeft > 0 && guessedWord.contains("_") {
            print("Enter a letter: ", terminator: "")
            if let input = readLine(), let letter = input.first, input.count == 1 {
                print("Selected letter is \(letter).")
                guessLetter(letter: letter)
            } else {
                print("Invalid input. Please enter a single letter.")
            }
        }
    
        if guessedWord.contains("_") {
            print("Game Over! The word was: \(wordToGuess)")
        } else {
            print("Congratulations! You guessed the word: \(wordToGuess) 🎉")
        }
    }
}

func selectCategory() -> String {
    let categories = [
        "Cities": ["Paris", "London", "Berlin", "Tokyo", "Sydney", "Bydgoszcz"],
        "Movies": ["Inception", "Titanic", "godfather", "Gladiator", "Joker"],
        "Books": ["Gameoftrone", "Dune", "Hamlet", "Frankenstein", "Dracula"],
        "Animals": ["whale", "bee", "tarantula", "elephant", "GoldenRetriever"],
        "Programming Languages": ["ruby", "kotlin", "javascript", "swift", "prolog", "haskell"]
    ]
    
    print("Select a category: ")
    for (index, category) in categories.keys.enumerated() {
        print("\(index + 1). \(category)")
    }
    
    if let choice = readLine(), let index = Int(choice), index > 0, index <= categories.count {
        let selectedCategory = Array(categories.keys)[index - 1]
        let words = categories[selectedCategory]!
        return words.randomElement()!
    } else {
        print("Invalid choice. Defaulting to a random word from Cities category.")
        return categories["Cities"]!.randomElement()!
    }
}

func selectLevel() -> Int{

    print("Select a Level: ")
    print("1. Easy (10 attempts to guess)")
    print("2. Medium (6 attempts to guess)")
    print("3. Hard (3 attempts to guess)")
    
    if let choice = readLine(), let index = Int(choice), index > 0, index <= 3 {
        return index
    } else {
        print("Invalid choice. Defaulting to a medium level")
        return 2
    }
}

// Example usage:
let word = selectCategory()
let level = selectLevel()
let game = Swiftle(word: word, level: level)
game.drawBoard()
game.play()
