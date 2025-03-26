import Foundation

class SwiftleGame {
    let wordToGuess: String
    var guessedWord: [Character]
    var attemptsLeft: Int
    let maxAttempts: Int = 6
    
    init(word: String) {
        self.wordToGuess = word.uppercased()
        self.guessedWord = Array(repeating: "_", count: word.count)
        self.attemptsLeft = maxAttempts
    }
    
    func drawBoard() {
        print("Word: ", guessedWord.map { String($0) }.joined(separator: " "))
        print("Attempts left: \(attemptsLeft)")
    }
    
    func guessLetter(_ letter: Character) {
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
            let letter = readLine().first
            print("Selected letter is  \(letter!).")
            guessLetter(letter)
            //if let input = readLine(), let letter = input.first {
                //
            //}
        }
        
        if guessedWord.contains("_") {
            print("Game Over! The word was: \(wordToGuess)")
        } else {
            print("Congratulations! You guessed the word: \(wordToGuess)")
        }
    }
}

// Example usage:
let game = SwiftleGame(word: "swift")
game.drawBoard()
game.play()
