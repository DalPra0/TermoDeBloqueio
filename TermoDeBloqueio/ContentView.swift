//
//  ContentView.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Spacer()
            
            // Grid de tentativas
            GuessGridView(viewModel: viewModel)
            
            // Mensagem de erro
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
            }
            
            Spacer()
            
            // Mensagem de vitória/derrota
            if viewModel.gameState != .playing {
                gameOverView
            }
            
            // Teclado
            KeyboardView(viewModel: viewModel)
        }
        .background(Color.white)
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("TERMO")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Divider()
        }
        .padding(.top)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 12) {
            if viewModel.gameState == .won {
                Text("🎉 Parabéns!")
                    .font(.title)
                    .bold()
                Text("Você acertou!")
                    .font(.title3)
            } else {
                Text("😔 Que pena!")
                    .font(.title)
                    .bold()
                Text("A palavra era: \(WordData.shared.getDailyWord().uppercased())")
                    .font(.title3)
            }
            
            Button(action: {
                viewModel.startNewGame()
            }) {
                Text("Jogar Novamente")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }
}

#Preview {
    ContentView()
}
