# Estrutura OneNote Personalizada

✅ **(1) A ESTRUTURA FINAL ULTRA-OTIMIZADA DO ONENOTE**
======================================================

**→ A versão final, depurada, enxuta, elegante e “sobre-humana” da arquitetura.**  
É literalmente um blueprint pronto para montar.

* * *

**📘 NOTEBOOK 1 — WORKSPACE · OPERACIONAL**
===========================================

Seu “QG” diário, onde vive tudo que você usa no trabalho.

* * *

**SESSÃO 1 — Linguagens & Sintaxe**
-----------------------------------

**Objetivo:** acesso rápido a exemplos, sintaxes e explicações.

**Páginas padrão (para cada linguagem):**

*   `[LANG] — Overview`
*   `[LANG] — Sintaxe Base`
*   `[LANG] — Exemplos`
*   `[LANG] — Snippets`
*   `[LANG] — Troubleshooting`

**Sugestão de linguagens iniciais:**

*   ABL
*   UNIX (ggrep, awk, sed etc.)
*   Regex
*   JavaScript
*   jQuery
*   CSS
*   Java
*   PowerShell / Windows CMD (se usar ocasionalmente)

* * *

**SESSÃO 2 — Infraestrutura & Unidades**
----------------------------------------

**Objetivo:** entender rapidamente o que é cada unidade e onde guardar/achar coisas.

**Páginas (uma por unidade):**

*   `[H:] — Character · Aplicações Terminal`
*   `[W:] — Web · Aplicações Web`
*   `[R:] — Relatórios · Outputs`
*   `[U:] — Fontes Restritas · Leitura`
*   `[X:] — Build · Técnicos`
*   `[Z:] — Administrativos / Não acessível`

**Dentro de cada página:**

```
1. Função
2. O que contém
3. Quando utilizar
4. Caminhos importantes
5. Riscos e erros comuns
6. Relações com outras unidades
7. Log de descobertas
```

* * *

**SESSÃO 3 — ERP: Unidades, Sistemas, Módulos & Aplicações**
------------------------------------------------------------

**Objetivo:** catálogo limpo das aplicações importantes.

### Estrutura:

**Subseções por Sistema**  
Exemplos: `SPT`, `FIN`, `LOG`, `COM`, etc.

Dentro de cada sistema:

### Padrão de página (uma por aplicação):

`[SPT-42-12] — Deploy Homologação`

Com conteúdo padrão:

```
1. Finalidade
2. Funcionamento
3. Fluxo de Uso
4. Inputs → Processamento → Outputs
5. Erros comuns
6. Relações com outras aplicações
7. Caminhos relevantes
8. Observações
```

* * *

**SESSÃO 4 — Git, GitHub & DevOps**
-----------------------------------

**Objetivo:** fluxos formais, protocolos e boas práticas.

**Páginas:**

*   `Git — Fluxo Oficial de Deploy`
*   `Git — Branching Model`
*   `Git — Comandos Essenciais`
*   `Git — Pull Requests — Checklist`
*   `DevOps — Build & Release`
*   `DevOps — Rollback Procedure`

* * *

**SESSÃO 5 — Sprints & SSIs**
-----------------------------

**Objetivo:** controle cirúrgico do que você está trabalhando.

* * *

### Subsessões:

*   `Sprint Atual (XX)`
*   `Sprints Anteriores`

### Dentro da Sprint Atual:

**Página:** `Resumo da Sprint`

**Modelo da página de SSI:**  
`[SSI-123456] — [Título Resumido]`

Conteúdo:

```
1. Contexto
2. Objetivo técnico
3. Artefatos envolvidos (APLs, unidades, DB, serviços)
4. Tarefas Kanban
5. Decisões tomadas
6. Testes necessários
7. Riscos
8. Estado (Em progresso | Teste | Aguardando | Finalizado)
9. Log diário
10. Checklist de finalização
```

* * *

**📙 NOTEBOOK 2 — KNOWLEDGE BASE · ENCICLOPÉDIA**
=================================================

Tudo que é conhecimento atemporal.

* * *

Sessões principais:
-------------------

*   Programação
    *   ABL
    *   JavaScript
    *   Java
    *   “Miscellaneous” (qualquer coisa fora das linguagens principais)
