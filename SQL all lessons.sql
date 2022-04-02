-----------SQL SERVER ÖNEMLÝ KODLAR ---------------
-- kaynak:   https://www.sqlkodlari.com/31-sql-primary-key-kullanimi.asp
-- Kaynak  : https://sqlserveregitimleri.com/sql-server-primary-key-constraint-kullanimi

-- INDEX
--		1. DATABASE CREATE ETME 
--		2. TABLO CREATE ETME
--		3. INSERT INTO ÝLE TABLOYA VERÝ GÝRMEK
--		4. INSERT INTO ÝLE BÝR TABLODAKÝ VERÝLERÝ ALIP VAROLAN BÝR TABLO ÝÇÝNE KOPYALAMAK
--		5. PRIMARY KEY TANIMLAMAK
--		6. PRIMARY KEY ALANINI KALDIRMAK
--		7. FOREIGN KEY TANIMLAMAK
--		8. FOREIGN KEY ALANINI KALDIRMAK
--		9. ALTER TABLE
--		10.DROP
--		11.DELETE
--		12.CONVERT KULLANIMI
--		13.CREATE VIEW ...AS
--		14.CTE COMMON TABLE EXPRESSIONS 
--		15.CREATE INDEX
--		16.LIKE



-- 1. DATABASE CREATE ETME-----------------------------------------------------------------------------------
	-- Bu iþlemi yapabilmek için mevcut kullanýcýmýzýn veritabaný oluþturma yetkisine sahip olmasý gerekmektedir.

CREATE DATABASE veritabani_adi


-- 2. TABLO CREATE ETME---------------------------------------------------------------------------------------
	-- Bu iþlemi yapabilmek için mevcut kullanýcýmýzýn tablo oluþturma yetkisine sahip olmasý gerekmektedir.

CREATE TABLE tablo_adý
(
alan_adi1 veri_tipi(boyut) Constraint_Adý,
alan_adi2 veri_tipi(boyut),
alan_adi3 veri_tipi(boyut),
....
)
-- CONSTRAINT'LER:

--NOT NULL   : Alanýnda boþ geçilemeyeceðini belirtir.
--UNIQUE     : Bu alana girilecek verilerin hiç biri birbirine benzeyemez. Yani tekrarlý kayýt içeremez.
--PRIMERY KEY: Not Null ve Unique kriterlerinin her ikisini birden uygulanmasýdýr.
--FOREIGN KEY: Baþka bir tablodaki kayýtlarla eþleþtirmek için alandaki kayýtlarýn tutarlýlýðýný belirtir.
--CHECK      : Alandaki deðerlerin belli bir koþulu saðlamasý için kullanýlýr.
--DEFAULT    : Alan için herhangi bir deðer girilmezse, varsýyalan olarak bir deðer giremeyi saðlar.

-- örnek:
CREATE TABLE Personel
(
id int,
adi_soyadi varchar(25),
sehir varchar(15),
bolum varchar(15),
medeni_durum bolean
)


-- 3. INSERT INTO ÝLE TABLOYA VERÝ GÝRMEK-----------------------------------------------------------------------

	-- Burada dikkat edeceðimiz nokta eklenecek deðer tablomuzdaki alan sýrasýna göre olmalýdýr.
	-- Values ifadesinden yazýlacak deðerler sýrasý ile iþlenir.

INSERT INTO  tablo_adi
VALUES (deger1, deger2, ...)

-- diðer yöntem:
	--Bu yöntemde ise eklenecek alanlarý ve deðerleri kendimiz belirtiriz. 
	-- Burada dikkat edilmesi gereken þey; yazdýðýmýz alan adýnýn sýrasýna göre deðerleri eklememiz olacaktýr.
INSERT INTO  tablo_adi (alan_adi1, alan_adi2, alan_adi3)
VALUES (deger1, deger2, deger3)

--örnek1 (tablonun tüm sütunlarýna veri giriþi)
INSERT INTO Personel 
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan', 'Muhasebe', 3456789)
-- örnek2 (tablonun yalnýzca 3 alanýna veri giriþi) 
INSERT INTO Personel (id, adi_soyadi, sehir)
VALUES (3, 'Serkan ÖZGÜREL', 'Erzincan')



-- 4. INSERT INTO ÝLE BÝR TABLODAKÝ VERÝLERÝ ALIP VAROLAN BÝR TABLO ÝÇÝNE KOPYALAMAK-----------------------------

	-- Hedefte belirttiðimiz tablonun var olmasý gerekmektedir. 
	-- Hedef tabloda var olan alanlar silinmez. Var olan alanlarýn yanýna yeni alanlar eklenir.

INSERT INTO Hedef_tablo (alan_adi1,alan_adi2...)
SELECT alan_adi1,alan_adi2...
FROM tablo1

---- 4. a. Tüm sütunlarý kopyalama
INSERT INTO personel_yedek
SELECT *
FROM personel

---- 4. b. Sütun isimlerini deðiþtirerek kopyalama
INSERT INTO personel_yedek (isim, sehir)
SELECT  ad_soyad, sehir
FROM personel

---- 4. c. Belirli kriterlere göre kopyalama 
INSERT INTO istanbul_personelleri (isim)
SELECT ad_soyad
FROM personel
WHERE sehir='istanbul'

-- 5. PRIMARY KEY TANIMLAMAK ----------------------------------------------------------------------------

----- 5. a. TABLO OLUÞTURURKEN TANIMLAMAK

---------5. a. (1) sadece bir alanda kullaným biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL PRIMARY KEY,
adi_soyadi varchar(20) ,
Sehir varchar(20)
)

--------5. a. (2) birden fazla alanda kullaným biçimine örnek
CREATE TABLE Personel
(
id int NOT NULL,
adi_soyadi varchar(20) NOT NULL ,
Sehir varchar(20),
CONSTRAINT id_no PRIMARY KEY  (id,adi_soyadi)
)
-- Burada görüleceði üzere birden fazla alan PRIMARY KEY yapýsý içine alýnýyor. 
	-- CONSTRAINT ifadesi ile bu iþleme bir taným giriliyor. Aslýnda bu taným bizim tablomuzun index alanýný oluþturmaktadýr. 
	-- Ýndexleme sayesinde tablomuzdaki verilerin bütülüðü daha saðlam olurken aramalarda da daha hýzlý sonuçlar elde ederiz. 
	-- Ayrýca kullandýðýnz uygulama geliþtirme ortamlarýnda (ör .Net) tablo üzerinde daha etkin kullaným imkanýnýz olacaktýr.
	-- PRIMARY KEY ifadesinden sonra ise ilgili alanlarý virgül ile ayýrarak yazarýz.


-----5. b. PRIMARY KEY TANIMLAMAK (VAR OLAN BÝR TABLOYA)

--------5. b. (1) Sadece bir alanda (sütunda) kullaným biçimine örnek:
ALTER TABLE Personel
ADD PRIMARY KEY (id)

-- VEYA:
ALTER TABLE Calisanlar
ADD CONSTRAINT PK_CalisanID PRIMARY KEY (ID); 
--Kodu çalýþtýrdýðýmýz zaman Calisanlar tablomuzdaki ID alanýný Primary Key olarak yapmýþ oluyoruz. 
	--PK_CalisanID ifadesi ise bu primary key ifadesine verdiðimiz isimdir. Ýstediðiniz ismi verebilirsiniz. 
	-- Ben primary key alaný belli olsun diye PK ifadesi koydum ve 
	-- sonrasýnda CalisanID diyerek çalýþan id deðeri olduðunu belirttim.


--------5. b. (2) Birden fazla alanda (sütunda) kullaným biçimine örnek:
ALTER TABLE Personel
ADD CONSTRAINT  id_no PRIMARY KEY (id,adi_soyadi)

-- Burada dikkat edilecek nokta; ALTER ile sonradan bir alana PRIMARY KEY kriteri tanýmlanýrken 
	-- ilgili alanda veya alanlarda NULL yani boþ kayýt olmamalýdýr.


-------5. b. (3) Tabloya yeni bir sütun ekleyerek PRIMARY KEY tanýmlamak:
ALTER TABLE market_fact
ADD Market_ID INT PRIMARY KEY IDENTITY(1,1)


--6. PRIMARY KEY ALANINI KALDIRMAK---------------------------------------------------------------------------
ALTER TABLE Personel
DROP  CONSTRAINT id_no

