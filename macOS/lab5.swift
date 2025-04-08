import Foundation

enum Likes: String {
    case yes = "✅"
    case no = " "
}

enum Follower: String {
    case yes = "Obserwujesz"
    case no = "Obserwuj"
}

class Artist {
    var name: String
    var listeners: Int
    var following: Bool
    
    init(name: String, listeners: Int, following: Bool) {
        self.name = name
        self.listeners = listeners
        self.following = following
    }
    
    func display(songs: [Song]) {
        self.displayArtist()
        self.likedSongs(songs: songs)
        self.allSongs(songs: songs)
    }
    
    func displayArtist() {
        let followStatus = following ? Follower.yes.rawValue : Follower.no.rawValue
        for _ in 1...7 {
            print("///////////////////////////////////////")
        }
        print(self.name)
        print("słuchaczy w tym miesiącu: \(self.listeners) ")
        print(" |\(followStatus)|       :           🔀 ▶️")
        print(" ")
    }
    
    func likedSongs(songs: [Song]) {
        let count = songs.filter { $0.liked && $0.authors.contains(where: { $0.name == self.name }) }.count
        print("/// Polubione Utwory")
        print("/// \(count) utwór * \(name) * ")
        print(" ")
    }
    
    func allSongs(songs: [Song]) {
        let artistSongs = songs.filter { $0.authors.contains(where: { $0.name == self.name }) }
        
        if artistSongs.isEmpty {
            print("Brak piosenek tego artysty.")
        } else {
            for (index, song) in artistSongs.enumerated() {
                song.displaySong(num: index+1)
            }
        }
    }
}

class Song {
    var name: String
    var liked: Bool
    var authors: [Artist]
    var currentlyPlayed: Bool
    var numberOfStreams: Int
    
    init(name: String, liked: Bool, author: Artist? = nil, currentlyPlayed: Bool, numberOfStreams: Int) {
        self.name = name
        self.liked = liked
        self.authors = author != nil ? [author!] : []
        self.currentlyPlayed = currentlyPlayed
        self.numberOfStreams = numberOfStreams
    }
    
    func displaySong(num: Int = 1) {
        let like = liked ? Likes.yes.rawValue : Likes.no.rawValue
        
        let green = "\u{001B}[32m"  // Kod ANSI dla koloru zielonego
        let reset = "\u{001B}[0m"   // Resetowanie koloru
        
        let displayName = currentlyPlayed ? "\(green)\(name)\(reset)" : name

        print("  //////")
        print("\(num) //////   \(displayName)       \(like) :")
        print("  //////   \(numberOfStreams) ")
        print(" ")
    }
}
func nowPlaying(songs: [Song]) {
    if let playingSong = songs.first(where: { $0.currentlyPlayed }) {
        print("------------------------------------------")
        print("| /// \(playingSong.name)           🖳 ➕ ▶️|")
        print("| /// \(playingSong.authors)                      |")
        print("------------------------------------------")
    } else {
        print("\n Brak aktualnie odtwarzanej piosenki.\n")
    }
}


let artist = Artist(name: "Dawid Podsiadło", listeners: 2800000, following: true)

let song1 = Song(name: "Pięknie płyniesz", liked: false, author: artist, currentlyPlayed: true, numberOfStreams: 11459806)
let song2 = Song(name: "Let You Down    ", liked: false, author: artist, currentlyPlayed: false, numberOfStreams: 65260000)
let song3 = Song(name: "Phantom Liberty", liked: true, author: artist, currentlyPlayed: false, numberOfStreams: 20334177)

let songs: [Song] = [song1, song2, song3]
print("spotify:")
artist.display(songs: songs)
nowPlaying(songs: songs)



