
-------------------------------------------------------DELETE-----------------------------------------------------------------------

--1)yalovadaki hastanelerin randevular�n� silen sorguyu yaz�n�z.

delete from tblRandevu
where Id in (select  R.Id  from tblRandevu R 
				where  exists(
					select * from tblRandevu X  inner join tblHastane H on H.Id =X.HastaneId
					inner join tblIl I on I.Id= H.IlId
					where I.�sim= 'Yalova' and X.HastaneId= R.HastaneId
					 group by HastaneId ))

--2)amasya ilindeki kullan�c�lar�n te�hisini silen sorguyu yaz�n�z.


delete from tblTeshis
where Id in (select T.Id from tblTeshis T
              where exists(
				  select * from tblTeshis X
				  inner join tblRandevu R on R.Id = X.RandevuId
				  inner join tblKullan�c� K on K.Id =R.Kullan�c�Id
				  inner join tblIl I on I.Id= K.IlId
				  where I.�sim= 'Amasya' and X.RandevuId= R.Kullan�c�Id
				  group by Kullan�c�Id ) )


--3) id si 08 olan randevular�n randevu te�hislerinin silinmesi
delete from tblRandevuTeshisleri
where Id in (select Ra.Id 
             from tblRandevuTeshisleri Ra
              where exists(
				  select * from tblRandevuTeshisleri X
				  inner join tblRandevu R on R.Id =X.RandevuId
				  where R.Id= '08' and X.Id = R.Id
				  group by RandevuId ))


--4) Randevuya gitmi� olan kullan�c�lar�n tahlillerini silen sorguyu yaz�n�z.

delete from tblRandevuTahlilleri
where Id in (select Rt.Id
              from tblRandevuTahlilleri Rt
			  where exists(
				 select * from tblRandevuTahlilleri X inner join tblRandevu R
				 on R.Id=X.RandevuId where R.Id=1 and X.RandevuId=Rt.RandevuId
				 group by RandevuId ))


--5) etken maddesi NULL olan ila�lar�n verildi�i re�ete ila�lar�n�n silinmesi

delete from tblReceteIlaclar�
where Id in (select RI.Id
             from tblReceteIlaclar� RI
			 where  exists(
				 select * from tblReceteIlaclar� X 
				 inner join tblIlac I on I.Id= X.IlacId
				 where I.Etken_Maddeler= NULL  and X.IlacId=RI.IlacId
				group by IlacId ))


