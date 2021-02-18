
CREATE TABLE tblIlac
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Ad CHAR(50) NOT NULL,
Etken_Maddeler CHAR(50),
)
GO


CREATE TABLE tblBolum
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Ad CHAR(50) NOT NULL,
)
GO


CREATE TABLE tblG�rev
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(50) NOT NULL
)
GO



CREATE TABLE tblIl
(
Id INT PRIMARY KEY,
�sim CHAR(50) NOT NULL,
)
GO


CREATE TABLE tblIlce
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(50) NOT NULL,
IlId INT  FOREIGN KEY REFERENCES tblIl(Id)
)
GO


CREATE TABLE tblHastane
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(50) NOT NULL,
Adres VARCHAR(100) NOT NULL,
EMail VARCHAR(50) NOT NULL
         CONSTRAINT chktblHastaneEMail CHECK (EMail LIKE '%@%.%'),
IlId INT FOREIGN KEY REFERENCES tblIl(Id),
IlceId INT FOREIGN KEY REFERENCES tblIlce(Id),
)
GO


CREATE TABLE tblPersonel
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(50) NOT NULL,
Soyisim CHAR(50) NOT NULL,
Adres VARCHAR(100) NOT NULL,
EMail CHAR(50) NOT NULL
         CONSTRAINT chktblPersonelEMail CHECK (EMail LIKE '%@%.%'),  --mail i�in �nce@ sonra . gelmeli 
IlId  INT FOREIGN KEY REFERENCES tblIl(Id),
IlceId INT  FOREIGN KEY REFERENCES tblIlce(Id),
HastaneId INT   FOREIGN KEY REFERENCES tblHastane(Id),
BolumId INT  FOREIGN KEY REFERENCES tblBolum(Id),
G�revId INT  FOREIGN KEY REFERENCES tblG�rev(Id),

)
GO


CREATE TABLE tblRecete
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Tarih DATE NOT NULL,
PersonelId INT FOREIGN KEY REFERENCES tblPersonel(Id)
)
GO


Create TABLE tblKullan�c�
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(80) NOT NULL,
Soyisim CHAR(80) NOT NULL,
Adres CHAR(100) NOT NULL,
Tel CHAR(10) NOT NULL
         CONSTRAINT chktblKullan�c�Tel CHECK (Tel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),       
Sifre CHAR(6)  NOT NULL,      
EMail CHAR(50)   NOT NULL
         CONSTRAINT chktblKullan�c�EMail CHECK (EMail LIKE '%@%.%'),         
IlId INT  FOREIGN KEY REFERENCES tblIl(Id),
IlceId INT  FOREIGN KEY REFERENCES tblIlce(Id)
)
GO



CREATE TABLE tblRandevu
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Tarih DATE NOT NULL,
Saat TIME NOT NULL,
Durum SMALLINT NOT NULL,       --- 0:randevuya gitmemi� , 1:randevuya gitmi� , 2:randevu g�n�ne daha var       
Ac�klama VARCHAR(50),
Kullan�c�Id INT  FOREIGN KEY REFERENCES tblKullan�c�(Id),
BolumId INT FOREIGN KEY REFERENCES tblBolum(Id),
HastaneId INT  FOREIGN KEY REFERENCES tblHastane(Id),
PersonelId INT FOREIGN KEY REFERENCES tblPersonel(Id)
)
GO


CREATE TABLE tblTeshis
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(80) NOT NULL,
RandevuId INT  FOREIGN KEY REFERENCES tblRandevu(Id)
)
GO


CREATE TABLE tblTahlil
(
Id INT IDENTITY(1,1) PRIMARY KEY,
�sim CHAR(80) NOT NULL,
)
GO


CREATE TABLE tblIcerik
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Ad CHAR(80) NOT NULL,
AltLimit CHAR(50),
UstLimit CHAR(50),
TahlilId INT FOREIGN KEY REFERENCES tblTahlil(Id)
)
GO


CREATE TABLE tblReceteIlaclar�
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Sure CHAR(50) NOT NULL,
M�ktar CHAR(50) NOT NULL,
ReceteId INT  FOREIGN KEY REFERENCES tblRecete(Id),
IlacId INT  FOREIGN KEY REFERENCES tblIlac(Id)
)
GO


CREATE TABLE tblRandevuTeshisleri
(
Id INT IDENTITY(1,1) PRIMARY KEY,
RandevuId INT  FOREIGN KEY REFERENCES tblRandevu(Id),
TeshisId INT FOREIGN KEY REFERENCES tblTeshis(Id)
)
GO

CREATE TABLE tblHastaneB�l�mleri
(
Id INT IDENTITY(1,1) PRIMARY KEY,
HastaneId INT FOREIGN KEY REFERENCES tblHastane(Id),
BolumId INT FOREIGN KEY REFERENCES  tblBolum(Id)
)
GO

CREATE TABLE tblRandevuTahlilleri
(
Id INT IDENTITY(1,1) PRIMARY KEY,
TahlilId INT  FOREIGN KEY REFERENCES tblTahlil(Id),
RandevuId INT  FOREIGN KEY REFERENCES tblRandevu(Id)
)
GO

CREATE TABLE tblRandevu�cerikleri
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Deger DECIMAL NOT NULL,
IcerikId INT  FOREIGN KEY REFERENCES tblIcerik(Id),
TahlilId INT  FOREIGN KEY REFERENCES tblTahlil(Id),
RandevuId INT  FOREIGN KEY REFERENCES tblRandevu(Id)
)
GO

