-- order by col-name DESCending 
SELECT * FROM Person.CountryRegion
order by Name DESC;

-- order by col-name ASCending 
SELECT * FROM Person.CountryRegion
order by Name ASC;

-- Sort a result set by an expression 
SELECT * FROM Production.ProductReview;

-- Order by len of words 
SELECT ProductID,
		ReviewerName, 
		Rating,
		Comments 
FROM Production.ProductReview
ORDER BY len(comments) DESC;

-- Retrieve the first 10% of the result set 
-- SQL Server Rounds to the next round number 

SELECT  top 10 percent 
		TransactionID,
		ProductID,
		TransactionDate,
		TransactionType
FROM Production.TransactionHistory;

-- Retrieve distinct values 
-- distinct filters all duplicate values 
SELECT distinct CardType FROM Sales.CreditCard;

-- Return Values Based On Condition 
-- Display the output in a more understandable way (1-Poor, 2-Fair, 3-Good, 4-Very Good, 5-Excellent)
SELECT  ProductID,
		ReviewerName,
		CASE Rating
			WHEN 1 THEN 'Poor'
			WHEN 2 THEN 'Fair'
			WHEN 3 THEN 'Good'
			WHEN 4 THEN 'Very Good'
			WHEN 5 THEN 'Excellent'
		END AS Rating
		FROM Production.ProductReview;

-- Replace NULL values with specific values 
/* In the output displayed instead of NULL values need to have value 0 for 'ProductAssemblyID' column 
"without changing any values" in the table */ 

SELECT  BillOfMaterialsID,
		ISNULL(ProductAssemblyID,0) AS ProductAssemblyID,
		StartDate
FROM Production.BillOfMaterials;

-- Replacing the table or column name temporarily 
-- Name columns (ProductModelID, ProductDescriptionID) and table name with an Alias 

SELECT  ProductModelID AS ID,
		ProductDescriptionID AS DescID
FROM Production.ProductModelProductDescriptionCulture AS A;

-- Filtering out information 
-- Filter rows that have the name 'Archive' from the displays 
SELECT * FROM Person.AddressType
WHERE NOT NAME = 'Archive';

-- Filtering on more than one condition 
-- Find all the Purchase Orders for the ProductId = 512 that cost less than $35 Unit Price 
SELECT * FROM Purchasing.PurchaseOrderDetail
WHERE ProductID = 512 AND UnitPrice < 35;

-- Searching within a range of values 
SELECT  Name,
		ProductNumber,
		ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 10 AND 20;
 
-- Filtering out data by comparing values 
-- Find records for Products with ProductID = 995
-- Find records for Products with ProductID = 995 that have more than 500 Orders
-- Find records for Products with ProductID = 995 that have more than 500 Orders
--	and received before May 3, 2013
SELECT * FROM Production.WorkOrder
WHERE ProductID = 995 AND OrderQty > 500 AND StartDate < '2013-05-03';


-- Finding rows based on a list of values 
-- Find the name of Products that have these 3 ListPrice values: 106.5 1003.91 333.42
SELECT  Name,
		ListPrice
FROM Production.Product
WHERE ListPrice IN (106.5, 1003.91, 333.42);

-- Finding rows having a specific string 
SELECT * FROM PERSON.CountryRegion
WHERE NAME LIKE 'V%';

-- Filtering rows having no data in the column
SELECT * FROM Production.WorkOrder
WHERE ScrapReasonID IS NOT NULL;

-- Filtering rows based on some values in a sub-query
SELECT ProductID FROM Production.WorkOrder
WHERE OrderQty > 20000;    -- Query 1

SELECT  ProductID, 
		Name 
FROM Production.Product
WHERE ProductID = ANY(SELECT ProductID FROM Production.WorkOrder
						WHERE OrderQty > 20000);  -- Query 2

-- Return values by converting them into Upper or Lower case 
SELECT UPPER(Name) AS Name, 
		LOWER(ProductNumber) AS ProductNumber
FROM Production.Product;

