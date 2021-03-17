

----------------STORED PROCEDURE------------------------------------------------------
------SP1(Insert SP)
-----�rnek 1)tblIlac tablosuna ad� parol olan ve etken maddesi parasetemol olan ila� ekleyen stored prosedure
 create or alter procedure YeniIlac(
       @ad CHAR(50),
       @etken_maddeler CHAR(50)
	   ) 
	   as
	   begin
	   insert into tblIlac(Ad, Etken_Maddeler) values(@ad, @etken_maddeler)
	   end
----�al��t�rmak i�in sql c�mlesi
	   exec YeniIlac 'Parol', 'parasetamol'
---kontrol edildi
	   select * from tblIlac


------SP1(Insert SP)
---------�rnek 2)sp ile tblTeshis tablosuna te�hisin varl���n� kontrol ederek veri insert etme.(INSERT SP)
IF OBJECT_ID ('dbo.Te�hisEkleme') IS NOT NULL
BEGIN 
	DROP PROCEDURE Te�hisEkleme
	END
GO
CREATE OR ALTER PROCEDURE Te�hisEkleme (@teshis char(50),@randevuid INT)
AS
IF EXISTS(SELECT * FROM tblTeshis T WHERE T.�sim=@teshis ) BEGIN
PRINT 'Te�his kay�d� mevcuttur.' END
ELSE BEGIN  
INSERT INTO tblTeshis VALUES (@teshis,@randevuid)
END;
EXEC Te�hisEkleme 'Kulak A�r�s�','17'
GO


------SP2(Update SP)(TRIGGERDA KULLANILACAK SP ��LEM�)
------�rnek 3) personeller tablosundan Id si 1 olan personelin ad�n�  g�ncelleyen stored procedure
create or alter procedure sp_YeniPerr(
@id int=1,
@ad CHAR(50)
)
as
begin
update tblPersonel set �sim = @ad  where Id = @id
end
----�al��t�rmak i�in sql c�mlesi
exec sp_YeniPerr 1,'Hamdiyye'
----kontrol
select * from tblPersonel


------SP2(Update SP)
----�rnek 4) personeller tablosundan Id si 1 olan personelin ad�n� ve soyad�n� g�ncelle stored procedure
create or alter procedure sp_YeniPer(
@id int,
@ad CHAR(50),
@soyad CHAR(50)
)
as
begin
update tblPersonel set �sim = @ad, Soyisim = @soyad where Id = @id
end
----�al��t�rmak i�in sql c�mlesi
exec sp_YeniPer 1, 'Hamdi', 'Cemai'
----kontrol
select * from tblPersonel


------SP2(Update SP)
-----�rnek 5)sp ile 2018 Ocak ay�nda en �ok te�his konulan 3 hastal���n ad�n� Ruhsal Bunal�m olarak de�i�tiriniz.(UPDATE SP)
IF OBJECT_ID ('dbo.RuhsalBunal�m') IS NOT NULL
BEGIN 
	DROP PROCEDURE RuhsalBunal�m
	END
GO
CREATE OR ALTER PROCEDURE RuhsalBunal�m( @Teshis char (50))AS
update tblTeshis SET �sim=@Teshis where �sim IN(
select TOP 3 �sim from tblRandevu R Inner JOIN tblTeshis T
	on R.Id=T.RandevuId where  Tarih>'2017-12-31' and Tarih<'2018-02-01' 
	Group by �sim  
	Order by Count (�sim) DESC )

EXEC RuhsalBunal�m'Ruhsal Bunal�m'
GO

------SP2(Update SP)
------�rnek 6)sp ile Adana'daki hastanelerde bulunan Diyetisyen doktorlar�n�n verdi�i ila�lar�n s�resini g�nde 2 kez olarak g�ncelleyiniz.(UPDATE SP)
 IF OBJECT_ID ('dbo.DozMiktar�') IS NOT NULL
