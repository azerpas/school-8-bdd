-- Partie n°1 : Exprimez les requetes suivantes en langage SQL :
--- 1. Toutes les informations sur les voyageurs.
select * from voyageur;
--- 2. Les voyageurs âgés entre 40 et 50 ans.
select * from voyageur where age between 40 and 50;
--- 3. Les voyageurs de moins de 45 ans et leurs éventuelles sorties.

--- 4. Les voyageurs qui n’ont jamais fait de sorties (avec sous-requête).
select * from voyageur where idVoyageur not in (select idVoyageur from sortie);
--- 5. Les voyageurs qui vivent dans une ville contenant ’en’ et qui font des voyages (avec sous-requetes).
select * from voyageur where ville like '%en%' and idVoyageur in (select idVoyageur from sortie);
--- 6. Les voyageurs qui ont fait des sorties en 2011 et 2012.
select distinct * from voyageur, sortie where voyageur.idVoyageur = sortie.idVoyageur AND extract(year from dateSortie) = 2011 
    intersect
select distinct * from voyageur, sortie where voyageur.idVoyageur = sortie.idVoyageur AND extract(year from dateSortie) = 2012;
--- 7. Les voyageurs qui ont fait des sorties en 2011 ou 2012.
select distinct * from voyageur, sortie where voyageur.idVoyageur = sortie.idVoyageur AND extract(year from dateSortie) = 2011 
    union
select distinct * from voyageur, sortie where voyageur.idVoyageur = sortie.idVoyageur AND extract(year from dateSortie) = 2012;
--- 8. Le voyageur le plus âgé (avec sous-requête).
select * from voyageur where age >= all(select age from voyageur);
--- 9. Le nombre total des voyageurs.
select count(*) from voyageur;
--- 10. L’âge moyen des voyageurs.
select avg(age) from voyageur;

-- thks Nicolas
--- 11. L’identifiant et le nom des voyages de plus de 20 kms.
SELECT IDVOYAGE, NOMVOYAGE FROM VOYAGE WHERE DISTANCE > 20;
--- 12. Les voyages qui ont une suite.
SELECT * FROM VOYAGE WHERE SUITEVOYAGE IS NOT NULL;
--- 13. Les informations sur les voyages ainsi que sur le voyage qui suit.
SELECT V1.*, V2.* FROM VOYAGE V1 INNER JOIN VOYAGE V2 ON V1.SUITEVOYAGE = V2.IDVOYAGE;
--- 14. Le voyage qui n’a jamais été fait par un voyageur (avec sous-requête).
SELECT * FROM VOYAGE WHERE IDVOYAGE NOT IN (SELECT IDVOYAGE FROM SORTIE);
--- 15. La sortie la plus longue (avec sous-requête).
SELECT * FROM SORTIE WHERE DUREESORTIE = (SELECT MAX(DUREESORTIE) FROM SORTIE);
--- 16. La distance maximale des voyages.
SELECT MAX(DISTANCE) AS DISTANCE_MAXIMALE FROM VOYAGE;
--- 17. Le nombre de voyage de la région de Provence Alpes Côte d'Azur. 
SELECT COUNT(*) AS NB_VOYAGES_PACA FROM VOYAGE WHERE REGION LIKE 'Provence Alpes Côte dAzur';
--- 18. Le nombre de voyages effectuées par voyageur.
--- 19. Le nombre de voyage effectuées par région.
SELECT REGION, COUNT(*) AS NB_VOYAGES FROM VOYAGE V GROUP BY REGION;
--- 20. La sortie la plus récente.
SELECT * FROM SORTIE WHERE DATESORTIE = (SELECT MAX(DATESORTIE) FROM SORTIE);
--- 21. Le nombre de sorties effectuées par jour.
SELECT DATESORTIE, COUNT(*) AS NB_SORTIES FROM SORTIE GROUP BY DATESORTIE ORDER BY DATESORTIE;
--- 22. Le nombre de sorties effectuées par an.
SELECT EXTRACT(YEAR FROM DATESORTIE) AS ANNEE, COUNT(*) AS NB_SORTIES FROM SORTIE GROUP BY EXTRACT(YEAR FROM DATESORTIE) ORDER BY EXTRACT(YEAR FROM DATESORTIE);
--- 23. La sortie la plus récente.

-- Partie n°2 : Effectuez les mises à jour suivantes :
--- 1. Mettre à jour la ville de naissance du voyageur Nicolas par Paris.
--- 2. Mettre en majuscule tous les noms des voyageurs.
--- 3. Mettre à jour les voyages qui n’ont pas de suite par la valeur 0.
--- 4. Ajouter un nouveau attribut ’pays’ à la table voyage et mettre à jour la colonne par la valeur France.
--- 5. Ajouter deux contraintes d’intégrité permettant de garantir que la distance des voyages ainsique l’âge des voyageurs soient strictement positives.
-- Partie n°3 : Création des vues :
--- 1. Créer une vue contenant les voyageurs de moins de 50 ans.
--- 2. Créer une vue contenant les noms des voyageurs de moins de 50 qui ont fait un voyage à Rouen (utiliser la vue précédemment crée).