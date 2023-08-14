-- First Assignment 
SELECT p.FirstName, p.MiddleName , p.LastName 
,pp.PhoneNumber,st.Name
FROM Sales.SalesOrderHeader soh
JOIN  Sales.SalesPerson  sp
ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e 
on sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p
ON p.BusinessEntityID = e.BusinessEntityID
JOIN Person.PersonPhone pp
ON pp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesTerritory st
ON sp.TerritoryID =st.TerritoryID


--  Second Assignment 
SELECT sm.Name
FROM Sales.SalesOrderHeader soh
JOIN Purchasing.ShipMethod sm
ON soh.ShipMethodID = sm.ShipMethodID

-- Third Assignment 
SELECT p.Name , so.Type
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SpecialOfferProduct sop
ON sop.SpecialOfferID =sod.SalesOrderDetailID
JOIN Production.Product p 
ON p.ProductID = sop.ProductID
JOIN Sales.SpecialOffer so
ON so.SpecialOfferID = sop.SpecialOfferID







