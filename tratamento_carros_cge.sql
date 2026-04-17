-- ============================================================
-- PROJETO: Sistema de Reserva de Veículos - CGE/RJ
-- AUTOR: [Seu Nome]
-- DATA: 2024
-- DESCRIÇÃO: Script de limpeza e tratamento da tabela reservas_raw
-- FONTE: Dataset público do sistema SISLOG - CGE/RJ
-- ============================================================


-- ============================================================
-- BLOCO 0 — VISÃO GERAL DOS DADOS BRUTOS (rode antes de tudo)
-- Registre os resultados como "antes da limpeza" no portfólio
-- ============================================================

-- Total de registros
SELECT COUNT(*) AS total_registros FROM reservas_raw;

-- Nulos por coluna
SELECT
    COUNT(*) FILTER (WHERE setor IS NULL)            AS nulos_setor,
    COUNT(*) FILTER (WHERE usuario_cargo IS NULL)    AS nulos_usuario_cargo,
    COUNT(*) FILTER (WHERE "supervisor.cargo" IS NULL) AS nulos_supervisor_cargo,
    COUNT(*) FILTER (WHERE "supervisor.email" IS NULL) AS nulos_supervisor_email,
    COUNT(*) FILTER (WHERE supervisor_name IS NULL)  AS nulos_supervisor_name,
    COUNT(*) FILTER (WHERE sectors_name IS NULL)     AS nulos_sectors_name
FROM reservas_raw;

-- Distribuição de status
SELECT status, COUNT(*) FROM reservas_raw GROUP BY status;

-- Distribuição de prioridade
SELECT prioridade, COUNT(*) FROM reservas_raw GROUP BY prioridade;

-- Frota de veículos
SELECT placa, carro_modelo, carro_cor, COUNT(*) AS reservas
FROM reservas_raw
GROUP BY placa, carro_modelo, carro_cor
ORDER BY placa;


-- ============================================================
-- BLOCO 1 — CRIAÇÃO DA TABELA LIMPA
-- Criamos uma tabela nova para preservar os dados originais.
-- A tabela reservas_raw nunca será alterada.
-- ============================================================

DROP TABLE IF EXISTS reservas_clean;

CREATE TABLE reservas_clean (
    id_reserva          TEXT,
    date                DATE,
    timestart           TIMESTAMP,
    timeend             TIMESTAMP,
    usuario_username    TEXT,
    usuario_name        TEXT,
    usuario_email       TEXT,
    usuario_cargo       TEXT,
    setor               TEXT,
    sectors_name        TEXT,
    sectors_sigla       TEXT,
    carro_modelo        TEXT,
    carro_cor           TEXT,
    placa               TEXT,
    motorista_telefone  TEXT,
    descricao           TEXT,
    idavolta            BOOLEAN,
    tem_supervisor      BOOLEAN,
    supervisor_name     TEXT,
    supervisor_cargo    TEXT,
    supervisor_email    TEXT,
    status              TEXT,
    prioridade          TEXT,
    endereco_ida        TEXT,
    endereco_fim_ida    TEXT,
    endereco_inicio_volta TEXT,
    endereco_fim_volta  TEXT,
    inicio_ida_cep      TEXT,
    fim_ida_cep         TEXT,
    inicio_volta_cep    TEXT,
    fim_volta_cep       TEXT
);


-- ============================================================
-- BLOCO 2 — INSERÇÃO COM TODOS OS TRATAMENTOS
-- ============================================================

