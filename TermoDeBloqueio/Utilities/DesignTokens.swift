import SwiftUI

struct DesignTokens {
    
    struct Colors {
        static let termoGreen = Color(red: 0.40, green: 0.71, blue: 0.38)
        static let duetoYellow = Color(red: 0.85, green: 0.73, blue: 0.20)
        static let quartetoBlue = Color(red: 0.35, green: 0.65, blue: 0.85)
        
        static let background = Color(red: 0.06, green: 0.06, blue: 0.06)
        static let backgroundSecondary = Color(red: 0.11, green: 0.11, blue: 0.11)
        static let backgroundTertiary = Color(red: 0.15, green: 0.15, blue: 0.15)
        
        static let textPrimary = Color.white
        static let textSecondary = Color(red: 0.85, green: 0.85, blue: 0.85)
        static let textTertiary = Color(red: 0.60, green: 0.60, blue: 0.60)
        static let textDisabled = Color(red: 0.40, green: 0.40, blue: 0.40)
        
        static let success = termoGreen
        static let warning = duetoYellow
        static let error = Color(red: 0.90, green: 0.30, blue: 0.30)
        static let info = quartetoBlue
        
        static let correctPosition = termoGreen
        static let wrongPosition = duetoYellow
        static let absent = Color(red: 0.23, green: 0.23, blue: 0.23)
        
        static let keyDefault = Color(red: 0.45, green: 0.45, blue: 0.45)
        static let keyPressed = Color(red: 0.55, green: 0.55, blue: 0.55)
        
        static let blocked = Color(red: 0.15, green: 0.15, blue: 0.15)
        static let unlocked = termoGreen.opacity(0.15)
    }
    
    struct Typography {
        static func display(size: CGFloat = 34) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        static func title1(size: CGFloat = 28) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        static func title2(size: CGFloat = 22) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        static func title3(size: CGFloat = 20) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        static func body(size: CGFloat = 17) -> Font {
            .system(size: size, weight: .regular, design: .rounded)
        }
        
        static func bodyBold(size: CGFloat = 17) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        static func caption(size: CGFloat = 14) -> Font {
            .system(size: size, weight: .regular, design: .rounded)
        }
        
        static func captionBold(size: CGFloat = 14) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        static func gameLetter(size: CGFloat) -> Font {
            .system(size: size * 0.55, weight: .bold, design: .rounded)
        }
        
        static func keyboard(size: CGFloat = 18) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
    }
    
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }
    
    struct Shadows {
        static func small(color: Color = .black) -> some View {
            EmptyView().shadow(color: color.opacity(0.08), radius: 4, y: 2)
        }
        
        static func medium(color: Color = .black) -> some View {
            EmptyView().shadow(color: color.opacity(0.12), radius: 8, y: 4)
        }
        
        static func large(color: Color = .black) -> some View {
            EmptyView().shadow(color: color.opacity(0.16), radius: 16, y: 8)
        }
        
        static func button(color: Color) -> some View {
            EmptyView().shadow(color: color.opacity(0.25), radius: 12, y: 6)
        }
    }
    
    struct Animations {
        static let quick = Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let standard = Animation.spring(response: 0.4, dampingFraction: 0.75)
        static let smooth = Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let bounce = Animation.spring(response: 0.6, dampingFraction: 0.6)
        static let celebration = Animation.spring(response: 0.8, dampingFraction: 0.5)
    }
    
    struct GameBoxSizes {
        static func termo(availableWidth: CGFloat) -> CGFloat {
            let spacing: CGFloat = Spacing.xxs * 4
            let available = availableWidth - spacing
            return min(available / 5, 60)
        }
        
        static func dueto(availableWidth: CGFloat) -> CGFloat {
            let spacing: CGFloat = Spacing.xxs * 4
            let available = availableWidth - spacing
            return min(available / 5, 50)
        }
        
        static func quarteto(availableWidth: CGFloat) -> CGFloat {
            let spacing: CGFloat = Spacing.xxs * 4
            let available = availableWidth - spacing
            return max(min(available / 5, 36), 28)
        }
    }
}

extension View {
    func designShadow(_ style: DesignTokens.Shadows.Type = DesignTokens.Shadows.self) -> some View {
        self
    }
}
