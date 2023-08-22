--اكتر منتج مبيعا اخر 3 شهور
--XXX
SELECT sod.SalesOrderID ,sod.OrderQty,sod.ProductID
FROM Sales.SalesOrderDetail sod JOIN
Sales.SalesOrderHeader soh
on soh.SalesOrderID = sod.SalesOrderID
order by sod.ProductID 
--GROUP BY 

SELECT sod.ProductID ,PP.Name 'PRODUCT NAME ',sum(sod.OrderQty)'order quntity'
FROM Sales.SalesOrderDetail sod JOIN
Sales.SalesOrderHeader soh
on soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SpecialOfferProduct sop
ON sop.ProductID = sod.ProductID
JOIN Production.Product PP
ON PP.ProductID =sop.ProductID
GROUP BY sod.ProductID ,PP.Name
order by sod.ProductID desc

------------------------------------------------------------------
--عدد العروض على كل منتج

SELECT p.ProductID, p.Name ProductName ,count( so.SpecialOfferID)  QtyOffers
FROM Sales.SpecialOffer so
JOIN Sales.SpecialOfferProduct sop
on so.SpecialOfferID = sop.SpecialOfferID
JOIN Production.Product p
ON p.ProductID = sop.ProductID
where so.Description!='No Discount'
GROUP BY p.ProductID,p.Name
ORDER BY p.ProductID,p.Name ,QtyOffers

-----------------------------------------------------------------------------
--XX
--كام عميل جديد في اخر سنة
select count(Distinct soh.CustomerID) NumberOfCustomers
from sales.SalesOrderHeader soh 
where YEAR(OrderDate)= 2014


-----------------------------
-- اكتر مندوب تحقيقا للمبيعات

SELECT soh.SalesPersonID,CONCAT(p.FirstName,' ',p.MiddleName,' ' ,p.LastName)'FULL NAME' ,sum(soh.TotalDue) TotalDue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp
ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e
ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person P
ON e.BusinessEntityID =P.BusinessEntityID
where SalesPersonID is not NULL
GROUP BY SOH.SalesPersonID  ,p.FirstName,p.MiddleName,p.LastName
ORDER BY TotalDue DESC ,soh.SalesPersonID

--------------------------------------------------------------------
-- اكتر الدول مبيعا

SELECT soh.TerritoryID,st.Name,sum(soh.TotalDue) TotalDue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
GROUP BY soh.TerritoryID,st.Name  
ORDER BY TotalDue desc

-----------------------------------------
-- اكتر فئة منتجات مطلوبة 
 ----XXX

SELECT pc.Name  ProductCategory  ,sum(soh.TotalDue) TotalDue
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SpecialOfferProduct sop
ON sop.SpecialOfferID = sod.SpecialOfferID 
JOIN Production.Product P
on sop.ProductID = P.ProductID
JOIN Production.ProductSubcategory psc
ON psc.ProductCategoryID =p.ProductSubcategoryID
JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = psc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalDue DESC

------------------------------------------------------

--كم عدد الموظفين المعينين خلال اخر عام

select  COUNT(e.HireDate)
from HumanResources.Employee e
where YEAR(HireDate)= 2013

-------------------------------------------------------
--اكثر وسيلة شحن مستخدمةxx

select sm.Name, COUNT(  soh.ShipMethodID )
from Sales.SalesOrderHeader soh
JOIN Purchasing.ShipMethod sm
ON soh.ShipMethodID = sm.ShipMethodID
GROUP BY sm.Name
ORDER BY COUNT(  soh.ShipMethodID ) DESC
-----------------------------------------------------
--- متوسط مرتبات الموظفين خلال اخر عام 

SELECT e.BusinessEntityID,AVG( eph.Rate * eph.PayFrequency) salary
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph
ON e.BusinessEntityID = eph.BusinessEntityID
where YEAR(HireDate)= 2013
GROUP BY e.BusinessEntityID
ORDER BY salary DESC