BEGIN 
	DROP PROCEDURE DozMiktar�
	END
GO
 CREATE OR ALTER PROCEDURE DozMiktar�( @Miktar char (50))AS
 update tblReceteIlaclar� SET M�ktar=@Miktar
 where IlacId IN (
 (select IlacId from tblReceteIlaclar� where ReceteId IN(
	 select Id from tblRecete where PersonelId =(
		 select P.Id from tblPersonel P Inner Join tblBolum B
		 on P.BolumId=B.Id  where B.Ad='Diyetisyen' and P.HastaneId IN(
			 select Id from tblHastane where IlId IN(
			 select Id from tblIl where �sim='Adana'))))))

EXEC DozMiktar�'G�nde 2 Kez'
GO


------SP2(Update SP)
-----�rnek 7)sp ile Mide Yanmas� Randevusuna Sahip Kullan�c�lar�n Te�hisini Refl� olarak g�ncelleyiniz.(UPDATE SP)
 IF OBJECT_ID ('dbo.teshisg�ncelleme') IS NOT NULL
BEGIN 
	DROP PROCEDURE teshisg�ncelleme
	END
GO
create or alter procedure teshisg�ncelleme (@teshis char (50))
as 
update tblTeshis set �sim=@teshis
where  Id  IN (
	select T.Id from tblTeshis T Inner join tblRandevuTeshisleri RT On 
	T.Id=RT.TeshisId INNER JOIN tblRandevu R ON RT.RandevuId=R.Id
	WHERE  R.Ac�klama ='Mide Yanmas�'
)
EXEC teshisg�ncelleme 'Refl�'



------SP2(Update SP)
-----�rnek 8) Bu prosed�r parametrelere g�re yeni randevu bilgilerini g�ncellemeye olanak sa�lar.(UPDATE)
CREATE PROCEDURE spYyeniRandevuyuG�ncelle (

@tarih DATE ,
@saat TIME 
)
AS
BEGIN
UPDATE tblRandevu 
SET 

tarih = @Tarih,
saat = @Saat
END
GO
-- Update i�lemi yapan prosed�r�n �al��t�r�lmas�.
EXEC spYyeniRandevuyuG�ncelle  '2018-01-01', '11:14'

------SP3(Delete SP)
------�rnek 9)personellerden Id si 21 olan personeli silen stored prosedure
create or alter procedure sp_personelsil(
@id int
)
as
begin
delete from tblPersonel where Id = @id
end
----�al��t�rma c�mlesi
EXECUTE sp_personelsil 21
---kontrol
select * from tblPersonel


------SP3(Delete SP)
------�rnek 10)Amasya ilindeki kullan�c�lar�n te�hisini silen sorguyu Stored Procedere ile  yaz�n�z.(DELETE SP)
IF OBJECT_ID ('dbo.SehreG�reTe�hisSilme') IS NOT NULL
BEGIN 
	DROP PROCEDURE SehreG�reTe�hisSilme
	END
GO
CREATE OR ALTER PROCEDURE SehreG�reTe�hisSilme(@�sim CHAR(50)) AS
delete from tblTeshis
where Id in (select T.Id from tblTeshis T
              where exists(
				  select * from tblTeshis X
				  inner join tblRandevu R on R.Id = X.RandevuId
				  inner join tblKullan�c� K on K.Id =R.Kullan�c�Id
				  inner join tblIl I on I.Id= K.IlId
				  where I.�sim= @�sim and X.RandevuId= R.Kullan�c�Id
				  group by Kullan�c�Id ) )

EXEC SehreG�reTe�hisSilme 'Amasya'
GO


------SP3(Delete SP)
------�rnek 11)id si 01 olan randevular�n randevu te�hislerini silen sorguyu storedprocedure ile yaz�n�z.(DELETE SP)
IF OBJECT_ID ('dbo.RandevuTeshisSilme') IS NOT NULL
BEGIN 
	DROP PROCEDURE RandevuTeshisSilme
	END
