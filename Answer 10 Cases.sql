USE TStore

--1
SELECT	[Transaction Count] = COUNT(PurchaseID),
		s.[Name] AS StaffName,
		v.[Name] AS VendorName
FROM	PurchaseTransaction pt 
		JOIN Staff s ON pt.StaffID = s.StaffID
		JOIN Vendor v ON pt.VendorID = v.VendorID
GROUP BY s.[Name], v.[Name], Salary
HAVING	Salary BETWEEN 5000000 AND 10000000 
		AND v.[Name] LIKE '%o%'

--2
SELECT	st.SalesID,
		SalesDate,
		c.[Name] AS [CustomerName],
		c.[Address] AS [CustomerAddress]
FROM	SalesTransaction st 
		JOIN Customer c ON c.CustomerID = st.CustomerID
		JOIN DetailSalesTransaction dst ON dst.SalesID = st.SalesID
		JOIN Cloth ON Cloth.ClothID = dst.ClothID
GROUP BY st.SalesID, st.SalesDate, c.[Name], c.[Address]
HAVING	DATENAME(DD, st.SalesDate) = 15 
		AND SUM(Cloth.Price) > 150000

--3
SELECT	DATENAME(MONTH, st.SalesDate) AS [Month],
		COUNT(st.SalesID) AS [Transaction Count],
		SUM(dst.ClothQuantity) AS [Cloth Sold]
FROM	SalesTransaction st 
		JOIN DetailSalesTransaction dst ON dst.SalesID = st.SalesID
		JOIN Cloth ON Cloth.ClothID = dst.ClothID
		JOIN Staff s ON s.StaffID = st.StaffID
		JOIN Customer c ON c.CustomerID = st.CustomerID
GROUP BY DATENAME(MONTH, st.SalesDate), Cloth.ClothID, s.Gender, Cloth.Price
HAVING	s.Gender = 'Female' AND Cloth.Price > 70000

--4
SELECT	REVERSE(SUBSTRING(REVERSE(c.Brand), 1, CHARINDEX(' ',  REVERSE(c.Brand)))) AS [Brand Last Name],
		MAX(dst.ClothQuantity) AS [Maximum Cloth(s) Sold]
FROM	Cloth c
		JOIN DetailSalesTransaction dst ON dst.ClothID = c.ClothID
GROUP BY c.Brand
HAVING	SUM(dst.ClothQuantity) BETWEEN 5 AND 10

--5
SELECT	Brand AS 'ClothBrand',
		Price AS 'ClothPrice', 
		Stock
FROM	Cloth c JOIN
		(SELECT	pt.PurchaseID, 
				v.VendorID, 
				v.[Name],
				pt.StaffID,
				dpt.ClothID,
				dpt.ClothQuantity
		FROM	PurchaseTransaction pt 
				JOIN DetailPurchaseTransaction dpt ON dpt.PurchaseID = pt.PurchaseID 
				JOIN Vendor v ON v.VendorID = pt.VendorID) AS sub ON c.ClothID = sub.ClothID
GROUP BY c.Brand, c.Stock, sub.[Name], c.Price
HAVING	AVG(c.Price) BETWEEN AVG(c.Price)-35000 AND AVG(c.Price) AND sub.[Name] LIKE 'Saad%'

--6
SELECT	CONVERT(VARCHAR, SalesDate, 101) AS [Sales Date],
		c.Brand AS [ClothBrand],
		ClothQuantity AS [Quantity]
FROM	SalesTransaction st
		JOIN DetailSalesTransaction dst ON dst.SalesID = st.SalesID
		JOIN Cloth c ON c.ClothID = dst.ClothID
		JOIN (SELECT COUNT(SalesID) AS [CountSalesID], SalesID FROM SalesTransaction GROUP BY SalesID) AS sub ON sub.SalesID = st.SalesID
WHERE	ClothQuantity > sub.CountSalesID 
		AND CONVERT(VARCHAR, SalesDate, 106) LIKE '%May%'
ORDER BY ClothQuantity ASC

--7
SELECT	pt.PurchaseID,
		LOWER(s.Name) AS [Staff Name],
		'IDR' + CAST(s.Salary AS VARCHAR) AS [Staff Salary],
		CONVERT(VARCHAR, PurchaseDate, 107) AS [Purchase Date],
		SUM(ClothQuantity) AS [Total Quantity]
FROM	PurchaseTransaction pt
		JOIN Staff s ON s.StaffID = pt.StaffID
		JOIN DetailPurchaseTransaction dpt ON dpt.PurchaseID = pt.PurchaseID
		WHERE ClothQuantity > (SELECT ClothQuantity = MIN(ClothQuantity) FROM DetailPurchaseTransaction WHERE PurchaseDate LIKE '%-04-%')
GROUP BY pt.PurchaseID, s.[Name], s.Salary, PurchaseDate

--8
SELECT	SUBSTRING(v.VendorID,3,4) AS [VendorID],
		v.[Name] AS [VendorName],
		CAST(sub.ClothQuantity AS VARCHAR) + ' piece(s)' AS [Clothes Brought],
		STUFF(v.PhoneNumber,1,1,'+62') AS [VendorPhone]
FROM	Vendor v
		JOIN PurchaseTransaction pt ON pt.VendorID = v.VendorID
		JOIN DetailPurchaseTransaction dpt ON dpt.PurchaseID = pt.PurchaseID
		JOIN (SELECT s.StaffID, st.CustomerID, st.SalesID, dst.ClothID, dst.ClothQuantity FROM Staff s JOIN SalesTransaction st ON st.StaffID = s.StaffID JOIN DetailSalesTransaction dst ON dst.SalesID = st.SalesID) AS sub ON sub.StaffID = pt.StaffID
GROUP BY v.VendorID, v.[Name], sub.ClothQuantity, v.PhoneNumber
HAVING	sub.ClothQuantity > AVG(sub.ClothQuantity)
		AND sub.ClothQuantity < 100

--9
GO
CREATE VIEW StoreSalesView AS
SELECT	st.SalesID,
		c.[Name] AS [CustomerName],
		c.PhoneNumber AS [CustomerPhone],
		'IDR' + CAST(AVG(Cloth.Price) AS VARCHAR) AS [Cloth Average Price],
		CAST(dst.ClothQuantity AS VARCHAR) + ' piece(s)' AS [Sales Quality]
FROM	SalesTransaction st
		JOIN Customer c ON c.CustomerID = st.CustomerID
		JOIN DetailSalesTransaction dst ON dst.SalesID = st.SalesID
		JOIN Cloth ON Cloth.ClothID = dst.ClothID
GROUP BY st.SalesID, c.[Name], c.PhoneNumber, dst.ClothQuantity
HAVING	AVG(Cloth.Price) > 100000
		AND dst.ClothQuantity > 4

--10
GO
CREATE VIEW StorePurcahseView AS 
SELECT	DATENAME(mm, pt.PurchaseDate) AS [Purchase Month],
		MIN(dpt.ClothQuantity) AS [Minimum Purchase Quantity],
		COUNT(dpt.ClothQuantity) AS [Purchase Cloth Count]
FROM	PurchaseTransaction pt
		JOIN DetailPurchaseTransaction dpt ON dpt.PurchaseID = pt.PurchaseID
GROUP BY pt.PurchaseDate
HAVING	MIN(dpt.ClothQuantity) > 10 
		AND COUNT(dpt.ClothQuantity) > 1