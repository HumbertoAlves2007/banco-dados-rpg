/* ============================================================================
   Projeto  : Jogo de RPG online
   Arquivo  : script_jogo_rpg.sql
   SGBD     : SQL Server (T-SQL) - executar no SSMS ou no Azure Data Studio
   Autor    : Humberto
   Objetivo : Criar o banco de dados e as tabelas do diagrama do jogo de RPG,
              aplicando chaves primárias, chaves estrangeiras e restrições.

   Tabelas (5):
     Usuarios            - contas de quem joga
     Classes             - classes de personagem (ex.: Guerreiro, Mago)
     Habilidades         - habilidades que existem no jogo
     Personagens         - personagens criados pelos usuários
     Classes_Habilidades - tabela associativa que resolve a relação N:N
                           entre Classes e Habilidades

   Relacionamentos (conforme o diagrama):
     Usuarios    1:N Personagens
     Classes     1:N Personagens
     Classes     1:N Classes_Habilidades
     Habilidades 1:N Classes_Habilidades
     => Classes N:N Habilidades (resolvida por Classes_Habilidades)

   Ordem de criação: das tabelas menos dependentes (sem chave estrangeira)
   para as mais dependentes, como orientado no material do curso.

   Como executar: abra o arquivo no SSMS e clique em "Executar" (F5) para
   rodar o script inteiro. Para recriar tudo do zero, use antes o bloco
   "REINICIAR" (comentado) no final do arquivo.
   ============================================================================ */


/* ----------------------------------------------------------------------------
   1. BANCO DE DADOS
   ---------------------------------------------------------------------------- */

-- Cria o banco somente se ele ainda não existir
IF DB_ID('RPGOnlineDB') IS NULL
    CREATE DATABASE RPGOnlineDB;
GO

-- Seleciona o banco: as tabelas abaixo serão criadas dentro dele (e não no master)
USE RPGOnlineDB;
GO


/* ----------------------------------------------------------------------------
   2. TABELAS
   ---------------------------------------------------------------------------- */

-- 2.1 Usuarios (sem chave estrangeira)
CREATE TABLE Usuarios
(
    UsuarioId INT IDENTITY(1,1) NOT NULL         -- chave primária (gerada automaticamente)
    ,Email    VARCHAR(120)      NOT NULL         -- login do usuário
    ,Senha    VARCHAR(255)      NOT NULL         -- guardar o HASH da senha, nunca o texto puro

    ,CONSTRAINT PK_Usuarios       PRIMARY KEY (UsuarioId)
    ,CONSTRAINT UQ_Usuarios_Email UNIQUE (Email) -- não permite e-mails repetidos
);
GO

-- 2.2 Classes (sem chave estrangeira)
CREATE TABLE Classes
(
    ClasseId  INT IDENTITY(1,1) NOT NULL         -- chave primária
    ,Nome     VARCHAR(60)       NOT NULL
    ,Descricao VARCHAR(500)     NULL             -- opcional

    ,CONSTRAINT PK_Classes      PRIMARY KEY (ClasseId)
    ,CONSTRAINT UQ_Classes_Nome UNIQUE (Nome)    -- não permite classes com nome repetido
);
GO

-- 2.3 Habilidades (sem chave estrangeira)
CREATE TABLE Habilidades
(
    HabilidadeId INT IDENTITY(1,1) NOT NULL      -- chave primária
    ,Nome        VARCHAR(60)       NOT NULL

    ,CONSTRAINT PK_Habilidades      PRIMARY KEY (HabilidadeId)
    ,CONSTRAINT UQ_Habilidades_Nome UNIQUE (Nome)
);
GO

-- 2.4 Personagens (depende de Usuarios e Classes)
CREATE TABLE Personagens
(
    PersonagemId   INT IDENTITY(1,1) NOT NULL    -- chave primária
    ,NomePersonagem VARCHAR(60)      NOT NULL
    ,UsuarioId     INT               NOT NULL    -- chave estrangeira -> Usuarios
    ,ClasseId      INT               NOT NULL    -- chave estrangeira -> Classes

    ,CONSTRAINT PK_Personagens          PRIMARY KEY (PersonagemId)
    ,CONSTRAINT FK_Personagens_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
    ,CONSTRAINT FK_Personagens_Classes  FOREIGN KEY (ClasseId)  REFERENCES Classes(ClasseId)
);
GO

-- 2.5 Classes_Habilidades (tabela associativa: depende de Classes e Habilidades)
--     A chave primária é composta pelas duas chaves estrangeiras, o que impede
--     que a mesma habilidade seja ligada duas vezes à mesma classe.
CREATE TABLE Classes_Habilidades
(
    ClasseId      INT NOT NULL                   -- PK e FK -> Classes
    ,HabilidadeId INT NOT NULL                   -- PK e FK -> Habilidades

    ,CONSTRAINT PK_Classes_Habilidades            PRIMARY KEY (ClasseId, HabilidadeId)
    ,CONSTRAINT FK_ClassesHabilidades_Classes     FOREIGN KEY (ClasseId)      REFERENCES Classes(ClasseId)
    ,CONSTRAINT FK_ClassesHabilidades_Habilidades FOREIGN KEY (HabilidadeId)  REFERENCES Habilidades(HabilidadeId)
);
GO


/* ----------------------------------------------------------------------------
   3. CONFERÊNCIA (compare o resultado com o diagrama)
   ---------------------------------------------------------------------------- */

-- 3.1 Tabelas e colunas criadas (tipo, tamanho e se aceita nulo)
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

-- 3.2 Relacionamentos (chaves estrangeiras): tabela filha -> tabela pai
SELECT fk.name                              AS NomeChaveEstrangeira
      ,OBJECT_NAME(fk.parent_object_id)     AS TabelaFilha
      ,OBJECT_NAME(fk.referenced_object_id) AS TabelaPai
FROM sys.foreign_keys AS fk
ORDER BY TabelaFilha, NomeChaveEstrangeira;
GO


/* ----------------------------------------------------------------------------
   4. REINICIAR (OPCIONAL - mantenha comentado)
      Apaga as tabelas na ordem inversa da criação (primeiro as que têm chave
      estrangeira) e depois o banco. CUIDADO: apaga todos os dados.
   ----------------------------------------------------------------------------

USE RPGOnlineDB;
GO
DROP TABLE Classes_Habilidades;
DROP TABLE Personagens;
DROP TABLE Habilidades;
DROP TABLE Classes;
DROP TABLE Usuarios;
GO
USE master;
GO
DROP DATABASE RPGOnlineDB;
GO
*/