--!!! Burada dikkat edilmesi gereken nokta eðer çoklu alanda PRIMARY KEY iþlemi yaptýysak, 
	-- CONSTRAINT ifadesinden sonra tablomuzdaki alan adý deðil, oluþturduðumuz "index adý" yazýlmalýdýr. 
	-- Eðer tek bir alanda oluþturduysak o zaman CONSTRAINT  ifadesinden sonra sadece alana adýný yazabiliriz.


-- 7. FOREIGN KEY TANIMLAMAK---------------------------------------------------------------------------------

	--Temel olarak FOREIGN KEY yardýmcý index oluþturmak için kullanýlýr. 
	-- Bir tabloda "id" alanýna PRIMARY KEY uygulayabiliriz. Ancak ayný tablodaki baþka bir alan farklý bir tablodaki kayda baðlý çalýþabilir
	-- Ýþte bu iki tablo arasýnda bir bað kurmak gerektiði durumlarda FOREIGN KEY devreye giriyor.
	-- Böylece tablolar arasý veri akýþý daha hýzlý olduðu gibi ileride artan kayýt sayýsý sonucu veri bozulmalarýnýn önüne geçilmiþ olunur.

------ 7. a. Tablo oluþtururken FOREIGN KEY tanýmlama:
CREATE TABLE Satislar
(
id int NOT NULL PRIMARY KEY,
Urun varchar(20) ,
Satis_fiyati varchar(20),
satan_id int CONSTRAINT fk_satici FOREIGN KEY References Personel(id)
)
-- !! FOREIGN KEY tanýmlamasý yapýlýrken hangi tablodaki hangi alanla iliþkili oldðunu 
	-- REFERENCES ifadesinden sonra yazmak gerekir!!
--  CONSTRAINT ile ona bir isim veriliyor. Böylece daha sonra bu FOREIGN KEY yapýsýný kaldýrmak istersek 
	-- bu verdiðimiz ismi kullanmamýz gerekecektir.

------ 7. b. Var olan tabloya FOREIGN KEY tanýmlama:
ALTER TABLE Satislar
ADD CONSTRAIN fk_satici FOREIGN KEY (satan_id) REFERENCES Personel(id)

ALTER TABLE [dbo].[market_fact] 
ADD CONSTRAIN FK_PROPID FOREIGN KEY ([Prod_id]) REFERENCES [dbo].[prod_dimen]



--8. FOREIGN KEY ALANINI KALDIRMAK ---------------------------------------------------------------------------

ALTER TABLE Satislar
DROP  CONSTRAINT fk_satici



--9. ALTER TABLE -----------------------------------------------------------------------------------------

---- 9. a. Sütun eklemek için:
ALTER TABLE tablo_adi
ADD alan_adi veri_tipi

ALTER TABLE dbo.doc_exa 
ADD column_b VARCHAR(20) NULL, 
	column_c INT NULL ;

---- 9. b. Sütun silmek için:
ALTER TABLE tablo_adi
DROP COLUMN alan_adi

---- 9. c. Sütun tipini deðiþtirmek:
ALTER TABLE tablo_adi
ALTER COLUMN  alan_adi  veri_tipi



--10.  DROP -----------------------------------------------------------------------------------------------

	-- DROP yapýsý ile indexler, alanlar, tablolar ve veritabanlarý kolaylýkla silinebilir. 
	-- DELETE yapýsý ile karýþtýrýlabilir. DELETE ile sadece tablomuzdaki kayýtlarý silebiliriz. 
	-- Eðer tablomuzu veya veritabanýmýzý silmek istiyorsak DROP yapýsýný kullanmamýz gerekmektedir.

DROP INDEX tablo_adi.index_adi
DROP TABLE tablo_adi
DROP DATABASE veritabani_adi
ALTER TABLE dbo.doc_exb DROP COLUMN column_b;

--TRUNCATE TABLE Kullaným Biçimi
	--Eðer tablomuzu deðilde sadece içindeki kayýtlarý silmek istiyorsak yani tablomuzun içini boþaltmak istiyorsak 
	--aþaðýdaki kodu kullanabiliriz:
TRUNCATE TABLE tablo_adi
--Truncate yapýsýnda parametre girilmez direkt olarak tüm kayýtlarý siler. Yeni kayýt yapýlýrsa numarasý 1 den baþlar.
-- Delete ile bütün kayýtlarý sildiðimiz zaman otomatik numara sýrasý baþtan baþlamaz.
	-- örneðin 150 kayýt silindiðinde ve yeni kayýt eklediðimizde bu 151 olur.



--11. DELETE -------------------------------------------------------------------------------------------

	-- Burada dikkat edilecek nokta WHERE ifadesi ile belli bir kayýt seçilip silinir. 
	-- Eðer WHERE ifadesini kullanmadan yaparsak tablodaki bütün kayýtlarý silmiþ oluruz.

DELETE  FROM tablo_adi
WHERE secilen_alan_adi=alan_degeri

DELETE FROM Personel 
WHERE Sehir='Ýstanbul'
AND id = 3



--12. CONVERT KULLANIMI-----------------------------------------------------------------------------------
	--tarih alanýný farklý biçimlerde ekrana yazdýrmak için:

SELECT  CONVERT(hedef_veri_tipi, alan_adi, gosterim_formati)
FROM tablo_adi

-- örnek:
SELECT ad_soyad, CONVERT(VARCHAR(11), dogum_tar, 106) AS [Doðum Tarihi] 
FROM Personel

CONVERT(VARCHAR(19),GETDATE())
CONVERT(VARCHAR(10),GETDATE(),10)
CONVERT(VARCHAR(10),GETDATE(),110)
CONVERT(VARCHAR(11),GETDATE(),6)
CONVERT(VARCHAR(11),GETDATE(),106)
CONVERT(VARCHAR(24),GETDATE(),113)

Çýktýsý:
Nov 04 2014 11:45 PM
11-04-14
11-04-2014
04 Nov 14
04 Nov 2014
04 Nov 2014 11:45:34:243



-- 13. CREATE VIEW ...AS ---------------------------------------------------------------------------------

---- 13. a. Yeni VIEW oluþturmak:
CREATE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. b. Var olan bir VIEW üzerinde deðiþiklik yapmak (CREATE OR REPLACE VIEW .. AS)
CREATE OR REPLACE VIEW view_adi AS
Select * From Tablo_adi
Where sorgulama_sartlari

---- 13. c. VIEW silmek:
DROP VIEW view_adi


-- 14. CTE - COMMON TABLE ESPRESSIONS ------------------------------------------------------------------

-- Subquery mantýðý ile ayný. Subquery'de içerde bir tablo ile ilgileniyorduk CTE'de yukarda yazýyoruz.

--(CTE), baþka bir SELECT, INSERT, DELETE veya UPDATE deyiminde baþvurabileceðiniz veya içinde kullanabileceðiniz geçici bir sonuç kümesidir. 
-- Baþka bir SQL sorgusu içinde tanýmlayabileceðiniz bir sorgudur. Bu nedenle, diðer sorgular CTE'yi bir tablo gibi kullanabilir. 
-- CTE, daha büyük bir sorguda kullanýlmak üzere yardýmcý ifadeler yazmamýzý saðlar.


-----14. a. ORDINARY CTE

	--subquery den hiç bir farký yok. subquery içerde kullanýlýyor, Ordinary CTE yukarda WITH ile oluþturuluyor.

WITH query_name [(column_name1, ....)] AS
	(SELECT ....)   -- CTE Definition

SQL_Statement

-- sadece WITH kýsmýný yazarsan tek baþýna çalýþmaz. WITH ile belirttiðim query'yi birazdan kullanacaðým demek bu. 
-- asýl SQL statement içinde bunu kullanýyoruz.

---- 14. B. RECURSIVE CTE

	-- UNION ALL ile kullanýlýyor.

WITH table_name (colum_list)
AS
(
	-- Anchor member
	initial_query
	UNION ALL
	-- Recursive member that references table_name.
	recursive_query
)
-- references table_name
SELECT *
FROM table_name

-- WITH ile yukarda tablo oluþturuyor, aþaðýda da SELECT FROM ile bu tabloyu kullanýyor




--15. CREATE INDEX--------------------------------------------------------------------------------------------

	-- Eðer tablomuza index tanýmý yaparsak yazacaðýmýz uygulamada kayýt arama esnasýnda bütün veritabanýný taramak yerine
	-- indexleri kullanarak daha hýzlý sonuçlar elde ederiz

	-- Tekrar eden deðerlere sahip alana index tanýmý yapýlacaksa:
CREATE INDEX index_adi
ON tablo_adi(alan_adi)

	-- "id" gibi tekrar etmeyen numaralarý barýndýran bir alana index tanýmý yapýlacak ise :
CREATE UNIQUE INDEX index_adi
ON tablo_adi(alan_adi)




--16. LIKE -------------------------------------------------------------------------------------------------

SELECT *
FROM Personel 
WHERE Sehir LIKE 'Ý%'
--Sehir alanýnda Ý harfi ile baþlayan kayýtlar seçilmiþtir. 
SELECT *
FROM Personel 
WHERE Bolum LIKE '%Yönetici%'
--Bolum alanýnýn herhangi bir yerinde (baþýnda, ortasýnda veya sonunda) Yönetici kelimesini seçer.
SELECT *
FROM Personel 
WHERE Bolum NOT LIKE '%Yönetici%'
--Bolum alanýnýn herhangi bir yerinde Yönetici yazmayan kayýtlarý seçer
SELECT *
FROM Personel 
WHERE Sehir  LIKE 'Ýzmi_'
--Ýzmi ile baþlayan ve son harfi ne olursa olsun farketmeyen
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[S,A]%'
--ilk harfi S veya A ile baþlayan kayýtlarý seçer. 
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '[A-K]%'
--ilk harfi A ile K harfleri arasýnda ki herhangi bir harf ile baþlayan
SELECT *
FROM Personel 
WHERE Adi_soyadi  LIKE '%[A-K]'
-- A ile K harfleri arasýnda ki herhangi bir harf ile biten


---Combine your tables
/* 12 july 2021 -- Data Analysis with SQL */

USE BikeStores

-- INNER JOIN
-- list products with category name
-- select product_id, product_name, category_id, category_name

-- 1. WAY
SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM production.products AS A
INNER JOIN production.categories AS B
ON A.category_id = B.category_id;


-- 2. WAY
SELECT A.product_id, A.product_name, B.category_name, B.category_id
FROM production.products A, production.categories B
WHERE A.category_id = B.category_id


-- INNER JOIN
-- List store employees with their store information
-- Select employee name, surname, store names

-- 1. WAY
SELECT A.first_name, A.last_name, B.store_name
FROM sales.staffs A, sales.stores B
WHERE A.store_id = B.store_id

-- 2. WAY
-- Without allias
SELECT sales.staffs.first_name, sales.staffs.last_name, sales.stores.store_name
FROM sales.staffs
JOIN sales.stores
ON sales.staffs.store_id = sales.stores.store_id

-- 3. WAY (GulF)
SELECT first_name,last_name, sales.stores.store_name 
FROM sales.staffs
INNER JOIN sales.stores
ON sales.stores.store_id = sales.staffs.store_id;


-- LEFT JOIN
-- List the products with their category names.
-- Select product ID, product name, category name, and categoryID

-- 1. WAY
SELECT A.product_id, A.product_name, B.category_name, B.category_id
FROM production.products AS A
LEFT JOIN production.categories AS B
ON A.category_id = B.category_id

-- 2. WAY
-- Without allias
SELECT production.products.product_id, production.products.product_name,  production.categories.category_name, production.categories.category_id
FROM production.products
LEFT JOIN production.categories 
ON production.products.category_id = production.categories.category_id


-- LEFT JOIN
-- report the stock status of the products that product id greater than 310 in the store
-- expected columns: product id, product name, store id, quantity

-- 1.WAY
SELECT PP.product_id, PP.product_name, PS.store_id, PS.quantity
FROM production.products AS PP
LEFT JOIN production.stocks AS PS
ON PP.product_id = PS.product_id
WHERE PP.product_id > 310;


-- RIGHT JOIN
-- report the stock status of the products that product id greater than 310 in the store
-- expected columns: product id, product name, store id, quantity

-- 1. WAY
SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM production.stocks AS B
RIGHT JOIN production.products AS A
ON A.product_id = B.product_id
WHERE A.product_id > 310

-- 2. WAY
SELECT B.product_id, B.product_name, A.store_id, A.quantity
FROM production.stocks as A
RIGHT JOIN production.products as B
ON A.product_id = B.product_id
where B.product_id > 310


-- RIGHT JOIN
-- Report the orders information made by all staffs.
-- Expected columns: Staff_id, first_name, last_name, all the information about orders

SELECT * 
FROM sales.staffs; -- 10

SELECT COUNT (DISTINCT staff_id)
FROM sales.orders; --6
-- (This counts unique 'staff_id's from orders, how many of staff entered the order details. We found 6 of them used it.
-- 4 of them weren't using the system, no input so their ids are missing. We are gonna sack them from their job. :) )

-- 1. WAY
SELECT A.staff_id, A.first_name,A.last_name, B.*
FROM sales.staffs A
RIGHT JOIN sales.orders B
ON A.staff_id = B.staff_id

-- 2. WAY
SELECT B.staff_id, B.first_name, B.last_name, A.*
FROM sales.orders A
RIGHT JOIN sales.staffs B
ON A.staff_id = B.staff_id


-- FULL OUTER JOIN
-- Write a query that returns stock and order information together for all products
-- Expected columns: product_id, store_id, quantity, order_id, list_price

-- 1. WAY
SELECT EMIR.product_id, HAN.store_id, HAN.quantity, EMIR.order_id, EMIR.list_price
FROM sales.order_items AS EMIR
FULL OUTER JOIN production.stocks AS HAN
ON EMIR.product_id = HAN.product_id

-- 2. WAY
SELECT EMIR.product_id, EMIR.store_id, EMIR.quantity, HAN.order_id,  HAN.list_price
FROM production.stocks AS EMIR
FULL OUTER JOIN sales.order_items AS HAN
ON EMIR.product_id = HAN.product_id

-- 3. WAY
SELECT A.product_id, A.store_id, B.quantity, B.order_id, B.list_price
FROM production.stocks A
FULL OUTER JOIN sales.order_items B
ON A.product_id = B.product_id;


-- CROSS JOIN
-- Write a query that returns all brand x category possibilities.
-- Expected columns: brand_id, brand_name, category_id, category_name

-- 1. WAY
SELECT A.brand_id, A.brand_name, B.category_id, B.category_name
FROM production.brands AS A
CROSS JOIN production.categories AS B
-- THERE IS NO "ON" WITH CROSS JOIN


-- CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity

-- To understand question, let's check

SELECT *
FROM production.stocks

SELECT *
FROM production.products

-- As you can see some of products are not in the stocks table, now let's find:
-- Number of items not on stock list but on product list


SELECT *
FROM production.products AS A
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks);

-- We find which product_id in stores but not in stocks

SELECT B.store_id, A.product_id, A.product_name, 0 quantity
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id


-- SELF JOIN
-- Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name

SELECT * 
FROM sales.staffs AS A
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id

/* 15 july 2021 -- Data Analysis with SQL - 2 - Tr*/

USE BikeStores

-- CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity

SELECT B.store_id, A.product_id, A.product_name, 0 quantity
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id


-- CROSS JOIN 
-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor
-- Ürün sayýsý hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluþturun.
-- Çýkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarýna göre sýralayýn

SELECT * 
FROM production.brands
CROSS JOIN production.categories
ORDER BY production.brands.brand_id

-- SELF JOIN
-- Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sales.staffs AS A
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id

-- GROUPING OPERATIONS -1
-- Write a query that checks if any product id is repeated in more than one row in the products table.

SELECT TOP 20 *
FROM production.products

SELECT A.product_name, COUNT(A.product_name)
FROM production.products AS A
GROUP BY A.product_name
HAVING COUNT(A.product_name) >1;
-- WHERE is useful for another new table, for current table HAVING is okay.

SELECT product_id, COUNT(product_id) AS CNT_PRODUCT
FROM production.products
GROUP BY product_id, product_name
HAVING COUNT (product_id) > 1;

SELECT	product_id, COUNT (*) AS CNT_PRODUCT
FROM	production.products
GROUP BY product_id
HAVING COUNT (*) > 1


-- GROUPING OPERATIONS -2
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.

SELECT category_id, MAX(list_price) AS max_list_price , MIN(list_price) AS min_list_price
FROM production.products
GROUP BY category_id
HAVING MAX(list_price)>4000 OR MIN(list_price)<500;