*   Arquitetura de Software
*   DevOps & CI/CD
*   UNIX / Linux
*   Banco de Dados
*   Frameworks
*   Ferramentas (VSCode, Postman, etc.)

### Modelo de página:

```
1. Conceito
2. Aplicação prática
3. Exemplos
4. Boas práticas
5. Armadilhas / Anti-patterns
6. Casos de uso reais
```

* * *

**📗 NOTEBOOK 3 — PLAYBOOK PESSOAL**
====================================

Procedimentos fixos. Suas “SOPs”.

Sessões:

*   Deploy Homologação
*   Deploy Produção
*   Criação de Branch
*   Revisão de PR
*   Debug Character
*   Debug Web
*   Rollback
*   Checklist de Qualidade

Modelo:

```
Objetivo
Quem executa
Pré-requisitos
Passo a Passo (numerado)
Validação Final
Falhas comuns e soluções
```

* * *

**📒 NOTEBOOK 4 — ARCHIVE**
===========================

Somente coisas antigas.

Sessões:

*   Sprints concluídas
*   SSIs fechadas
*   Notas antigas
*   Comandos deprecados
*   Sistemas não usados

* * *

🧬 **Padrão de Cabeçalho Universal (usar em TODAS as páginas):**
================================================================

_(Isso é o que dá o aspecto “IA”)_

```
━━━━━━━━━━━
📌 Objetivo
━━━━━━━━━━━

━━━━━━━━━━━
📎 Estrutura / Sintaxe
━━━━━━━━━━━

━━━━━━━━━━━
🧪 Exemplos
━━━━━━━━━━━

━━━━━━━━━━━
⚙️ Boas Práticas
━━━━━━━━━━━

━━━━━━━━━━━
❗ Erros Frequentes
━━━━━━━━━━━

━━━━━━━━━━━
🔗 Relações
━━━━━━━━━━━

━━━━━━━━━━━
🗒️ Observações Pessoais
━━━━━━━━━━━
```

* * *

✅ **(3) NOMENCLATURA DEFINITIVA: ÍCONES, CORES E PREFIXOS**
===========================================================

A fórmula final para parecer “não-humano”.

* * *

**A) Prefixos universais**
==========================

São fáceis de filtrar e padronizam tudo.

| Categoria | Prefixo | Exemplo |
| --- | --- | --- |
| Linguagem | `LANG:` | `LANG: ABL — Snippets` |
| Sistema ERP | `SYS:` | `SYS: SPT-42-12 — Deploy` |
| Unidade de Rede | `UNIT:` | `UNIT: H — Apps Character` |
| Sprint | `SPR:` | `SPR: 38 — Resumo` |
| SSI | `SSI:` | `SSI: 123456 — Ajuste X` |
| Procedimento | `PROC:` | `PROC: Deploy Homologação` |
| Conceitos / Teoria | `CON:` | `CON: Git — Branching` |
| Troubleshooting | `TS:` | `TS: Git — Merge Issues` |

> Todos ficam naturalmente agrupados e pesquisáveis.

* * *

**B) Esquema de cores**
=======================

Use **apenas 4 cores** (minimalismo extremo):

*   **Azul** → Conhecimento e sintaxe
*   **Verde** → Procedimentos e fluxos
*   **Amarelo** → Avisos / importantes
*   **Vermelho** → Erros / troubleshooting

Essas cores se repetem em todos os notebooks.

* * *

**C) Ícones**
=============

Padrão absoluto:

| Ícone | Uso |
| --- | --- |
| 📘 | Linguagens & sintaxe |
| ⚙️ | Comandos / Unix |
| 🧩 | Aplicações ERP |
| 🗄️ | Unidades de rede |
| 🚀 | Deploy |
| 🔧 | Git & DevOps |
| 📝 | SSIs |
| 📊 | Sprints |
| 📚 | Knowledge Base |
| 🧭 | Procedimentos |
| 🧠 | Conceitos / teoria |
| 🛑 | Erros e riscos |
| ⭐ | Prioridade alta |

Exemplo real de título aplicando prefixos + ícones:

`🧩 SYS: SPT-42-12 — Deploy Homologação`  
`⚙️ LANG: ABL — Sintaxe Base`  
`📝 SSI: 123456 — Ajuste do Processo de Venda`  
`🗄️ UNIT: H — Character Apps`  
`🚀 PROC: Deploy Produção`
