import SwiftUI
import FamilyControls

struct AppSelectionView: View {
    @StateObject private var appBlockingManager = AppBlockingManager.shared
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var isPickerPresented = false
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { coordinator.showSettings() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text("APPS PARA BLOQUEAR")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .opacity(showContent ? 1.0 : 0.0)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if !appBlockingManager.isAuthorized {
                            VStack(spacing: 16) {
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                                
                                Text("Autorização Necessária")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                                
                                Text("Precisamos de permissão para bloquear apps no seu dispositivo")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Button(action: {
                                    Task {
                                        await appBlockingManager.requestAuthorization()
                                    }
                                }) {
                                    Text("Autorizar")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                                        )
                                }
                                .padding(.horizontal, 40)
                                .padding(.top, 8)
                            }
                            .padding(.vertical, 60)
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Apps Selecionados")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                                
                                if appBlockingManager.selection.applicationTokens.isEmpty {
                                    Text("Nenhum app selecionado")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                                        .padding(.vertical, 20)
                                } else {
                                    Text("\(appBlockingManager.selection.applicationTokens.count) app(s) selecionado(s)")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                                        .padding(.vertical, 20)
                                }
                                
                                Button(action: {
                                    isPickerPresented = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                        Text("Selecionar Apps")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                                    )
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                            )
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                                    
                                    Text("Como funciona")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    InfoRow(number: "1", text: "Selecione os apps que deseja bloquear")
                                    InfoRow(number: "2", text: "Os apps serão bloqueados até você resolver o Termo")
                                    InfoRow(number: "3", text: "Complete os desafios para desbloquear")
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                            )
                        }
                    }
                    .padding(24)
                }
                .opacity(showContent ? 1.0 : 0.0)
            }
        }
        .familyActivityPicker(
            isPresented: $isPickerPresented,
            selection: $appBlockingManager.selection
        )
        .onChange(of: appBlockingManager.selection) {
            print("SELEÇÃO ALTERADA")
            print("   Apps selecionados: \(appBlockingManager.selection.applicationTokens.count)")
            print("   Tokens: \(appBlockingManager.selection.applicationTokens)")
            
            if !appBlockingManager.selection.applicationTokens.isEmpty {
                print("Aplicando bloqueio automaticamente")
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await MainActor.run {
                        appBlockingManager.blockApps()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showContent = true
            }
            
            print("📋 AppSelectionView carregada")
            print("   Autorizado: \(appBlockingManager.isAuthorized)")
            print("   Apps já selecionados: \(appBlockingManager.selection.applicationTokens.count)")
        }
    }
}

struct InfoRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                )
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
            
            Spacer()
        }
    }
}

#Preview {
    AppSelectionView()
        .environmentObject(AppCoordinator())
}
