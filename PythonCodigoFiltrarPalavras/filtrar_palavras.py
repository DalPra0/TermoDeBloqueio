#!/usr/bin/env python3
import json
import re

def is_good_word(word):
    """Retorna True se a palavra é boa para o jogo"""
    
    # Remove nomes próprios óbvios (aarão, elena, ayres, etc)
    nomes_proprios = {
        'aarão', 'abdon', 'abner', 'acker', 'adele', 'adolf', 'agnes', 'aisha',
        'akira', 'alain', 'alamo', 'alan', 'alana', 'alba', 'alban', 'alber',
        'alceu', 'alda', 'aldos', 'alec', 'alena', 'alexa', 'alex', 'alexy',
        'alfred', 'alice', 'aline', 'alírio', 'alois', 'alves', 'alyah', 'amado',
        'amara', 'améli', 'amira', 'anders', 'andre', 'andrés', 'andy', 'angel',
        'anita', 'anjos', 'anton', 'antôn', 'araci', 'ariel', 'artur', 'aryeh',
        'atila', 'ayres', 'aécio', 'babel', 'bahia', 'balkh', 'barém', 'basil',
        'bella', 'bento', 'berço', 'betha', 'blake', 'blois', 'bobby', 'boris',
        'brady', 'brian', 'brits', 'bruce', 'bruno', 'bryan', 'brýon', 'báryo',
        'byron', 'caetá', 'cairo', 'caleb', 'canda', 'caraó', 'carlo', 'carlos',
        'carol', 'casey', 'catão', 'cathy', 'cecil', 'cesar', 'célia', 'celta',
        'chad', 'chico', 'chile', 'china', 'chloe', 'chris', 'cindy', 'circe',
        'clark', 'claus', 'clóvis', 'cohen', 'colin', 'congo', 'conan', 'craig',
        'dalai', 'dalém', 'damon', 'danny', 'dante', 'darcy', 'dario', 'daryl',
        'david', 'derek', 'devon', 'diana', 'diane', 'diego', 'dilma', 'dixon',
        'dolly', 'donát', 'doris', 'douro', 'drake', 'duíno', 'dylan', 'édipo',
        'edgar', 'edith', 'edmon', 'édson', 'elena', 'elias', 'élias', 'elisa',
        'ellen', 'ellis', 'elton', 'elvis', 'emile', 'emily', 'emma', 'ender',
        'enoch', 'enola', 'enrico', 'erick', 'ernst', 'errol', 'ester', 'ethan',
        'evan', 'evans', 'évora', 'fabia', 'fabio', 'fábio', 'faith', 'faulk',
        'felix', 'fênix', 'fidel', 'fiona', 'flora', 'floyd', 'fomin', 'foucá',
        'frank', 'franz', 'freds', 'frege', 'freud', 'fritz', 'furia', 'gable',
        'ganso', 'garth', 'gates', 'gauss', 'gênoa', 'george', 'gerda', 'giles',
        'gilma', 'gisél', 'glenn', 'globo', 'golda', 'grace', 'grant', 'greco',
        'grécia', 'grégó', 'greta', 'grévy', 'guido', 'haifa', 'haiti', 'haley',
        'hardy', 'harold', 'harry', 'havel', 'hayes', 'hazel', 'hegel', 'heidi',
        'heinz', 'helen', 'helga', 'henri', 'henry', 'herma', 'hobbs', 'holly',
        'homer', 'hoppe', 'horta', 'hosea', 'hugh', 'hugo', 'hulda', 'hyatt',
        'ian', 'ibsen', 'idaho', 'india', 'indio', 'ionne', 'iraqi', 'irene',
        'irish', 'isaac', 'isaak', 'isabel', 'isaiah', 'isamu', 'israel', 'itália',
        'ivan', 'jacob', 'jacó', 'james', 'jamie', 'janet', 'janis', 'jason',
        'jeane', 'jeová', 'jerry', 'jesse', 'jesus', 'jimmy', 'joana', 'joão',
        'joel', 'johan', 'john', 'jonas', 'jones', 'jorge', 'josé', 'josh',
        'joyce', 'juan', 'judas', 'judith', 'julio', 'júlio', 'kafka', 'karen',
        'karl', 'karol', 'katia', 'kathy', 'katie', 'keith', 'kelly', 'kenny',
        'kerry', 'kevin', 'klaus', 'korea', 'kraus', 'lagos', 'lajos', 'lance',
        'laos', 'larry', 'laura', 'leeds', 'leigh', 'lenin', 'leone', 'lewis',
        'libya', 'linda', 'lioné', 'lloyd', 'lopes', 'louis', 'lucas', 'lucia',
        'luigi', 'luisa', 'luis', 'luke', 'lynch', 'lydia', 'mabel', 'machó',
        'malta', 'marco', 'marcos', 'maria', 'marie', 'mario', 'mário', 'marla',
        'marta', 'marti', 'marty', 'mason', 'mateo', 'maura', 'mauro', 'meyer',
        'miami', 'micha', 'milan', 'miles', 'mills', 'minas', 'mitch', 'mitya',
        'moira', 'molly', 'mona', 'monte', 'moore', 'moses', 'nancy', 'naomi',
        'nelly', 'nepal', 'niger', 'nikki', 'nixon', 'noah', 'nobel', 'nolan',
        'norah', 'norma', 'norse', 'norse', 'norte', 'olavo', 'olga', 'olive',
        'olsen', 'omar', 'omãr', 'oprah', 'orion', 'oscar', 'oscar', 'osíri',
        'oslo', 'owen', 'pablo', 'paolo', 'parád', 'paris', 'parks', 'patel',
        'patri', 'paul', 'paula', 'paulo', 'pearl', 'pedro', 'peggy', 'penny',
        'percy', 'perry', 'peter', 'petra', 'phebe', 'phill', 'piper', 'plato',
        'porto', 'praga', 'price', 'primo', 'putin', 'qatar', 'quick', 'quinn',
        'ralph', 'ramon', 'randy', 'raoul', 'raúl', 'ravel', 'regan', 'reich',
        'renan', 'renée', 'rhine', 'rhoda', 'rica', 'riley', 'ringo', 'rocha',
        'rocky', 'roger', 'roman', 'romeo', 'ronan', 'ronda', 'rosa', 'rosie',
        'rowan', 'roxie', 'rufus', 'russo', 'ruth', 'ryan', 'sagan', 'sally',
        'samoa', 'sandy', 'sarah', 'saul', 'scott', 'seoul', 'serge', 'shane',
        'shawn', 'sheba', 'sheen', 'sheik', 'sheri', 'sibyl', 'simon', 'singh',
        'sioux', 'smith', 'sofia', 'sonia', 'sonya', 'soren', 'spain', 'stalin',
        'stark', 'steve', 'stone', 'sudan', 'sueli', 'suéli', 'susan', 'syria',
        'tanía', 'tanya', 'tatum', 'teddy', 'terry', 'tesla', 'texas', 'theda',
        'tibet', 'tiflis', 'timor', 'titus', 'todd', 'tokyo', 'tommy', 'tonga',
        'tonya', 'tracy', 'trent', 'trevor', 'trina', 'troy', 'tudor', 'tyler',
        'ucrân', 'uganda', 'ulric', 'union', 'uriah', 'uriel', 'ursula', 'utah',
        'vadim', 'vance', 'verna', 'verne', 'vicki', 'vickt', 'vidal', 'vietnã',
        'vince', 'viola', 'vitor', 'volga', 'wade', 'wales', 'wanda', 'wayne',
        'wells', 'wendy', 'wilde', 'wiley', 'willy', 'wolfe', 'woody', 'wyatt',
        'xerxé', 'yakov', 'yemen', 'yetta', 'yonne', 'young', 'yvete', 'yvone',
        'zaire', 'zelda', 'zilda', 'zumbi'
    }
    
    if word.lower() in nomes_proprios:
        return False
    
    # Remove estrangeirismos óbvios (palavras com k, w, y)
    if re.search(r'[kwy]', word, re.IGNORECASE):
        return False
    
    # Remove palavras com acentos muito raros juntos (ô + ã, etc)
    if word.count('ô') > 1 or word.count('ã') > 1 or word.count('õ') > 1:
        return False
    
    # Remove palavras que são só abreviações (maiúsculas)
    if word.isupper() and len(word) == 5:
        return False
    
    # Remove palavras com muitas consoantes seguidas (4+)
    if re.search(r'[bcdfghjlmnpqrstvxz]{4,}', word, re.IGNORECASE):
        return False
    
    # Remove palavras com muitas vogais seguidas (4+)
    if re.search(r'[aeiou]{4,}', word, re.IGNORECASE):
        return False
    
    # Remove palavras muito técnicas ou raras (com padrões específicos)
    # Palavras terminadas em -ôa, -ío, -ía repetidos podem ser técnicas
    if word.endswith('ôa') or word.endswith('ío') or word.endswith('ía'):
        # Mas mantém as comuns
        comuns_terminacao = {'areia', 'ateia', 'ideia', 'pleia', 'cheia', 'maria', 'seria', 'varia'}
        if word not in comuns_terminacao:
            # Verifica se não é uma conjugação verbal comum
            if not re.match(r'^[a-z]{2,3}(eia|aia|oia)$', word):
                return False
    
    # Mantém todas as outras palavras
    return True


