3/5
-- Aufgabe 1:

--the query does not seem to come to an end, the part causing that is the exlustion parts of the countries already reached in the indirectly reachable tables. (-1) Following changes can be done: delete the parts. Then in the Grenzuebergang table add a SELECT before the others (SELECT Country1, country2, Min(Anzahl) AS Anzahl FROM) the min chooses the path with the viewest border crossings from the other views. You have to group by country1 and country2 for the min. Then the result is correct and runs really fast.
CREATE VIEW SymBorders AS (
  SELECT Country1 AS Country1, Country2 AS Country2
  FROM Borders)
UNION (
  SELECT Country2 AS Country1, Country1 AS Country2
  FROM Borders);

-- Helper View 1: European countries
-- without percentage = 100 it is correct (-0.5)
CREATE VIEW Europe AS
  SELECT DISTINCT Country1 AS Lcode
  FROM SymBorders, Encompasses
  WHERE Country1 = Country AND Continent = 'Europe' AND percentage = 100;

-- Helper View 2: All European countries, that are directly connected

-- here we search vor country1 <> country2, because we want both directions in the view. (-0.5)
CREATE VIEW directlyReachable AS
  SELECT DISTINCT Country1, Country2, 1 AS Anzahl 
  FROM SymBorders
  WHERE Country1 IN (SELECT Lcode FROM Europe)
    AND Country2 IN (SELECT Lcode FROM Europe)
    AND Country1 < Country2;

-- Helper View 3: All European countries, that are indirectly connected, one
-- country in between

-- also here check for S1.country1 <> s2.country2
CREATE VIEW indirectlyReachable1 AS
  SELECT DISTINCT S1.Country1 AS Country1, S2.Country2 AS Country2, 2 AS Anzahl
  FROM SymBorders S1, SymBorders S2
  WHERE S1.Country1 IN (SELECT Lcode FROM Europe)
    AND S2.Country2 IN (SELECT LCode FROM Europe)
    AND S1.Country1 < S2.Country2
    -- The traversed country
    AND S1.Country2 = S2.Country1
    -- Exclude the countries which were already reached
    AND S2.Country2 NOT IN (
      SELECT Country2
      FROM directlyReachable
      WHERE S1.Country1 = Country1);


-- Helper View 4: All european countries, seperated by two other countries

-- also here check for S1.country1 <> s2.country2
CREATE VIEW indirectlyReachable2 AS
  SELECT DISTINCT S1.Country1 AS Country1, S3.Country2 AS Country2, 3 AS Anzahl
  FROM symBorders S1, symBorders S2, symBorders S3
  WHERE S1.Country1 IN (SELECT Lcode FROM Europe)
    AND S3.Country2 IN (SELECT Lcode FROM Europe)
    AND S1.Country1 < S3.Country2
    -- First traversed country
    AND S1.Country2 = S2.Country1
    -- Second traversed country
    AND S2.Country2 = S3.Country1
    -- Exclude the countries which were already reached
    AND S3.Country2 NOT IN ((
        SELECT Country2
        FROM directlyReachable
        WHERE S1.Country1 = Country1)
      UNION (
        SELECT Country2
        FROM indirectlyReachable1
        WHERE S1.Country1 = Country1));

-- Main VIEW for this exercise
-- https://youtu.be/ErvgV4P6Fzc?t=1m34s
CREATE VIEW Grenzuebergang AS (
  SELECT Country1, Country2, Anzahl FROM directlyReachable)
UNION ((
    SELECT Country1, Country2, Anzahl FROM indirectlyReachable1)
  UNION (
    SELECT DISTINCT Country1, Country2, Anzahl FROM indirectlyReachable2))
ORDER BY Country1 ASC, Anzahl ASC, Country2 ASC;


3/5
--2b) missing (-2)
-- Aufgabe 2a:
/*
0: Nach | Anzahl
   -------------
   1    | 1
   
   Vor der ersten Iteration ist nur '1' erreichbar,
   da '1' direkt an '0' grenzt

1: Nach | Anzahl
   -------------
   1    | 1
   2    | 2
   4    | 2

   Über '1' sind '2' und '4' erreichbar.
   '0' wird nicht hinzugefügt, da dies der Ausgangspunkt ist.

2: Nach | Anzahl
   -------------
   1    | 1
   2    | 2
   4    | 2
   3    | 3
   5    | 3

   '3' ist über '2' erreichbar und '5' ist über '4' erreichbar.
   Weitere Zeilen werden nicht hinzugefügt, da nun alle Knoten
   die <> 0 enthalten sind.

3: Nach | Anzahl
   -------------
   1    | 1
   2    | 2
   4    | 2
   3    | 3
   5    | 3

   In dieser Iteration geschieht nichts mehr, so dass
   alt = neu und der Loop abbricht.
*/

-- Aufgabe 3:
4/4
-- The table that holds the result
CREATE TABLE Languages(
  Name VARCHAR2(40),
  Percentage NUMBER);

-- The procedure
CREATE OR REPLACE
PROCEDURE SpokenLanguage(lang CHAR) AS
BEGIN
  -- Empty the table
  DELETE FROM Languages;
  -- And insert the country names
  INSERT INTO Languages
    SELECT DISTINCT C.Name AS Name, L.Percentage AS Percentage
    /* This gives us a table with the country name and
         the spoken language in one row */
    FROM Language L JOIN Country C ON L.country = C.Code
    -- And select the fitting languages
    WHERE L.name = lang
END;


5.5/6
-- Aufgabe 4 a) 
-- check (not exists (SELECT ... WHERE t1.b <> t2.b)) (-0.5)
CHECK ( SELECT * FROM T AS t1 INNER JOIN T AS t2 ON t1.a = t2.a
        WHERE t1.b = t2.b)


CHECK ((SELECT * SUM(T.a) from T) >= (select sum(T.b) FROM t))

-- Aufgabe b)

CREATE ASSERTION TEST(CHECK((SELECT SUM(t.a) FROM T) >= (SELECT SUM(T.B) FROM T )))

--also here check (not exists (SELECT ... WHERE t1.b <> t2.b))
CREATE ASSERTION TEST 1( CHECK(SELECT * FROM T AS AT1 INNER JOINT T AS T2 ON T.A = T2.A WHERE T1.b = T2.b))
