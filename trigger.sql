-------TRIGGER---------------------------------------------------------------------------------------------------------------------
-------1) güncelleme yapýldýktan sonra (Upter Trigger)
create or alter trigger Eklenme on tblPersonel 
after update
as
if update (Ýsim)
begin
print 'Güncelleme yapýldý'
end
-----(Update SP yapýlan iþlem kullanýlsýn)
----çalýþtýrmak için sql cümlesi
exec sp_YeniPerr 1,'Hamdiyye'
----kontrol
select * from tblPersonel


-----örnek 2) Kullanýcý bir kayýt ekledikten sonra kullanýcý tablosunu listeleyen trigger
create or alter trigger Listele on tblKullanýcý
after insert
as
begin
select * from tblKullanýcý
end
--Kayýt ekleme örneði
insert into tblKullanýcý(Ýsim, Soyisim, Adres, Tel, Sifre, EMail)
values('Betül','Satý','Acý Sokak No:15', '5632148965', '523641', 'btlsatý@hotmail.com') --ÖNCE TRÝGGER I ÇALIÞTIR



----- örnek 3)spDelete trigger
IF OBJECT_ID ('dbo.tgSehreGöreTeþhisSilme') IS NOT NULL
BEGIN 
	DROP TRIGGER  tgSehreGöreTeþhisSilme
	END
GO
CREATE OR ALTER Trigger tgSehreGöreTeþhisSilme
ON tblTeshis
AFTER DELETE
AS
Declare @Ýsim char (50)
SELECT @Ýsim=Ýsim FROM deleted
GO

-------örnek 4)spInsert trigger
IF OBJECT_ID ('dbo.trgÞehirEkleme') IS NOT NULL
BEGIN 
	DROP TRIGGER  trgÞehirEkleme
	END
GO
CREATE Trigger trgÞehirEkleme
ON tblIl
AFTER INSERT
AS 
Declare @id INT
Declare @Ýsim Char (50)
Select @id=Id,@Ýsim=Ýsim from inserted
GO


------örnek 5)spDeleteTrigger

IF OBJECT_ID ('tgspHastanePersonelSilme') IS NOT NULL
	BEGIN
		DROP TRIGGER tgspHastanePersonelSilme
	END
GO
CREATE OR ALTER Trigger tgspHastanePersonelSilme
on tblPersonel
after delete
as
declare @hastaneId char(50)
select @hastaneId=hastaneId FROM deleted
GO
