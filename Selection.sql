
------------------------------------------------------SELECTION-------------------------------------------------------------------

--1)hem ˛eker hem kolestrol ˆlÁ¸m¸ yap˝lan randevularda ˛eker ˆlÁ¸m¸ y¸ksek Á˝kan hastalar˝n o ildeki toplam hasta say˝s˝na oran˝


select * FROM (
	select T.›sim, COUNT(T.Id) sayi FROM (
		select ˝.›sim,K.Id from tblKullan˝c˝ K Inner JOIN tblIl ˝
		on K.IlId=˝.Id where IlId IN(
			select IlId from tblKullan˝c˝ where Id IN(
				select Kullan˝c˝Id from tblRandevu where Id IN(
					select RandevuId from tblRandevu›cerikleri R INNER JOIN  tblIcerik I 
					on R.IcerikId=I.Id where I.Ad='›ns¸lin' and  R.Deger>I.UstLimit
Intersect
select RandevuId from tblRandevu›cerikleri R INNER JOIN  tblIcerik I 
on R.IcerikId=I.Id where I.Ad='Kolestrol' and  R.Deger<I.UstLimit)))) T
group by ›sim ) T
order by sayi 


/*2)2018 Ocak ay˝nda en Áok te˛his konulan 3 hastal˝˝n 2019 Ocak ay˝nda te˛his koyulma say˝s˝.
    Eer 2018 Ocaktan fazla ise gˆsterilecektir. */		
  

select ›sim, Count(*) as Toplam from tblRandevu R Inner JOIN tblTeshis T
on R.Id=T.RandevuId where Tarih>'2018-12-31' and Tarih<'2019-02-01' and ›sim IN(
	select TOP 3 ›sim from tblRandevu R Inner JOIN tblTeshis T
	on R.Id=T.RandevuId where  Tarih>'2017-12-31' and Tarih<'2018-02-01' 
	Group by ›sim  
	Order by Count (›sim) DESC)
Group by ›sim 
Order by Toplam DESC


/* 3)En az say˝da ba˛vurulan bˆl¸m¸n, en Áok ba˛vurulduu hastaneyle ayn˝ ilde olan ve randevu al˝p gitmeyen 
kullan˝c˝lar˝n olup olmad˝˝n˝ kontrol eden sorguyu yaz˝n˝z. */


select * from tblRandevu where Durum='0' and Kullan˝c˝Id IN(
select Id from tblKullan˝c˝ where IlId IN(
select IlId from tblHastane where Id=(
select top 1 HastaneId from tblRandevu where BolumId=(
	select TOP 1 BolumId --, count(BolumId) as ToplamRandevu 
	from tblRandevu
	group by BolumId
	order by count(Id) ASC
)
GROUP BY HastaneId
ORDER BY COUNT(Id) DESC )))


/*4)hem ˆnceden randevuya gitmi˛ hem de yeni bir randevusu olan kullan˝c˝lar˝n randevu ald˝˝ doktorlar˝n bu zamana kadar 
    vermi˛ olduu ilaÁlar˝n miktarlar˝n˝ say˝s˝na gˆre b¸y¸kten k¸Á¸e s˝ralay˝n˝z. */


select M˝ktar as Toplam from tblReceteIlaclar˝ where ReceteId IN(
select Id from tblRecete where PersonelId IN(
select Id from tblPersonel where BolumId IN(
	select TOP 1 BolumId from tblRandevu where Kullan˝c˝Id IN (
		select Kullan˝c˝Id from tblRandevu where Durum='1'
		INTERSECT
		select Kullan˝c˝Id from tblRandevu where Durum='2')
		group by BolumId
		order by count(BolumId) DESC)))
group by M˝ktar
order by count(M˝ktar) ASC


--5)2018 y˝l˝nda en Áok randevu al˝nan doktorun, 2019'da bakt˝˝ randevulara verdii ilaÁlar˝n etken maddelerini listeleyiniz.

select Etken_Maddeler from tblIlac where Id IN(
	select IlacId from tblReceteIlaclar˝ where ReceteId IN(
		select Id from tblRecete where Tarih>'2018-12-31'  and PersonelId=(
			select TOP 1 PersonelId -- count(Id) ToplamRandevu 
			from tblRandevu where Tarih>'2017-12-31'
			group by PersonelId
			order by count(Id) DESC,PersonelId DESC)))
