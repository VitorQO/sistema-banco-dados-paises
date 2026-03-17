#ALUNOS INTEGRANTES
 # WILLIAN JERONIMO SOUSA DA SILVA
 # CAIO HENRIQUE SILVA ANDRADE
 # VITOR QUEIROZ DE OLIVEIRA
 # THEO CHRISTIANO DA SILVA ODAWARA
 
# CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE db_bddpaises_normalizado;
USE db_bddpaises_normalizado;

#CRIAÇÃO DO USUARIO
CREATE USER 'aaa'@'localhost' identified by "1234";
GRANT SELECT,INSERT,UPDATE ON db_bddpaises_normalizado.* TO 'Usuario_admin'@'localhost';
REVOKE INSERT,UPDATE ON *.* FROM "Usuario_admin"@"localhost"; 

# TABELA: CONTINENTE
CREATE TABLE continente(
    id_continente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);
 
# TABELA: IDIOMA
CREATE TABLE idioma (
    id_idioma INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);
 
# TABELA: MOEDA
CREATE TABLE moeda (
    id_moeda INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);
 
# TABELA: DDI
CREATE TABLE ddi (
    id_ddi INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL
);
 
# TABELA: PAÍS
CREATE TABLE pais (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    Capital VARCHAR(50) NOT NULL,
    id_moeda INT,
    id_continente INT,
    populacao BIGINT NOT NULL,
    area DECIMAL(12,2) NOT NULL,
    id_ddi INT,
    pib DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (id_moeda) REFERENCES moeda(id_moeda),
    FOREIGN KEY (id_continente) REFERENCES continente(id_continente),
    FOREIGN KEY (id_ddi) REFERENCES ddi(id_ddi)
);

# ALTERAÇAO NA TABELA PRA ADICIONAR O CODIGO_ISO DO PAIS
ALTER TABLE PAIS ADD CODIGO_ISO CHAR(3);
 
# TABELA: RELACIONAMENTO PAÍS-IDIOMA (Caso exista mais de um idioma por país)
CREATE TABLE pais_idioma (
    id_pais INT,
    id_idioma INT,
    PRIMARY KEY (id_pais, id_idioma),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais),
    FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma)
);

#DESLIGA O MODO SEGURO
SET SQL_SAFE_UPDATES = 0;

#INICIO DA TRANSACTION
START TRANSACTION;
# DADOS - CONTINENTES
INSERT INTO continente (nome) VALUES 
('América do Sul'), ('América do Norte'), ('Europa'), 
('África'), ('Ásia'), ('Oceania');

# DADOS - IDIOMAS
INSERT INTO idioma (nome) VALUES 
('Português'), ('Inglês'), ('Espanhol'), 
('Alemão'), ('Francês'), ('Mandarim'), 
('Hindi'), ('Japonês'), ('Russo'), ('Esperanto');

DELETE FROM idioma WHERE nome = 'Russo';
COMMIT;

#LIGA MODO SEGURO
SET SQL_SAFE_UPDATES = 1;
 
# DADOS - MOEDAS
INSERT INTO moeda (nome) VALUES 
('Real'), ('Dólar'), ('Euro'), 
('Iene'), ('Dólar Australiano'), 
('Rupia'), ('Renminbi'), ('Peso Mexicano'), 
('Libra'), ('Rublo');
 
# DADOS - DDI
INSERT INTO ddi (codigo) VALUES 
('+55'), ('+1'), ('+49'), 
('+81'), ('+61'), ('+91'), 
('+86'), ('+52'), ('+44'), 
('+7'), ('+34');
 
# INSERINDO 15 PAÍSES (referenciando por ID)
INSERT INTO pais (nome, capital, id_moeda, id_continente, populacao, area, id_ddi, pib)
VALUES 
('Brasil', 'Brasília', 1, 1, 215000000, 8515767, 1, 2174000000000),
('Estados Unidos', 'Washington', 2, 2, 330000000, 9833517, 2, 30510000000000),
('Alemanha', 'Berlim', 3, 3, 83000000, 357022, 3, 4740000000000),
('Japão', 'Tóquio', 4, 5, 126700000, 377947, 4, 4180000000000),
('Austrália', 'Canberra', 5, 6, 27466749, 7741220, 5, 1728000000000),
('Índia', 'Nova Délhi', 6, 5, 1366000000, 3287263, 6, 4190000000000),
('França', 'Paris', 3, 3, 68600000, 643801, 3, 3211000000000),
('China', 'Pequim', 7, 5, 1390000000, 9600000, 7, 19230000000000),
('Canadá', 'Ottawa', 2, 2, 38000000, 9984670, 2, 2230000000000),
('Reino Unido', 'Londres', 9, 3, 68000000, 242495, 9, 3840000000000),
('México', 'Cidade do México', 8, 2, 126000000, 1964375, 8, 1258000000000),
('África do Sul', 'Pretória', 2, 4, 60000000, 1219090, 2, 351000000000),
('Argentina', 'Buenos Aires', 8, 1, 45000000, 2780000, 8, 646100000000),
('Rússia', 'Moscou', 10, 3, 144000000, 17098240, 10, 2200000000000),
('Espanha', 'Madri', 3, 3, 47000000, 505370, 11, 1600000000000);

