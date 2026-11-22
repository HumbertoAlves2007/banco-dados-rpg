# Banco de dados — Jogo de RPG online

Script SQL (SQL Server) que cria o banco de dados e as tabelas de um jogo de RPG online, seguindo o diagrama entidade-relacionamento do projeto.

**Autor:** Humberto

## Arquivos

| Arquivo | Descrição |
|---|---|
| `script_jogo_rpg.sql` | Cria o banco `RPGOnlineDB` e as 5 tabelas, com chaves primárias, chaves estrangeiras e restrições. Inclui consultas de conferência. |

## Modelo de dados

| Tabela | Campos | Chaves |
|---|---|---|
| `Usuarios` | `UsuarioId`, `Email`, `Senha` | PK: `UsuarioId` · `Email` único |
| `Classes` | `ClasseId`, `Nome`, `Descricao` | PK: `ClasseId` · `Nome` único |
| `Habilidades` | `HabilidadeId`, `Nome` | PK: `HabilidadeId` · `Nome` único |
| `Personagens` | `PersonagemId`, `NomePersonagem`, `UsuarioId`, `ClasseId` | PK: `PersonagemId` · FK: `UsuarioId` → `Usuarios`, `ClasseId` → `Classes` |
| `Classes_Habilidades` | `ClasseId`, `HabilidadeId` | PK composta (`ClasseId`, `HabilidadeId`) · FK: `ClasseId` → `Classes`, `HabilidadeId` → `Habilidades` |

### Relacionamentos

- `Usuarios` **1:N** `Personagens` — um usuário possui vários personagens.
- `Classes` **1:N** `Personagens` — uma classe agrupa vários personagens.
- `Classes` **N:N** `Habilidades` — resolvido pela tabela associativa `Classes_Habilidades`.

### Decisões de projeto

- `IDENTITY(1,1)` nas chaves primárias simples: o próprio banco gera os identificadores.
- `Email`, `Classes.Nome` e `Habilidades.Nome` são `UNIQUE` para evitar duplicidade.
- `Personagens.UsuarioId` e `Personagens.ClasseId` são `NOT NULL`: todo personagem pertence a um usuário e tem uma classe.
- `Senha` tem 255 caracteres para comportar o **hash** da senha; a senha em texto puro nunca deve ser armazenada.
- As tabelas são criadas das menos dependentes (sem chave estrangeira) para as mais dependentes.

## Como executar

1. Abra o **SQL Server Management Studio (SSMS)** e conecte-se ao servidor.
2. Abra o arquivo `script_jogo_rpg.sql` (menu *Arquivo → Abrir*).
3. Clique em **Executar** (ou tecle `F5`) para rodar o script inteiro.
4. Confira o resultado nas duas consultas do final do script (colunas e relacionamentos) e compare com o diagrama.

Para recriar tudo do zero, descomente o bloco **REINICIAR** no final do arquivo e execute-o antes de rodar o script novamente.