-- GROUPING OPERATIONS -3
-- Find the average product prices of the brands.
-- As a result of the query, the average prices should be displayed in descending order.

SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY AVG(B.list_price) DESC;

SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM production.brands AS A, production.products AS B
WHERE A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY avg_list_price DESC;
-- As you can see, if you will write two table side by side with comma after FROM expression, you can use WHERE instead of INNER JOIN


-- GROUPING OPERATIONS -4
-- Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name, AVG(list_price) as avg_price
FROM production.products as A
INNER JOIN production.brands as B
ON A.brand_id = B.brand_id
GROUP BY brand_name
HAVING AVG (list_price) > 1000
ORDER BY avg_price ASC;

SELECT brands.brand_name, AVG(products.list_price) AS avg_price
FROM production.products, production.brands
WHERE products.brand_id = brands.brand_id
GROUP BY brands.brand_name
HAVING AVG(products.list_price) > 1000
ORDER BY AVG(products.list_price) ASC;


-- GROUPING OPERATIONS -5
-- Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)

SELECT A.order_id, SUM(quantity * list_price * (1-discount)) AS net_value -- (1-discount) for percentile
FROM sales.order_items AS A
GROUP BY A.order_id

SELECT order_id, SUM(quantity * (list_price-list_price*discount)) AS net_value -- (1-discount) for percentile
FROM sales.order_items
GROUP BY order_id


-- CREATING SUMMARY TABLE INTO OUR BIKESTORES TABLES

SELECT b.brand_name AS brand, c.category_name AS category, p.model_year,
     ROUND (SUM (quantity * i.list_price * (1 - discount)) , 0 ) total_sales_price
INTO sales.sales_summary1
FROM
sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year

OR

SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sales.sales_summary

FROM sales.order_items A, production.products B, production.brands C, production.categories D
WHERE A.product_id = B.product_id
AND B.brand_id = C.brand_id
AND B.category_id = D.category_id
GROUP BY
C.brand_name, D.category_name, B.model_year

-- GROUP BY with GROUPING SETS

-- 1. Total Sales (grouping by Brand)

SELECT brand, SUM(total_sales_price) AS sum_of_total_sales_price
FROM sales.sales_summary1
GROUP BY Brand

-- 2. Total Sales (grouping by Category)

SELECT category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category

-- 3. Total Sales (grouping by Brand and Category)

SELECT Brand, Category, Model_Year, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Brand, Category, Model_Year -- you can group by writing 1,2,3 also

-- 4. Total Sales (grouping by Brand and Category and Brand-Category with GROUPING SETS)

SELECT	Brand, Category, SUM(total_sales_price)
FROM	sales.sales_summary1
GROUP BY
GROUPING SETS ((Brand),(Category),(Brand,Category),()) -- blank paranthesis is bringing us the both nulls condititons at the same time
ORDER BY 1,2;


-- GROUP BY with ROLLUP

-- 1. Total Sales (grouping by Brand and Category and Brand-Category with ROLLUP)

SELECT	Brand, Category, SUM(total_sales_price)
FROM	sales.sales_summary
GROUP BY 
ROLLUP (Brand, Category)
ORDER BY 1,2;

-- GROUP BY with CUBE

-- 1. Total Sales (grouping by Brand and Category and Brand-Category with CUBE)

SELECT	Brand, Category, Model_Year, SUM(total_sales_price)
FROM	sales.sales_summary1
GROUP BY 
CUBE (Brand, Category, Model_Year)
ORDER BY 1,2;

--------------------DAwSQL 17.07.2021 Session 3 (Organize Complex Queries)--------------

-- Pivot

-- Example of PIVOT Syntax
SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
FROM 
table_name
PIVOT
(
aggregate_function(aggregate_column)
FOR pivot_column
IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS pivot_table_name;


-- The following syntax summarizes how to use the PIVOT operator. syntax-sql
SELECT <non-pivoted column>,  
    [first pivoted column] AS <column name>,  
    [second pivoted column] AS <column name>,  
    ...  
    [last pivoted column] AS <column name>  
FROM  
    (<SELECT query that produces the data>)   
    AS <alias for the source query>  
PIVOT  
(  
    <aggregation function>(<column being aggregated>)  
FOR   
[<column that contains the values that will become column headers>]   
    IN ( [first pivoted column], [second pivoted column],  
    ... [last pivoted column])  
) AS <alias for the pivot table>  
<optional ORDER BY clause>;  


Use BikeStores

SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY Category


-- Using PIVOT table for giving same values as like above

-- My code
SELECT * 
FROM
(
SELECT Category, total_sales_price
FROM sales.sales_summary
) AS A
PIVOT
(
SUM (total_sales_price)
FOR Category
IN (
[Cruisers Bicycles],
[Mountain Bikes],
[Road Bikes],
[Children Bicycles],
[Cyclocross Bicycles],
[Electric Bikes]
) 
)AS PIVOT_TABLE


-- Instructor's code
SELECT *
FROM
	(
	SELECT	Category,Model_Year, total_sales_price ---model year ekledigimizde yillara gore pivot elde ediyoruz.
	FROM	sales.sales_summary
	) AS A ---isimlendirmek gerekiyor
PIVOT
(
SUM (total_sales_price)
FOR	Category
IN	(
	[Children Bicycles],
    [Comfort Bicycles],
    [Cruisers Bicycles],
    [Cyclocross Bicycles],
    [Electric Bikes],
    [Mountain Bikes],
    [Road Bikes]
	)
) AS PIVOT_TABLE ---isimlendirmediginde hata veriyor

--------////////////////////////////////////

------- SINGLE ROW SUBQUERIES --------

-- Question: Bring all the personnels from the store that Kali Vargas works


SELECT *
FROM sales.staffs
WHERE first_name = 'Kali' AND last_name = 'Vargas'

SELECT *
FROM sales.staffs
WHERE store_id = (SELECT store_id
				  FROM sales.staffs
				  WHERE first_name = 'Kali' and last_name = 'Vargas')



-- Question: List the staff that Venita Daniel is the manager of.

SELECT *
FROM sales.staffs
WHERE manager_id = (SELECT staff_id 
					FROM sales.staffs
					WHERE first_name='Venita')

SELECT A.*
FROM sales.staffs A, sales.staffs B
WHERE A.manager_id = B.staff_id
AND B.first_name = 'Venita' AND B.last_name = 'Daniel'


-- Question: Write a query that returns customers in the city where the 'Rowlett Bikes' store is located.

SELECT *
FROM sales.customers A
WHERE a.city = (
				SELECT city
				FROM sales.stores b
				WHERE b.store_name = 'Rowlett Bikes')

-- Question: List bikes that are more expensive than the 'Trek CrossRip+ - 2018' bike.

SELECT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id 
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')

-- with DISTINCT

SELECT DISTINCT A.product_id, A.product_name, A.model_year, A.list_price, B.brand_name, C.category_name
FROM production.products AS A, production.brands AS B, production.categories AS C
WHERE A.brand_id = B.brand_id AND A.category_id = C.category_id 
AND list_price > (SELECT list_price
					FROM production.products
					WHERE product_name= 'Trek CrossRip+ - 2018')


-- Question: List customers who orders previous dates than Arla Ellis.

-- C8366 - Harun's answer
SELECT b.first_name, b.last_name, a.order_date
FROM sales.orders a, sales.customers b
WHERE a.customer_id = b.customer_id
and a.order_date < (
					SELECT order_date
					FROM sales.orders
					WHERE customer_id = (
										SELECT customer_id
										FROM sales.customers
										WHERE first_name = 'Arla' and last_name = 'Ellis'))

-- Instructor's answer
SELECT	A.first_name, A.last_name, B.order_date
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id and B.order_date < (
						SELECT	order_date
						FROM	sales.customers A, sales.orders B
						WHERE	A.customer_id = B.customer_id
						AND		A.first_name = 'Arla' AND A.last_name = 'Ellis'
						)

-- Question: List order dates for customers residing in the Holbrook city.

SELECT ORDER_DATE
FROM sales.orders
WHERE customer_id IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )

-- with NOT IN

SELECT ORDER_DATE
FROM sales.orders
WHERE customer_id NOT IN (
					  SELECT customer_id
					  FROM sales.customers
					  WHERE city = 'Holbrook'
					  )


-- Question: List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes.

