# 🔧 CONFIGURAÇÃO OBRIGATÓRIA - APP GROUPS

## ⚠️ PROBLEMA IDENTIFICADO

O bloqueio não funciona porque falta configurar **App Groups**. O `ManagedSettingsStore` precisa de um App Group compartilhado entre:
- App principal (TermoDeBloqueio)
- ShieldConfiguration extension
- ShieldAction extension

Sem isso, as extensions não conseguem ver quais apps foram bloqueados!

---

## 📋 CONFIGURAÇÃO NO XCODE (OBRIGATÓRIO)

### 1️⃣ Criar App Group (Target Principal)

1. Abra o projeto no Xcode
2. Selecione o target **TermoDeBloqueio** (principal)
3. Vá na aba **Signing & Capabilities**
4. Clique em **+ Capability** (canto superior esquerdo)
5. Adicione **App Groups**
6. Clique no **+** dentro de App Groups
7. Digite: `group.com.DalPra.TermoDeBloqueio`
8. Marque o checkbox ✅

### 2️⃣ Adicionar App Group nas Extensions

**Para TermoDeBloqueioShieldConfiguration:**
1. Selecione target **TermoDeBloqueioShieldConfiguration**
2. Aba **Signing & Capabilities**
3. Clique em **+ Capability**
4. Adicione **App Groups**
5. Clique no **+** dentro de App Groups
6. Digite: `group.com.DalPra.TermoDeBloqueio`
7. Marque o checkbox ✅

**Para TermoDeBloqueioShieldAction:**
1. Selecione target **TermoDeBloqueioShieldAction**
2. Aba **Signing & Capabilities**
3. Clique em **+ Capability**
4. Adicione **App Groups**
5. Clique no **+** dentro de App Groups
6. Digite: `group.com.DalPra.TermoDeBloqueio`
7. Marque o checkbox ✅

---

## ✅ CHECKLIST COMPLETO

### Target Principal (TermoDeBloqueio)
- [x] URL Scheme: `termodebloqueio` ✓ (já configurado no Info.plist)
- [x] Privacy Description ✓ (já configurado no Info.plist)
- [ ] **Family Controls** capability
- [ ] **App Groups** capability → `group.com.DalPra.TermoDeBloqueio`

### TermoDeBloqueioShieldConfiguration
- [ ] **Family Controls** capability
- [ ] **App Groups** capability → `group.com.DalPra.TermoDeBloqueio`

### TermoDeBloqueioShieldAction
- [ ] **Family Controls** capability
- [ ] **App Groups** capability → `group.com.DalPra.TermoDeBloqueio`

---

## 🧪 TESTANDO PASSO A PASSO

### Fase 1: Build e Autorização
1. **Clean build**: Cmd+Shift+K
2. **Build no device real**: Cmd+R (iPhone físico obrigatório)
3. Abra o app
4. Vá em **Configurações**
5. Clique em **Selecionar Apps**
6. Autorize quando pedir (vai abrir Settings do iOS)

### Fase 2: Seleção de Apps
1. Volte pro app
2. Clique em **Selecionar Apps** novamente
3. Selecione 2-3 apps (Instagram, Twitter, Safari, etc.)
4. **IMPORTANTE**: NÃO selecione Settings, Phone, Messages
5. Clique **Done** no picker

### Fase 3: Verificar Logs
1. Conecte no Mac
2. Abra **Console.app**
3. Selecione seu iPhone no lado esquerdo
4. Filtre por: `TermoDeBloqueio`
5. Você deve ver:
   ```
   📱 SELEÇÃO ALTERADA!
      Apps selecionados: 3
   🔄 Aplicando bloqueio automaticamente...
   🔒 BLOQUEIO ATIVADO
   📱 Apps bloqueados: 3
   ```

### Fase 4: Testar Bloqueio Manual (Debug)
1. Vá em **Configurações** do app
2. Role até "Debug"
3. Clique em **"Bloquear Apps (Debug)"**
4. Botão deve ficar vermelho
5. Veja os logs no Console:
   ```
   🔒 BLOQUEIO ATIVADO
   📱 Apps bloqueados: 3
   ```

### Fase 5: Verificar Bloqueio Real
1. **FECHE COMPLETAMENTE O APP** (swipe pra cima)
2. Tente abrir um app bloqueado (ex: Instagram)
3. Deve aparecer tela verde "App Bloqueado"
4. Se NÃO aparecer:
   - Verifique Console.app por erros
   - Confirme que App Groups está configurado
   - Reinstale o app completamente

### Fase 6: Resolver e Desbloquear
1. Clique "Resolver Termo" na tela verde
2. Deve abrir o app
3. Complete o Termo
4. Apps desbloqueiam automaticamente

---

## 🐛 TROUBLESHOOTING

### "Apps não bloqueiam"
**Causas possíveis:**
1. ❌ **App Groups não configurado** (mais comum!)
   - Solução: Siga passos acima para adicionar em TODOS os targets
   
2. ❌ **Family Controls não autorizado**
   - Vá em Settings → Screen Time → Ative
   - Reinstale o app
   
3. ❌ **Store sem nome**
   - ✅ JÁ CORRIGIDO: Agora usa `ManagedSettingsStore(named: "TermoDeBloqueio")`
   
4. ❌ **Tokens vazios**
   - Veja Console.app: se "Apps selecionados: 0" → problema no picker

### "Tela verde não aparece customizada"
- Extensions precisam ter **Family Controls** E **App Groups**
- Verifique Bundle IDs corretos
- Reinstale completamente

### Logs importantes no Console:
```
✅ Autorização concedida!
📱 SELEÇÃO ALTERADA! Apps selecionados: 3
🔒 BLOQUEIO ATIVADO
🎯 Tokens: [tokens aqui]
```

Se não ver esses logs, o problema está na configuração!

---

## 🎯 O QUE FOI CORRIGIDO NO CÓDIGO

1. ✅ **ManagedSettingsStore nomeado**
   ```swift
   private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("TermoDeBloqueio"))
   ```

2. ✅ **Bloqueio automático após seleção**
   - `onChange` no AppSelectionView chama `blockApps()` automaticamente

3. ✅ **Logs detalhados**
   - Todos os passos agora imprimem no Console.app

4. ✅ **ShieldActionExtension sem UIApplication.shared**
   - Usa selector via responder chain (compatível com extensions)

---

## 📱 PRÓXIMOS PASSOS

1. **Configure App Groups** em TODOS os targets (obrigatório!)
2. **Adicione Family Controls** capability se ainda não tiver
3. **Clean build**: Cmd+Shift+K
4. **Build no device**: Cmd+R
5. **Siga o teste passo a passo acima**
6. **Use Console.app** para ver logs em tempo real

Qualquer problema, mande os logs do Console.app!
