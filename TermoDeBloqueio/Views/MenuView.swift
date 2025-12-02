import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("TERMO DE BLOQUEIO")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 40)
                
                Spacer()
                
                VStack(spacing: 20) {
                    NavigationLink(destination: ContentView()) {
                        MenuButton(title: "TERMO", subtitle: "1 palavra - 6 tentativas")
                    }
                    
                    NavigationLink(destination: DuetoView()) {
                        MenuButton(title: "DUETO", subtitle: "2 palavras - 7 tentativas")
                    }
                    
                    NavigationLink(destination: QuartetoView()) {
                        MenuButton(title: "QUARTETO", subtitle: "4 palavras - 9 tentativas")
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuButton: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
        )
    }
}

#Preview {
    MenuView()
}
