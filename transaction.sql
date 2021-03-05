---------TRANSACTION--------------------------------------------------------------------------------------

------üstte bulunan SP Update örneði kullanýldý 
----örnek 1) personeller tablosundan Id si 1 olan personelin adýný ve soyadýný güncelle stored procedure transaction
create or alter procedure sp_YeniPer(
@id int,
@ad CHAR(50),
@soyad CHAR(50)
)
as
begin try
 begin transaction
 update tblPersonel set Ýsim = @ad, Soyisim = @soyad 
 where Id = @id
 commit
end try
begin catch
 print @@error + 'kodlu hata'
 rollback
 end catch
go

sp_YeniPer 1, 'Arzum', 'Oya'
-----kontrol edelim
select * from tblPersonel

--------örnek 2)En az randevuya giden hastanýn tahlil içeriklerine en az kullanýlan içeriði yazýnýz.
BEGIN TRANSACTION 
update tblRandevuÝcerikleri SET IcerikId = (
select TOP 1 IcerikId from tblRandevuÝcerikleri
group by IcerikId
order by count(Id)ASC) where IcerikId IN(
 select IcerikId from tblRandevuÝcerikleri where TahlilId IN(
	 select TahlilId from tblRandevuTahlilleri where RandevuId IN(
	 select Id from tblRandevu where KullanýcýId=(
		 select TOP 1 KullanýcýId from tblRandevu 
		 group by KullanýcýId
		 order by count(Id) ASC ))))
COMMIT TRANSACTION


---------örnek 3) Transaction Mide Yanmasý Randevusuna Sahip Kullanýcýlarýn Teþhisini Reflü olarak güncelleyiniz.
IF OBJECT_ID ('dbo.teshisgüncelleme ') IS NOT NULL
BEGIN 
	DROP PROCEDURE teshisgüncelleme
	END
GO
CREATE or Alter procedure teshisgüncelleme (@teshis char (50))
AS
BEGIN TRANSACTION T1
update tblTeshis set Ýsim=@teshis
where  Id  IN (
	select T.Id from tblTeshis T Inner join tblRandevuTeshisleri RT On 
	T.Id=RT.TeshisId INNER JOIN tblRandevu R ON RT.RandevuId=R.Id
	WHERE  R.Acýklama ='Mide Yanmasý'
)
If (@teshis='Reflü') COMMIT TRANSACTION T1;
ELSE ROLLBACK TRANSACTION T1;



------örnek 4) Bu prosedür parametrelere göre yeni randevu bilgilerini güncellemeye olanak saðlar.(TRANSACTION)
IF OBJECT_ID ('spYyeniRandevuyuGüncelle') IS NOT NULL
	BEGIN
		DROP PROCEDURE spYyeniRandevuyuGüncelle
	END
GO
CREATE OR ALTER PROCEDURE spYyeniRandevuyuGüncelle (

@tarih DATE ,
@saat TIME 
)
AS
BEGIN TRANSACTION T1
UPDATE tblRandevu 
SET 

tarih = @Tarih,
saat = @Saat
EXEC spYyeniRandevuyuGüncelle  '2018-01-01', '11:14'