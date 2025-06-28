/****************************************
 Autor: Matheus Nunes Rossi

 Hands On: Plano de Execução
*****************************************/
USE TESTES
go

/*******************
 Plano de Execução
********************/
-- Texto
SET STATISTICS IO ON
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS TIME OFF

SET STATISTICS PROFILE ON
SET STATISTICS PROFILE OFF

-- XML
SET STATISTICS XML ON
SET STATISTICS XML OFF


/*******************
 Plano Estimado
********************/
-- Texto
SET SHOWPLAN_ALL ON 
SET SHOWPLAN_ALL OFF

-- XML
SET SHOWPLAN_XML ON
SET SHOWPLAN_XML ON


/**************************
 Plano de Execução
***************************/
-- Texto
SET STATISTICS IO ON
SET STATISTICS IO OFF

SET STATISTICS TIME ON
SET STATISTICS TIME OFF

SET STATISTICS PROFILE ON
SET STATISTICS PROFILE OFF

-- XML
SET STATISTICS XML ON
SET STATISTICS XML OFF

SELECT 
    h.SalesOrderID,
    h.OrderDate,
    h.[Status],
    h.CustomerID,
    p.FirstName,
    p.LastName
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.Customer AS c
    ON h.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
WHERE h.OrderDate = '2011-05-31';

-- Table 'Person'. Scan count 0, logical reads 183
-- Table 'Customer'. Scan count 0, logical reads 126
-- Table 'SalesOrderHeader'. Scan count 1, logical reads 689
-- Total IO: 998 x 8Kb = 7984 Kb = 7,79 MB


/**************************
 Plano Estimado
***************************/
-- Texto
SET SHOWPLAN_ALL ON 
SET SHOWPLAN_ALL OFF

-- XML
SET SHOWPLAN_XML ON
SET SHOWPLAN_XML ON

SET STATISTICS XML ON
SET STATISTICS XML OFF

SELECT 
    h.SalesOrderID,
    h.OrderDate,
    h.[Status],
    h.CustomerID,
    p.FirstName,
    p.LastName
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.Customer AS c
    ON h.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
WHERE h.OrderDate = '2011-05-31';