# ATUALIZAÇÃO DO REGISTRO EM PAIS PARA ADICIONAR O CODIGO ISO
UPDATE PAIS SET CODIGO_ISO = 'BRA' WHERE nome = 'Brasil';
UPDATE PAIS SET CODIGO_ISO = 'USA' WHERE nome = 'Estados Unidos';
UPDATE PAIS SET CODIGO_ISO = 'DEU' WHERE nome = 'Alemanha';
 
# VINCULANDO PAÍSES A SEUS IDIOMAS
-- Brasil (Português)
INSERT INTO pais_idioma VALUES (1, 1);
-- EUA, Austrália, África do Sul, Canadá, Reino Unido (Inglês)
INSERT INTO pais_idioma VALUES (2, 2), (5, 2), (12, 2), (9, 2), (10, 2);
-- Alemanha (Alemão)
INSERT INTO pais_idioma VALUES (3, 4);
-- Japão (Japonês)
INSERT INTO pais_idioma VALUES (4, 8);
-- Índia (Hindi)
INSERT INTO pais_idioma VALUES (6, 7);
-- França (Francês)
INSERT INTO pais_idioma VALUES (7, 5);
-- China (Mandarim)
INSERT INTO pais_idioma VALUES (8, 6);
-- México, Argentina, Espanha (Espanhol)
INSERT INTO pais_idioma VALUES (11, 3), (13, 3), (15, 3);
-- Rússia (Russo)
INSERT INTO pais_idioma VALUES (14, 9);

# LIMPA OS REGISTROS DA TABELA DDI
TRUNCATE TABLE DDI;

# VISUALIZAÇÃO TABELA COM PONTUAÇÃO EM POPULAÇÃO, ÁREA E PIB (USD)
SELECT 
    p.nome AS País,
    p.capital AS Capital,
    c.nome AS Continente,
    m.nome AS Moeda,
    GROUP_CONCAT(i.nome SEPARATOR ', ') AS Idiomas,
    d.codigo AS DDI,
    CONCAT(FORMAT(p.populacao, 0)) AS População,
    CONCAT(FORMAT(p.area, 2), ' km²') AS Área,
    CONCAT('USD ', FORMAT(p.pib, 2)) AS PIB
FROM pais p
LEFT JOIN continente c ON p.id_continente = c.id_continente
LEFT JOIN moeda m ON p.id_moeda = m.id_moeda
LEFT JOIN ddi d ON p.id_ddi = d.id_ddi
LEFT JOIN pais_idioma pi ON p.id_pais = pi.id_pais
LEFT JOIN idioma i ON pi.id_idioma = i.id_idioma
GROUP BY 
    p.id_pais, p.nome, p.capital, c.nome, m.nome, d.codigo, 
    p.populacao, p.area, p.pib
ORDER BY p.nome;
  
# UNION ENTRE A TABELA MOEDA E A TABELA IDIOMA
SELECT nome AS nome_unificado, 'Idioma' AS tipo
FROM idioma
UNION
SELECT nome AS nome_unificado, 'Moeda' AS tipo
FROM moeda;

# CRIAÇÃO DE VIEW COM PONTUAÇÃO FORMATADA
CREATE VIEW vw_paises_detalhado_formatado AS
SELECT 
    p.nome AS Pais,
    p.capital AS Capital,
    c.nome AS Continente,
    m.nome AS Moeda,
    GROUP_CONCAT(i.nome ORDER BY i.nome SEPARATOR ', ') AS Idiomas,
    d.codigo AS DDI,
    CONCAT(FORMAT(p.populacao, 0), '') AS População,
    CONCAT(FORMAT(p.area, 2), ' km²') AS Área,
    CONCAT('USD ', FORMAT(p.pib, 2)) AS PIB
FROM pais p
LEFT JOIN continente c ON p.id_continente = c.id_continente
LEFT JOIN moeda m ON p.id_moeda = m.id_moeda
LEFT JOIN ddi d ON p.id_ddi = d.id_ddi
LEFT JOIN pais_idioma pi ON p.id_pais = pi.id_pais
LEFT JOIN idioma i ON pi.id_idioma = i.id_idioma
GROUP BY 
    p.id_pais, p.nome, p.capital, c.nome, m.nome, d.codigo, 
    p.populacao, p.area, p.pib;
