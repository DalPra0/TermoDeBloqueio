import json
import os
import glob
import xml.etree.ElementTree as ET

# --- CONFIGURAÇÃO AUTOMÁTICA DE CAMINHOS ---
# 1. Descobre a pasta onde ESTE script (.py) está salvo
DIRETORIO_BASE = os.path.dirname(os.path.abspath(__file__))

# 2. Define os caminhos dos arquivos baseados nessa pasta
# Certifique-se de que o arquivo de texto está ao lado deste script
ARQUIVO_IME = os.path.join(DIRETORIO_BASE, 'br-utf8.txt')

# Certifique-se de que existe uma pasta com os XMLs ao lado deste script
PASTA_XMLS = os.path.join(DIRETORIO_BASE, 'xmls_dicionario_aberto')

# O arquivo final será salvo na mesma pasta
ARQUIVO_SAIDA = os.path.join(DIRETORIO_BASE, 'palavras_termo_completo.json')

def limpar_palavra(palavra):
    """Padroniza a palavra para filtragem."""
    if not palavra:
        return ""
    palavra = palavra.strip()
    # Remove sufixos do IME tipo /M, /v, etc.
    if '/' in palavra:
        palavra = palavra.split('/')[0]
    return palavra.lower()

def eh_valida(palavra):
    """Regras para ser aceita no jogo (5 letras, sem hífen/símbolos)."""
    # Verifica tamanho e se só tem letras (aceita acentos, rejeita números/símbolos)
    if len(palavra) == 5 and palavra.isalpha() and '-' not in palavra:
        return True
    return False

def processar_ime(caminho_arquivo):
    palavras = set()
    if not os.path.exists(caminho_arquivo):
        print(f"AVISO: Arquivo do IME não encontrado em:\n -> {caminho_arquivo}")
        return palavras

    try:
        print(f"Lendo IME...")
        with open(caminho_arquivo, 'r', encoding='utf-8') as f:
            for linha in f:
                p = limpar_palavra(linha)
                if eh_valida(p):
                    palavras.add(p)
    except Exception as e:
        print(f"Erro ao ler IME: {e}")
    return palavras

def processar_xmls(pasta):
    palavras = set()
    # Pega todos os arquivos .xml na pasta indicada
    # O glob vai procurar: .../xmls_dicionario_aberto/*.xml
    padrao_busca = os.path.join(pasta, '*.xml')
    lista_arquivos = glob.glob(padrao_busca)
    
    if not lista_arquivos:
        print(f"AVISO: Nenhum XML encontrado na pasta:\n -> {pasta}")
        return palavras

    print(f"Encontrados {len(lista_arquivos)} arquivos XML no Dicionário Aberto.")
    
    for arquivo in lista_arquivos:
        try:
            tree = ET.parse(arquivo)
            root = tree.getroot()
            # A estrutura é <entry> -> <form> -> <orth>
            for entry in root.findall('entry'):
                form = entry.find('form')
                if form is not None:
                    orth = form.find('orth')
                    if orth is not None and orth.text:
                        p = limpar_palavra(orth.text)
                        if eh_valida(p):
                            palavras.add(p)
        except Exception as e:
            # Mostra apenas o nome do arquivo que deu erro para não poluir muito
            nome_arq = os.path.basename(arquivo)
            print(f"Erro ao ler {nome_arq}: {e}")
            
    return palavras

def main():
    print("--- INICIANDO ---")
    print(f"Diretório de trabalho: {DIRETORIO_BASE}")

    # 1. Ler IME
    conjunto_ime = processar_ime(ARQUIVO_IME)
    print(f"-> Palavras válidas vindas do IME: {len(conjunto_ime)}")

    # 2. Ler XMLs
    conjunto_xml = processar_xmls(PASTA_XMLS)
    print(f"-> Palavras válidas vindas dos XMLs: {len(conjunto_xml)}")

    # 3. Unir os conjuntos (set cuida de remover duplicatas automaticamente)
    total_palavras = conjunto_ime.union(conjunto_xml)
    lista_final = sorted(list(total_palavras))

    # 4. Salvar
    dados_json = {
        "metadados": {
            "total": len(lista_final),
            "fonte": "IME + Dicionário Aberto"
        },
        "palavras": lista_final
    }

    try:
        with open(ARQUIVO_SAIDA, 'w', encoding='utf-8') as f:
            json.dump(dados_json, f, ensure_ascii=False, indent=2)

        print(f"\n--- SUCESSO ---")
        print(f"Arquivo gerado: {ARQUIVO_SAIDA}")
        print(f"Total de palavras de 5 letras únicas: {len(lista_final)}")
    except Exception as e:
        print(f"Erro ao salvar arquivo final: {e}")

if __name__ == "__main__":
    main()