def filtrar_palavras():
    """Filtra o arquivo de palavras mantendo apenas as boas para o jogo"""
    
    # Caminho do arquivo
    input_file = 'TermoDeBloqueio/Resources/palavras_termo_completo.json'
    output_file = 'TermoDeBloqueio/Resources/palavras_termo_filtrado.json'
    
    # Lê o arquivo original
    print("📖 Lendo arquivo original...")
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    total_original = len(data['palavras'])
    print(f"   Total de palavras: {total_original}")
    
    # Filtra as palavras
    print("\n🔍 Filtrando palavras...")
    palavras_filtradas = [palavra for palavra in data['palavras'] if is_good_word(palavra)]
    
    total_filtrado = len(palavras_filtradas)
    removidas = total_original - total_filtrado
    porcentagem = (removidas / total_original) * 100
    
    print(f"   Palavras mantidas: {total_filtrado}")
    print(f"   Palavras removidas: {removidas} ({porcentagem:.1f}%)")
    
    # Cria novo JSON
    novo_data = {
        "metadados": {
            "total": total_filtrado,
            "fonte": data['metadados']['fonte'] + " (filtrado)",
            "filtrado_em": "2025-12-14"
        },
        "palavras": sorted(palavras_filtradas)
    }
    
    # Salva arquivo filtrado
    print(f"\n💾 Salvando em: {output_file}")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(novo_data, f, ensure_ascii=False, indent=2)
    
    print("\n✅ FILTRO CONCLUÍDO!")
    print(f"\n   Arquivo original: {input_file} ({total_original} palavras)")
    print(f"   Arquivo filtrado: {output_file} ({total_filtrado} palavras)")
    print(f"\n   Para usar o arquivo filtrado, renomeie:")
    print(f"   mv {output_file} {input_file}")
    
    # Mostra algumas palavras removidas como exemplo
    print("\n📋 Exemplos de palavras removidas:")
    palavras_removidas = [p for p in data['palavras'] if not is_good_word(p)]
    for palavra in palavras_removidas[:20]:
        print(f"   - {palavra}")
    
    # Mostra algumas palavras mantidas como exemplo
    print("\n✨ Exemplos de palavras mantidas:")
    for palavra in palavras_filtradas[:20]:
        print(f"   + {palavra}")


if __name__ == "__main__":
    filtrar_palavras()
