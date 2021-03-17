

----------------STORED PROCEDURE------------------------------------------------------
------SP1(Insert SP)
-----örnek 1)tblIlac tablosuna adı parol olan ve etken maddesi parasetemol olan ilaç ekleyen stored prosedure
 create or alter procedure YeniIlac(
       @ad CHAR(50),
       @etken_maddeler CHAR(50)
	   ) 
	   as
	   begin
	   insert into tblIlac(Ad, Etken_Maddeler) values(@ad, @etken_maddeler)
	   end
----çalıştırmak için sql cümlesi
	   exec YeniIlac 'Parol', 'parasetamol'
---kontrol edildi
	   select * from tblIlac


------SP1(Insert SP)
---------örnek 2)sp ile tblTeshis tablosuna teşhisin varlığını kontrol ederek veri insert etme.(INSERT SP)
IF OBJECT_ID ('dbo.TeşhisEkleme') IS NOT NULL
BEGIN 
	DROP PROCEDURE TeşhisEkleme
	END
GO
CREATE OR ALTER PROCEDURE TeşhisEkleme (@teshis char(50),@randevuid INT)
AS
IF EXISTS(SELECT * FROM tblTeshis T WHERE T.İsim=@teshis ) BEGIN
PRINT 'Teşhis kayıdı mevcuttur.' END
ELSE BEGIN  
INSERT INTO tblTeshis VALUES (@teshis,@randevuid)
END;
EXEC TeşhisEkleme 'Kulak Ağrısı','17'
GO


------SP2(Update SP)(TRIGGERDA KULLANILACAK SP İŞLEMİ)
------örnek 3) personeller tablosundan Id si 1 olan personelin adını  güncelleyen stored procedure
create or alter procedure sp_YeniPerr(
@id int=1,
@ad CHAR(50)
)
as
begin
update tblPersonel set İsim = @ad  where Id = @id
end
----çalıştırmak için sql cümlesi
exec sp_YeniPerr 1,'Hamdiyye'
----kontrol
select * from tblPersonel


------SP2(Update SP)
----örnek 4) personeller tablosundan Id si 1 olan personelin adını ve soyadını güncelle stored procedure
create or alter procedure sp_YeniPer(
@id int,
@ad CHAR(50),
@soyad CHAR(50)
)
as
begin
update tblPersonel set İsim = @ad, Soyisim = @soyad where Id = @id
end
----çalıştırmak için sql cümlesi
exec sp_YeniPer 1, 'Hamdi', 'Cemai'
----kontrol
select * from tblPersonel


------SP2(Update SP)
-----örnek 5)sp ile 2018 Ocak ayında en çok teşhis konulan 3 hastalığın adını Ruhsal Bunalım olarak değiştiriniz.(UPDATE SP)
IF OBJECT_ID ('dbo.RuhsalBunalım') IS NOT NULL
BEGIN 
	DROP PROCEDURE RuhsalBunalım
	END
GO
CREATE OR ALTER PROCEDURE RuhsalBunalım( @Teshis char (50))AS
update tblTeshis SET İsim=@Teshis where İsim IN(
select TOP 3 İsim from tblRandevu R Inner JOIN tblTeshis T
	on R.Id=T.RandevuId where  Tarih>'2017-12-31' and Tarih<'2018-02-01' 
	Group by İsim  
	Order by Count (İsim) DESC )

EXEC RuhsalBunalım'Ruhsal Bunalım'
GO

------SP2(Update SP)
------örnek 6)sp ile Adana'daki hastanelerde bulunan Diyetisyen doktorlarının verdiği ilaçların süresini günde 2 kez olarak güncelleyiniz.(UPDATE SP)
 IF OBJECT_ID ('dbo.DozMiktarı') IS NOT NULL
BEGIN 
	DROP PROCEDURE DozMiktarı
	END
