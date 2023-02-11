'3.	Renommez la table Vol2 en TRAJET et la table Pilote en PERSONNEL. Vous pouvez utiliser'
RENAME VOL2 TO TRAJET
RENAME PILOTES TO PERSONNEL 
'4.	Modifiez le trajet (anciennement vol) n° 4 en mettant (VILLEDEP = ‘Lille’, HEUREARR = 17)'
ALTER TABLE TRAJET
SET villedep='Lille', heurearr='17'
WHERE volnum = 4;

'5.	Supprimez le trajet n° 5 en utilisant'
DELETE FROM TRAJET WHERE volnum = 1;

'6.	Modifiez la structure de la table PERSONNEL en y rajoutant un attribut Fonction dont le contenu sera la valeur'
ALTER TABLE PERSONNEL 
ADD Fonction VARCHAR2(20) 
DEFAULT 'pilote' NOT NULL;

'PARTIE 2'
'1.	Afficher la structure de la table TRAJET'
describe TRAJET

'2.	Afficher la liste de tous les trajets'
SELECT villedep as depart,villearr as arrive
FROM TRAJET;
'3.	Afficher les nom, prénom, et ville de tous les pilotes, par ordre alphabétique (changer les noms des colonnes en Nom, Prénom et ville)'
SELECT plnom as nom,plprenom as prenom,ville as ville
FROM PERSONNEL 
ORDER BY plnom ASC,plprenom ASC,ville ASC;

'4.	Afficher les nom, prénom, et salaire des pilotes dont le salaire est supérieur à 20 000 F'
SELECT plnom as nom,plprenom as prenom,salaire as salaire
FROM PERSONNEL 
WHERE salaire > 20000;

'5.	Sélectionner les noms des personnels dont le salaire est 10000 FF ou 20000 FF (utiliser la fonction ANY)'
SELECT plnom as nom,salaire as salaire
FROM PERSONNEL 
WHERE salaire IN (10000,20000); 'On pouvait faire aussi =ANY'
-- cad 
SELECT plnom
FROM PERSONNEL 
WHERE salaire = ANY (10000, 20000);

'6.	Afficher la liste des personnels dont le salaire dépasse la moyenne de tous les pilotes'
SELECT plnom as nom,plprenom as prenom,salaire
FROM PERSONNEL 
WHERE salaire > (SELECT AVG(salaire) FROM PERSONNEL);


'7.	Afficher le numéro et nom des avions localisés à Paris'
SELECT avnum as numero, avnom as nom
FROM AVION 
WHERE localisation = 'PARIS';

'8.	Donner le nom et prénom des pilotes dont le salaire est supérieur à un salaire plafond saisi au clavier (requête paramétrée).'
SELECT plnom as nom,plprenom as prenom
FROM PERSONNEL 
WHERE salaire > &saisir_salaire;
/*Rmq: La variable &saisir_salaire doit être définie par l'utilisateur avant l'exécution de la requête.*/

'9.	Donner les caractéristiques (AVNUM, AVNOM, CAPACITE, LOCALISATION) des avions localisés dans la même ville qu’un pilote dont le nom est saisi au clavier'
SELECT AVION.avnum,AVION.avnom,AVION.capacite,AVION.localisation,PERSONNEL.plnom
FROM AVION 
JOIN PERSONNEL
ON PERSONNEL.ville=AVION.ville
WHERE PERSONNEL.plnom = &saisie_nom_personnel;

'10. Donner les caractéristiques (VOLNUM, VILLEDEP, VILLEARR, HEUREDEP, HEUREARR, AVNOM, PLNOM) d un trajet dont le numero est saisi au clavier (paramètre) '
SELECT TRAJET.volnum, TRAJET.villedep, TRAJET.villearr, TRAJET.heuredep, TRAJET.heurearr, TRAJET.avnom, PERSONNEL.plnom
FROM TRAJET
INNER JOIN PERSONNEL ON TRAJET.plnom = PERSONNEL.plnom
WHERE TRAJET.volnum = &numero;

'11.Donner le nom, prénom, et numéro du trajet des pilotes affectés à (au moins) un trajet.'
SELECT PERSONNEL.plnom, PERSONNEL.plnum, PERSONNEL.volnum
FROM PERSONNEL
JOIN TRAJET ON PERSONNEL.plnom = TRAJET.plnom;

/*Rmq: Cette requette ne conserve que les lignes où il existe au moins un trajet affecté au pilote.*/

'12.Donner le numéro et nom des avions affectés à des trajets (éliminer les doublons)'

SELECT DISTINCT AVION.avnum, AVION.avnom
FROM AVION 
JOIN TRAJET ON AVION.avnum = TRAJET.avnum;

'13.Afficher le nombre total de trajets'
SELECT COUNT(DISTINCT heurearr)
FROM TRAJET;

'14.Afficher la somme des capacités de tous les avions'
SELECT SUM(capacite) AS TotalCapacite
FROM AVION;

'15.Donner la moyenne des durées des voyages'
SELECT AVG(TIMESTAMPDIFF(HOUR, HEUREDEP, HEUREARR)) AS MoyenneDuree
FROM TRAJET;

'16.Donner les capacités minimum et maximum de tous les avions'
SELECT MIN(capacite) AS CapaciteMinimum, MAX(capacite) AS CapaciteMaximum
FROM AVION;

'17.	Afficher le nombre total d’heures de trajet, par pilote.'

SELECT PILOTE.plnom, SUM(TIMESTAMPDIFF(HOUR, TRAJET.heuredep, TRAJET.heurearr)) AS NombreTotalHeures
FROM PILOTE
JOIN TRAJET ON PILOTE.plnom = PILOTE.plnom
GROUP BY PILOTE.plnom;

/*GROUP BY pour regrouper les résultats par pilote*/
/*On a utiliser la fonction TIMESTAMPDIFF pour calculer la différence
entre les heures de départ et d'arrivée de chaque traje*/