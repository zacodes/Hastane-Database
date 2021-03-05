
----------FONKS�YONLAR-----------------------------------------------------------------------------------------------------------
-----�rnek 1) tblBolum tablosundaki Ad k�sm�ndaki yaz�lar�n hepsini b�y�k harfe yazan fonksiyon
CREATE OR ALTER FUNCTION harflerbuyuk(@deger varchar(55))
RETURNS varchar(55)
BEGIN
RETURN UPPER (@deger)
END
--Fonksiyon testi
SELECT dbo.harflerbuyuk(Ad) FROM tblBolum



-----�rnek 2) ayn� hastal�ktan dolay� al�nan ka� randevu oldu�unu sayan fonksiyon
CREATE OR ALTER FUNCTION c�kansayi(@girilenac�klama varchar(55))
RETURNS INT
AS
BEGIN
DECLARE @sayi INT
SELECT @sayi=COUNT(Ac�klama) FROM tblRandevu WHERE Ac�klama=@girilenac�klama
RETURN @sayi
END
--Fonksiyon testi
SELECT dbo.c�kansayi('A��r� kilo al�m�')



------�rnek 3)Verilen Kullan�c�n�n Randevu Tarihini G�steren Fonksiyon
IF OBJECT_ID ('dbo.KullaniciRandevuDetay') IS NOT NULL
BEGIN 
	DROP FUNCTION KullaniciRandevuDetay
	END
GO
CREATE OR ALTER FUNCTION KullaniciRandevuDetay( @Kullan�c�ID INT ) 
RETURNS TABLE AS RETURN ( 
SELECT K.Id, K.�sim,K.Soyisim , R.Tarih
FROM tblKullan�c� K INNER JOIN tblRandevu R ON R.Kullan�c�Id = K.Id 
WHERE K.Id = @Kullan�c�ID)
--Fonksiyon testi
SELECT * FROM dbo.KullaniciRandevuDetay('8') 


-----�rnek 4) Verilen tarihte (y�l-ay format�nda) en �ok te�his konulan hastal��� g�steren fonksiyonu 
IF OBJECT_ID ('dbo.Hastal�kTeshis�') IS NOT NULL
BEGIN 
	DROP FUNCTION Hastal�kTeshis�
	END
GO
CREATE OR ALTER FUNCTION Hastal�kTeshis�( @Tarih VARCHAR(50) ) 
RETURNS TABLE AS RETURN (
SELECT  TOP 1 �sim, COUNT(*) AS Toplam FROM tblRandevu R INNER JOIN tblTeshis T
ON R.Id=T.RandevuId WHERE R.Tarih= @Tarih  
GROUP BY �sim  
ORDER BY Count (*) DESC)
--Fonksiyon testi
SELECT * FROM dbo.Hastal�kTeshis�('2019-01-05')


 -----�rnek 5)Re�etede Yaz�lan bir �lac�n Miktar�n� Belirten Fonksiyon.
IF OBJECT_ID ('dbo.�lacMiktar�') IS NOT NULL
BEGIN 
	DROP FUNCTION dbo.�lacMiktar�
	END
GO
CREATE OR ALTER FUNCTION dbo.�lacMiktar� (@Id INT) 
RETURNS VARCHAR(50) 
AS 
BEGIN 
	RETURN (SELECT M�ktar FROM tblReceteIlaclar�
	WHERE ReceteId=@Id) 
END
--Fonksiyon Testi
PRINT dbo.�lacMiktar�('1'); --G�nl�k 2 tablet



-----�rnek 6)Bir g�nde ka� randevu al�nd���n� belirten fonksiyon.
IF OBJECT_ID ('dbo.KacRandevu') IS NOT NULL
BEGIN 
	DROP FUNCTION KacRandevu
	END
GO
CREATE OR ALTER FUNCTION KacRandevu (@Tarih DATE) 
RETURNS INT
AS 
BEGIN 
	RETURN (SELECT COUNT(*) FROM tblRandevu
	WHERE Tarih=@Tarih) 
END
--Fonksiyon testi
PRINT dbo.KacRandevu('2019-03-01'); --3 tane randevu al�nm��t�r.
PRINT dbo.KacRandevu('2019-01-01'); --2 tane randevu al�nm��t�r.





------�rnek 7)Fonksiyon bir randevu id si al�r ve bu id si verilen randevunun verildi�i t�m hastalar,randevu a��klamas�
IF OBJECT_ID('dbo.RandevuVerilenHastalar�Dondur') IS NOT NULL
	BEGIN
		DROP FUNCTION RandevuVerilenHastalar�Dondur
	END
GO
CREATE OR ALTER FUNCTION dbo.RandevuVerilenHastalar�Dondur (@RandevuId INT)
RETURNS TABLE
AS
RETURN (
	SELECT K.�sim as Hasta_Ad�,R.Ac�klama 
	FROM tblKullan�c� K inner join tblRandevu R
	ON K.Id =R.Kullan�c�Id 
	where R.Id=@RandevuId
)
GO
--Fonksiyon testi
Select * from dbo.RandevuVerilenHastalar�Dondur(2)