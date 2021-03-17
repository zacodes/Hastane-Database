
----------VÝEW-----------------------------------------------------------------------------------------------------------------------------------

-----örnek 1)Tahlilin adýnýn ve içeriðinin ne olduðunu gösteren bir view oluþturunuz.
IF OBJECT_ID ('dbo.vwTahlilÝcerikleri') IS NOT NULL
BEGIN 
	DROP VIEW vwTahlilÝcerikleri 
	END
GO
CREATE OR ALTER VIEW vwTahlilÝcerikleri  AS 
SELECT T.Ýsim,Ý.Ad FROM tblIcerik Ý INNER JOIN
tblTahlil T ON Ý.TahlilId = T.Id INNER JOIN 
tblRandevuTahlilleri RT ON RT.TahlilId =T.Id INNER JOIN 
tblRandevuÝcerikleri RÝ ON RÝ.IcerikId =Ý.Id 
--Oluþtrulan viewin gösterilmesi
Select * from vwTahlilÝcerikleri
--Oluþturulan viewin join ile test edilmesi
SELECT T.Ýsim,Ý.Ad FROM tblIcerik Ý INNER JOIN
tblTahlil T ON Ý.TahlilId = T.Id INNER JOIN 
tblRandevuTahlilleri RT ON RT.TahlilId =T.Id INNER JOIN 
tblRandevuÝcerikleri RÝ ON RÝ.IcerikId =Ý.Id 
where t.Id ='3'



--------örnek 2) En az sayýda baþvurulan bölümün, en çok baþvurulduðu hastaneyle ayný ilde olan ve
--------randevu alýp gitmeyen kullanýcýlarýn olup olmadýðýný kontrol eden view  

IF OBJECT_ID ('dbo.vwRandevuDurumu') IS NOT NULL
BEGIN 
	DROP VIEW vwRandevuDurumu 
	END
GO
CREATE OR ALTER VIEW vwRandevuDurumu  AS 
SELECT * FROM tblRandevu WHERE Durum='0' and KullanýcýId IN(
SELECT Id FROM tblKullanýcý WHERE IlId IN(
SELECT IlId FROM tblHastane WHERE Id=(
SELECT top 1 HastaneId FROM tblRandevu WHERE BolumId=(
	SELECT TOP 1 BolumId --, count(BolumId) as ToplamRandevu 
	FROM tblRandevu
	GROUP BY  BolumId
	ORDER BY count(Id) ASC
)
GROUP BY HastaneId
ORDER BY COUNT(Id) DESC )))
--Oluþtrulan viewin gösterilmesi
SELECT * FROM vwRandevuDurumu


------örnek 3)  kullanýcýlardan soyismi A ile baþlayan hastanýn ismini soyismini ve hangi hastalýklardan teþhiþ konulduðunu getiren view
create or alter view dbo.kullanýcýteshis
as
select K.Ýsim as hasta_ad, K.Soyisim as hasta_soyad, T.Ýsim as hasta_teshis from tblTeshis T 
inner join tblRandevu R on R.Id = T.RandevuId
inner join tblKullanýcý K on K.Id = R.KullanýcýId
inner join tblIl I on I.Id = K.IlId
go
select * from kullanýcýteshis where hasta_soyad like 'A%'
go



-------örnek 4)  teshisi obezite baþlangýcý olan kullanýcýyý view ile getirme
create or alter view dbo.vHastalarr 
as
select K.Id as hasta_id, K.Ýsim as hasta_adý, K.Soyisim as hasta_soyadý, K.Tel as hasta_telefonu, T.Ýsim as tesih_isim
from tblTeshis T 
inner join tblRandevu R on R.Id = T.RandevuId
inner join tblKullanýcý K on K.Id = R.KullanýcýId
GO
select * from vHastalarr where tesih_isim='Obezite baþlangýcý'
GO