-- Return values by extracting specific characters
SELECT  NAME, 
		LEFT(ProductNumber, 2) as ProductNumber  
FROM Production.Product;

SELECT  NAME, 
		RIGHT(ProductNumber, 4) as ProductNumber  
FROM Production.Product;

-- Select records that have matching values in two tables

SELECT  WorkOrderID,
		ProductID
FROM Production.WorkOrder 

SELECT  ProductID, 
		Name 
FROM Production.Product

SELECT A.WorkOrderID, A.ProductID, B.Name FROM Production.WorkOrder AS A
INNER JOIN Production.Product AS B
ON A.ProductID = B.ProductID; 

-- Select all records from first table and only the matching records form the second table
-- You want to find the Sales Orders for all ProductID's along with the ProductID and Name

SELECT ProductID, Name FROM Production.Product;
SELECT ProductID, SalesOrderID FROM Sales.SalesOrderDetail;

SELECT A.ProductID, A.Name, B.SalesOrderID FROM Production.Product as A
LEFT JOIN Sales.SalesOrderDetail AS B
ON A.ProductID = B.ProductID;
 
-- Select all records from the second table and only the matching records from the first table
SELECT ProductID, Name FROM Production.Product;
SELECT ProductID, Comments  FROM Production.ProductReview; 

SELECT B.ProductID, B.Comments, A.Name FROM Production.Product as A
RIGHT JOIN Production.ProductReview as B
ON A.ProductID = B.ProductID;

-- Select all records from two tables when there is a match between them or not
-- You want to find the Sub-Category name which each Product belongs and also find if any sub-category name is not assigned to a Product name

SELECT ProductID, Name, ProductSubcategoryID FROM Production.Product;
SELECT *  FROM Production.ProductSubcategory;

SELECT A.ProductID, A.Name , A.ProductSubcategoryID, B.Name FROM Production.Product as A
FULL JOIN Production.ProductSubcategory as B -- returns all selected values
ON A.ProductSubcategoryID = B.ProductSubcategoryID;

-- Return the number of items found in a result set
SELECT DISTINCT count(ProductNumber) FROM Production.Product

-- Compute the Total amount
SELECT SalesOrderID, ProductID, LineTotal, ModifiedDate FROM Sales.SalesOrderDetail
WHERE ProductID = 777 AND ModifiedDate BETWEEN '2011-01-01' AND '2011-12-01';

SELECT SUM(LineTotal) FROM Sales.SalesOrderDetail
WHERE ProductID = 777 AND ModifiedDate BETWEEN '2011-01-01' AND '2011-12-31';

--Compute the Average
-- Average Price on which the Product 777 got sold in 2011
SELECT AVG(LineTotal) FROM Sales.SalesOrderDetail
WHERE ProductID = 777 AND ModifiedDate BETWEEN '2011-01-01' AND '2011-12-31';


-- Calculate lowest values
-- Find the lowest quantity in stock for the ProductID 944
SELECT MIN(Quantity) FROM Production.ProductInventory
WHERE ProductID = 944

-- Compute the Largest Value
-- Find the Largest Quantity in stock for the ProductID 747
SELECT MAX(Quantity) FROM Production.ProductInventory
WHERE ProductID = 747

-- Combine values from two columns into one column
SELECT StateProvinceID, CONCAT(StateProvinceCode, '-', Name) AS State FROM Person.StateProvince

-- Create a calculated Field
SELECT  ProductID,
		UnitPrice,
		OrderQty,
		LineTotal,
		RejectedQty,
		(UnitPrice * RejectedQty) AS LossAmount
		FROM Purchasing.PurchaseOrderDetail

-- Arrange Rows in Groups
SELECT ProductID, MIN(Quantity) FROM Production.ProductInventory
GROUP BY ProductID

-- Filter Groups Based on Condition
SELECT  ProductID, 
		MIN(Quantity) AS MinQuantity,
		count(LocationID) as Locations 
FROM Production.ProductInventory
GROUP BY ProductID
HAVING count(LocationID) < 3