-------TRIGGER---------------------------------------------------------------------------------------------------------------------
-------1) g�ncelleme yap�ld�ktan sonra (Upter Trigger)
create or alter trigger Eklenme on tblPersonel 
after update
as
if update (�sim)
begin
print 'G�ncelleme yap�ld�'
end
-----(Update SP yap�lan i�lem kullan�ls�n)
----�al��t�rmak i�in sql c�mlesi
exec sp_YeniPerr 1,'Hamdiyye'
----kontrol
select * from tblPersonel


-----�rnek 2) Kullan�c� bir kay�t ekledikten sonra kullan�c� tablosunu listeleyen trigger
create or alter trigger Listele on tblKullan�c�
after insert
as
begin
select * from tblKullan�c�
end
--Kay�t ekleme �rne�i
insert into tblKullan�c�(�sim, Soyisim, Adres, Tel, Sifre, EMail)
values('Bet�l','Sat�','Ac� Sokak No:15', '5632148965', '523641', 'btlsat�@hotmail.com') --�NCE TR�GGER I �ALI�TIR



----- �rnek 3)spDelete trigger
IF OBJECT_ID ('dbo.tgSehreG�reTe�hisSilme') IS NOT NULL
BEGIN 
	DROP TRIGGER  tgSehreG�reTe�hisSilme
	END
GO
CREATE OR ALTER Trigger tgSehreG�reTe�hisSilme
ON tblTeshis
AFTER DELETE
AS
Declare @�sim char (50)
SELECT @�sim=�sim FROM deleted
GO

-------�rnek 4)spInsert trigger
IF OBJECT_ID ('dbo.trg�ehirEkleme') IS NOT NULL
BEGIN 
	DROP TRIGGER  trg�ehirEkleme
	END
GO
CREATE Trigger trg�ehirEkleme
ON tblIl
AFTER INSERT
AS 
Declare @id INT
Declare @�sim Char (50)
Select @id=Id,@�sim=�sim from inserted
GO


------�rnek 5)spDeleteTrigger

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
