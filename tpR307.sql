SET SERVEROUTPUT ON;

BEGIN 
    dbms_output.put_line(DBMS_DB_VERSION.VERSION || '.' || DBMS_DB_VERSION.RELEASE);
END;

---------------------------------------------------------------------------------------
DECLARE 
   -- i NUMBER(2);
BEGIN
    FOR i IN REVERSE 1..5 LOOP 
        dbms_output.put_line('Nombre :' || i);
    END LOOP ;
END;

--------------------------------------------------------------------------------------
/*Test de methode select*/
SELECT emp.nom_complet,dept.nomdep FROM emp JOIN dept ON emp.numdep=dept.numdep WHERE emp.nom_complet='BARTH Florent' AND dept.numdep=2;
----------------------------------------------------------------------------------------
SELECT *FROM user_source;
---------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;

/*TP PARTIE A*/ 
/*Question 2 et 3-*/
DECLARE
--On declare une variable n designant le nombre de ligne de la requette
n NUMBER(2);
--On delcare un cursor employes dont la position courante se placera sur chaque ligne de la requette 
CURSOR employes IS SELECT emp.numemp, emp.nom_complet ,emp.salaire FROM EMP;
--On declare la variable newsal de meme type que celui du tYpe salaire de la table emp
newsal emp.salaire%TYPE; 
--On decalre une variable empv de type exception a lever au cas ou le nombre de ligne n =0
empv EXCEPTION;
BEGIN
--On selectionne le nombre d'employe pour mettre dans n
SELECT COUNT(*) INTO n FROM EMP;
--Si n=0 alors on leve l'exception utilisateur
IF n=0 THEN 
--Leve d'exception
RAISE empv; 
END IF;
--Pour la varaible employe dans le curseur  
FOR employe IN employes LOOP
--Augmente le salaire de 50 a chaque position courante du curseur
 newsal:=employe.salaire+50; 
--Mise a jour des nouveaux salaires dans la table emp
UPDATE EMP SET SALAIRE=newsal where NUMEMP = employe.numemp;
END LOOP;
Commit;
--Gestion de l'exception
EXCEPTION
--Si exception levee alors affichage du message d'erreur 
WHEN empv THEN dbms_output.put_line('Aucun tuple dans la table!');
END; 
----------------------------------------------------------
---Question4 : La variable emplyes peut declarer par le cursor peut etre assimile a un Recordset
--car des lors que le cursor est ouvert, on fait les augmentation du salaire a chaque iteration de employe dans cursor  
---Question5 : Ce programme augmente le salaire de 50 de chaque employe de la table Emp 
---A condition que la table employe contienne au moin un tuple

/*PARTIE B*/
/*Procedure sans parametre CREATE OR REPLACE PROCEDURE nom_proc AS (ou IS)*/
--Remarque les procedures sont encadrer par BEGIN et END 
---Question7
CREATE OR REPLACE PROCEDURE hello_world AS
texte VARCHAR2(25);
BEGIN 
    texte:='Hello World';
    dbms_output.put_line(texte);
END;

/*On peut aussi l'appeler de cette maniere*/
DECLARE 
BEGIN 
    hello_world;
END;

/*Appel de la procedure */
CALL hello_world();

/*Question 8*/
CREATE OR REPLACE FUNCTION leSalaire(employeNom IN emp.nom_complet%TYPE)
RETURN emp.salaire%TYPE IS 
--On declare la variable salaire a L'interieur du quel on mettra le(s) ligne de requettes
salaire emp.salaire%TYPE; --declare la variable qui sera manipule dans le BEGIN
--rmq : On a pas de section declare parce que cette section declare automatiquement les variables
BEGIN 
    /*Cette requette renverra toutefois une ligne tjr 
    On reccupere le salaire de l'employe pour lequel le nom de l'employe soit egal au non passe en parametre*/
    SELECT emp.salaire INTO salaire FROM emp WHERE emp.nom_complet = employeNom;
RETURN salaire;
END;

DECLARE 
BEGIN 
    --Appel de la fonction 
     dbms_output.put_line(leSalaire('BARTH Florent'));
END;

---------------------------------------------------------------------
/*Modification de la fonction pour qu'elle renvoie le numero, le poste et le salaire*/
--Pour cela on la modifira en une procedure 


