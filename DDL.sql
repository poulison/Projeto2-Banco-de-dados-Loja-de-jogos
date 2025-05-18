-- Criação das tabelas principais

CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL
);

CREATE TABLE Funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Jogo (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    genero VARCHAR(50) NOT NULL,
    preco NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Plataforma (
    id_plataforma SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fabricante VARCHAR(100) NOT NULL,
    ano_lancamento INT NOT NULL
);

CREATE TABLE CupomDesconto (
    id_cupom SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    valor NUMERIC(6, 2) NOT NULL,
    validade DATE NOT NULL
);

CREATE TABLE Pedido (
    id_pedido SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

-- Relacionamento N:M com atributos
CREATE TABLE Pedido_Jogo (
    id_pedido INT,
    id_jogo INT,
    quantidade INT NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido, id_jogo),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_jogo) REFERENCES Jogo(id_jogo)
);

-- Relacionamento N:M simples
CREATE TABLE Jogo_Plataforma (
    id_jogo INT,
    id_plataforma INT,
    PRIMARY KEY (id_jogo, id_plataforma),
    FOREIGN KEY (id_jogo) REFERENCES Jogo(id_jogo),
    FOREIGN KEY (id_plataforma) REFERENCES Plataforma(id_plataforma)
);

-- Relacionamento 1:N
CREATE TABLE Cupom_Pedido (
    id_cupom INT,
    id_pedido INT,
    PRIMARY KEY (id_cupom, id_pedido),
    FOREIGN KEY (id_cupom) REFERENCES CupomDesconto(id_cupom),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);
