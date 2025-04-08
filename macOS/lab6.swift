import Foundation

struct MoominCharacter {
    var name: String
    var health: Int
    var friendship: Int
    var level: Int

    mutating func levelUp() {
        level += 1
        health += 10
        friendship += 5
        print("\(name) leveled up! Now level \(level). 🌟")
    }

    var isHealthy: Bool {
        return health > 0
    }

    func displayStats() {
        print("""
        🌼 \(name)'s Stats:
        Health: \(health)
        Friendship: \(friendship)
        Level: \(level)
        """)
    }
    
    func talkToCreature(_ creature: inout Creature) {
        print("💬 You try to charm \(creature.name)...")
        creature.patience -= player.friendship

        if creature.isCalm {
            print("😠 \(creature.name) is still upset! They lash out!")
            player.health -= creature.mood * 10
            print("💥 You lost some health!")
        } else {
            print("🌈 \(creature.name) has calmed down and wanders off peacefully.")
            player.levelUp()
        }
    }

    func walkAway(from creature: Creature) {
        if Bool.random() == false{
            print("🏃 You ran away safely from \(creature.name).")
        }else {
            print("😨 \(creature.name) spooked you, you lost health.")
        }
    }
    
    func handleEncounter()
    {
        var creature = Creature.randomEncounter()
        creature.displayInfo()
        displayStats()
    
        print("""
        What will you do?
        1 - Talk to calm them
        2 - Run away
        Enter your choice:
        """)
    
        if let input = readLine() {
            switch input {
            case "1":
                talkToCreature(&creature)
           case "2":
                walkAway(from: creature)
            default:
                print("🤔 Invalid choice. You hesitate and lose time.")
            }
        }
    }
}


struct Creature {
    var name: String
    var mood: Int // 1 = chill, 3 = scary!
    var patience: Int

    static func randomEncounter() -> Creature {
        let names = ["The Groke", "Hattifattener", "Stinky"]
        let name = names.randomElement()!
        let mood = Int.random(in: 1...3)
        let patience = Int.random(in: 10...30)
        return Creature(name: name, mood: mood, patience: patience)
    }

    var isCalm: Bool {
        return patience > 0
    }

    func displayInfo() {
        print("""
        🧿 A wild \(name) appears!
        Mood Level: \(mood) (1=Chill, 3=Scary)
        Patience: \(patience)
        """)
    }
}


var player = MoominCharacter(name: "muminek", health: 50, friendship: 15, level:1)

while player.isHealthy {
    print("\n🌲 Exploring Moominvalley...")
    
    player.handleEncounter()

    if !player.isHealthy {
        print("\n💤 You collapse from exhaustion... Game Over!")
        break
    }
}