GO
CREATE OR ALTER PROCEDURE RandevuTeshisSilme(@RandevuId CHAR(50)) AS
delete from tblRandevuTeshisleri
where Id in (select Ra.Id 
             from tblRandevuTeshisleri Ra
              where exists(
				  select * from tblRandevuTeshisleri X
				  inner join tblRandevu R on R.Id =X.RandevuId
				  where R.Id=@RandevuId and X.Id = R.Id
				  group by RandevuId ))

EXEC RandevuTeshisSilme '01'
GO


------SP3(Delete SP)
-----�rnek 12) Prosed�r�n mevcutsa silinmesi
IF OBJECT_ID ('spHastanePersonelSilme') IS NOT NULL
	BEGIN
		DROP PROCEDURE spHastanePersonelSilme
	END
GO
-- Bu prosed�r Id'si 04 olan hastanelerdeki personelleri silme i�lemi ger�ekle�tirir. (DELETE)
CREATE PROCEDURE spHastanePersonelSilme (
@hastaneId char(50)
)
as
DELETE FROM tblPersonel WHERE Id 
IN(SELECT P.Id FROM tblPersonel P where exists
(select * from tblPersonel X inner join tblHastane H on H.Id=X.HastaneId
where H.Id=@hastaneId and X.Id=H.Id
group by HastaneId))
EXEC spHastanePersonelSilme '04'
GO

------SP4(CURSOR SP) Bir ile ait hastan�n isim ve adresini yan yana yazd�ran stored procedure
-----�rnek 13)girdi olarak bir ilin id si girilecek
CREATE OR ALTER PROCEDURE sp_opp
(
@il VARCHAR(100)
)
AS 
BEGIN
DECLARE @isimler VARCHAR(100), @adresler VARCHAR(100)
DECLARE curya CURSOR FOR
SELECT  K.�sim as hasta_ad, K.Adres as hasta_adres from tblTeshis T 
	inner join tblRandevu R on R.Id = T.RandevuId
	inner join tblKullan�c� K on K.Id = R.Kullan�c�Id
	inner join tblIl I on I.Id = K.IlId
	WHERE I.Id = @il
	OPEN curya
	FETCH NEXT FROM curya INTO @isimler, @adresler
	WHILE @@FETCH_STATUS =0 
	BEGIN
	 DECLARE @statement VARCHAR(1000)
	 PRINT @isimler +' '+ @adresler
 FETCH NEXT FROM curya INTO @isimler, @adresler
 END
 CLOSE curya
 DEALLOCATE curya
 END
						
GO
--testler burada yap�lacak
EXEC sp_opp 8
GO


------SP4(CURSOR SP)
 -----�rnek 14)Spcursor Kullanarak �lac ad� Arveles olan verilerin etken maddesini Trometamol olarak g�ncelleyiniz.(CURSOR SP)
  IF OBJECT_ID ('dbo.EtkenMadde') IS NOT NULL
BEGIN 
	DROP PROCEDURE EtkenMadde
	END
GO
 CREATE OR ALTER PROCEDURE EtkenMadde( @Ilacisim char (50))AS

  DECLARE @Ilaccursor CURSOR 
  SET @Ilaccursor = CURSOR FOR 
        SELECT Ad FROM tblIlac

  OPEN @Ilaccursor
  FETCH NEXT FROM @Ilaccursor INTO @Ilacisim

  SELECT Ad FROM tblIlac

  WHILE ( @@FETCH_STATUS = 0) 
  BEGIN 
        IF @Ilacisim ='Arveles'
              UPDATE tblIlac SET Etken_Maddeler ='Trometamol'
              WHERE CURRENT OF @Ilaccursor
        
  FETCH NEXT FROM @Ilaccursor INTO @Ilacisim
  END

  SELECT Ad FROM tblIlac

  CLOSE @Ilaccursor

  DEALLOCATE @Ilaccursor

 EXEC EtkenMadde 'Arveles'
 

 ------SP4(CURSOR SP)
 ------�rnek 15)Cursor ile Procedure kullanarak kullan�c� �d,isim,soyisim ekrana yazd�rma.(CURSOR SP) 
 IF OBJECT_ID ('dbo.spKullan�c�Cursor') IS NOT NULL
