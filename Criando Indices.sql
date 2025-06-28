/***********************************
 Autor: Matheus Nunes Rossi
 
 Hands On - Criando Indices
************************************/
USE TESTES
go


/***********************
 Indice �nico
************************/
DROP TABLE IF exists dbo.Cliente
go

CREATE TABLE dbo.Cliente (
	ClienteID int not null PRIMARY KEY,
	Nome varchar(170) not null,
	CPF_CNPJ varchar(14) not null
)
go

INSERT dbo.Cliente VALUES (1,'Jose','11111111111')
INSERT dbo.Cliente VALUES (2,'Maria','22222222222')
go

INSERT dbo.Cliente VALUES (1,'Pedro','33333333333') -- Msg 2627, Level 14, State 1, Line 27 Violation of PRIMARY KEY constraint 'PK__Cliente__71ABD0A7140E1917'.

INSERT dbo.Cliente VALUES (3,'Pedro','33333333333')

SELECT * 
FROM dbo.Cliente

-- Para garantir valores �nicos na coluna Nome
CREATE UNIQUE INDEX ixu_Cliente_Nome
ON dbo.Cliente (Nome)
-- ou
ALTER TABLE dbo.Cliente 
ADD CONSTRAINT unq_Cliente_Nome UNIQUE (Nome

INSERT dbo.Cliente VALUES (4,'Pedro','33333333333') -- Msg 2601, Level 14, State 1, Line 46 Cannot insert duplicate key row in object 'dbo.Cliente' with unique index 'ixu_Cliente_Nome'.

-- Mostra os Index que tem na Tabela
exec sp_helpindex 'dbo.Cliente'


/***************************
 FILLFACTOR e PAD_INDEX
****************************/
DROP TABLE IF exists dbo.Cliente

go
CREATE TABLE dbo.Cliente (
	ClienteID int not null IDENTITY PRIMARY KEY,
	Nome varchar(1000) not null,
	CPF_CNPJ char(14) not null
)
go

DECLARE @i int = 1, @CPF char(100)
SET @CPF = ltrim(str(@i))
INSERT dbo.Cliente VALUES ('Ana Maria de Macedo Silva',@CPF)
SET @i += 1
go 1000

DROP INDEX IF exists dbo.Cliente.ix_Cliente_Nome
go

CREATE NONCLUSTERED INDEX ix_Cliente_Nome
ON dbo.Cliente (Nome)
WITH (FILLFACTOR = 50)
go

-- Mostra os Index que tem na Tabela
SELECT * 
FROM sys.indexes 
WHERE object_id = object_id('Cliente')
/*
index_id = 0 Heap
index_id = 1 Indice Clustered
index_id > 1 Demais �ndices e estat�sticas
*/

SELECT 
	object_name(object_id) as Tabela, 
	rows as QtdLinhas, 
	p.index_id,
	a.[type], 
	a.[type_desc],
	a.used_pages as Paginas
FROM sys.partitions p JOIN sys.system_internals_allocation_units a
ON p.partition_id = a.container_id
WHERE object_id = object_id('Cliente') and index_id = 2
-- FILLFACTOR padr�o 100% = 7 p�ginas
-- FILLFACTOR padr�o 50%  = 12 p�ginas

SELECT 
	a.index_type_desc, a.index_level,
	a.page_count,
	a.record_count, 
	a.avg_page_space_used_in_percent,
	a.forwarded_record_count,
	a.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.Cliente', 'U'), NULL, NULL,'DETAILED') as a
WHERE index_id >= 2

-- Fillfactor 100% -> AVG Page Space Used: 96%
-- Fillfactor 050% -> AVG Page Space Used: 48%