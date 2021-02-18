
-------------------------------------------------------DELETE-----------------------------------------------------------------------

--1)yalovadaki hastanelerin randevularýný silen sorguyu yazýnýz.

delete from tblRandevu
where Id in (select  R.Id  from tblRandevu R 
				where  exists(
					select * from tblRandevu X  inner join tblHastane H on H.Id =X.HastaneId
					inner join tblIl I on I.Id= H.IlId
					where I.Ýsim= 'Yalova' and X.HastaneId= R.HastaneId
					 group by HastaneId ))

--2)amasya ilindeki kullanýcýlarýn teþhisini silen sorguyu yazýnýz.


delete from tblTeshis
where Id in (select T.Id from tblTeshis T
              where exists(
				  select * from tblTeshis X
				  inner join tblRandevu R on R.Id = X.RandevuId
				  inner join tblKullanýcý K on K.Id =R.KullanýcýId
				  inner join tblIl I on I.Id= K.IlId
				  where I.Ýsim= 'Amasya' and X.RandevuId= R.KullanýcýId
				  group by KullanýcýId ) )


--3) id si 08 olan randevularýn randevu teþhislerinin silinmesi
delete from tblRandevuTeshisleri
where Id in (select Ra.Id 
             from tblRandevuTeshisleri Ra
              where exists(
				  select * from tblRandevuTeshisleri X
				  inner join tblRandevu R on R.Id =X.RandevuId
				  where R.Id= '08' and X.Id = R.Id
				  group by RandevuId ))


--4) Randevuya gitmiþ olan kullanýcýlarýn tahlillerini silen sorguyu yazýnýz.

delete from tblRandevuTahlilleri
where Id in (select Rt.Id
              from tblRandevuTahlilleri Rt
			  where exists(
				 select * from tblRandevuTahlilleri X inner join tblRandevu R
				 on R.Id=X.RandevuId where R.Id=1 and X.RandevuId=Rt.RandevuId
				 group by RandevuId ))


--5) etken maddesi NULL olan ilaçlarýn verildiði reçete ilaçlarýnýn silinmesi

delete from tblReceteIlaclarý
where Id in (select RI.Id
             from tblReceteIlaclarý RI
			 where  exists(
				 select * from tblReceteIlaclarý X 
				 inner join tblIlac I on I.Id= X.IlacId
				 where I.Etken_Maddeler= NULL  and X.IlacId=RI.IlacId
				group by IlacId ))


