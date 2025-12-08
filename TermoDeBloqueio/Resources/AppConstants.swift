import SwiftUI

struct AppConstants {
    static let wordLength = 5
    static let termoMaxAttempts = 6
    static let duetoMaxAttempts = 7
    static let quartetoMaxAttempts = 9
    
    struct Colors {
        static let correctGreen = Color(red: 0.40, green: 0.71, blue: 0.38)
        static let misplacedYellow = Color(red: 0.85, green: 0.73, blue: 0.20)
        static let wrongGray = Color(red: 0.45, green: 0.45, blue: 0.45)
        static let keyboardGray = Color(red: 0.85, green: 0.85, blue: 0.85)
        static let backgroundColor = Color(red: 0.97, green: 0.97, blue: 0.97)
        static let textDark = Color(red: 0.20, green: 0.20, blue: 0.20)
        static let textLight = Color(red: 0.50, green: 0.50, blue: 0.50)
        static let errorRed = Color(red: 0.85, green: 0.35, blue: 0.35)
        static let borderGray = Color(red: 0.53, green: 0.53, blue: 0.53)
    }
    
    struct Animation {
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.7
        static let buttonPressDuration: Double = 0.1
        static let scaleEffect: CGFloat = 0.96
    }
    
    struct Sizes {
        static let termoBoxSize: CGFloat = 62
        static let duetoBoxSize: CGFloat = 40
        static let quartetoBoxSize: CGFloat = 22
        static let keyboardHeight: CGFloat = 58
    }
}
