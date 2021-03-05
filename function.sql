
----------FONKSÝYONLAR-----------------------------------------------------------------------------------------------------------
-----örnek 1) tblBolum tablosundaki Ad kýsmýndaki yazýlarýn hepsini büyük harfe yazan fonksiyon
CREATE OR ALTER FUNCTION harflerbuyuk(@deger varchar(55))
RETURNS varchar(55)
BEGIN
RETURN UPPER (@deger)
END
--Fonksiyon testi
SELECT dbo.harflerbuyuk(Ad) FROM tblBolum



-----örnek 2) ayný hastalýktan dolayý alýnan kaç randevu olduðunu sayan fonksiyon
CREATE OR ALTER FUNCTION cýkansayi(@girilenacýklama varchar(55))
RETURNS INT
AS
BEGIN
DECLARE @sayi INT
SELECT @sayi=COUNT(Acýklama) FROM tblRandevu WHERE Acýklama=@girilenacýklama
RETURN @sayi
END
--Fonksiyon testi
SELECT dbo.cýkansayi('Aþýrý kilo alýmý')



------örnek 3)Verilen Kullanýcýnýn Randevu Tarihini Gösteren Fonksiyon
IF OBJECT_ID ('dbo.KullaniciRandevuDetay') IS NOT NULL
BEGIN 
	DROP FUNCTION KullaniciRandevuDetay
	END
GO
CREATE OR ALTER FUNCTION KullaniciRandevuDetay( @KullanýcýID INT ) 
RETURNS TABLE AS RETURN ( 
SELECT K.Id, K.Ýsim,K.Soyisim , R.Tarih
FROM tblKullanýcý K INNER JOIN tblRandevu R ON R.KullanýcýId = K.Id 
WHERE K.Id = @KullanýcýID)
--Fonksiyon testi
SELECT * FROM dbo.KullaniciRandevuDetay('8') 


-----örnek 4) Verilen tarihte (yýl-ay formatýnda) en çok teþhis konulan hastalýðý gösteren fonksiyonu 
IF OBJECT_ID ('dbo.HastalýkTeshisÝ') IS NOT NULL
BEGIN 
	DROP FUNCTION HastalýkTeshisÝ
	END
GO
CREATE OR ALTER FUNCTION HastalýkTeshisÝ( @Tarih VARCHAR(50) ) 
RETURNS TABLE AS RETURN (
SELECT  TOP 1 Ýsim, COUNT(*) AS Toplam FROM tblRandevu R INNER JOIN tblTeshis T
ON R.Id=T.RandevuId WHERE R.Tarih= @Tarih  
GROUP BY Ýsim  
ORDER BY Count (*) DESC)
--Fonksiyon testi
SELECT * FROM dbo.HastalýkTeshisÝ('2019-01-05')


 -----örnek 5)Reçetede Yazýlan bir Ýlacýn Miktarýný Belirten Fonksiyon.
IF OBJECT_ID ('dbo.ÝlacMiktarý') IS NOT NULL
BEGIN 
	DROP FUNCTION dbo.ÝlacMiktarý
	END
GO
CREATE OR ALTER FUNCTION dbo.ÝlacMiktarý (@Id INT) 
RETURNS VARCHAR(50) 
AS 
BEGIN 
	RETURN (SELECT Mýktar FROM tblReceteIlaclarý
	WHERE ReceteId=@Id) 
END
--Fonksiyon Testi
PRINT dbo.ÝlacMiktarý('1'); --Günlük 2 tablet



-----örnek 6)Bir günde kaç randevu alýndýðýný belirten fonksiyon.
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
PRINT dbo.KacRandevu('2019-03-01'); --3 tane randevu alýnmýþtýr.
PRINT dbo.KacRandevu('2019-01-01'); --2 tane randevu alýnmýþtýr.





------örnek 7)Fonksiyon bir randevu id si alýr ve bu id si verilen randevunun verildiði tüm hastalar,randevu açýklamasý
IF OBJECT_ID('dbo.RandevuVerilenHastalarýDondur') IS NOT NULL
	BEGIN
		DROP FUNCTION RandevuVerilenHastalarýDondur
	END
GO
CREATE OR ALTER FUNCTION dbo.RandevuVerilenHastalarýDondur (@RandevuId INT)
RETURNS TABLE
AS
RETURN (
	SELECT K.Ýsim as Hasta_Adý,R.Acýklama 
	FROM tblKullanýcý K inner join tblRandevu R
	ON K.Id =R.KullanýcýId 
	where R.Id=@RandevuId
)
GO
--Fonksiyon testi
Select * from dbo.RandevuVerilenHastalarýDondur(2)