GO
 CREATE OR ALTER PROCEDURE DozMiktarı( @Miktar char (50))AS
 update tblReceteIlacları SET Mıktar=@Miktar
 where IlacId IN (
 (select IlacId from tblReceteIlacları where ReceteId IN(
	 select Id from tblRecete where PersonelId =(
		 select P.Id from tblPersonel P Inner Join tblBolum B
		 on P.BolumId=B.Id  where B.Ad='Diyetisyen' and P.HastaneId IN(
			 select Id from tblHastane where IlId IN(
			 select Id from tblIl where İsim='Adana'))))))

EXEC DozMiktarı'Günde 2 Kez'
GO


------SP2(Update SP)
-----örnek 7)sp ile Mide Yanması Randevusuna Sahip Kullanıcıların Teşhisini Reflü olarak güncelleyiniz.(UPDATE SP)
 IF OBJECT_ID ('dbo.teshisgüncelleme') IS NOT NULL
BEGIN 
	DROP PROCEDURE teshisgüncelleme
	END
GO
create or alter procedure teshisgüncelleme (@teshis char (50))
as 
update tblTeshis set İsim=@teshis
where  Id  IN (
	select T.Id from tblTeshis T Inner join tblRandevuTeshisleri RT On 
	T.Id=RT.TeshisId INNER JOIN tblRandevu R ON RT.RandevuId=R.Id
	WHERE  R.Acıklama ='Mide Yanması'
)
EXEC teshisgüncelleme 'Reflü'



------SP2(Update SP)
-----örnek 8) Bu prosedür parametrelere göre yeni randevu bilgilerini güncellemeye olanak sağlar.(UPDATE)
CREATE PROCEDURE spYyeniRandevuyuGüncelle (

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
-- Update işlemi yapan prosedürün çalıştırılması.
EXEC spYyeniRandevuyuGüncelle  '2018-01-01', '11:14'

------SP3(Delete SP)
------örnek 9)personellerden Id si 21 olan personeli silen stored prosedure
create or alter procedure sp_personelsil(
@id int
)
as
begin
delete from tblPersonel where Id = @id
end
----çalıştırma cümlesi
EXECUTE sp_personelsil 21
---kontrol
select * from tblPersonel


------SP3(Delete SP)
------örnek 10)Amasya ilindeki kullanıcıların teşhisini silen sorguyu Stored Procedere ile  yazınız.(DELETE SP)
IF OBJECT_ID ('dbo.SehreGöreTeşhisSilme') IS NOT NULL
BEGIN 
	DROP PROCEDURE SehreGöreTeşhisSilme
	END
GO
CREATE OR ALTER PROCEDURE SehreGöreTeşhisSilme(@İsim CHAR(50)) AS
delete from tblTeshis
where Id in (select T.Id from tblTeshis T
              where exists(
				  select * from tblTeshis X
				  inner join tblRandevu R on R.Id = X.RandevuId
				  inner join tblKullanıcı K on K.Id =R.KullanıcıId
				  inner join tblIl I on I.Id= K.IlId
				  where I.İsim= @İsim and X.RandevuId= R.KullanıcıId
				  group by KullanıcıId ) )

EXEC SehreGöreTeşhisSilme 'Amasya'
GO


------SP3(Delete SP)
------örnek 11)id si 01 olan randevuların randevu teşhislerini silen sorguyu storedprocedure ile yazınız.(DELETE SP)
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
-----örnek 12) Prosedürün mevcutsa silinmesi
IF OBJECT_ID ('spHastanePersonelSilme') IS NOT NULL
	BEGIN
		DROP PROCEDURE spHastanePersonelSilme
	END
GO
-- Bu prosedür Id'si 04 olan hastanelerdeki personelleri silme işlemi gerçekleştirir. (DELETE)
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

------SP4(CURSOR SP) Bir ile ait hastanın isim ve adresini yan yana yazdıran stored procedure
-----örnek 13)girdi olarak bir ilin id si girilecek
CREATE OR ALTER PROCEDURE sp_opp
(
@il VARCHAR(100)
)
AS 
BEGIN
DECLARE @isimler VARCHAR(100), @adresler VARCHAR(100)
DECLARE curya CURSOR FOR
SELECT  K.İsim as hasta_ad, K.Adres as hasta_adres from tblTeshis T 
	inner join tblRandevu R on R.Id = T.RandevuId
	inner join tblKullanıcı K on K.Id = R.KullanıcıId
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
--testler burada yapılacak
EXEC sp_opp 8
GO