CREATE OR REPLACE FUNCTION coordorneeEmploye(employeNom IN emp.nom_complet%TYPE)
/*Retourne une chaine de caractere*/
RETURN  VARCHAR2 IS
leNum emp.numemp%TYPE;
laProfession emp.profession%TYPE;
leSalaire emp.salaire%TYPE;
BEGIN 
    SELECT emp.numemp,emp.profession,emp.salaire INTO leNum,LaProfession,leSalaire FROM emp WHERE emp.nom_complet=employeNom;
    RETURN 'NUMERO = '|| leNum ||', POSTE = '|| laProfession||', SALAIRE = '|| leSalaire;
END;
    
DECLARE 
BEGIN 
    --Appel de la fonction 
     dbms_output.put_line(coordorneeEmploye('BARTH Florent'));
END;




/*PARTIE C*/
/*Question 9*/
CREATE OR REPLACE PROCEDURE affecter_emp_dept(nomEmp emp.nom_complet%TYPE,newDep dept.nomdep%TYPE) AS
unEmploye emp.nom_complet%TYPE;
leDepartement dept.nomdep%TYPE;

BEGIN 
    SELECT emp.nom_complet,dept.nomdep INTO unEmploye,leDepartement FROM emp JOIN dept ON emp.numdep=dept.numdep WHERE emp.nom_complet=nomEmp;
    ledepartement:=newdep;
    --Sans cette mise a jour la table ne serait modifie
    UPDATE emp SET numdep=ledepartement WHERE nom_complet = nomEmp;
    dbms_output.put_line('l employe '||unemploye||' est affecter maintenant dans le departement numero '||ledepartement);
END;

/*Remarque pas besoin d'utiliser un curseur car la methode select ne manipule pas plusieurs lignes ( ne renvoie) */
/*cad La procedure agit sur un employe*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*NB : Si nous rentrons un departement imcompris entre [1,4] alors le script renverra une erreur car dans la table departemnt on a seument les 4 numero de departement*/
CALL affecter_emp_dept('BARTH Florent',4);

------------------------------------------------------------------------
/*Question 10*/
CREATE OR REPLACE FUNCTION exist_emp(unEmployeNom emp.nom_complet%TYPE)
RETURN boolean IS 
ilExiste boolean :=false;
CURSOR curseur IS SELECT emp.nom_complet FROM emp;
BEGIN   
    FOR employe IN curseur LOOP 
        IF unEmployeNom=employe.nom_complet THEN
            ilExiste := true;
        END IF;
    END LOOP;
    COMMIT;
    RETURN ilExiste;
END;

--------Appel de la fonction 
DECLARE 
BEGIN 
    --Appel de la fonction 
     dbms_output.put_line(exist_emp('BARTH Florent'));
END;

-----------------------------------------------------------
/*Question 11*/
CREATE OR REPLACE FUNCTION app_emp_dept(unEmp emp.nom_complet%TYPE,unDepartement dept.numdep%TYPE)
RETURN VARCHAR2 AS 
resultat VARCHAR2(70);
numDepartement emp.numdep%TYPE;
nomDepart dept.nomdep%TYPE;
nomEmploye emp.nom_complet%TYPE;
BEGIN
    --SELECT dept.nomdep,emp.numdep INTO nomDepart,departement FROM emp JOIN dept ON dept.numdep=emp.numdep WHERE dept.numdep = unDepartement AND emp.nom_complet = unEmp;
    SELECT DISTINCT emp.numdep,dept.nomdep,emp.nom_complet INTO numDepartement, nomDepart , nomEmploye  FROM emp JOIN dept ON dept.numdep=emp.numdep WHERE emp.numdep=unDepartement AND emp.nom_complet=unEmp; 
    --SELECT emp.numdep INTO numDepartement FROM emp WHERE emp.nom_complet = unEmp;
    IF numDepartement = unDepartement AND nomEmploye = unEmp THEN
        resultat := 'Cet employé appartient au département '||nomDepart;
    ElSE
        resultat := 'Cet employé n''appartient pas au département '||nomDepart;
    END IF;
    RETURN resultat;
    BREAK;
END;

BEGIN 
    dbms_output.put_line(app_emp_dept('BARTH Florent',2));
END; 
    SELECT DISTINCT emp.numdep,dept.nomdep,emp.nom_complet FROM emp JOIN dept ON dept.numdep=emp.numdep WHERE emp.numdep=1; 
-------------------------------------------------------------
/*Question 12*/
---Programme qui met a jour les salaire des employes
CREATE OR REPLACE PROCEDURE maj_emp AS 
CURSOR recherche IS SELECT salaire, NUMEMP FROM EMP WHERE NUMDEP = 1;
CURSOR developpement IS SELECT salaire, NUMEMP FROM EMP WHERE NUMDEP = 2;
CURSOR facturation IS SELECT salaire, NUMEMP FROM EMP WHERE NUMDEP = 3;
CURSOR direction IS SELECT salaire, NUMEMP FROM EMP WHERE NUMDEP = 4;
newsal EMP.SALAIRE%TYPE;
moyenneActu NUMBER(15);
BEGIN
--On calcule la moyenne actuelle des salaires pour le département facturation
    SELECT AVG(salaire) INTO moyenneActu FROM EMP;