-- C8316 - Süleyman's answer
SELECT	A.product_name, A.list_price
FROM	production.products A, production.categories B
WHERE	A.category_id = B.category_id
AND A.product_name NOT IN (
							SELECT	category_name
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes'))

-- Instructor's answer
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
							SELECT	category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes')
							)

-- What if  i want only 2016
-- C8301 -Sam's answer
select product_name
from production.products
where category_id NOT IN (
     select category_id
     from production.categories
     where category_id != 3 AND category_id != 6 AND category_id != 7)

-- Instructor's answer
SELECT	product_name, list_price, model_year
FROM	production.products
WHERE	category_id NOT IN (
							SELECT	category_id
							FROM	production.categories
							WHERE	category_name IN ('Cruisers Bicycles', 'Mountian Bikes', 'Road Bikes')
							)
AND model_year=2016


-- Question: List bikes that cost more than electric bikes.

-- we will use ALL or ANY because:
-- Subquery returned more than 1 value. This is not permitted when the subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ANY (
						SELECT B.list_price
						FROM production.categories AS A, production.products AS B
						WHERE A.category_id = B.category_id
						AND A.category_name = 'Electric Bikes'
						)

-------------------//////////////////////////

-----------CORRELATED SUBQUERIES--------------

-- EXIST / NOT EXIST

-- Question: Wirite a query that returns State where 'Trek Remedy 9.8 - 2617' product is not ordered
-- EXISTS or NOT EXISTS

SELECT	DISTINCT STATE
FROM	sales.customers X
WHERE	EXISTS 				(
							SELECT	1
							FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
							WHERE	A.product_id = B.product_id
							AND		B.order_id = C.order_id
							AND		C.customer_id = D.customer_id
							AND		A.product_name = 'Trek Remedy 9.8 - 2017'
							AND		X.state = D.state
							)


-- Question: List bikes that cost more than any electric bikes.

SELECT product_name, model_year, list_price
FROM production.products
WHERE list_price > ANY (
						SELECT B.list_price
						FROM production.categories AS A, production.products AS B
						WHERE A.category_id = B.category_id
						AND A.category_name = 'Electric Bikes'
						)

------------ VIEWS ---------------

-- Create a View with the order details and use it in several queries.
-- Customer name surname, order_date, product_name, model_year, quantity, list_price, final_price (discounted price)
-- You can find your view inside Bikestores > Views > dbo.SUMMARY_VIEW (dbo means default schema) not allowed temporary view with #

CREATE VIEW SUMMARY_VIEW AS
SELECT	first_name, last_name, order_date, product_name, model_year,
		quantity, list_price, final_price
FROM
		(
		SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
				C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
		FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
		WHERE	A.customer_id = B.customer_id AND
				B.order_id = C.order_id AND
				C.product_id = D.product_id
		) A
;

SELECT * 
FROM SUMMARY_VIEW
where order_date<= '2016-01-01'


--------- CREATE TABLE ---------------
-- '#' is useful for temporary creating inside System Database > tempdb > Temporary Tables

SELECT	first_name, last_name, order_date, product_name, model_year,
		quantity, list_price, final_price
INTO #SUMMARY_VIEWi
FROM
		(
		SELECT	A.first_name, A.last_name, B.order_date, D.product_name, D.model_year,
				C.quantity, C.list_price, C.list_price * (1-C.discount) final_price
		FROM	sales.customers A, sales.orders B, sales.order_items C, production.products D
		WHERE	A.customer_id = B.customer_id AND
				B.order_id = C.order_id AND
				C.product_id = D.product_id
		) A
;

SELECT * 
FROM #SUMMARY_VIEWi




/* 28.97.2021 DAwSQL Session 4 -- Set Operators and Case Expression */

-- Question: List customers who have an order prior to the last order of a customer named Sharyn Hopkins 
-- and are residents of the city of San Diego.

select A.*,B.order_date
from sales.customers A,sales.orders B
where A.customer_id=B.customer_id and B.order_date<(
								select max(B.order_date)
								from sales.customers A, sales.orders B
								where A.customer_id=B.customer_id and A.first_name='Sharyn') and A.city='San Diego'

---with CTE 
--- Common Table Expression CTE provides us to use table in ongoing query---
WITH T1 AS   
			(
			SELECT MAX(B.order_date) AS last_order
			FROM sales.customers AS A, sales.orders AS B
			WHERE A.customer_id = B.customer_id
			AND	  A.first_name LIKE 'Sharyn'
			AND   A.last_name  LIKE 'Hopkins'
			)
SELECT A.customer_id, first_name, last_name, city, order_date
FROM sales.customers AS A, sales.orders AS B, T1 AS C
WHERE A.customer_id = B.customer_id
AND   B.order_date < C.last_order
AND   A.city LIKE 'San Diego'

-- Question: 0'dan 9'a kadar herbir rakam bir satýrda olacak þekilde bir tablo olusturun.

WITH T1 AS
		  (
		  SELECT 0 AS number
		  UNION ALL
		  SELECT number + 1
		  FROM T1
		  WHERE number <= 8
		  )
SELECT *
FROM T1

--

WITH Users AS
			 (
			  SELECT *
			  FROM (
					VALUES
						  (1,'start', CAST('01-01-20' AS date)),
						  (1,'cancel', CAST('01-02-20' AS date)),
						  (2,'start', CAST('01-03-20' AS date)),
						  (2,'publish', CAST('01-04-20' As date)),
						  (3,'start', CAST('01-05-20' AS date)),
						  (3,'cance1', CAST('01-06-20' AS date)),
						  (1,'start', CAST('01-07-20' AS date)),
						  (1,'publish', CAST('01-08-20' AS date))
					) as tab1e_1 ([user_id], [action], [date])
			 )
SELECT * 
FROM Users

-- Question: Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soy isimlerini listeleyin

-- UNION ALL
SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'

-- UNION

SELECT last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT last_name
FROM sales.customers
WHERE city = 'Monroe'

-- WITH first_name

SELECT first_name ,last_name
FROM sales.customers
WHERE city = 'Sacramento'

UNION

SELECT first_name, last_name
FROM sales.customers
WHERE city = 'Monroe'

-- Another Way 'OR' 'IN'

select distinct last_name
from sales.customers
where city = 'Sacramento' or city = 'Monroe'

SELECT last_name
FROM sales.customers
WHERE city IN ('Sacramento', 'Monroe')


-- Question: Write a query that returns brands that have products for both 2016 and 2017.

SELECT B.brand_id, A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2016
INTERSECT
SELECT B.brand_id, A.brand_name
FROM production.brands A, production.products B
WHERE A.brand_id = B.brand_id
AND B.model_year = 2017

--

-- Leon's Way

SELECT	*
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					INTERSECT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)

-- Question: Write a query that returns customers who have orders for both 2016, 2017, and 2018

SELECT A.first_name, A.last_name
FROM sales.customers A, sales.orders AS B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2016
INTERSECT
SELECT A.first_name, A.last_name
FROM sales.customers A, sales.orders AS B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2017
INTERSECT
SELECT A.first_name, A.last_name
FROM sales.customers A, sales.orders AS B
WHERE A.customer_id = B.customer_id
AND YEAR(B.order_date) = 2018

-- With subquery

SELECT	first_name, last_name
FROM	sales.customers
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2016-01-01' AND '2016-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2017-01-01' AND '2017-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	sales.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						)

--Question: Write a query that returns products produced in 2016 not in 2017

SELECT B.brand_id, B.brand_name, A.model_year
FROM production.brands AS B, production.products AS A
WHERE A.brand_id=B.brand_id 
AND A.model_year =2016
EXCEPT
SELECT B.brand_id, B.brand_name, A.model_year
FROM production.brands AS B, production.products AS A
WHERE A.brand_id=B.brand_id 
AND A.model_year=2017

--

SELECT	*
FROM	production.brands
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2016
					EXCEPT
					SELECT	brand_id
					FROM	production.products
					WHERE	model_year = 2017
					)
;

--Question: Write a query that returns only products ordered in 2017 (not ordered in other years).

SELECT B.product_id, C.product_name
FROM sales.orders AS A, sales.order_items AS B, production.products AS C
WHERE A.order_id = B.order_id
AND B.product_id = C.product_id
AND YEAR(A.order_date) = 2017

EXCEPT

SELECT B.product_id, C.product_name
FROM sales.orders AS A, sales.order_items AS B, production.products AS C
WHERE A.order_id = B.order_id
AND B.product_id = C.product_id
AND YEAR(A.order_date) != 2017