------SP4(CURSOR SP)
 -----örnek 14)Spcursor Kullanarak İlac adı Arveles olan verilerin etken maddesini Trometamol olarak güncelleyiniz.(CURSOR SP)
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
 ------örnek 15)Cursor ile Procedure kullanarak kullanıcı ıd,isim,soyisim ekrana yazdırma.(CURSOR SP) 
 IF OBJECT_ID ('dbo.spKullanıcıCursor') IS NOT NULL
BEGIN 
	DROP PROCEDURE spKullanıcıCursor
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE spKullanıcıCursor
AS
BEGIN
      SET NOCOUNT ON;
 
      
      DECLARE @KullanıcıId INT
             ,@isim VARCHAR(100)
             ,@soyisim VARCHAR(100)
 
     
      DECLARE @Counter INT
      SET @Counter = 1
 
     
      DECLARE PrintKullanıcı CURSOR READ_ONLY
      FOR
      SELECT K.Id,K.İsim,K.Soyisim
      FROM tblKullanıcı K
 
     
      OPEN PrintKullanıcı
 
      
      FETCH NEXT FROM PrintKullanıcı INTO
      @KullanıcıId, @isim, @soyisim
 
     
      WHILE @@FETCH_STATUS = 0
      BEGIN
             IF @Counter = 1
             BEGIN
                        PRINT 'KullanıcıID' + CHAR(9) + 'İsim' + CHAR(9) + CHAR(9) + CHAR(9) + 'Soyisim'
                        PRINT '------------------------------------'
             END
 
           
             PRINT CAST(@KullanıcıId AS VARCHAR(10)) + CHAR(9) + CHAR(9) + CHAR(9) + @isim + CHAR(9) + @soyisim
    
             
             SET @Counter = @Counter + 1
 
          
             FETCH NEXT FROM PrintKullanıcı INTO
             @KullanıcıId, @isim, @soyisim
      END
 
    
      CLOSE PrintKullanıcı
      DEALLOCATE PrintKullanıcı
END
GO

Exec spKullanıcıCursor


------SP5(Select SP)
------örnek 16)  hastane Id si 5  ve ismi Büşra olan personelerin adres bilgilerini, hangi hastanede ve hastanedeki bölümün ıd sini getiren stored prosedure
create or alter procedure sp_personelli(
@id int,
@ad CHAR(50))
as
begin
select P.Adres as personel_adres, H.İsim as hastane_isim, Hb.Id as hastane_bolum_id  from tblPersonel P 
inner join tblHastane H on P.HastaneId = H.Id 
inner join tblHastaneBölümleri Hb on H.Id = HB.HastaneId
where P.HastaneId = @id and P.İsim = @ad
end
---çalıştırma cümlesi
exec sp_personelli 5, 'Büşra'



------SP5(Select SP)
----örnek 17) hastane Id si 5 olan personelleri getiren stored prosedure
create or alter procedure sp_perso
as
select * from tblPersonel
where HastaneId=5
go
---çalıştırma cümlesi
exec sp_perso


------SP(SELECT SP)
-----örnek 18)Verilen bir tarih aralığında en çok görev yapan 3 Personel bilgisi (select stored procedure)(SELECT SP)
IF OBJECT_ID ('dbo.EnÇokGörevAlan3Personel') IS NOT NULL
BEGIN 
	DROP PROCEDURE EnÇokGörevAlan3Personel
	END
GO
CREATE OR ALTER PROCEDURE EnÇokGörevAlan3Personel (@Tarih1 DATE ,@Tarih2 DATE ) AS 
SELECT TOP 3
P.Id
FROM tblPersonel P INNER JOIN tblRandevu R ON P.Id=R.PersonelId
WHERE R.Tarih BETWEEN @Tarih1 and @Tarih2
GROUP BY P.Id
GO
EXEC EnÇokGörevAlan3Personel '2019-01-01','2019-05-01'