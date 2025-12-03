import Foundation

struct Letter: Identifiable {
    let id = UUID()
    var character: String
    var status: LetterStatus
}