INSERT INTO reservas_clean
SELECT

    -- ID da reserva (chave única, sem alteração)
    id_reserva,

    -- DATAS
    -- Convertendo de TEXT para DATE e TIMESTAMP corretamente
    TO_DATE(date, 'DD/MM/YYYY HH24:MI')                    AS date,
    TO_TIMESTAMP(timestart, 'DD/MM/YYYY HH24:MI')          AS timestart,
    TO_TIMESTAMP(timeend, 'DD/MM/YYYY HH24:MI')            AS timeend,

    -- USUÁRIO
    -- Removendo o ponto do nome original da coluna (usuario.username)
    "usuario.username"                                      AS usuario_username,
    usuario_name,
    "usuario.email"                                         AS usuario_email,
    usuario_cargo,

    -- SETOR
    -- Nulos mantidos como NULL (informação não registrada no sistema)
    setor,
    sectors_name,
    sectors_sigla,

    -- VEÍCULO
    carro_modelo,
    carro_cor,
    placa,
    motorista_telefone,

    -- DESCRIÇÃO DA VIAGEM
    -- Alguns registros não possuem descrição — mantidos como NULL
    "descrição"                                             AS descricao,

    -- IDA E VOLTA
    -- Convertendo de texto VERDADEIRO/FALSO para booleano real
    CASE WHEN idavolta = 'VERDADEIRO' THEN TRUE ELSE FALSE END AS idavolta,

    -- SUPERVISOR
    -- Criando flag booleana: TRUE se tinha supervisor, FALSE se não tinha
    -- ~50% dos registros não possuem supervisor associado
    CASE WHEN supervisor_name IS NOT NULL THEN TRUE ELSE FALSE END AS tem_supervisor,

    -- Nulos de supervisor mantidos como NULL (viagens sem supervisor registrado)
    supervisor_name,
    "supervisor.cargo"                                      AS supervisor_cargo,
    "supervisor.email"                                      AS supervisor_email,

    -- STATUS E PRIORIDADE
    status,
    prioridade,

    -- ENDEREÇOS IDA
    -- Limpando artefato de exportação: removendo ' - nan, nan' do texto
    REGEXP_REPLACE("Endereco_Ida", '\s*-\s*nan,\s*nan', '', 'g')         AS endereco_ida,
    REGEXP_REPLACE("Endereco_Fim_Ida", '\s*-\s*nan,\s*nan', '', 'g')     AS endereco_fim_ida,

    -- ENDEREÇOS VOLTA
    -- Quando idavolta = FALSO, o veículo não realizou retorno do passageiro.
    -- O valor 'nan, S/N - nan, nan' é artefato de exportação, não dado real.
    -- Nesses casos, campos de volta são definidos como NULL.
    CASE
        WHEN idavolta = 'VERDADEIRO'
        THEN REGEXP_REPLACE("Endereco_Inicio_Volta", '\s*-\s*nan,\s*nan', '', 'g')
        ELSE NULL
    END AS endereco_inicio_volta,

    CASE
        WHEN idavolta = 'VERDADEIRO'
        THEN REGEXP_REPLACE("Endereco_Fim_Volta", '\s*-\s*nan,\s*nan', '', 'g')
        ELSE NULL
    END AS endereco_fim_volta,

    -- CEPs
    -- Padronizando formato: removendo hífen para deixar tudo numérico (ex: 20020-000 → 20020000)
    REGEXP_REPLACE(inicio_ida_cep, '-', '', 'g')            AS inicio_ida_cep,
    REGEXP_REPLACE(fim_ida_cep, '-', '', 'g')               AS fim_ida_cep,

    -- CEPs de volta: quando idavolta = FALSO, estão como '0' — definidos como NULL
    CASE
        WHEN idavolta = 'VERDADEIRO'
        THEN REGEXP_REPLACE(inicio_volta_cep, '-', '', 'g')
        ELSE NULL
    END AS inicio_volta_cep,

    CASE
        WHEN idavolta = 'VERDADEIRO'
        THEN REGEXP_REPLACE(fim_volta_cep, '-', '', 'g')
        ELSE NULL
    END AS fim_volta_cep

    -- COLUNA REMOVIDA: usuario_ativo
    -- 100% dos registros eram VERDADEIRO — coluna sem valor analítico

FROM reservas_raw;


-- ============================================================
-- BLOCO 3 — VALIDAÇÃO PÓS-LIMPEZA
-- Rode após o INSERT e compare com os resultados do Bloco 0
-- ============================================================

-- Total de registros (deve ser 512)
SELECT COUNT(*) AS total_registros FROM reservas_clean;

-- Verificar booleanos
SELECT idavolta, COUNT(*) FROM reservas_clean GROUP BY idavolta;
SELECT tem_supervisor, COUNT(*) FROM reservas_clean GROUP BY tem_supervisor;

-- Verificar se ainda tem 'nan' nos endereços
SELECT COUNT(*) AS enderecos_com_nan
FROM reservas_clean
WHERE endereco_ida LIKE '%nan%'
   OR endereco_fim_ida LIKE '%nan%';

-- Verificar CEPs zerados que deveriam ser NULL
SELECT COUNT(*) AS ceps_zerados
FROM reservas_clean
WHERE inicio_volta_cep = '0' OR fim_volta_cep = '0';

-- Verificar datas convertidas corretamente
SELECT MIN(date) AS data_mais_antiga, MAX(date) AS data_mais_recente FROM reservas_clean;

-- Frota final validada
SELECT placa, carro_modelo, COUNT(*) AS reservas
FROM reservas_clean
GROUP BY placa, carro_modelo
ORDER BY placa;