--

SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		A.order_date LIKE '%2017%'
					EXCEPT
					SELECT	B.product_id
					FROM	sales.orders A, sales.order_items B
					WHERE	A.order_id= B.order_id
					AND		YEAR(A.order_date) != 2017
					)

--

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @EndDate = '2017-12-31'
SET @StartDate = '2017-01-01'

SELECT	product_id, product_name
FROM	production.products
WHERE	product_id IN (
						SELECT	B.product_id
						FROM	sales.orders A, sales.order_items B
						WHERE	A.order_id = B.order_id AND
								A.order_date BETWEEN @StartDate AND @EndDate
						EXCEPT
						SELECT	B.product_id
						FROM	sales.orders A, sales.order_items B
						WHERE	A.order_id = B.order_id AND
								A.order_date NOT BETWEEN @StartDate AND @EndDate)

-- Question: Write a query that returns State where 'Trek Remedy 9.8 - 2017' product is not ordered

SELECT D.state
FROM sales.customers D

EXCEPT

SELECT D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE A.product_id = B.product_id
AND B.order_id = C.order_id
AND	C.customer_id = D.customer_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'

--

SELECT	E.[state], COUNT (D.product_id) count_of_products
FROM
		(
		SELECT	C.order_id, C.customer_id, B.product_id
		FROM	production.products A, sales.order_items B, sales.orders C
		WHERE	A.product_id = B.product_id
		AND		B.order_id = C.order_id
		AND		A.product_name = 'Trek Remedy 9.8 - 2017'
		) D
RIGHT JOIN sales.customers E ON E.customer_id = D.customer_id
GROUP BY
		E.[state]
HAVING
		COUNT (D.product_id) = 0

-----

SELECT distinct state
FROM
SALES.customers X
WHERE NOT EXISTS
(
SELECT	D.STATE
FROM	production.products A, sales.order_items B, sales.orders C, sales.customers D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Trek Remedy 9.8 - 2017'
AND		D.STATE = X.STATE
) 

-- Question: Question: Generate a new column containing what the mean of the values in the Order_Status column.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_status,
		CASE order_status WHEN 1 THEN 'Pending'
						  WHEN 2 THEN 'Processing'
						  WHEN 3 THEN 'Rejected'
						  WHEN 4 THEN 'Completed'
		END AS MEAN_OF_STATUS
FROM sales.orders

-- Question: Create a new column containing the labels of the customers' email service providers ( "Gmail", "Hotmail", "Yahoo" or "Other" )

SELECT email
FROM sales.customers

SELECT email,
		CASE        WHEN email LIKE '%gmail%' THEN 'GMAIL'
					WHEN email LIKE '%hotmail%' THEN 'HOTMAIL'
					WHEN email LIKE '%yahoo%' THEN 'YAHOO'
					ELSE 'OTHER'
		END AS email_service_providers
FROM sales.customers

---List customers who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order


select A.order_id, B.first_name, B.last_name
from sales.orders A, sales.customers B
where A.customer_id=B.customer_id and A.order_id in(
										select B.order_id
										from production.products A, sales.order_items B
										where A.product_id=B.product_id and A.category_id =(select category_id
																							from production.categories
																							where category_name='Electric Bikes')
										intersect

										select B.order_id
										from production.products A, sales.order_items B
										where A.product_id=B.product_id and A.category_id =(select category_id
																							from production.categories
																							where category_name='Comfort Bicycles')
										intersect

										select B.order_id
										from production.products A, sales.order_items B
										where A.product_id=B.product_id and A.category_id =(select category_id
																							from production.categories
																							where category_name='Children Bicycles'))



--GET DATA TYPES FROM BIKESTORE DATABASE

SELECT DATA_TYPE,COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_CATALOG='BikeStores'
GROUP BY DATA_TYPE

--LET'S BUILD A TABLE THAT INCLUDES ALL THE DATE AND TIME FORMATS WE NEED
CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
)

--INSERT SOME DATA TO THE NEW TABLE
INSERT INTO dbo.t_date_time (
	A_time ,
	A_date ,
	A_smalldatetime,
	A_datetime,
	A_datetime2,
	A_datetimeoffset
	)
VALUES (
	'11:00:00',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31',
	'2021-07-31'
)
---- All values inserted come out appropriate way we defined
select *
from  t_date_time 



--LET'S USE CONSTRUCT FUNCTIONS FOR INSERTING DATA

--INSERT TIME FORMATTED VALUE FOR 12:10:30 INTO COLUMN A_time
INSERT INTO dbo.t_date_time (A_time) 
VALUES (TIMEFROMPARTS(12,10,30,0,0))

--INSERT TIME FORMATTED VALUE FOR 20:30:15 INTO COLUMN A_time
INSERT INTO dbo.t_date_time (A_time) 
VALUES (TIMEFROMPARTS(20,30,15,0,0))

--INSERT DATE FORMATTED VALUE FOR TODAY INTO COLUMN A_date
INSERT INTO dbo.t_date_time (A_date) 
VALUES (DATEFROMPARTS(2021,07,31))

--INSERT DATETIME FORMATTED VALUE FOR TODAY AT 15:30:20 INTO COLUMN A_datetime
INSERT INTO dbo.t_date_time (A_datetime) 
VALUES (DATETIMEFROMPARTS(2021,07,31,15,30,20,0))

SELECT *
FROM dbo.t_date_time

--INSERT DATETIMEOFFSET FORMATTED VALUE FOR TODAY AT 15:30:20  OFFSET=2 HOURS INTO COLUMN A_datetimeoffset
INSERT INTO dbo.t_date_time (A_datetimeoffset) 
VALUES (DATETIMEOFFSETFROMPARTS(2021,07,31,15,30,20,0,2,0,0))

--DELETE FROM DBO.t_date_time where A_datetimeoffset ='2021-07-31 15:30:20.0000000 +02:00'

--RETURN FUNCTIONS
SELECT A_date,
		DATENAME(DW,A_date) as date_name,
		DAY(A_date) as [day],
		DATEPART(MONTH,A_date) as [datepart],
		DATENAME(MONTH,A_date) as [datename]
FROM dbo.t_date_time

SELECT *,DATENAME(DW,order_date) as order_date
		,DATENAME(DW,required_date) as required_date
		,DATENAME(DW,shipped_date) as shipped_date
FROM sales.orders

SELECT *,DATENAME(DW,order_date) as order_date
		,DATEPART(MONTH,required_date) as [month]
		,DAY(shipped_date) as [day]
FROM sales.orders


--ISDATE, GETDATE(), CURRENT_TIMESTAMP,	GETUTCDATE();
SELECT ISDATE('2021-01-32')
SELECT GETDATE()
SELECT CURRENT_TIMESTAMP
SELECT GETUTCDATE()

INSERT INTO t_date_time VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE());

SELECT *
FROM t_date_time  ?


-- DATEADD ve EOMONTH FUNCTIONS
SELECT EOMONTH('2021-02-15')
SELECT EOMONTH('2020-02-15')
SELECT DAY(EOMONTH('2020-02-15'))
SELECT DAY(EOMONTH('2021-02-15'))

SELECT DATEADD(M,3,'2021-01-01')
SELECT DATEADD(WEEK,3,'2021-01-01')
SELECT DATEADD(D,-5,'2021-01-01')
SELECT DATEADD(M,-3,'2021-01-01')

--DATEDIFF, DATEADD,EOMONTH FUNCTIONS

SELECT *,
		DATENAME(DW,order_date) as [order_day],
		DATEDIFF(D, order_date, shipped_date) AS [day_diff]

FROM sales.orders

-- QUESTION: Create a new column that contains labels of the shipping speed of products.
-- 1. If the product has not been shipped yet, it will be marked as "Not Shipped"
-- 2. If the product was shipped in 1 day, it will be labeled as "Fast"
-- 3. If the product is shipped in 2 days after the order day, it will be labeled as "Normal"
-- 4. If the product was shipped 3 or more days after the day of order, it will be labeled as "Slow"
--(ORDER STATUS <> 4 THAT MEANS THIS ORDER IS NOT SHIPPED)

SELECT *,
		DATENAME(DW,order_date) as [order_day],
		DATEDIFF(D, order_date, shipped_date) AS [day_diff],

		CASE	WHEN order_status <> 4 THEN  'Not Shipped'
				WHEN DATEDIFF(D, order_date, shipped_date)=1 THEN 'Fast'
				WHEN DATEDIFF(D, order_date, shipped_date)=2 THEN 'Normal'
				ELSE 'Slow'
		END as Shipping_Speed				
