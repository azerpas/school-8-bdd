-- Etudiant(IdEtud: integer, NomEtud: string, age: integer, niveau: string, section: string) 
-- Cours(NomC: string, heure_cours: time, salle: string, #IdProf: integer) 
-- Inscription(#IdEtud: integer, #NomC: string) 
-- Professeur(IdProf: integer, prenom: string, #IdDep: integer)

CREATE TABLE Etudiant(idEtud INT UNIQUE, nomEtud VARCHAR(255), age INT, niveau VARCHAR(255), section VARCHAR(255));
CREATE TABLE Cours(NomC VARCHAR(255) UNIQUE, heure_cours TIMESTAMP, salle VARCHAR(255), idProf INT REFERENCES Professeur(idProf));
CREATE TABLE Inscription(idEtud INT REFERENCES Etudiant(idEtud), nomEtud VARCHAR(255) REFERENCES Etudiant(nomEtud));
CREATE TABLE Professeur(idProf INT UNIQUE, prenom VARCHAR(255), idDep INT REFERENCES Departement(idDep));

-- Écrire en langage PL/SQL les déclencheurs des requêtes suivants :

-- 1. L’effectif maximum des étudiants pour chaque cours est 30 étudiants. 
create or replace trigger maxEtu
before insert on Inscription
for each row
begin
    nb := 0;
    select count(*) into nb from Inscription where NomC = :new.NomC;
    if nb >= 30 then
        raise_application_error(-20300, "Maximum 30 étudiants");
    end if;
end;

-- 2. Uniquement les enseignants qui font partie de département dont l'IdDep = 33 ont le droit d’enseigner plus de trois cours.  
create or replace trigger coursParEnseignants
before insert on Cours
for each row
begin
    nbCours := 0;
    idDep := 0;
    select count(*) into nbCours from Cours where IdProf = :new.IdProf;
    -- j'utilise max pour récupérer la valeur unique
    select max(IdDep) into idDep from Professeur where IdProf = :new.IdProf;
    if nbCours >= 3 and idDep <> 33 then
        raise_application_error(-20300, "3 cours max pour ce prof");
    end if;
end;  

-- 3. Chaque étudiant doit être obligatoirement inscrit au cours intitulé "Data warehouse".   
 
-- 4. Chaque département ne doit pas avoir plus de 10 enseignants.   
create or replace trigger maxEnseignants
before insert or update on Professeur
for each row
begin
    nb := 0;
    select count(*) into nb from Professeur where IdDep = :new.IdDep;
    if nb >= 10 then
        raise_application_error(-20300, "Maximum 10 enseignants");
    end if;
end;

-- 5. Le nombre d’étudiants inscrits dans le module base de données répartis doit être supérieur au nombre d’étudiants dans le module mathématique pour l'info.   
create or replace trigger bddVsMaths
before insert or update on Inscription
begin
    nbBdd := 0;
    nbMaths := 0;
    select count(*) into nbBdd from Inscription where NomC := 'BDD';
    select count(*) into nbMaths from Inscription where NomC := 'MATHS';
    if nbMaths + 1 >= nbBdd then 
        raise_application_error(-20300, "Le nombre d’étudiants inscrits dans le module base de données répartis doit être supérieur au nombre d’étudiants dans le module mathématique pour l'info.");
    end if;
end;

-- 6. Le nombre d'inscription aux modules enseignés par les enseignants du département dont l'IdDep = 33 doivent être supérieur au nombre d'inscriptions dans module Optimisation.   
create or replace trigger optimisationRule
before insert or update on Inscription
for each row
begin
    nbInscriptionsOptimisation := 0; -- nombre d'inscriptions dans module Optimisation
    totalInscriptionsModules := 0; -- nombre d'inscriptions aux modules enseignés par les enseignants du département dont l'IdDep = 33
    select count(*) into nbInscriptionsOptimisation from Cours where NomC <> 'Optimisation';
    select count(*) into totalInscriptionsModules
        from Professeur
        cross join Cours
        where IdDep = 33;
    if nbInscriptionsOptimisation > totalInscriptionsModules then
        raise_application_error(-20300, "Le nombre d'inscription aux modules enseignés par les enseignants du département dont l'IdDep = 33 doivent être supérieur au nombre d'inscriptions dans module Optimisation.");
    end if;
end;    

-- 7. Les professeurs qui ne font pas partie de mêmes départements ne peuvent pas enseigner dans la même salle.
create or replace trigger memeDepSalle
before insert or update on Cours
for each row
begin
    nb := 0; -- nombre de professeurs n'étant pas du même département que l'inséré
    idDep := 0;
    -- j'utilise max pour récupérer la valeur unique
    select max(IdDep) into idDep from Professeur where IdProf = :new.IdProf;
    select count(*) into nb from Professeur where idDep <> :new.IdDep;
    if nb > 0 then
        raise_application_error(-20300, "Il y a déjà des professeurs d'autres départements qui enseignent ici");
    end if;
end;    