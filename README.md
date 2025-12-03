# Termo de Bloqueio

Um jogo estilo Wordle/Termo em português para iOS, desenvolvido em SwiftUI.

## 📁 Estrutura de Pastas (MVVM-C)

```
TermoDeBloqueio/
├── Coordinators/                    # Coordenação de navegação
│   ├── AppCoordinator.swift         # Gerencia estado de navegação
│   └── CoordinatorView.swift        # Renderiza view baseada no estado
│
├── Models/                          # Camada de dados
│   ├── Letter.swift                 # Letra individual com status
│   ├── Guess.swift                  # Tentativa com array de letras
│   ├── LetterStatus.swift           # Enum: none/correct/misplaced/wrong
│   ├── GameState.swift              # Enum: playing/won/lost
│   ├── OverallGameState.swift       # Estado para multi-palavra
│   └── WordData.swift               # Singleton para gerenciar palavras
│
├── ViewModels/                      # Lógica de apresentação
│   ├── GameViewModel.swift          # ViewModel do Termo (1 palavra)
│   ├── DuetoViewModel.swift         # ViewModel do Dueto (2 palavras)
│   ├── QuartetoViewModel.swift      # ViewModel do Quarteto (4 palavras)
│   └── SingleGameState.swift        # Estado de jogo individual (helper)
│
├── Views/                           # Interface do usuário
│   ├── ContentView.swift            # Entry point (chama CoordinatorView)
│   ├── MenuView.swift               # Menu principal
│   ├── TermoGameView.swift          # Tela do jogo Termo
│   ├── DuetoView.swift              # Tela do jogo Dueto
│   ├── QuartetoView.swift           # Tela do jogo Quarteto
│   └── Components/                  # Componentes reutilizáveis
│       ├── GuessGridView.swift      # Grid de tentativas
│       ├── KeyboardView.swift       # Teclado virtual
│       └── LetterBoxView.swift      # Caixa de letra individual
│
├── Resources/                       # Recursos e constantes
│   ├── AppConstants.swift           # Cores, tamanhos, animações
│   └── palavras_termo_completo.json # 10.299 palavras portuguesas
│
└── TermoDeBloqueioApp.swift         # App entry point
```

## 🎮 Modos de Jogo

### Termo
- **1 palavra** para adivinhar
- **6 tentativas**
- Palavra diária baseada em seed

### Dueto
- **2 palavras** simultâneas
- **7 tentativas**
- Palavras garantidas como não similares

### Quarteto
- **4 palavras** simultâneas
- **9 tentativas**
- Layout otimizado para telas pequenas

## 🏗️ Padrão MVVM-C

### Model
Representa os dados e lógica de negócio:
- `Letter`: Representa uma letra com seu caractere e status
- `Guess`: Representa uma tentativa com array de letras
- `LetterStatus`: Enum para estados (none, correct, misplaced, wrong)
- `WordData`: Singleton para carregar e gerenciar palavras

### View
Interface do usuário em SwiftUI:
- Views são declarativas e reativas
- Observam mudanças no ViewModel via `@ObservedObject`
- Não contém lógica de negócio

### ViewModel
Conecta Model e View:
- Gerencia estado do jogo (`@Published` properties)
- Processa entrada do usuário
- Atualiza status das letras
- Usa Combine para reatividade

### Coordinator
Gerencia navegação e fluxo:
- `AppCoordinator`: Controla qual tela mostrar
- `CoordinatorView`: Renderiza a view apropriada
- Desacopla Views da lógica de navegação

## 🎨 Design

- **Cores**: Paleta limpa sem gradientes
  - Verde: Letra correta `(0.40, 0.71, 0.38)`
  - Amarelo: Letra na posição errada `(0.85, 0.73, 0.20)`
  - Cinza: Letra não existe `(0.45, 0.45, 0.45)`

- **Animações**:
  - Efeito de "pulso" ao digitar letras
  - Transições suaves nos modais
  - Animações de spring nos botões
  - Entrada animada do menu

- **Responsivo**:
  - Usa `GeometryReader` para cálculos dinâmicos
  - Tamanhos adaptáveis de caixas por modo
  - Layout otimizado para diferentes telas

## 🔧 Funcionalidades Técnicas

### Palavra Diária Determinística
- Usa gerador pseudo-aleatório com seed (PCG)
- Seed baseado em dias desde 01/01/2025
- Mesma palavra para todos no mesmo dia

### Algoritmo Anti-Similaridade
- Evita palavras com 3+ letras em posições iguais
- Evita palavras com 4+ letras em comum
- Garante experiência justa no Dueto/Quarteto

### Validação de Input
- Aceita apenas letras
- Máximo 5 caracteres
- Valida palavras contra dicionário
- Feedback visual imediato

## 📦 Dados

- **Fonte**: JSON com 10.299 palavras portuguesas de 5 letras
- **Filtros**: Palavras ofensivas removidas
- **Validação**: Todas palavras verificadas e limpas

## 🚀 Como Funciona

1. **App inicia** → `TermoDeBloqueioApp` carrega `CoordinatorView`
2. **Coordinator** → Mostra `MenuView` com opções
3. **Seleção** → Coordinator navega para view correspondente
4. **ViewModel** → Carrega palavra(s) do dia via `WordData`
5. **Jogo** → User interage, ViewModel processa, View atualiza
6. **Fim** → Modal animado com resultado

## 🎯 Princípios Seguidos

- **Single Responsibility**: Cada classe tem uma responsabilidade
- **Separation of Concerns**: Model/View/ViewModel separados
- **Dependency Injection**: ViewModels recebem dependências
- **Observable Pattern**: Combine para reatividade
- **Coordinator Pattern**: Navegação desacoplada
