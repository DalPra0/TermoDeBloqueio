import Foundation

struct Guess: Identifiable {
    let id = UUID()
    var letters: [Letter]
}