BEGIN 
	DROP PROCEDURE spKullan�c�Cursor
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE spKullan�c�Cursor
AS
BEGIN
      SET NOCOUNT ON;
 
      
      DECLARE @Kullan�c�Id INT
             ,@isim VARCHAR(100)
             ,@soyisim VARCHAR(100)
 
     
      DECLARE @Counter INT
      SET @Counter = 1
 
     
      DECLARE PrintKullan�c� CURSOR READ_ONLY
      FOR
      SELECT K.Id,K.�sim,K.Soyisim
      FROM tblKullan�c� K
 
     
      OPEN PrintKullan�c�
 
      
      FETCH NEXT FROM PrintKullan�c� INTO
      @Kullan�c�Id, @isim, @soyisim
 
     
      WHILE @@FETCH_STATUS = 0
      BEGIN
             IF @Counter = 1
             BEGIN
                        PRINT 'Kullan�c�ID' + CHAR(9) + '�sim' + CHAR(9) + CHAR(9) + CHAR(9) + 'Soyisim'
                        PRINT '------------------------------------'
             END
 
           
             PRINT CAST(@Kullan�c�Id AS VARCHAR(10)) + CHAR(9) + CHAR(9) + CHAR(9) + @isim + CHAR(9) + @soyisim
    
             
             SET @Counter = @Counter + 1
 
          
             FETCH NEXT FROM PrintKullan�c� INTO
             @Kullan�c�Id, @isim, @soyisim
      END
 
    
      CLOSE PrintKullan�c�
      DEALLOCATE PrintKullan�c�
END
GO

Exec spKullan�c�Cursor


------SP5(Select SP)
------�rnek 16)  hastane Id si 5  ve ismi B��ra olan personelerin adres bilgilerini, hangi hastanede ve hastanedeki b�l�m�n �d sini getiren stored prosedure
create or alter procedure sp_personelli(
@id int,
@ad CHAR(50))
as
begin
select P.Adres as personel_adres, H.�sim as hastane_isim, Hb.Id as hastane_bolum_id  from tblPersonel P 
inner join tblHastane H on P.HastaneId = H.Id 
inner join tblHastaneB�l�mleri Hb on H.Id = HB.HastaneId
where P.HastaneId = @id and P.�sim = @ad
end
---�al��t�rma c�mlesi
exec sp_personelli 5, 'B��ra'



------SP5(Select SP)
----�rnek 17) hastane Id si 5 olan personelleri getiren stored prosedure
create or alter procedure sp_perso
as
select * from tblPersonel
where HastaneId=5
go
---�al��t�rma c�mlesi
exec sp_perso


------SP(SELECT SP)
-----�rnek 18)Verilen bir tarih aral���nda en �ok g�rev yapan 3 Personel bilgisi (select stored procedure)(SELECT SP)
IF OBJECT_ID ('dbo.En�okG�revAlan3Personel') IS NOT NULL
BEGIN 
	DROP PROCEDURE En�okG�revAlan3Personel
	END
GO
CREATE OR ALTER PROCEDURE En�okG�revAlan3Personel (@Tarih1 DATE ,@Tarih2 DATE ) AS 
SELECT TOP 3
P.Id
FROM tblPersonel P INNER JOIN tblRandevu R ON P.Id=R.PersonelId
WHERE R.Tarih BETWEEN @Tarih1 and @Tarih2
GROUP BY P.Id
GO
EXEC En�okG�revAlan3Personel '2019-01-01','2019-05-01'