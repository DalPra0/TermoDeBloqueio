# 🔒 Configuração do Bloqueio de Apps - Termo de Bloqueio

## ✅ Arquivos Criados

1. **AppBlockingManager.swift** - Gerencia bloqueio de apps via FamilyControls
2. **ShieldConfigurationExtension.swift** - Define aparência da tela de bloqueio
3. **ShieldActionExtension.swift** - Define ações quando usuário clica nos botões
4. **AppSelectionView.swift** - Tela para selecionar apps a bloquear

## 📋 Passos para Configurar

### 1. Adicionar URL Scheme no Info.plist

No Xcode, clique no arquivo `Info.plist` e adicione:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>termodebloqueio</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.seunome.TermoDeBloqueio</string>
    </dict>
</array>
```

### 2. Criar Shield Configuration Extension

1. **File → New → Target**
2. Escolha **Shield Configuration Extension**
3. Nome: `TermoDeBloqueioShieldConfiguration`
4. Clique **Finish**
5. Quando perguntar "Activate scheme?", clique **Activate**

6. **Copie o conteúdo do arquivo** `Extensions/ShieldConfigurationExtension.swift` para o arquivo `ShieldConfigurationExtension.swift` que foi criado

7. No `Info.plist` da Extension, adicione:
```xml
<key>com.apple.developer.family-controls</key>
<true/>
```

### 3. Criar Shield Action Extension

1. **File → New → Target**
2. Escolha **Shield Action Extension**
3. Nome: `TermoDeBloqueioShieldAction`
4. Clique **Finish**

5. **Copie o conteúdo do arquivo** `Extensions/ShieldActionExtension.swift` para o arquivo `ShieldActionExtension.swift` que foi criado

6. No `Info.plist` da Extension, adicione:
```xml
<key>com.apple.developer.family-controls</key>
<true/>
```

### 4. Configurar Capabilities no Target Principal

1. Selecione o projeto no Xcode
2. Vá em **Signing & Capabilities**
3. Clique em **+ Capability**
4. Adicione **Family Controls**

### 5. Configurar os Targets das Extensions

Para **ambas** as extensions (ShieldConfiguration e ShieldAction):

1. Selecione o target da extension
2. **Signing & Capabilities**
3. Adicione **Family Controls**
4. Use o mesmo Team e Bundle ID base

### 6. Adicionar Imports no Bridging Header (se necessário)

Se o Xcode pedir um bridging header, crie um arquivo e adicione:

```swift
import FamilyControls
import ManagedSettings
import DeviceActivity
```

## 🎮 Como Funciona

1. **Usuário abre Settings** → Clica em "Selecionar Apps"
2. **Autoriza FamilyControls** → Primeira vez pede permissão
3. **Seleciona apps** → Escolhe quais apps bloquear
4. **Apps são bloqueados** → Quando `BlockManager.isBlocked == true`
5. **Tenta abrir app bloqueado** → Aparece tela customizada:
   - Título: "App Bloqueado"
   - Mensagem: "Complete o Termo para desbloquear"
   - Botão verde: "Resolver Termo" → Abre o app na LockScreen
6. **Completa o Termo** → Apps desbloqueiam automaticamente

## 🔧 Troubleshooting

### "Cannot find FamilyControls in scope"
- Certifique-se que adicionou Family Controls nas Capabilities
- Verifique se o import está correto: `import FamilyControls`

### "Authorization denied"
- Vá em Settings → Screen Time → Ative Screen Time
- Tente novamente autorizar no app

### Apps não bloqueiam
- Verifique se os apps foram selecionados corretamente
- Confirme que `BlockManager.isBlocked == true`
- Reinicie o app

### Extension não compila
- Certifique-se que o Bundle ID está correto
- Verifique que Family Controls está nas Capabilities da Extension
- Limpe o build: Cmd+Shift+K

## 🚀 Testando

1. Abra o app
2. Vá em Configurações
3. Clique em "Selecionar Apps"
4. Autorize quando pedir
5. Selecione Instagram, Twitter, etc
6. Volte e use o botão de debug "Bloquear Apps"
7. Feche o app e tente abrir Instagram
8. Deve aparecer a tela de bloqueio customizada!

## ⚠️ IMPORTANTE

- **Nunca bloqueie Settings ou Phone** - Você vai travar o dispositivo!
- **Teste primeiro com poucos apps** - Comece com 2-3 apps
- **Device real necessário** - Não funciona no simulador
- **iOS 16+** - FamilyControls requer iOS 16 ou superior
