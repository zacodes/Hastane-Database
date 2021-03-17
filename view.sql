
----------V�EW-----------------------------------------------------------------------------------------------------------------------------------

-----�rnek 1)Tahlilin ad�n�n ve i�eri�inin ne oldu�unu g�steren bir view olu�turunuz.
IF OBJECT_ID ('dbo.vwTahlil�cerikleri') IS NOT NULL
BEGIN 
	DROP VIEW vwTahlil�cerikleri 
	END
GO
CREATE OR ALTER VIEW vwTahlil�cerikleri  AS 
SELECT T.�sim,�.Ad FROM tblIcerik � INNER JOIN
tblTahlil T ON �.TahlilId = T.Id INNER JOIN 
tblRandevuTahlilleri RT ON RT.TahlilId =T.Id INNER JOIN 
tblRandevu�cerikleri R� ON R�.IcerikId =�.Id 
--Olu�trulan viewin g�sterilmesi
Select * from vwTahlil�cerikleri
--Olu�turulan viewin join ile test edilmesi
SELECT T.�sim,�.Ad FROM tblIcerik � INNER JOIN
tblTahlil T ON �.TahlilId = T.Id INNER JOIN 
tblRandevuTahlilleri RT ON RT.TahlilId =T.Id INNER JOIN 
tblRandevu�cerikleri R� ON R�.IcerikId =�.Id 
where t.Id ='3'



--------�rnek 2) En az say�da ba�vurulan b�l�m�n, en �ok ba�vuruldu�u hastaneyle ayn� ilde olan ve
--------randevu al�p gitmeyen kullan�c�lar�n olup olmad���n� kontrol eden view  

IF OBJECT_ID ('dbo.vwRandevuDurumu') IS NOT NULL
BEGIN 
	DROP VIEW vwRandevuDurumu 
	END
GO
CREATE OR ALTER VIEW vwRandevuDurumu  AS 
SELECT * FROM tblRandevu WHERE Durum='0' and Kullan�c�Id IN(
SELECT Id FROM tblKullan�c� WHERE IlId IN(
SELECT IlId FROM tblHastane WHERE Id=(
SELECT top 1 HastaneId FROM tblRandevu WHERE BolumId=(
	SELECT TOP 1 BolumId --, count(BolumId) as ToplamRandevu 
	FROM tblRandevu
	GROUP BY  BolumId
	ORDER BY count(Id) ASC
)
GROUP BY HastaneId
ORDER BY COUNT(Id) DESC )))
--Olu�trulan viewin g�sterilmesi
SELECT * FROM vwRandevuDurumu


------�rnek 3)  kullan�c�lardan soyismi A ile ba�layan hastan�n ismini soyismini ve hangi hastal�klardan te�hi� konuldu�unu getiren view
create or alter view dbo.kullan�c�teshis
as
select K.�sim as hasta_ad, K.Soyisim as hasta_soyad, T.�sim as hasta_teshis from tblTeshis T 
inner join tblRandevu R on R.Id = T.RandevuId
inner join tblKullan�c� K on K.Id = R.Kullan�c�Id
inner join tblIl I on I.Id = K.IlId
go
select * from kullan�c�teshis where hasta_soyad like 'A%'
go



-------�rnek 4)  teshisi obezite ba�lang�c� olan kullan�c�y� view ile getirme
create or alter view dbo.vHastalarr 
as
select K.Id as hasta_id, K.�sim as hasta_ad�, K.Soyisim as hasta_soyad�, K.Tel as hasta_telefonu, T.�sim as tesih_isim
from tblTeshis T 
inner join tblRandevu R on R.Id = T.RandevuId
inner join tblKullan�c� K on K.Id = R.Kullan�c�Id
GO
select * from vHastalarr where tesih_isim='Obezite ba�lang�c�'
GO