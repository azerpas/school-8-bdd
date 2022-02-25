-- 1. Écrire en langage PL/SQL la fonction factoriel(n) qui calcule la factoriel d’un nombre et le programme permettant d’afficher le factoriel(15)

FUNCTION factoriel (n IN NUMBER)
RETURN NUMBER IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        RETURN n * factoriel(n - 1);
    END IF;
END;

-- 2. En utilisant la fonction déjà définie précédemment, calculer la factorielle d’une valeur donnée en entrée par l’utilisateur
CREATE OR REPLACE FUNCTION factoriel(n IN NUMBER)
RETURN NUMBER IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        RETURN n * factoriel(n - 1);
    END IF;
END;
/

accept x prompt 'Enter First Number : '

begin
  DBMS_OUTPUT.PUT_LINE('Factoriel: ' || fact(&x);
end;
/

-- 3. Écrire une procédure permettant d’afficher la catégorie ainsi que le nom de chaque voyageur. La catégorie est définie comme suit :
-- ▪ Si l’âge du voyageur est inferieur a 18 ans ---> Junior 
-- ▪ Si l’âge du voyageur est supérieur à 50 ans ---> Senior
-- ▪ Pour les autres voyageurs --->Middle
CREATE OR REPLACE PROCEDURE GET_CATEGORIE (age IN NUMBER)
IS
begin
    if age < 18 then 
        dbms_output.put_line('Junior');
    else if age < 50 then
        dbms_output.put_line('Senior');
    else 
        dbms_output.put_line('Middle');
    end if; 
end;
-- 4. Écrire une procédure permettant d’afficher les informations d’un voyageur à partir de son identifiant (idVoyageur).

-- 5. Écrire un trigger qui se déclenche avant la suppression d’un voyageur. Le trigger devra supprimer toutes les sorties de ce voyageur.
-- Faire le test avec la suppression du participant ’Nelson’.

-- 6. Ajouter dans la table voyageur l’attribut catégorie.
-- ▪ L’attribut catégorie devra contenir la catégorie du voyageur.
create or replace procedure Remplir Categorie (part Voyageur%rowtype) as 
cat part.categorie %type;
begin 
    if partage <18 then
        cat := 'junior'; 
    end if;
    if part.age > 50 then
        cat:= 'senior';
    else
        cat='middle';
    end if;
    update Voyageur set categorie = cat where idVoyageur = part.idVoyageur 
end;
--Appel de la procedure 
declare
    catg Voyagageur%rowtype;
begin
    for particip in (select * from Voyageur) 
    loop
        Remplircategorie(catg); 
    end loop;
end;

-- 7. Créer un trigger qui permet de s’assurer qu’à l’insertion ou à la mise à jour d’un voyage, que
-- celui-ci ne peut être la suite de lui-même.
create or replace trigger suite 
before insert or update on Voyage 
for each row 
begin
    if :new.idVoyage = :new.suite Voyage 
    then raise application error(-20300, 'Erreur! Un voyage ne peut etre la suite de lui meme!');
end if; end;