--Departement RECHERCHE
    FOR employe in recherche LOOP
        newsal:=employe.salaire+200;
        UPDATE EMP SET SALAIRE=newsal where NUMEMP = employe.numemp;
    END LOOP;
--Departement DEVELOPPEMENT
    FOR employe in developpement LOOP
        newsal:=employe.salaire+40;
--
    UPDATE EMP SET SALAIRE=newsal where NUMEMP = employe.numemp;
    END LOOP;

--Departement FACTURATION
    FOR employe in facturation LOOP
        newsal:=moyenneActu;
--
        UPDATE EMP SET SALAIRE=newsal where NUMEMP = employe.numemp;
    END LOOP;

--Departement DIRECTION
FOR employe in direction LOOP

newsal:=employe.salaire*2;
--
UPDATE EMP SET SALAIRE=newsal where NUMEMP = employe.numemp;
END LOOP;

commit;
END maj_emp;

---TD4 
--Partie 2

---- Procedure qui insère un employé avec tous les attribut 
CREATE OR REPLACE PROCEDURE insert_emp(numEmp emp.numemp%TYPE,nomEmp emp.nom_complet%TYPE,professionEmp emp.profession%TYPE,empChef emp.chef%TYPE,salaireEmp emp.salaire%TYPE,empDept emp.numdep%TYPE)AS
v_employe emp%ROWTYPE; ---declaration d'une variable colonne pour interagir sur les differentes colonnnes
---CURSOR curseur IS SELECT * FROM emp;
BEGIN 
    SELECT * INTO v_employe FROM emp;
    --FOR v_employe IN curseur LOOP 
    v_employe.numemp := numEmp;
    v_employe.nom_complet := nomEmp;
    v_employe.profession := professionEmp;
    v_employe.chef := empChef;
    v_employe.salaire := salaireEmp;
    v_employe.numdep := empDept;
    --END LOOP;
    INSERT INTO emp VALUES v_employe;
END;
SELECT * FROM emp;

exec insert_emp(10,'KOFFI J-Jonathan','DEVELOPPEUR',5,25000,2);

----Procedure qui met à jour le salaire de l’employé dont le nom est fourni en paramètre
CREATE OR REPLACE PROCEDURE maj_emp_salaire(nomEmp emp.nom_complet%TYPE,newSalaire emp.salaire%TYPE) AS
unEmploye emp.nom_complet%TYPE;
leSalaire emp.salaire%TYPE;

BEGIN 
    SELECT emp.nom_complet,emp.salaire INTO unEmploye,leSalaire FROM emp WHERE emp.nom_complet=nomEmp;
    leSalaire:=newSalaire;
    --Sans cette mise a jour la table ne serait modifie
    UPDATE emp SET salaire=leSalaire WHERE nom_complet = nomEmp;
    dbms_output.put_line('l employe '||unEmploye||' dispoe maintenant du salaire '||leSalaire);
END;
---

CALL maj_emp_salaire('BARTH Florent',10000)

----Fonction qui retourne le nombre d'employe
CREATE OR REPLACE FUNCTION count_emp
RETURN number IS 
nbreTotalEmp NUMBER;
BEGIN 
    SELECT COUNT(DISTINCT emp.nom_complet) INTO nbreTotalEmp FROM emp;
    dbms_output.put_line('Le nombre total d employe dans est : ');
     RETURN nbreTotalEmp;
END;

--Test
DECLARE 
BEGIN 
    dbms_output.put_line(count_emp);
END;


---Fonction qui retourne le nombre d'employe dans une ville entree en parametre
--Pour ne pas modifier la table, on va adapter cette fonction a une profession
---On va donc retourner le nombre d'employes occupant une profession entrer en parametre
CREATE OR REPLACE FUNCTION count_emp(uneProfession emp.profession%TYPE)
RETURN number IS 
nbreEmp number ;
BEGIN 
    SELECT COUNT(*) INTO nbreEmp FROM emp WHERE emp.profession = uneProfession;
    dbms_output.put_line('Le nombre total de '||uneProfession||' dans la table est :');
    RETURN nbreEmp;
END;

BEGIN 
    dbms_output.put_line(count_emp('DEVELOPPEUR'));
END;