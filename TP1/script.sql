-- Jeu de données sur des voyages  

-- Creation des trois tables 

CREATE TABLE Voyage(idVoyage INT UNIQUE, nomVoyage VARCHAR(255), region VARCHAR(255), distance REAL, suiteVoyage INT);
CREATE TABLE Voyageur(idVoyageur INT UNIQUE, nomVoyageur VARCHAR(255), ville VARCHAR(255), age INT);
CREATE TABLE Sortie(idVoyage INT REFERENCES Voyage(idVoyage), idVoyageur INT REFERENCES Voyageur(idVoyageur), dateSortie DATE, dureeSortie REAL, UNIQUE (idVoyage, idVoyageur, dateSortie));

-- Insertions de tuples dans les tables


-----------------------------------------------------------------------------------------------------
INSERT INTO Voyage VALUES (1, 'Discover Honfleurs', 'Normandie', 35, NULL);
INSERT INTO Voyage VALUES (2, 'La Chemin vers Paris', 'Ile de France', 25 , NULL);
INSERT INTO Voyage VALUES (3, 'Enjoy Paris', 'Ile de France', 31, 2);
INSERT INTO Voyage VALUES (4, 'Chateau de Versailles', 'Ile de France', 18, 3);
INSERT INTO Voyage VALUES (5, 'Patrimoine historique de lOccitane', 'Occitanie', 19, NULL);
INSERT INTO Voyage VALUES (6, 'Tapis rouge cannes', 'Provence Alpes Côte dAzur', 8, 8);
INSERT INTO Voyage VALUES (7, 'Le Grand Tour du Massif', 'Normandie', 10, NULL);
INSERT INTO Voyage VALUES (8, 'Le Chemin du Saint-Nazaire', 'Hauts de France', 14.18, NULL);
INSERT INTO Voyage VALUES (9, 'Etretat', 'Normandie', 6.23, 11);
INSERT INTO Voyage VALUES (10, 'Les montagnes en Corse', 'Corse', 14.5, NULL);
INSERT INTO Voyage VALUES (11, 'Couloir du Normandie', 'Normandie', 21, NULL);
INSERT INTO Voyage VALUES (12, 'La magnifique Saint-Malo', 'Bretagne', 10.8, NULL);
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
INSERT INTO Voyageur VALUES (1, 'Nolwen', 'Montpellier', 18);
INSERT INTO Voyageur VALUES (2, 'Eva', 'Paris', 22);
INSERT INTO Voyageur VALUES (3, 'Janson', 'Paris', 34);
INSERT INTO Voyageur VALUES (4, 'Brouna', 'Lille', 45);
INSERT INTO Voyageur VALUES (5, 'Nelson', 'Marseille', 59);
INSERT INTO Voyageur VALUES (6, 'Sofie', 'Nice', 66);
INSERT INTO Voyageur VALUES (7, 'Patrick', 'Lille', 54);
INSERT INTO Voyageur VALUES (8, 'Baptiste', 'Lille', 38);
INSERT INTO Voyageur VALUES (9, 'Nicolas', 'Rouen', 29);
INSERT INTO Voyageur VALUES (10, 'Sara', 'Rouen', 21);
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
INSERT INTO Sortie VALUES (1, 1, '21/JUL/2011', 6);
INSERT INTO Sortie VALUES (12, 7, '28/NOV/2011', 5.5);
INSERT INTO Sortie VALUES (2, 2, '01/JAN/2007', 6);
INSERT INTO Sortie VALUES (2, 5, '17/JUN/2012', 7.5);
INSERT INTO Sortie VALUES (8, 5, '21/JUL/2008', 6.5);
INSERT INTO Sortie VALUES (4, 5, '08/MAR/2011', 3.5);
INSERT INTO Sortie VALUES (7, 3, '19/MAY/2011', 11);
INSERT INTO Sortie VALUES (9, 2, '24/JUN/2014', 7);
INSERT INTO Sortie VALUES (10, 2, '25/JUN/2011', 8.5);
INSERT INTO Sortie VALUES (4, 8, '16/APR/2010', 6);
INSERT INTO Sortie VALUES (5, 8, '17/APR/2010', 4.5);
INSERT INTO Sortie VALUES (6, 8, '18/APR/2010', 5);
INSERT INTO Sortie VALUES (11, 8, '23/AUG/2010', 6);
INSERT INTO Sortie VALUES (11, 2, '23/JUL/2012', 7);
INSERT INTO Sortie VALUES (11, 5, '23/JUL/2012', 7);
INSERT INTO Sortie VALUES (7, 2, '27/JAN/2006', 6);
INSERT INTO Sortie VALUES (9, 9, '17/MAY/2011', 6.5);
INSERT INTO Sortie VALUES (10, 9, '10/APR/2008', 6);
INSERT INTO Sortie VALUES (10, 3, '24/FEB/2006', 2);
INSERT INTO Sortie VALUES (8, 10, '13/MAY/2012', 10.5);
INSERT INTO Sortie VALUES (5, 9, '01/SEP/2009', 3);
INSERT INTO Sortie VALUES (5, 1, '01/SEP/2009', 3);
INSERT INTO Sortie VALUES (8, 7, '14/JUN/2011', 6);
INSERT INTO Sortie VALUES (8, 7, '03/JUL/2012', 5);
INSERT INTO Sortie VALUES (8, 7, '19/MAY/2007', 5.5);
-----------------------------------------------------------------------------------------------------
