--2301941990 - Fauza Wahidira

CREATE DATABASE TStore

USE TStore

CREATE TABLE Staff(
	StaffID VARCHAR(10) PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	[Name] VARCHAR(255) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(255) CHECK(PhoneNumber LIKE '08%'),
	Gender VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	Salary NUMERIC(10) CHECK(Salary >= 3000000)
)

CREATE TABLE Customer(
	CustomerID VARCHAR(10) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	[Name] VARCHAR(255) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(255) CHECK(PhoneNumber LIKE '08%'),
	Gender VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
)

CREATE TABLE Vendor(
	VendorID VARCHAR(10) PRIMARY KEY CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]'),
	[Name] VARCHAR(255) CHECK(LEN([Name]) >= 5),
	[Address] VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(255) CHECK(PhoneNumber LIKE '08%'),
	Email VARCHAR(255) NOT NULL,
)

CREATE TABLE ClothesCategory(
	CategoryID VARCHAR(10) PRIMARY KEY CHECK(CategoryID LIKE 'CA[0-9][0-9][0-9]'),
	[Name] VARCHAR(255) NOT NULL,
)

CREATE TABLE Cloth(
	ClothID VARCHAR(10) PRIMARY KEY CHECK(ClothID LIKE 'CL[0-9][0-9][0-9]'),
	CategoryID VARCHAR(10) REFERENCES ClothesCategory(CategoryID),
	Brand VARCHAR(255) CHECK(LEN(Brand) >= 5),
	Price NUMERIC(10) CHECK(Price >= 20000),
	Stock NUMERIC(10) NOT NULL,
)

CREATE TABLE SalesTransaction(
	SalesID VARCHAR(10) PRIMARY KEY CHECK(SalesID LIKE 'SA[0-9][0-9][0-9]'),
	StaffID VARCHAR(10) REFERENCES Staff(StaffID),
	CustomerID VARCHAR(10) REFERENCES Customer(CustomerID),
	SalesDate DATE CHECK(SalesDate NOT BETWEEN DATEADD(HOUR, -1, GETDATE()) AND GETDATE())
)

CREATE TABLE DetailSalesTransaction(
	SalesID VARCHAR(10) REFERENCES SalesTransaction(SalesID),
	ClothID VARCHAR(10) REFERENCES Cloth(ClothID),
	ClothQuantity NUMERIC(10) NOT NULL
)

CREATE TABLE PurchaseTransaction(
	PurchaseID VARCHAR(10) PRIMARY KEY CHECK(PurchaseID LIKE 'PU[0-9][0-9][0-9]'),
	StaffID VARCHAR(10) REFERENCES Staff(StaffID),
	VendorID VARCHAR(10) REFERENCES Vendor(VendorID),
	PurchaseDate DATE CHECK(PurchaseDate NOT BETWEEN DATEADD(HOUR, -1, GETDATE()) AND GETDATE())
)

CREATE TABLE DetailPurchaseTransaction(
	PurchaseID VARCHAR(10) REFERENCES PurchaseTransaction(PurchaseID),
	ClothID VARCHAR(10) REFERENCES Cloth(ClothID),
	ClothQuantity NUMERIC(10) NOT NULL
)