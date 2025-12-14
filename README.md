# 🎮 Termo de Bloqueio

**Transforme seu vício em apps em um hábito de treinar o cérebro!**

Um app iOS que bloqueia suas redes sociais até você resolver palavras do Termo. Desenvolvido com SwiftUI e FamilyControls.

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)]()
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)]()
[![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green.svg)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)]()

---

## 🎯 O que é?

Termo de Bloqueio combina produtividade com gamificação:
- 🔒 **Bloqueia apps** distrativos (Instagram, TikTok, etc)
- 🧠 **Desafia seu cérebro** com palavras em português
- ⏰ **Resetar diário** à meia-noite para criar rotina
- 🎮 **3 níveis** de dificuldade para todos os perfis

---

## ✨ Funcionalidades

### 🔐 Sistema de Bloqueio
- Usa FamilyControls da Apple (nativo e seguro)
- Bloqueio persiste mesmo reiniciando iPhone
- Configurável por app
- 100% local - zero telemetria

### 🎯 3 Modos de Jogo
1. **Termo** (Fácil): 1 palavra, 6 tentativas
2. **Dueto** (Médio): 2 palavras, 7 tentativas
3. **Quarteto** (Difícil): 4 palavras, 9 tentativas

### 📊 Gerenciamento de Progresso
- Rastreamento diário automático
- Dificuldade bloqueada após começar a jogar
- Validação de palavras (10.000+ palavras PT-BR)
- Reset automático à meia-noite

### 🎨 Interface Moderna
- Design SwiftUI nativo
- Animações suaves e haptic feedback
- Acessibilidade (VoiceOver)
- Onboarding interativo

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

---

## 🚀 Como Rodar

### Requisitos:
- macOS Sonoma 14.0+ ou Sequoia 15.0+
- Xcode 15.0+
- iPhone com iOS 17.0+ (Simulador NÃO suporta FamilyControls)
- Apple Developer Account (para testar no device)

### Passo a Passo:

1. **Clone o repositório:**
```bash
git clone https://github.com/lucasdalpra/TermoDeBloqueio.git
cd TermoDeBloqueio
```

2. **Abra no Xcode:**
```bash
open TermoDeBloqueio.xcodeproj
```

3. **Configure App Groups:**
   - Selecione target "TermoDeBloqueio"
   - Signing & Capabilities > + Capability > App Groups
   - Adicione: `group.com.DalPra.TermoDeBloqueio`
   - Repita para targets "ShieldAction" e "ShieldConfiguration"

4. **Configure Signing:**
   - Selecione sua equipe em cada target
   - Certifique-se que Bundle ID é único

5. **Build no iPhone:**
   - Conecte iPhone via USB
   - Selecione como device
   - Cmd+R para rodar

---

## 📝 Arquitetura

### MVVM-C (Model-View-ViewModel-Coordinator)

```
┌─────────────┐
│ Coordinator │ ←─── Gerencia navegação
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    View     │ ←─── SwiftUI declarativa
└──────┬──────┘
       │ observa
       ▼
┌─────────────┐
│  ViewModel  │ ←─── Lógica de apresentação
└──────┬──────┘
       │ usa
       ▼
┌─────────────┐
│    Model    │ ←─── Dados e regras
└─────────────┘
```

### Componentes Principais:

#### Managers
- **BlockManager**: Singleton que gerencia estado de bloqueio
- **AppBlockingManager**: Interface com FamilyControls

#### ViewModels
- **GameViewModel**: Jogo Termo (1 palavra)
- **DuetoViewModel**: Jogo Dueto (2 palavras)
- **QuartetoViewModel**: Jogo Quarteto (4 palavras)

#### Views
- **MenuView**: Menu principal
- **LockScreenView**: Tela de bloqueio
- **SettingsView**: Configurações
- **WelcomeView**: Onboarding

---

## 🎮 Como Funciona

### 1️⃣ Usuário Configura
```swift
// Seleciona dificuldade
blockManager.setDifficulty(.medium)

// Seleciona apps para bloquear
appBlockingManager.selection = selectedApps
```

### 2️⃣ Apps São Bloqueados
```swift
// BlockManager verifica progresso
if !dailyProgress.isUnlocked {
    appBlockingManager.blockApps()
}
```

