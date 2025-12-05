# ⚠️ CONFIGURAÇÕES ADICIONAIS NECESSÁRIAS

## 1️⃣ Adicionar URL Scheme no Xcode

1. Abra o projeto no Xcode
2. Selecione o target **TermoDeBloqueio** (principal)
3. Vá na aba **Info**
4. Expanda **URL Types**
5. Clique no **+** para adicionar
6. Configure:
   - **Identifier**: `com.seunome.TermoDeBloqueio`
   - **URL Schemes**: `termodebloqueio`
   - **Role**: Editor

## 2️⃣ Verificar Entitlements das Extensions

### TermoDeBloqueioShieldConfiguration.entitlements
Já deve ter:
```xml
<key>com.apple.developer.family-controls</key>
<true/>
```

### TermoDeBloqueioShieldAction.entitlements
Já deve ter:
```xml
<key>com.apple.developer.family-controls</key>
<true/>
```

## 3️⃣ Adicionar Family Controls no Target Principal

1. Selecione o target **TermoDeBloqueio**
2. Vá em **Signing & Capabilities**
3. Clique em **+ Capability**
4. Adicione **Family Controls**

## 4️⃣ Adicionar Privacy Descriptions (Info.plist)

No target principal, adicione:

1. Vá em **Info**
2. Clique no **+** em **Custom iOS Target Properties**
3. Adicione:

```
Privacy - Family Controls Usage Description
Precisamos acessar controles familiares para bloquear apps até você completar o Termo diário
```

## 5️⃣ Build Settings

Para cada Extension (ShieldConfiguration e ShieldAction):

1. Selecione o target da extension
2. Build Settings → **Skip Install** = **NO**
3. Build Settings → **Deployment Target** = **iOS 16.0** ou superior

## ✅ Checklist Final

- [ ] URL Scheme adicionado no target principal
- [ ] Family Controls capability no target principal
- [ ] Family Controls nas duas extensions (já adicionado)
- [ ] Privacy description adicionada
- [ ] Build Settings configurados
- [ ] Código das extensions atualizado (✓ Feito)
- [ ] AppBlockingManager adicionado ao projeto (✓ Feito)
- [ ] AppSelectionView adicionada (✓ Feito)

## 🧪 Como Testar

1. Build o app no device real (não funciona no simulador)
2. Primeiro run: Vai pedir autorização Family Controls → Autorize
3. Vá em Settings → Selecionar Apps
4. Escolha 1-2 apps (ex: Instagram, Twitter)
5. Volte e use o botão de debug "Bloquear Apps"
6. Feche o app e tente abrir Instagram
7. Deve aparecer a tela customizada verde com "Resolver Termo"
8. Clique nele → deve abrir o Termo de Bloqueio

## 🐛 Se não funcionar

1. **Console.app** no Mac → conecte o iPhone e veja os logs
2. Procure por erros de "ShieldConfiguration" ou "FamilyControls"
3. Certifique-se que ScreenTime está ativado no iPhone (Settings → Screen Time)
4. Reinstale o app completamente