FROM sales.orders

--Question-2: Write a query returning orders that are shipped more than two days after the ordered date. 

SELECT *, 
		DATEDIFF (DAY, order_date, shipped_date) AS difference_date
FROM sales.orders
WHERE DATEDIFF (DAY, order_date, shipped_date) > 2


--Question-3: Write a query that returns the number distributions of the orders in the previous query result, 
--according to the days of the week.
SELECT	SUM(CASE WHEN DATENAME(DW,order_date)='Monday' THEN 1 ELSE 0 END) as Monday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Tuesday' THEN 1 ELSE 0 END) as Tuesday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Wednesday' THEN 1 ELSE 0 END) as Wednesday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Thursday' THEN 1 ELSE 0 END) as Thursday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Friday' THEN 1 ELSE 0 END) as Friday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Saturday' THEN 1 ELSE 0 END) as Saturday,
		SUM(CASE WHEN DATENAME(DW,order_date)='Sunday' THEN 1 ELSE 0 END) as Sunday
FROM sales.orders
where DATEDIFF(DAY,order_date,shipped_date)>2 

--Question-4:Write a query that returns the order numbers of the states by months.

SELECT	c.state
		,YEAR(o.order_date) as [Year]
		,MONTH(o.order_date) as [MONTH]
		,COUNT(DISTINCT o.order_id) AS NUM_OF_ORDERS
FROM SALES.orders O, sales.customers C
WHERE  O.customer_id=C.customer_id
group by C.state, YEAR(o.order_date),MONTH(o.order_date)
ORDER BY C.state,[Year]




---------------- DAwSQL Session 6 String Function 02.08.2021 ------------------

-- LEN

SELECT LEN(123344)

SELECT LEN( 123344)

SELECT LEN('WELCOME')

SELECT LEN(' WELCOME')

SELECT LEN('"WELCOME"')

SELECT '"WELCOME"'

SELECT 1


-- CHARINDEX

SELECT CHARINDEX ('C', 'CHARACTER')

SELECT CHARINDEX ('C', 'CHARACTER', 5)

SELECT CHARINDEX ('CT', 'CHARACTER')

SELECT CHARINDEX ('ct', 'CAHARACTER')


-- PATINDEX

SELECT PATINDEX ('R', 'CHARACTER')

SELECT PATINDEX ('%R%', 'CHARACTER')

SELECT PATINDEX ('%r%', 'CHARACTER')

SELECT PATINDEX ('%R', 'CHARACTER')

SELECT PATINDEX ('%A____', 'CHARACTER')


-- LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT (' CHARACTER', 3)


-- RIGHT

SELECT RIGHT ('CHARACTER', 3)

SELECT RIGHT ('CHARACTER ', 3)


-- SUBSTRING

SELECT SUBSTRING ('CHARACTER', 3, 5)

SELECT SUBSTRING ('CHARACTER', 1, 5)
SELECT LEFT ('CHARACTER', 5)

SELECT SUBSTRING ('123456789', 3, 5)

SELECT SUBSTRING ('CHARACTER', -1, 5)
SELECT SUBSTRING ('CHARACTER', -4, 8)


-- LOWER

SELECT LOWER ('CHARACTER')


-- UPPER

SELECT UPPER ('character')


-- STRING_SPLIT

SELECT VALUE
FROM string_split('John,Sarah,Jack', ',')

SELECT VALUE
FROM string_split('John/Sarah/Jack', '/')

SELECT VALUE
FROM string_split('John//Sarah//Jack', '/')

SELECT *
FROM string_split('John//Sarah//Jack', '/')


-- character >>> Character

SELECT UPPER (LEFT('character', 1))

SELECT LEN ('character') -1
SELECT RIGHT ('character', LEN ('character') -1)

SELECT UPPER (LEFT('character', 1)) + RIGHT ('character', LEN ('character') -1)

SELECT UPPER(LEFT('character',1))+LOWER(SUBSTRING('character',2,LEN('character')))


--TRIM

SELECT TRIM(' CHARACTER ')

SELECT TRIM (' CHARACT ER')

SELECT TRIM('./' FROM '/character..') result


--LTRIM

SELECT LTRIM(' CHARACTER ')


--RTRIM

SELECT RTRIM(' CHARACTER ')


--REPLACE

SELECT REPLACE ('CHARACTER', 'RAC' , '')

SELECT REPLACE ('CHARACTER', 'RAC' , '/')


--STR

SELECT STR (1234.573, 6, 2) --- TO bring how many char, and after "," how many? 

SELECT STR (1234.573, 7, 2)

SELECT STR (1234.573, 7, 1) --- in order to get 7 char leave it blank the beginning of raw due to call 1 char after ","


SELECT STR (1234.573, 8, 3)


--JACK_10

SELECT 'JACK' + '_' + '10'

SELECT 'JACK' + '_' + STR (10, 2) ---10 dan 2 karakter getir

SELECT 'JACK' + '_' + STR (101, 3)


--CAST

SELECT CAST (123456 AS CHAR(6))

SELECT CAST (123456 AS VARCHAR(10))    

SELECT CAST (123456 AS VARCHAR(10)) + ' CHRIS'   


SELECT CAST (GETDATE() AS DATE)


--CONVERT

SELECT CONVERT (INT, 30.30)

SELECT CONVERT (FLOAT, 30.30)

SELECT CONVERT (FLOAT, 30.37)

SELECT CONVERT(DATE,GETDATE())

--COALECE()

SELECT COALESCE (NULL, NULL, 'JACK', 'HANS', NULL)


--NULLIF

SELECT NULLIF ('JACK', 'JACK')

SELECT NULLIF ('JACK', 'HANS')


SELECT first_name
FROM sales.customers


SELECT NULLIF (first_name, 'Debra')
from	sales.customers

SELECT COUNT(first_name)
FROM sales.customers
SELECT	COUNT (NULLIF (first_name, 'Debra'))
from	sales.customers


SELECT	COUNT (*)
from	sales.customers


--ROUND


SELECT ROUND (432.368, 2, 0)

SELECT ROUND (432.368, 2)

SELECT ROUND (432.368, 1, 0)


SELECT ROUND (432.368, 1, 1)

SELECT ROUND (432.300, 1, 1)


SELECT ROUND (432.368, 3, 0)


-- How many yahoo mails in customer’s email column? --

SELECT SUM(
		   CASE 
		   WHEN PATINDEX('%yahoo%', email) > 0 THEN 1 ELSE 0 
		   END
		   ) number_providers
FROM sales.customers
-- or

select count(*)
from sales.customers
where PATINDEX('%yahoo%', email)>0
-- or
SELECT SUM(
		   CASE 
		   WHEN email LIKE ('%yahoo%') THEN 1 ELSE 0 
		   END
		   ) number_providers
FROM sales.customers
-- or
SELECT SUM(
		   CASE
		   WHEN email = '%yahoo___' THEN 1 ELSE 0 
		   END
		   ) number_providers
FROM sales.customers
-- or
select count(*)
from sales.customers
where email like '%yahoo%'


--Write a query that returns the characters before the '.' character in the email column.

SELECT SUBSTRING (email, 1, CHARINDEX('.', email)-1) 
FROM sales.customers
-- or
SELECT SUBSTRING (email, 1, PATINDEX('%.%', email)-1) 
FROM sales.customers
--or
select left(a.email,PATINDEX ('%.%', a.email)-1),a.email
from sales.customers a



---Add a new column to the customers table that contains the customers' contact information. 
--If the phone is available, the phone information will be printed, if not, the email information will be printed.


SELECT customer_id, first_name,	last_name, phone, email, street, city, state, zip_code, COALESCE (phone, email) contact
FROM sales.customers

SELECT *, COALESCE (phone, email) contact
FROM sales.customers

------ end of today

--Write a query that returns streets. The third character of the streets is numerical.


SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) LIKE '[0-9]'



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	SUBSTRING( street, 3, 1) NOT LIKE '[^0-9]'



SELECT SUBSTRING( street, 3, 1), street
FROM sales.customers
WHERE	ISNUMERIC (SUBSTRING( street, 3, 1) ) = 1



--In the street column, clear the string characters that were accidentally added to the end of the initial numeric expression.