--XXX   what differnce betwenn quota in (salesperson.sqlesquota) and (sales.salespersonquotahistory)

--------------------------------------------------------------
-- عدد الاوردرات في اخر شهر

select count(soh.SalesOrderID) NumberOfOrders
from sales.SalesOrderHeader soh 
where Month(OrderDate) =7 
--------- ???? --------------
-- between ( getdate() and getdate()-30 day)
-----------------------------------------------------------
--اعلى سنة تحقيقا للمبيعات


select YEAR(OrderDate),SUM(TotalDue)
from sales.SalesOrderHeader soh 
group by YEAR(OrderDate)
order by SUM(TotalDue) DESC


-----------------------------------------------------------
--عدد العملاء مع كل موظف

SELECT soh.SalesPersonID, COUNT(soh.CustomerID)
FROM Sales.SalesOrderHeader soh
WHERE soh.SalesPersonID is not null
group by SalesPersonID
order by SalesPersonID

------------------------------------------------------------------
-- اقل موظف حصولا على الاجازات 

SELECT e.BusinessEntityID , (e.SickLeaveHours+e.VacationHours) offdays
FROM HumanResources.Employee e
order by offdays ASC
---------- why does IT CORRECT ? 
select top(1) sp.BusinessEntityID, e.VacationHours+e.SickLeaveHours
from sales.SalesPerson sp join HumanResources.Employee e
on sp.BusinessEntityID=e.BusinessEntityID
order by (e.VacationHours+e.SickLeaveHours) 
--------
--------------------------------------------------------------------
--هل يوجد علاقة مابين النوع والمبيعاتxx


select DISTINCT sod.ProductID,p.name ProductName,psc.Name ProductSubcategoryName,pc.Name ProductCategoryName,SUM(sod.OrderQty) TotalQuantity,COUNT(soh.TotalDue) TotalSales
from sales.SalesOrderDetail sod join sales.SpecialOfferProduct sop
on sod.ProductID=sop.ProductID
join Production.Product p
on sop.ProductID=p.ProductID
join Production.ProductSubcategory psc
on p.ProductSubcategoryID=psc.ProductSubcategoryID
join Production.ProductCategory pc
on psc.ProductCategoryID=pc.ProductCategoryID
join sales.SalesOrderHeader soh
on sod.SalesOrderID=soh.SalesOrderID
group by sod.ProductID,p.name ,psc.Name ,pc.Name 
order by TotalQuantity desc,TotalSales desc

--------------------------------------------------------------------
--افضل وسيلة شحن لكل مقاطعةxx

select sm.Name ShipMethodName,st.Name TerritoryName,count(*) NumberofShipments
from sales.SalesOrderHeader soh join sales.SalesTerritory st
on soh.TerritoryID=st.TerritoryID
join Purchasing.ShipMethod sm
on soh.ShipMethodID=sm.ShipMethodID
group by sm.ShipMethodID,sm.Name,st.name
order By count(*) desc


------------------------------------------------------------------
--عدد الموظفين المتخارجين من الشركة كل سنة

select YEAR(edh.EndDate) Year,COUNT(edh.BusinessEntityID) NumberOfCompanyLeavers
from HumanResources.EmployeeDepartmentHistory edh
where EndDate is not NULL
group by YEAR(edh.EndDate)

------------------------------------------------------------------
--نسبة الضرائب للمبيعات
select Soh.SalesOrderID,str.SalesTaxRateID,str.TaxType,soh.TaxAmt,TaxRate
from sales.SalesOrderHeader soh join sales.SalesTerritory st
on soh.TerritoryID=st.TerritoryID
join person.StateProvince psp
on st.TerritoryID=psp.TerritoryID
join sales.SalesTaxRate str
on psp.StateProvinceID=str.StateProvinceID
------------------------------------------------------------------
--المقارنة مابين المبيعات  والمشتريات لكل منتج
-------------------------------------------------------
---XXX







