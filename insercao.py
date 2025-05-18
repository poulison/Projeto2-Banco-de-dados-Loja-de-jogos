import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta
import csv
import os

# Configuração da conexão com Supabase
conn_params = {
    "host": "aws-0-sa-east-1.pooler.supabase.com",
    "port": "6543",
    "dbname": "postgres",
    "user": "postgres.njkmsxflhbnobhbulfcn",
    "password": "BINDA1"
}

# Inicializar Faker e conectar
faker = Faker()
conn = psycopg2.connect(**conn_params)
cur = conn.cursor()

# Inserir Clientes
for _ in range(20):
    nome = faker.name()
    email = faker.unique.email()
    data_nascimento = faker.date_of_birth(minimum_age=18, maximum_age=60)
    cur.execute("INSERT INTO Cliente (nome, email, data_nascimento) VALUES (%s, %s, %s)",
                (nome, email, data_nascimento))

# Inserir Funcionários
for _ in range(5):
    nome = faker.name()
    cargo = random.choice(['Gerente', 'Vendedor', 'Suporte'])
    salario = round(random.uniform(2500, 7000), 2)
    cur.execute("INSERT INTO Funcionario (nome, cargo, salario) VALUES (%s, %s, %s)",
                (nome, cargo, salario))

# Inserir Plataformas
plataformas = [
    ('PlayStation 5', 'Sony', 2020),
    ('Xbox Series X', 'Microsoft', 2020),
    ('Nintendo Switch', 'Nintendo', 2017),
    ('PC', 'Diversos', 0),
    ('Steam Deck', 'Valve', 2022)
]
for nome, fabricante, ano in plataformas:
    cur.execute("INSERT INTO Plataforma (nome, fabricante, ano_lancamento) VALUES (%s, %s, %s)",
                (nome, fabricante, ano))

# Inserir Jogos
for _ in range(15):
    titulo = faker.word().capitalize() + " " + faker.word().capitalize()
    genero = random.choice(['RPG', 'Ação', 'Esporte', 'Aventura'])
    preco = round(random.uniform(49.99, 299.99), 2)
    cur.execute("INSERT INTO Jogo (titulo, genero, preco) VALUES (%s, %s, %s)",
                (titulo, genero, preco))

# Inserir Cupons
for _ in range(5):
    codigo = faker.unique.bothify(text='CUPOM-####')
    valor = round(random.uniform(10, 50), 2)
    validade = datetime.today() + timedelta(days=random.randint(30, 180))
    cur.execute("INSERT INTO CupomDesconto (codigo, valor, validade) VALUES (%s, %s, %s)",
                (codigo, valor, validade.date()))

# Inserir Pedidos
for _ in range(25):
    data = faker.date_between(start_date='-30d', end_date='today')
    forma_pagamento = random.choice(['Cartão', 'Pix', 'Boleto'])
    cur.execute("SELECT id_cliente FROM Cliente ORDER BY RANDOM() LIMIT 1")
    id_cliente = cur.fetchone()[0]
    cur.execute("SELECT id_funcionario FROM Funcionario ORDER BY RANDOM() LIMIT 1")
    id_funcionario = cur.fetchone()[0]
    cur.execute("INSERT INTO Pedido (data, forma_pagamento, id_cliente, id_funcionario) VALUES (%s, %s, %s, %s) RETURNING id_pedido",
                (data, forma_pagamento, id_cliente, id_funcionario))
    pedido_id = cur.fetchone()[0]

    # Relacionar com cupons (nem todos)
    if random.random() < 0.4:
        cur.execute("SELECT id_cupom FROM CupomDesconto ORDER BY RANDOM() LIMIT 1")
        id_cupom = cur.fetchone()[0]
        cur.execute("INSERT INTO Cupom_Pedido (id_cupom, id_pedido) VALUES (%s, %s)", (id_cupom, pedido_id))

    # Relacionar com jogos, evitando duplicação (chave composta)
    jogos_usados = set()
    for _ in range(random.randint(1, 3)):
        cur.execute("SELECT id_jogo, preco FROM Jogo ORDER BY RANDOM() LIMIT 1")
        id_jogo, preco = cur.fetchone()
        if id_jogo in jogos_usados:
            continue
        jogos_usados.add(id_jogo)
        quantidade = random.randint(1, 4)
        cur.execute("INSERT INTO Pedido_Jogo (id_pedido, id_jogo, quantidade, preco_unitario) VALUES (%s, %s, %s, %s)",
                    (pedido_id, id_jogo, quantidade, preco))

# Relacionar jogos com plataformas
cur.execute("SELECT id_jogo FROM Jogo")
ids_jogos = [row[0] for row in cur.fetchall()]
cur.execute("SELECT id_plataforma FROM Plataforma")
ids_plataformas = [row[0] for row in cur.fetchall()]

for id_jogo in ids_jogos:
    plataformas_escolhidas = random.sample(ids_plataformas, random.randint(1, 3))
    for id_plataforma in plataformas_escolhidas:
        cur.execute("INSERT INTO Jogo_Plataforma (id_jogo, id_plataforma) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                    (id_jogo, id_plataforma))

# Commit das inserções
conn.commit()

# Exportar tabelas para CSV
output_dir = "csv_exportados"
os.makedirs(output_dir, exist_ok=True)

def export_table_to_csv(cursor, table_name):
    cursor.execute(f"SELECT * FROM {table_name}")
    rows = cursor.fetchall()
    colnames = [desc[0] for desc in cursor.description]
    filepath = os.path.join(output_dir, f"{table_name}.csv")
    with open(filepath, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(colnames)
        writer.writerows(rows)
    print(f"✅ Exportado: {filepath}")

# Tabelas para exportar
tabelas = [
    "Cliente",
    "Funcionario",
    "Plataforma",
    "Jogo",
    "CupomDesconto",
    "Pedido",
    "Pedido_Jogo",
    "Jogo_Plataforma",
    "Cupom_Pedido"
]

for tabela in tabelas:
    export_table_to_csv(cur, tabela)

# Fechar conexão
cur.close()
conn.close()

print("\n🚀 Todos os dados foram inseridos e exportados com sucesso!")