### 3️⃣ Usuário Joga
```swift
// ViewModel valida tentativa
func submitGuess() {
    guard isValidWord(currentGuess) else { return }
    
    // Avalia cores
    let letters = evaluateGuess(currentGuess)
    
    // Verifica vitória
    if currentGuess == targetWord {
        blockManager.markGameCompleted(.termo)
    }
}
```

### 4️⃣ Apps Desbloqueiam
```swift
// BlockManager atualiza estado
if dailyProgress.isUnlocked {
    appBlockingManager.unblockApps()
}
```

---

## 🧪 Testes

### Testar Bloqueio:
1. Configurações > Selecionar Apps
2. Escolha 2-3 apps de teste
3. Feche o app completamente
4. Tente abrir app bloqueado
5. ✅ Deve mostrar tela verde "App Bloqueado"

### Testar Desbloqueio:
1. Clique "Resolver Termo" na tela de bloqueio
2. Complete todos os jogos da dificuldade
3. Feche o app
4. ✅ Apps devem estar desbloqueados

### Debug Mode:
- Configurações > Toggle Debug Block
- Força bloqueio/desbloqueio manual
- **REMOVER antes da produção!**

---

## 📦 Estrutura de Extensions

```
TermoDeBloqueio/              # App principal
TermoDeBloqueioShieldAction/  # Botão "Resolver Termo"
TermoDeBloqueioShieldConfiguration/ # UI da tela de bloqueio
```

**Importante:** Todas as 3 targets precisam:
- ✅ Family Controls capability
- ✅ App Group: `group.com.DalPra.TermoDeBloqueio`
- ✅ Mesmo Bundle ID prefix

---

## 🔒 Privacidade

- ✅ **100% local** - nenhum dado sai do iPhone
- ✅ **Zero telemetria** - não coletamos nada
- ✅ **FamilyControls** - framework nativo da Apple
- ✅ **Open source** - código aberto para auditoria

---

## 📚 Recursos Adicionais

- 📖 [GUIA_DE_USO.md](GUIA_DE_USO.md) - Tutorial completo
- ✅ [CHECKLIST_FINAL.md](CHECKLIST_FINAL.md) - Testes pré-lançamento
- 🏪 [APP_STORE_DESCRIPTION.md](APP_STORE_DESCRIPTION.md) - Info para App Store
- 🎯 [MELHORIAS_FINAIS_APLICADAS.md](MELHORIAS_FINAIS_APLICADAS.md) - Changelog

---

## 🤝 Contribuindo

Pull requests são bem-vindos! Para mudanças grandes:
1. Abra uma issue primeiro
2. Fork o projeto
3. Crie sua branch (`git checkout -b feature/AmazingFeature`)
4. Commit suas mudanças (`git commit -m 'Add AmazingFeature'`)
5. Push para a branch (`git push origin feature/AmazingFeature`)
6. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

---

## ✨ Créditos

- Desenvolvido por **Lucas Dal Pra Brascher**
- Inspirado em [Wordle](https://www.nytimes.com/games/wordle) e [Termo](https://term.ooo)
- Palavras do [Dicionário Aberto](https://github.com/fserb/pt-br)

---

## 📱 Screenshots

<p align="center">
  <i>Screenshots disponíveis em breve...</i>
</p>

---

## 🎯 Roadmap

### v1.0 (Lançamento) ✅
- [x] Bloqueio de apps via FamilyControls
- [x] 3 modos de jogo
- [x] Sistema de dificuldade
- [x] Progresso diário
- [x] Onboarding completo

### v1.1 (Próxima)
- [ ] Estatísticas detalhadas
- [ ] Streak counter
- [ ] Modo escuro
- [ ] Sons de feedback

### v2.0 (Futuro)
- [ ] Widget iOS
- [ ] Compartilhar resultados
- [ ] Conquistas/Badges
- [ ] iCloud sync

---

## 🐛 Bugs Conhecidos

Nenhum bug crítico conhecido! 🎉

Encontrou um? [Abra uma issue](https://github.com/lucasdalpra/TermoDeBloqueio/issues)

---

## 💬 Contato

- GitHub: [@lucasdalpra](https://github.com/lucasdalpra)
- Email: [seu-email@exemplo.com]

---

**Feito com ❤️ e SwiftUI**
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
