import SwiftUI
import Combine

struct MenuView: View {
    @State private var showContent = false
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    
                    Button(action: { coordinator.showSettings() }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .opacity(showContent ? 1.0 : 0.0)
                
                VStack(spacing: 8) {
                    Text("TERMO")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .opacity(showContent ? 1.0 : 0.0)
                    
                    Text("DE BLOQUEIO")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .opacity(showContent ? 1.0 : 0.0)
                }
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: { coordinator.showTermo() }) {
                        MenuButton(title: "TERMO", subtitle: "1 palavra · 6 tentativas", color: Color(red: 0.40, green: 0.71, blue: 0.38), delay: 0.1)
                    }
                    
                    Button(action: { coordinator.showDueto() }) {
                        MenuButton(title: "DUETO", subtitle: "2 palavras · 7 tentativas", color: Color(red: 0.85, green: 0.73, blue: 0.20), delay: 0.2)
                    }
                    
                    Button(action: { coordinator.showQuarteto() }) {
                        MenuButton(title: "QUARTETO", subtitle: "4 palavras · 9 tentativas", color: Color(red: 0.45, green: 0.45, blue: 0.45), delay: 0.3)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let delay: Double
    
    @State private var isPressed = false
    @State private var showButton = false
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .shadow(color: color.opacity(0.3), radius: isPressed ? 2 : 8, y: isPressed ? 1 : 4)
        )
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .offset(y: showButton ? 0 : 20)
        .opacity(showButton ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                showButton = true
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    MenuView()
}
