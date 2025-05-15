import Foundation

// Olga Rodziewicz 198421 5/5

enum Symbol: Character {
    case X = "X", O = "O"
}

struct GameBoard {
    let dimension: Int
    var cells: [[Character]]

    init(dimension: Int) {
        self.dimension = dimension
        self.cells = Array(repeating: Array(repeating: " ", count: dimension), count: dimension)
    }

    func display() {
        for row in 0..<dimension {
            for col in 0..<dimension {
                print(cells[row][col], terminator: "")
                if col < dimension - 1 {
                    print(" |", terminator: "")
                }
            }
            print()
            if row < dimension - 1 {
                print(String(repeating: "-", count: dimension * 3 - 1))
            }
        }
    }

    func isCellAvailable(row: Int, col: Int) -> Bool {
        return cells[row][col] == " "
    }

    func hasEmptyCells() -> Bool {
        return cells.joined().contains(" ")
    }

    func getWinner() -> Symbol? {
        for i in 0..<dimension {
            let rowVal = cells[i][0]
            if rowVal != " " && cells[i].allSatisfy({ $0 == rowVal }) {
                return Symbol(rawValue: rowVal)
            }

            let colVal = cells[0][i]
            if colVal != " " && (0..<dimension).allSatisfy({ cells[$0][i] == colVal }) {
                return Symbol(rawValue: colVal)
            }
        }

        let diag1 = cells[0][0]
        if diag1 != " " && (0..<dimension).allSatisfy({ cells[$0][$0] == diag1 }) {
            return Symbol(rawValue: diag1)
        }

        let diag2 = cells[0][dimension - 1]
        if diag2 != " " && (0..<dimension).allSatisfy({ cells[$0][dimension - 1 - $0] == diag2 }) {
            return Symbol(rawValue: diag2)
        }

        return nil
    }
}

struct HumanPlayer {
    var mark: Character
    var goesFirst: Bool

    mutating func playMove(on board: inout GameBoard) {
        var inputRow = -1, inputCol = -1
        while true {
            print("Wprowadź współrzędne (x y): ", terminator: "")
            guard let input = readLine() else { continue }
            let components = input.split(separator: " ").map(String.init)
            if components.count == 2,
               let row = Int(components[0]), let col = Int(components[1]),
               row >= 0, row < board.dimension,
               col >= 0, col < board.dimension {

                if board.isCellAvailable(row: row, col: col) {
                    inputRow = row
                    inputCol = col
                    break
                } else {
                    print("To miejsce jest już zajęte.")
                }
            } else {
                print("Błędne dane wejściowe. Podaj dwie liczby oddzielone spacją.")
            }
        }
        board.cells[inputRow][inputCol] = mark
    }
}

func minimaxAlgorithm(board: GameBoard, depth: Int, isMax: Bool, ai: Character, player: Character) -> (Int, (Int, Int)?) {
    if let result = board.getWinner() {
        if result.rawValue == ai { return (10, nil) }
        if result.rawValue == player { return (-10, nil) }
    }

    if !board.hasEmptyCells() || depth == 0 {
        return (0, nil)
    }

    var bestVal = isMax ? Int.min : Int.max
    var move: (Int, Int)? = nil

    for r in 0..<board.dimension {
        for c in 0..<board.dimension {
            if board.isCellAvailable(row: r, col: c) {
                var temp = board
                temp.cells[r][c] = isMax ? ai : player
                let (score, _) = minimaxAlgorithm(board: temp, depth: depth - 1, isMax: !isMax, ai: ai, player: player)

                if isMax && score > bestVal {
                    bestVal = score
                    move = (r, c)
                } else if !isMax && score < bestVal {
                    bestVal = score
                    move = (r, c)
                }
            }
        }
    }
    return (bestVal, move)
}

struct ComputerPlayer {
    var mark: Character
    var goesFirst: Bool
    var difficulty: Int

    mutating func playMove(on board: inout GameBoard) {
        var row: Int, col: Int

        if difficulty == 1 {
            repeat {
                row = Int.random(in: 0..<board.dimension)
                col = Int.random(in: 0..<board.dimension)
            } while !board.isCellAvailable(row: row, col: col)
            board.cells[row][col] = mark
        } else {
            let searchDepth = difficulty == 2 ? 2 : 3
            let (_, move) = minimaxAlgorithm(board: board, depth: searchDepth, isMax: true, ai: mark, player: mark == "X" ? "O" : "X")
            if let (r, c) = move {
                board.cells[r][c] = mark
            }
        }
    }
}

class TicTacToeGame {
    var board: GameBoard
    var user: HumanPlayer!
    var ai: ComputerPlayer!
    var currentTurn = 0
    var difficulty = 2

    init(boardSize: Int) {
        board = GameBoard(dimension: boardSize)
    }

    func changeSize(newSize: Int){
        board = GameBoard(dimension: newSize)
    }

    func isOver() -> Bool {
        return board.getWinner() != nil || !board.hasEmptyCells()
    }

    func clearBoard() {
        for r in 0..<board.dimension {
            for c in 0..<board.dimension {
                board.cells[r][c] = " "
            }
        }
    }

    func runGame() {
        print("Tic-Tac-Toe")
        print("Wybierz znak (X lub O): ", terminator: "")
        var chosen = Character((readLine() ?? "").uppercased())
        if chosen != "X" && chosen != "O" {
            print("Wybrano domyślnie 'O'")
            chosen = "O"
        }

        print("Wybierz poziom trudności: \n 1-łatwy, \n 2-średni, \n 3-trudny \n ", terminator: "")
        if let input = readLine(), let lvl = Int(input), (1...3).contains(lvl) {
            difficulty = lvl
        } else {
            print("Niepoprawna wartość, ustawiono domyślnie średni poziom.")
            difficulty = 2
        }
        if difficulty == 3{
            changeSize(newSize: 4)
        }

        let starter = Int.random(in: 0...1)
        if starter == 0 {
            print("Gracz rozpoczyna!")
            user = HumanPlayer(mark: chosen, goesFirst: true)
            ai = ComputerPlayer(mark: chosen == "X" ? "O" : "X", goesFirst: false, difficulty: difficulty)
            currentTurn = 0
        } else {
            print("Komputer zaczyna!")
            user = HumanPlayer(mark: chosen, goesFirst: false)
            ai = ComputerPlayer(mark: chosen == "X" ? "O" : "X", goesFirst: true, difficulty: difficulty)
            currentTurn = 1
        }

        clearBoard()

        while !isOver() {
            board.display()
            print()
            if currentTurn == 0 {
                user.playMove(on: &board)
            } else {
                ai.playMove(on: &board)
            }
            currentTurn = 1 - currentTurn
        }

        board.display()
        if let win = board.getWinner() {
            if win.rawValue == user.mark {
                print("Wygrał gracz!")
            } else {
                print("Komputer wygrał!")
            }
        } else {
            print("Remis!")
        }
    }

    func start() {
        repeat {
            runGame()
            print("Zagrać ponownie? (T/N): ", terminator: "")
        } while (readLine() ?? "").uppercased() == "T"
        print("Dziękujemy za grę!")
    }
}

let gra = TicTacToeGame(boardSize: 3)
gra.start()
