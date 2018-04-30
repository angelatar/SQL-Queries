-----1-----
SELECT [Name], [ProductNumber], [ListPrice] as [Price]
FROM [Production].[Product]

-----2-----
SELECT *
FROM [HumanResources].[Employee]
WHERE YEAR([HireDate])>=2009

-----3-----
SELECT *
FROM [Production].[Product]
WHERE [ProductLine]='S' AND [DaysToManufacture]<5 
ORDER BY [Name]

-----4-----
SELECT DISTINCT [JobTitle]
FROM [HumanResources].[Employee]

-----5-----
SELECT [SalesOrderID],COUNT([SalesOrderID]) AS Count
FROM  [Sales].[SalesOrderDetail]
GROUP BY [SalesOrderID]

-----6-----
SELECT [ProductModelID]
FROM  [Production].[Product] WHERE [ListPrice]>900
GROUP BY [ProductModelID]

-----7-----
SELECT [ProductID]
FROM [Sales].[SalesOrderDetail]
GROUP BY [ProductID]
HAVING AVG([OrderQty])>4

-----8-----
USE AdventureWorks;  
GO  
CREATE PROC [uspGetEmployeeManagersPerDepartment]
(@BusinessEntityID int)
AS
BEGIN

	DECLARE @ORGNODE hierarchyid 
	SET @ORGNODE = (SELECT [OrganizationNode]  FROM [HumanResources].[Employee] WHERE  [HumanResources].[Employee].[BusinessEntityID] = @BusinessEntityID)
	
	DECLARE @BUSENTID INT
	SET @BUSENTID = (SELECT [BusinessEntityID] FROM [HumanResources].[Employee] WHERE [OrganizationNode] = @ORGNODE.GetAncestor(1))


	(SELECT P.BusinessEntityID,
		P.FirstName AS EmployeeFirstName,
		P.LastName AS EmployeeLastName,
		E.[JobTitle] AS EmployeeJobTitle,

		(SELECT E.[Gender] FROM [HumanResources].[Employee] E  WHERE E.[BusinessEntityID] = @BUSENTID)  AS ManagerGender,
		(SELECT P.FirstName FROM [Person].[Person] P  WHERE P.[BusinessEntityID] = @BUSENTID) AS ManagerFirstName,
		(SELECT P.LastName FROM [Person].[Person] P  WHERE P.[BusinessEntityID] = @BUSENTID)  AS ManagerLastName

	FROM [Person].[Person] P
	JOIN [HumanResources].[Employee] E 
	ON P.[BusinessEntityID] = E.[BusinessEntityID]
    WHERE E.[BusinessEntityID] = @BusinessEntityID)

END