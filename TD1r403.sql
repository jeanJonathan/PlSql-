--TD1 
--1
CREATE OR REPLACE TYPE Coordonnees AS OBJECT (
  ville VARCHAR2(30),
  cp VARCHAR2(10),
  telephone VARCHAR2(20),
  fax VARCHAR2(20)
);
--2
CREATE TABLE emp2 (
  numemp NUMBER,
  nom_complet VARCHAR2(50),
  salaire NUMBER(2),
  coordonnees Coordonnees
);

--2
/*INSERT INTO Coordonnees (ville, cp, telephone)
VALUES ('Lyon', '69000', '0472546585');

INSERT INTO emp2 (numemp, nom_complet, coordonnees)
SELECT 1, 'DUPUIS Yvonne', coordonnees
FROM Coordonnees
WHERE ville = 'Lyon' AND cp = '69000' AND telephone = '0472546585';
*/
--Reponse prof : 
INSERT INTO emp2
VALUES (14,'XAVIER Richard',NULL,Coordonnees('Lyon','69000','0472546585',NULL));

INSERT INTO emp2
VALUES (15,'NICOLLE Chris',NULL,Coordonnees('Paris','75000',NULL,NULL));

INSERT INTO emp2
VALUES (14,'XAVIER Richard',NULL,Coordonnees('Lyon','69000','0472546585',NULL));

--4
INSERT INTO coordonnees (ville, cp)
VALUES ('Anglet', '64200');

UPDATE emp2
SET nom_complet = 'Xavier Richard',
    ville = 'Anglet',
    cp = '64200'
WHERE numemp = 2;

--5) question 5
SELECT * FROM emp
WHERE salaire = &nouveau_slaire 
AND numéro_employé = &numero;

--sinon si on veut creer une requete parametrer qui permet d'affecter un salaire a un employe
--sachant qu'elle demande le salaire et le numero de l'employe alors : 

SELECT 
--Requette preparer
DECLARE
  p_salaire NUMBER;
  p_numemp NUMBER;
BEGIN
  -- On demande un nouveau salaire
  PROMPT 'Entrez le nouveau salaire : ';
  ACCEPT p_salaire NUMBER;

  -- On demande du numéro de l'employé
  PROMPT 'Entrez le numéro de l''employé : ';
  ACCEPT p_numemp NUMBER;

  -- On met à jour du salaire de l'employé
  UPDATE emp2
  SET salaire = &p_salaire
  WHERE numemp = &p_numemp;

  -- On affiche un message de confirmation
  DBMS_OUTPUT.PUT_LINE('Le salaire de l''employe numero ' || p_numemp || ' a bien ete mis a jour !');
END;
/

--6)Liste des ville d'ou provienne les employes (correction prof)
SELECT DISTINCT e.Coordonnees.Ville
FROM emp2 e;

--JOIN coordonnees ON emp2.coordonee = coordonnees.coordonee_id;

--7)Nombre de provenances differentes des employes 
SELECT COUNT(DISTINCT coordonnees.ville)
FROM emp2
JOIN coordonnees ON emp2.coordonee = coordonnees.coordonee_id;

--Prof: Pas besoin d'utiliser la jointure entre les tables 
--8) Liste des personnes venant d'anglet 
SELECT *
FROM emp2
--JOIN coordonnees ON emp2.coordonee = coordonnees.coordonee_id
WHERE coordonnees.ville = 'Anglet';

--9)Affiche les villes qui se trouvent dans emp2 et dans dept
SELECT DISTINCT coordonnees.ville
FROM emp2 
JOIN coordonnees ON emp2.coordonee = coordonnees.ville
UNION
SELECT DISTINCT ville
FROM dept;

--correciton sql 
SELECT * FROM emp e WHERE e.coordonnee.tel IS NOT NULL;

--10 Afficher les villes qui se trouvent dans emp et dans dept 

--11 Ajouter un numero de telephone et un numero de fax a XAVIER 

--Partie 2 (TD4 PlSql)
--INSERT_EMP(…) qui insère un employé avec tous les attributs
CREATE OR REPLACE PROCEDURE insert_emp(numeroEmp emp.numemp%TYPE,nomEmp emp.nom_complet%TYPE,professionEmp emp.profession%TYPE,chefEmp emp.chef%TYPE,salEmp emp.salaire%TYPE,numDepEmp emp.numdep%TYPE)
AS nbreEmploye NUMBER(2);
BEGIN 
    SELECT COUNT(*) INTO nbreEmploye FROM emp WHERE numemp = numeroEmp;
    IF nbreEmploye = 0 THEN 
        INSERT INTO emp VALUES (numeroEmp,nomEmp,professionEmp,chefEmp,salEmp,numDepEmp);
    END IF ;
     UPDATE emp SET numemp = numeroEmp, nom_complet = nomEmp, profession = professionEmp, chef = chefEmp, salaire = salEmp,numdep = numDepEmp WHERE numemp = numeroEmp ;
    END;

--MAJ_EMP(NomEMP, salaire) qui met à jour le salaire de l’employé dont le nom est fourni en paramètre
SET SERVEROUTPUT ON;
--
CREATE OR REPLACE PROCEDURE maj_salaire_emp(nomEmp emp.nom_complet%TYPE, salEmp emp.salaire%TYPE) AS
CURSOR employes IS SELECT * FROM emp;
BEGIN 
    FOR employe IN employes LOOP 
        IF employe.nom_complet = nomEmp THEN 
            UPDATE emp SET salaire = salEmp WHERE nom_complet = nomEmp;
            COMMIT;
        END IF;
    END LOOP;
END;

CALL maj_salaire_emp('BARTH Florent',20000);

--COUNT_EMP() permet de compter le nombre d’employés

CREATE OR REPLACE PROCEDURE countEmp AS
nbreEmp NUMBER(2);
BEGIN 
    SELECT COUNT(*) INTO nbreEmp FROM emp;
    dbms_output.put_line(nbreEmp);
END;

CALL countEmp();

--COUNT_EMP(ville) permet de compter le nombre d’employés de cette ville
CREATE OR REPLACE PROCEDURE count_emp_dep(nomduDep dept.nomdep%TYPE ) AS
nbreEmp NUMBER(2);
BEGIN 
    SELECT COUNT(*) INTO nbreEmp FROM emp join dept ON emp.numdep = dept.numdep WHERE dept.nomdep = nomDuDep;
END;

CALL countEmp('RECHERCHE');