---------TRANSACTION--------------------------------------------------------------------------------------

------�stte bulunan SP Update �rne�i kullan�ld� 
----�rnek 1) personeller tablosundan Id si 1 olan personelin ad�n� ve soyad�n� g�ncelle stored procedure transaction
create or alter procedure sp_YeniPer(
@id int,
@ad CHAR(50),
@soyad CHAR(50)
)
as
begin try
 begin transaction
 update tblPersonel set �sim = @ad, Soyisim = @soyad 
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

--------�rnek 2)En az randevuya giden hastan�n tahlil i�eriklerine en az kullan�lan i�eri�i yaz�n�z.
BEGIN TRANSACTION 
update tblRandevu�cerikleri SET IcerikId = (
select TOP 1 IcerikId from tblRandevu�cerikleri
group by IcerikId
order by count(Id)ASC) where IcerikId IN(
 select IcerikId from tblRandevu�cerikleri where TahlilId IN(
	 select TahlilId from tblRandevuTahlilleri where RandevuId IN(
	 select Id from tblRandevu where Kullan�c�Id=(
		 select TOP 1 Kullan�c�Id from tblRandevu 
		 group by Kullan�c�Id
		 order by count(Id) ASC ))))
COMMIT TRANSACTION


---------�rnek 3) Transaction Mide Yanmas� Randevusuna Sahip Kullan�c�lar�n Te�hisini Refl� olarak g�ncelleyiniz.
IF OBJECT_ID ('dbo.teshisg�ncelleme ') IS NOT NULL
BEGIN 
	DROP PROCEDURE teshisg�ncelleme
	END
GO
CREATE or Alter procedure teshisg�ncelleme (@teshis char (50))
AS
BEGIN TRANSACTION T1
update tblTeshis set �sim=@teshis
where  Id  IN (
	select T.Id from tblTeshis T Inner join tblRandevuTeshisleri RT On 
	T.Id=RT.TeshisId INNER JOIN tblRandevu R ON RT.RandevuId=R.Id
	WHERE  R.Ac�klama ='Mide Yanmas�'
)
If (@teshis='Refl�') COMMIT TRANSACTION T1;
ELSE ROLLBACK TRANSACTION T1;



------�rnek 4) Bu prosed�r parametrelere g�re yeni randevu bilgilerini g�ncellemeye olanak sa�lar.(TRANSACTION)
IF OBJECT_ID ('spYyeniRandevuyuG�ncelle') IS NOT NULL
	BEGIN
		DROP PROCEDURE spYyeniRandevuyuG�ncelle
	END
GO
CREATE OR ALTER PROCEDURE spYyeniRandevuyuG�ncelle (

@tarih DATE ,
@saat TIME 
)
AS
BEGIN TRANSACTION T1
UPDATE tblRandevu 
SET 

tarih = @Tarih,
saat = @Saat
EXEC spYyeniRandevuyuG�ncelle  '2018-01-01', '11:14'