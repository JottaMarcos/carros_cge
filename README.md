# 🚗 Frota Oficial CGE/RJ — Análise de Reservas de Veículos

> Dashboard interativo de análise operacional da frota da **Controladoria Geral do Estado do Rio de Janeiro**, com base em dados públicos do sistema SISLOG (Jul/2023 – Jul/2025).

[![Dashboard ao vivo](https://img.shields.io/badge/Dashboard-Ao%20Vivo-orange?style=for-the-badge&logo=github)](https://jottamarcos.github.io/carros_cge/)
[![Dados Públicos](https://img.shields.io/badge/Fonte-Dados%20P%C3%BAblicos-blue?style=for-the-badge)](https://jottamarcos.github.io/carros_cge/)
![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge)

---

## 📌 Sobre o Projeto

Este projeto analisa **512 registros de reservas de veículos oficiais** da CGE/RJ extraídos do sistema SISLOG, cobrindo um período de dois anos (julho de 2023 a julho de 2025). O objetivo é identificar padrões operacionais, gargalos de gestão e oportunidades de eficiência na utilização da frota pública.

O dataset original foi tratado via SQL, e os resultados foram publicados em um **dashboard HTML interativo** com múltiplas abas analíticas, hospedado via GitHub Pages.

---

## 🔍 Principais Insights

| Métrica | Valor |
|---|---|
| Total de reservas analisadas | **512** |
| Taxa de conclusão das viagens | **98,2%** |
| Veículos na frota | **4** (2 Fiat Mobi · 2 Renault Logan) |
| Usuários únicos (servidores) | **71** |
| Viagens com retorno organizado | **60%** |
| Destino mais frequente | Av. Presidente Vargas, 670 — **27,3% do total** |

### ⚠️ Gargalos Identificados

- **Concentração de destino (89%)** — Os 5 principais destinos concentram 45% de todas as viagens, sugerindo potencial para consolidação de corridas.
- **Uso desproporcional por usuário** — Um único servidor realizou 69 reservas (13,5% de todo o volume da frota no período).
- **Fiat Mobi subutilizado** — O veículo RUF8J42 registrou 3,4x menos reservas que o RUF8J43 no mesmo período de operação.
- **40% de viagens sem retorno** — 202 corridas foram somente de ida, sinalizando possível falta de planejamento operacional.

---

## 📊 Dashboard

O dashboard é dividido em **4 abas analíticas**:

- **Visão Geral** — KPIs principais, reservas por mês, prioridade das reservas, top usuários e horários de pico
- **Frota** — Composição da frota, uso por veículo, substituição Mobi → Logan, top setores e tipos de serviço
- **Operações** — Principais destinos, mapa de concentração de viagens
- **Gargalos & Insights** — Análise crítica com 4 gargalos identificados e 5 recomendações acionáveis

🔗 **[Acesse o dashboard ao vivo](https://jottamarcos.github.io/carros_cge/)**

---

## 🗂️ Estrutura do Repositório

```
carros_cge/
│
├── carros-sislog.csv          # Dataset original extraído do SISLOG (dados brutos)
├── reservas_clean.csv         # Dataset tratado e pronto para análise
├── tratamento_carros_cge.sql  # Script SQL completo de limpeza e transformação
├── View_sql.png               # Print da view criada no banco — demonstração do resultado
└── index.html                 # Dashboard interativo (HTML/CSS/JS puro)
```

---

## 🛠️ Tecnologias Utilizadas

| Ferramenta | Uso |
|---|---|
| **SQL / PostgreSQL** | Limpeza, tratamento e transformação dos dados |
| **HTML + CSS + JavaScript** | Desenvolvimento do dashboard interativo |
| **Chart.js** | Visualizações e gráficos |
| **GitHub Pages** | Hospedagem do dashboard |

---

## ⚙️ Processo de Análise

```
[SISLOG]  →  carros-sislog.csv  →  tratamento_carros_cge.sql  →  reservas_clean.csv  →  index.html
  Fonte        Dataset bruto         Limpeza via SQL               Dataset limpo          Dashboard
```

O script SQL realizou as seguintes transformações:
- Padronização de campos de texto (destinos, descrições de viagem)
- Remoção de duplicatas e registros inconsistentes
- Criação de colunas derivadas (duração, tipo de viagem, período do dia)
- Agregações para alimentar as visualizações do dashboard

---

## 💡 Recomendações Geradas pela Análise

1. **Consolidar viagens para destinos recorrentes** — criar escalas compartilhadas para a Av. Presidente Vargas, 670
2. **Investigar desequilíbrio de uso entre os Fiat Mobi** — verificar causas mecânicas ou operacionais
3. **Registrar o motorista individualmente por viagem** — o campo atual contém lista fixa, impedindo análise de carga
4. **Avaliar pico de demanda matutino (09h–10h)** — risco de conflito de agendamentos com apenas 4 veículos
5. **Padronizar descrições de viagem** — implementar categorias fixas no sistema de reserva

---

## 📁 Fonte dos Dados

Os dados são **públicos**, originados do sistema **SISLOG** da Controladoria Geral do Estado do Rio de Janeiro (CGE/RJ). O período coberto vai de **julho de 2023 a julho de 2025**, totalizando 512 registros de reservas de veículos oficiais.

---

## 👤 Autor

**João Marcos** — Analista de Dados | JM Analytics

[![Portfolio](https://img.shields.io/badge/Portfolio-jottamarcos.github.io-orange?style=flat&logo=github)](https://jottamarcos.github.io/portfolio)
[![GitHub](https://img.shields.io/badge/GitHub-JottaMarcos-black?style=flat&logo=github)](https://github.com/JottaMarcos)

---

*Projeto desenvolvido com dados públicos para fins analíticos e de portfólio.*

[![Banco de Dados](https://dados.gov.br/dados/conjuntos-dados/reserva-de-carros)]
