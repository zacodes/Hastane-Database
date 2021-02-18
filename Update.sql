
--------------------------------------------------------UPDATE--------------------------------------------------------------------

--1) En çok reçete yazan doktorun hastanesini en çok doktora giden hastanın gittiği hastane olarak güncelleyiniz.


update tblPersonel SET HastaneId=(
select DISTINCT HastaneId from tblRandevu where KullanıcıId IN(
	select TOP 1 KullanıcıId from tblRandevu
	group by KullanıcıId
	order by count(Id) )) where HastaneId=(
		select HastaneId from tblPersonel where Id=(
			select TOP 1 PersonelId from tblRecete
			group by PersonelId
			order by count(Id) DESC))


 --2)Adana'daki hastanelerde bulunan Diyetisyen doktorlarının verdiği ilaçların süresini günde 2 kez olarak güncelleyiniz.


 update tblReceteIlacları SET Mıktar='Günde 2 kez'(
 select * from tblReceteIlacları where ReceteId IN(
	 select Id from tblRecete where PersonelId =(
		 select P.Id from tblPersonel P Inner Join tblBolum B
		 on P.BolumId=B.Id  where B.Ad='Diyetisyen' and P.HastaneId IN(
			 select Id from tblHastane where IlId IN(
			 select Id from tblIl where İsim='Adana')))))
 

--3)En az randevuya giden hastanın tahlil içeriklerine en az kullanılan içeriği yazınız.


update tblRandevuİcerikleri SET IcerikId = (
select TOP 1 IcerikId from tblRandevuİcerikleri
group by IcerikId
order by count(Id)ASC) where IcerikId IN(
 select IcerikId from tblRandevuİcerikleri where TahlilId IN(
	 select TahlilId from tblRandevuTahlilleri where RandevuId IN(
	 select Id from tblRandevu where KullanıcıId=(
		 select TOP 1 KullanıcıId from tblRandevu 
		 group by KullanıcıId
		 order by count(Id) ASC ))))

--4) 2018 Ocak ayında en çok teşhis konulan 3 hastalığın adını Ruhsal Bunalım olarak değiştiriniz.


update tblTeshis SET İsim='Ruhsal Bunalım' where İsim IN(
select TOP 3 İsim from tblRandevu R Inner JOIN tblTeshis T
	on R.Id=T.RandevuId where  Tarih>'2017-12-31' and Tarih<'2018-02-01' 
	Group by İsim  
	Order by Count (İsim) DESC )


--5)En az bir kere randevuya giden ve tahlil yaptıran kullanıcıların tahlil değerini 0 olarak güncelleyiniz.

update tblRandevuİcerikleri SET Deger=0
 where TahlilId IN (
 select TahlilId from tblRandevuTahlilleri where RandevuId IN(
 select Id from tblRandevu
 where NOT EXISTS (select Id from tblRandevu where Durum=0)))
