USE TStore

--Ketika seorang customer dengan ID CU004
--Membeli Produk TStore dengan ID CL003
--Dilayani oleh staff dengan ID ST005
--Pada tanggal 1 Desember 2020
INSERT INTO SalesTransaction
VALUES('SA016', 'ST005', 'CU004', '2020-12-1')

INSERT INTO DetailSalesTransaction
VALUES('SA016', 'CL003', 1)

UPDATE	Cloth
SET		Stock -= 1
WHERE	ClothID = 'CL003'

--Ketika toko ingin menambah stock melalui staff dengan ID ST003
--Menambah 50 produk dengan ID CL001
--mengambil baju dari vendor dengan ID VE008
--Pada tanggal 2 Desember 2020

INSERT INTO PurchaseTransaction
VALUES('PU016', 'ST003', 'VE008', '2020-12-2')

INSERT INTO DetailPurchaseTransaction
VALUES('PU016', 'CL001', 50)

UPDATE	Cloth
SET		Stock += 50
WHERE	ClothID = 'CL001'
