/*
EMPLOYES(refemp, nom, prenom, salTot, NbProjet);
PROJET(refproj, #refdir, nomp, nbheuresprevues, nbheureseffectuees, budget) ;
PARTICIPE (#refproj, #refemp, dateP )
TACHE(#refproj, #refemp, semaine , nbheures);
*/

-- 1. Transformer en majuscule la valeur du l’attribut nom des employés dans la table EMPLOYES.
create or replace trigger NOMMAJ
before insert on employes
for each row
begin
:new.nom := upper(:new.nom);
end;
-- 2. Mettre à jour automatiquement la clé primaire refemp de la table EMPLOYES.
create or replace trigger AUTOINC
before insert on employes
declare
maxval integer,
begin
select max(refemp) into maxval from employes;
if maxval is not null then
:new.refemp := maxval + 1;
else
:new.refemp := 1;
end if;
end;
-- 3. Mettre à jour l’attribut salTot d’un employé de la table EMPLOYES (cas d’insertion seulement).
create or replace trigger MAJ SalTot
    after insert on tache for each row
begin
    update employes set saltot = saltot + (:new. nbheures * 600)
    where refemp = :new.refemp; 
end;

-- 4. Mettre à jour l’attribut nbheureseffectuees de la table PROJET.
create of replace trigger NBHEURES
after insert or delete or update on tache
for each row
begin
if inserting then
    update projet
    set nbheureseffectuees = nbheureseffectuees + :new.nbheures
    where refproj = :new.refproj;
end if;
if updating then 
    if :new.nbheures > :old.
end;
-- 5. Mettre à jour automatiquement l’attribut NbProjet de la table EMPLOYES
create or replace trigger MajNbProjet
before insert on tache
for each row
declare nb integer;
begin
    nb := 0;
    select count(*) into nb 
    from tache
    where refemp = :new.refemp and refproj = :new.refproj;

    if nb = 0 then 
        update employes 
        set NbProjet = NbProjet + 1
        where refemp = :new.refemp;
    end if;
end;
-- 6. L’attribut refdir représente le directeur d’un projet. Interdire le directeur d’un projet d’effectuer des tâches sur son propre projet. Nb : Utiliser la requête suivante pour la gestion d’erreur raise_application_error(- 20300, ’message ’);
create or replace trigger forb_director
before insert on tache
foreach row
declare ref integer;
begin
    ref := 0;
    select count(*) into ref from projet
    where refdir = :new.refemp and refproj = :new.refproj;
    if(ref > 0) then
        raise_application_error(-20300, "vous êtes directeur");
    endif;
end;
-- 7. Il faut veiller sur la vérification de nombre d’heures effectuées, qui ne doit pas dépasser le nombre d’heures prévues pour la réalisation d’un projet. En cas de dépassement, il faut écrire un message dans la table TAB LOG prévue pour recueillir les anomalies constatées lors de la gestion des projets. Le schéma de la table TAB LOG est TAB LOG(NumPb, date pb, refproj, message). Le champ NumPb est un champ qui doit se remplir et s’incrémenter automatiquement.

-- 8. La modification au niveau de la table TAB LOG est interdite, en cas de modification de celle-ci, on veut connaitre celui qui l’a modifié (l’utilisateur courant USER) ainsi que la date de cette modification. Ces informations seront automatiquement insérées dans la table AuditTable LOG(Num Pb, Modifie par, Date Modif). 

