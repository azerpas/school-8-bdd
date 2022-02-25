CREATE OR REPLACE PROCEDURE update_salaire(idemp IN Employe.nuempl%type, sal IN number)
IS
BEGIN
    UPDATE EMPLOYE SET salaire=salaire+sal WHERE nuempl=idemp;
END;


CREATE OR REPLACE FUNCTION projet_employe(idproj IN number)
RETURN number
IS
    nb number;
BEGIN
    select count(*) into nb from Travail where nuproj=idproj;
    return nb;
END;

CREATE OR REPLACE FUNCTION projet_service(idservice IN number)
RETURN number
IS
    nb number;
BEGIN
    select count(*) into nb from projet where resp in (select nuempl from employe where affect=idservice);
    return nb;
END;

CREATE OR REPLACE FUNCTION projet_employe(idemp IN number)
RETURN number
IS
    nb number;
BEGIN
    select count(*) into nb from Travail where nuempl=idemp;
    return nb;
END;

CREATE OR REPLACE FUNCTION etat_salaire(salaire IN number)
RETURN VARCHAR2
BEGIN
    IF salaire<2000 THEN
        return 'Salaire faible';
    ELSE
        return 'Bon salaire';
    END IF
END;

CREATE OR REPLACE FUNCTION resp_pop(nbproj IN number)
RETURN number
IS
    nb number;
BEGIN
    Select count(*) into nb from employe e where (select count(*) from projet p where e.nuempl=p.resp)> nbproj ;
    return nb;
END;

CREATE OR REPLACE PROCEDURE employe_backup(emp Employe%rowtype)
IS
BEGIN
    INSERT INTO ALERT_EMPLOYE VALUES(emp.nuempl,emp,nomemp,emp.hebdo,emp.salaire,emp.affect);
END;

CREATE OR REPLACE TRIGGER quest_1
AFTER INSERT OR UPDATE ON Travaille FOR EACH ROW
DECLARE
    DEP1 NUMBER;
    DEP2 NUMBER;
BEGIN
    SELECT N_Dep INTO DEP1 FROM Projet WHERE N_Proj=:NEW.N_Proj;
    SELECT N_Dep INTO DEP2 FROM Employe WHERE Matricule=:NEW.Matricule;
    IF DEP1 !=DEP2 THEN
        RAISE_APPLICATION_ERROR(-20005,'un employé ne peut pas travailler sur un projet qui n’appartient pas à son département');
    END IF;
END;

CREATE OR REPLACE TRIGGER Suivi_changements_salaire
AFTER UPDATE ON EMPLOYE FOR EACH ROW
BEGIN
    IF ((:NEW.Salaire/:OLD.Salaire) >= 1.2) OR ((:OLD.Salaire/:NEW.Salaire) >= 1.2) THEN
        RAISE_APPLICATION_ERROR(-20002, 'le salaire d’un employé ne peut pas être modifié de plus de 20% du salaire initial');
    END IF;
END;

CREATE OR REPLACE TRIGGER quest_3
BEFORE UPDATE of NomD OR DELETE ON Departement
BEGIN
    RAISE_APPLICATION_ERROR (-20501, 'Une fois qu’un département est créé, nous ne pouvons pas changer son nom ou le supprimer');
END;

CREATE OR REPLACE TRIGGER quest_4
AFTER INSERT OR UPDATE ON Travaille FOR EACH ROW
DECLARE
    SOMME NUMBER;
BEGIN
    SELECT SUM(Heures) INTO SOMME FROM Travaille WHERE Matricule=:NEW.Matricule;
    IF SOMME > 200 THEN
        RAISE_APPLICATION_ERROR(-20005,'Un employé ne peut pas travailler plus de 200 heures.');
    END IF;
END;