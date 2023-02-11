--tp1 seance du 10/02/2023

--Prof: Telphone doit contenir plusieur ligne par 
--On veut que un attribut prennent plusieur valeurs
--liste de telephone est une table qui permert de donner plusieur valeur a l'attribut telephone

CREATE OR REPLACE TYPE typeListeTelphones AS TABLE OF number(10);

CREATE TABLE tIntervenant(
pknom VARCHAR2(20) PRIMARY KEY,
prenom VARCHAR2(20) NOT NULL,
Itelephone typeListeTelephones
)
NESTED TABLE Itelephone STORE AS tTelephone;

--Gestion d'attribut multivalue par imbrication de collection de scalaires
--Collection d'enregistrement sous forme de table imbriquees
CREATE OR REPLACE TYPE specialite AS OBJECT (
  domaine VARCHAR2(100),
  technologie VARCHAR2(100)
);

CREATE OR REPLACE TYPE typeListeSpecialites AS TABLE OF specialite;

CREATE TABLE tIntervenant (
  pknom VARCHAR2(20) PRIMARY KEY,
  prenom VARCHAR2(20) NOT NULL,
  liste_specialites typeListeSpecialites
) NESTED TABLE liste_specialites STORE AS tSpecialites;

--Enregistrement imbrique, collection de scalaire imbriquee, collection d'enregistrement imbriquee

--Creation de la table tIntervenant

--Dans ce cas la colonne bureau contient imbrique trois colonne note centre, batiment,numero 

CREATE OR REPLACE TYPE typeListeTelephones AS TABLE OF numero_tel;

CREATE OR REPLACE TYPE bureau AS OBJECT (
  centre VARCHAR2(100),
  batiment VARCHAR2(100),
  numero NUMBER(10)
);

CREATE TABLE tIntervenant (
  pknom VARCHAR2(20) PRIMARY KEY,
  prenom VARCHAR2(20) NOT NULL,
  liste_telephone typeListeTelephones,
  liste_specialites typeListeSpecialites,
  liste_bureaux typeListeBureaux
) NESTED TABLE liste_telephone STORE AS tTelephone;
  NESTED TABLE liste_specialites STORE AS tSpecialites;


INSERT INTO tIntervenant
VALUES ('Crozat','Stephane',bureau('PG','K',256),typeListeTelephones(NULL,'0657990000','912345678','0344231234'),typeListeSpecialite(specialite('BD','SGBDR'),specialite('Doc','XML'),specialite('BD','SGBDRO')));

--Prof: Rmq : On utilise les table et objets dans les insertions 

--Acces a une collection imriquees de sclaire 

--Affichage les noms et la liste des telephones des personnes
SELECT pknom, liste_telephone
FROM tIntervenant;

SELECT i.pknom,t*
FROM tIntervenant i, Table(i.Itelephones) t;

--Afficher les noms et les specialite des personnes 

SELECT i.pknom, s.*
FROM tIntervenant i, TABLE(i.liste_specialites) s;


--Insertion dans les collections imbriquees
--Inserer les valeurs suivantes Crozat,Stephaone et dans bureau on insere PG,K,256 et dans liste telphone on insere 012321,54655465,23156546 et dans liste 