select SUBSTRING( street, 1, PATINDEX('% %', street)-1 ),street
from sales.customers
where ISNUMERIC (SUBSTRING( street, 1, PATINDEX('% %', street)-1 )) = 0

--or

select SUBSTRING( street, 1, PATINDEX('% %', street)-1 ),street
from sales.customers
where SUBSTRING( street, 1, PATINDEX('% %', street)-1 ) like '%[^0-9]%'





------------ DAwSQL Session 8 (05.08.2021)Tr ---------------

-- Ürünlerin stok sayýlarýný bulunuz

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id

SELECT product_id
FROM production.stocks
GROUP BY product_id
ORDER BY 1

SELECT *, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks
SELECT  SUM(quantity),product_id,store_id
FROM production.stocks
group by product_id,store_id
order by product_id 


SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id)
FROM production.stocks

-- Markalara göre ortalama bisiklet fiyatlarýný hem Group By hem de window Functions ile hesaplayýnýz.
--- Based on Brand name 
select B.brand_name, AVG(A.list_price) [AVG]
from production.products A, production.brands B
where A.brand_id=B.brand_id
group by B.brand_name

SELECT DISTINCT B.brand_name, AVG(list_price) OVER(PARTITION BY B.brand_name) AS avg_price
FROM production.products A, production.brands B
where A.brand_id=B.brand_id

--- based on bran_id

SELECT brand_id, AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id;

SELECT DISTINCT brand_id, AVG(list_price) OVER(PARTITION BY brand_id) AS avg_price
FROM production.products

-- 1. ANALYTIC AGGREGATE FUNCTIONS --

-- MIN() -MAX() - AVG() - SUM() - COUNT()

-- Tüm bisikletler arasýnda en ucuz bisikletin fiyatý

SELECT TOP 1 product_name, MIN(list_price) OVER()
FROM production.products

SELECT	DISTINCT TOP 1 brand_id,MIN(list_price) OVER (PARTITION BY brand_id) min_price
FROM	production.products
ORDER BY min_price

-- Herbir kategorideki en ucuz bisikletin fiyatý

SELECT	DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id) 
FROM	production.products

-- Products tablosunda kaç farklý bisiklet var

SELECT DISTINCT COUNT(product_id) OVER() AS num_of_bayk
FROM production.products

-- oder items tablosunda toplam kaç farklý bisiklet var

SELECT COUNT(DISTINCT product_id)
FROM sales.order_items

SELECT DISTINCT COUNT(product_id) OVER() AS num_of_bike
FROM (
	  SELECT distinct product_id
	  FROM sales.order_items
	  ) AS A


-- Herbir kategoride toplam kaç farklý bisikletin bulunduðu

SELECT DISTINCT category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products


-- Herbir kategorideki herbir  markada kaç farklý bisikletin bulunduðu

SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products

-- WF ile tek select'te herbir kategoride kaç farklý marka olduðunu hesaplayabilir misiniz?


SELECT	category_id, count (DISTINCT brand_id)
FROM	production.products
GROUP BY category_id

--Group by ile

SELECT DISTINCT category_id, COUNT(distinct brand_id) 
FROM production.products
group by category_id

---WF ile
SELECT DISTINCT category_id, COUNT(brand_id) OVER(PARTITION BY category_id)
FROM (
	  SELECT DISTINCT category_id, brand_id
	  FROM production.products
	  ) AS A


---- 2. ANALYTIC NAVIGATION FUNCTIONS

--first_value() - last_value() - lead() - lag()

--Order tablosuna aþaðýdaki gibi yeni bir sütun ekleyiniz:
--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)

SELECT *, LAG(order_date, 1) OVER(PARTITION BY staff_id ORDER BY order_date, order_id) AS prev_order_date
FROM sales.orders -- Personele göre demeseydi partititon by hesaba katýlmazdý


SELECT *, LAG(order_date, 1) OVER(ORDER BY order_date, order_id) AS prev_order_date
FROM sales.orders

--1. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)

SELECT	*, LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

--

SELECT	*, LEAD(order_date, 2) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

----------------------

-- Window Frame

SELECT category_id, product_id, 
	   COUNT(*) OVER() AS TOT_ROW   
FROM production.products

--

SELECT DISTINCT category_id, product_id, 
	   COUNT(*) OVER() AS total_row,
	   COUNT(*) OVER(PARTITION BY category_id) AS num_of_row,
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) AS num_of_row --- kumulatif toplam icin order by gerekiyor
FROM production.products

--

SELECT category_id,
	   COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS prev_with_current
FROM production.products  ----current row a kadar tum oncekileri getiriyor

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
---Burda son satirdan current row a kadar azalan sekilde getirmesini bekliyorduk getirmedi assagida order by ile sagladik

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
order by category_id,product_id --- order by ile current row unbounded following geldi.

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id  

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products												--- 1 onceki satir current ve 1 sonrakini baz aliyor
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products           ---- 2 onceki current ve 3 sonrakini baz aliyor(ortada ise 6 dondurur)
ORDER BY	category_id, product_id

--
select
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id

--

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)
SELECT	distinct FIRST_VALUE(product_name) OVER ( ORDER BY list_price)
FROM	production.products

--ürünün yanýna list price' ýný nasýl eklersiniz?

SELECT	 DISTINCT FIRST_VALUE(product_name) OVER ( ORDER BY list_price) , min (list_price) over ()
FROM	production.products


--2. Herbir kategorideki en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)

select distinct category_id, FIRST_VALUE(product_name) over (partition by category_id order by list_price)
from production.products


--3. Tüm bisikletler arasýnda en ucuz bisikletin adý (LAST_VALUE fonksiyonunu kullanýnýz)

---last_value fonk first value dan farkli olarak partition by veya windows frame istiyor alttaki ornekteki gibi

SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products


-- 3. ANALYTIC NUMBERING FUNCTIONS --

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()

--1. Herbir kategori içinde bisikletlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)

SELECT  category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products

--2. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)

SELECT category_id, list_price,
	  ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
	  RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM production.products

--3. Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (DENSE_RANK fonksiyonunu kullanýnýz)

SELECT category_id, list_price,
	  ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
	  RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
	  DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM production.products


--4. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (CUME_DIST fonksiyonunu kullanýnýz)
--5. Herbir kategori içinde bisikletierin fiyatlarýna göre bulunduklarý yüzdelik dilimleri yazdýrýnýz. (PERCENT_RANK fonksiyonunu kullanýnýz)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products

--6. Herbir kategorideki bisikletleri artan fiyata göre 4 gruba ayýrýn. Mümkünse her grupta ayný sayýda bisiklet olacak.
--(NTILE fonksiyonunu kullanýnýz)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM, ---partition by a gore row number atiyor
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM, ---- ayni degerleri yazdiktan sonra diger row u row number a gore atiyor
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,--- row number a kaldigi yerden atiyor
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST, ---max degere 1 verip ona gore kalanlari atiyor
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,---min deger 0 kalanlar ona gore ve tekrar edenler 1 kere hesaba katiliyor
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil ---RFM analizindeki qcut() gibi istedigin range gore atiyor
FROM	production.products


---- row number ile atama yaptiktan sonra onu getirmek icin:

select *
from (SELECT  category_id,list_price,
	   ROW_NUMBER () OVER( order by list_price) AS rn ---analytic numbering function row_number da order by kullanimi zorunlu
FROM production.products) as t --- CTE ile atama yaparken alias vermek zorundasin as t gibi
where rn=1

--- partition by ile categorideki en ucuz urunlerin listesi subquery ile

select *
from (SELECT  category_id,list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS rn
FROM production.products) as t
where rn=1

---with C(common) T(table) E(expression) 

with T1 as 
(select *
from (SELECT  category_id,list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS rn
FROM production.products) as t
)
select *
from T1
where rn=1

---assgidaki siralamaya gore sorgu calistigi icin Select de kullandigimiz analytic numbering function row number gibi yeni bir girdi olarak 
---islem gorurken once where sartini saglayip akabinde select i check ediyor. O yuzden subquery veya CTE ile oncelikli hale getirip where kullaniyoruz
---Yukaridaki ornekteki gibi


---Priorities in SQL
--FROM
--ON
--JOIN
--WHERE
--GROUP BY
--WITH CUBE/ROLLUP
--HAVING
--SELECT
--DISTINCT
--ORDER BY
--TOP
---OFFSET/FETCH





