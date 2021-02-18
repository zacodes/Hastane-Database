
--------------------------------------------------------UPDATE--------------------------------------------------------------------

--1) En �ok re�ete yazan doktorun hastanesini en �ok doktora giden hastan�n gitti�i hastane olarak g�ncelleyiniz.


update tblPersonel SET HastaneId=(
select DISTINCT HastaneId from tblRandevu where Kullan�c�Id IN(
	select TOP 1 Kullan�c�Id from tblRandevu
	group by Kullan�c�Id
	order by count(Id) )) where HastaneId=(
		select HastaneId from tblPersonel where Id=(
			select TOP 1 PersonelId from tblRecete
			group by PersonelId
			order by count(Id) DESC))


 --2)Adana'daki hastanelerde bulunan Diyetisyen doktorlar�n�n verdi�i ila�lar�n s�resini g�nde 2 kez olarak g�ncelleyiniz.


 update tblReceteIlaclar� SET M�ktar='G�nde 2 kez'(
 select * from tblReceteIlaclar� where ReceteId IN(
	 select Id from tblRecete where PersonelId =(
		 select P.Id from tblPersonel P Inner Join tblBolum B
		 on P.BolumId=B.Id  where B.Ad='Diyetisyen' and P.HastaneId IN(
			 select Id from tblHastane where IlId IN(
			 select Id from tblIl where �sim='Adana')))))
 

--3)En az randevuya giden hastan�n tahlil i�eriklerine en az kullan�lan i�eri�i yaz�n�z.


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

--4) 2018 Ocak ay�nda en �ok te�his konulan 3 hastal���n ad�n� Ruhsal Bunal�m olarak de�i�tiriniz.


update tblTeshis SET �sim='Ruhsal Bunal�m' where �sim IN(
select TOP 3 �sim from tblRandevu R Inner JOIN tblTeshis T
	on R.Id=T.RandevuId where  Tarih>'2017-12-31' and Tarih<'2018-02-01' 
	Group by �sim  
	Order by Count (�sim) DESC )


--5)En az bir kere randevuya giden ve tahlil yapt�ran kullan�c�lar�n tahlil de�erini 0 olarak g�ncelleyiniz.

update tblRandevu�cerikleri SET Deger=0
 where TahlilId IN (
 select TahlilId from tblRandevuTahlilleri where RandevuId IN(
 select Id from tblRandevu
 where NOT EXISTS (select Id from tblRandevu where Durum=0)))
