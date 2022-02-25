-- Exercice 1

-- Employe(NumEmp:string, NomEmp:string, Hebdo:integer, Salaire:integer, #affect:integer) 
-- Service(NumServ:integer, NomServ:string, #chef:integer) 
-- Projet(NumProj:integer, NomProj:string, #Resp:integer) 
-- Travail(#NumEmp:integer, #NumProj:integer, Duree:integer)

-- 1. Écrire  une  procédure  qui prend comme  arguments  un  identifiant  d'employé  et  un  nombre,  puis mettre à jour le salaire de l'employé donné avec le nombre donné. Nombre = 500€. 
CREATE OR REPLACE PROCEDURE salaire_udpate(employe IN NUMBER, salaire IN NUMBER := 500) AS
begin
    UPDATE Employe SET Salaire = salaire+Salaire WHERE NumEmp = employe;
end;
-- 2. Écrire une fonction qui compte le nombre d'employés participant à un projet donné.   
CREATE OR REPLACE FUNCTION nb_employes(projet IN NUMBER)
RETURN NUMBER
IS 
    nb NUMBER;
begin
    select count(*) into nb from Travail where NumProj = projet;
    return nb;
end;
-- 3. Écrire  une  fonction  qui  compte  le  nombre  de  projets  supervisés  par  les  employés  d'un  service donné.   
CREATE OR REPLACE FUNCTION projets_sup(service_donne IN NUMBER)
RETURN NUMBER
IS 
    nb NUMBER;
begin
    select count(*) into nb from Projet where Resp in (select NumEmp from Employe where affect = service_donne);
    return nb;
end;

-- 4. Écrire une fonction qui compte le nombre de projets auxquels participe l'employé donné.   
CREATE OR REPLACE FUNCTION nb_projets(employe IN NUMBER)
RETURN NUMBER
IS 
    nb NUMBER;
begin
    select count(*) into nb from Travail where NumEmp = employe;
    return nb 
end;
-- 5. Écrire une fonction qui renvoie la chaîne 'Salaire faible' si le salaire de l'employé donné est inférieur à 2000€ sinon retourner 'Bon salaire'.   
CREATE OR REPLACE FUNCTION salaire_bon_mauvais(employe IN NUMBER)
RETURN VARCHAR
IS 
    salaire NUMBER;
begin
    select Salaire into salaire from Employe where NumEmp = employe;
    if salaire < 2000 then
    return ('Salaire faible')
    else
    return ('Bon salaire')
    end if;
end;
-- 6. Écrire une fonction, qui compte le nombre d'employés qui prennent en charge plus que le nombre de projets donné. 
CREATE OR REPLACE FUNCTION charge(nb_donne IN NUMBER)
RETURN NUMBER
IS 
    nb NUMBER;
begin
    select count(*) into nb from Travail where nb_donne < (select count(*) from Projet where Resp = NumEmp);
end;  
-- 7. Écrire une procédure qui insère l'employé donné dans une table de sauvegarde nommée 'ALERT_EMPLOYE'. 
CREATE OR REPLACE PROCEDURE sauvegarde(employe IN NUMBER)
IS 
    emp Employe%ROWTYPE;
begin
    select * into emp from Employe where NumEmp = employe;
    INSERT INTO ALERT_EMPLOYE VALUES (emp.NumEmp, emp.NomEmp, emp.Hebdo, emp.Salaire, emp.affect);
end;  


-- Exercice 2

-- Departement (NumDep, NomDep, Directeur) 
-- Employe (Matricule, Nom, Prenom, DateNaissance, Adresse, Salaire, #Numdep, #superieur) 
-- Projet (NumPrj, NomPrj, Lieu, #NumDep) 
-- Travaille (#Matricule, #NumPrj, Heures)

-- 1. Un employé ne peut pas travailler sur un projet qui n'appartient pas à son département
CREATE OR REPLACE TRIGGER not_dep
BEFORE INSERT OR UPDATE ON Travaille FOR EACH ROW
DECLARE
    dep_employe NUMBER;
    dep_projet NUMBER;
BEGIN
    select NumDep into dep_employe from Departement d where d.NumDep = (select NumDep from Employe e where e.Matricule = :new.Matricule);
    select p.NumDep into dep_projet from Projet p where p.NumPrj = :new.NumPrj;
    if dep_employe <> dep_projet then
        raise_application_error(-20000, 'Un employé ne peut pas travailler sur un projet qui nappartient pas à son département');
    end if;
END;
-- 2. Supposons  qu'il  existe  une  règle  dans  l'entreprise  stipulant  que  le  salaire  d'un  employé  ne  peut pas  être  modifié  de  plus  de  20%  du  salaire  initial.  Créez  un  trigger  'Suivi_changements_salaire' pour faire respecter cette contrainte.   
CREATE OR REPLACE TRIGGER Suivi_changements_salaire
BEFORE UPDATE ON Employe FOR EACH ROW
BEGIN
    if ((Salaire / :new.Salaire >= 1.2) or ((:new.Salaire / Salaire >= 1.2)) then
        raise_application_error(-20000, 'le  salaire  dun  employé  ne  peut pas  être  modifié  de  plus  de  20%  du  salaire  initial')
    end if;
END;
-- 3. Une fois qu'un département est créé, nous ne pouvons pas changer son nom ou le supprimer. 
CREATE OR REPLACE TRIGGER dep_fini 
BEFORE UPDATE OF NomDep OR DELETE ON Departement FOR EACH ROW
BEGIN
    raise_application_error(-20000, 'Une fois quun département est créé, nous ne pouvons pas changer son nom ou le supprimer.')
END;
-- 4. Un employé ne peut pas travailler plus de 200 heures.  
CREATE OR REPLACE TRIGGER heures_limite 
BEFORE INSERT OR UPDATE ON Travaille FOR EACH ROW
DECLARE 
    heures NUMBER;
BEGIN
    select sum(t.Heures) into heures from Travaille where Matricule = :new.Matricule;
    if heures > 200
        raise_application_error(-20000, 'Un employé ne peut pas travailler plus de 200 heures. ')
    end if;
END;