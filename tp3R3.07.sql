SET SERVEROUTPUT ON;

BEGIN 
    dbms_output.put_line(DBMS_DB_VERSION.VERSION || '.' || DBMS_DB_VERSION.RELEASE);
END;

---------------------------------------------------------------------------------------
DECLARE 
    i NUMBER(2);
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
WHEN empv THEN dbms_output.put_line('Aucune donne dans la table!');
END; 
----------------------------------------------------------
---Question4 : La variable emplyes peut declarer par le cursor peut etre assimile a un Recordset
---Question5 : Ce programme augmente le salaire de chaque employe de la table Emp 
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
salaire emp.salaire%TYPE;
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

CREATE OR REPLACE FUNCTION app_emp_dept(employeNom emp.nom_complet%TYPE, leDepartement dep.numdep%TYPE)
RETURN VARCHAR2 IS

BEGIN

END;
-------------------------------------------------------------