-- Aufgabe 1
16.5/21

7/8
CREATE TABLE Abteilung (
	Abnr INTEGER PRIMARY KEY,
	Bezeichnung VARCHAR2(2),
        -- a)
	Budget NUMBER
          CHECK (Budget >= (
            SELECT SUM(A.Gehalt)
            FROM Angestellte A
            WHERE AbNr = A.AbNr)),
	AnzAng INTEGER,
        -- b)
	-- this schould be in table Angestellte (-0.5)
	-- and you should group by abNr, because the AVG should be of a department (-0.5)
	CHECK (2000 >= (
          SELECT AVG(Gehalt)
          FROM Angestellte A
          WHERE AbNr = A.AbNr))
);

CREATE TABLE Angestellte (
	AngNr INTEGER PRIMARY KEY ,
	Name VARCHAR2 (40) ,
	Gehalt NUMBER ,
	AbNr INTEGER
        -- c)
	FOREIGN KEY (Abnr) REFERENCES Abteilung (Abnr)
	ON NO ACTION ON RESTRICT)
);	

-- d)
CREATE ASSERTION Assertgehalt(
  CHECK (
    (SELECT MAX(Gehalt) FROM Angestellte GROUP BY AbNr) =< (
      SELECT (AVG(Gehalt) * 2) FROM Angestellte)
  )
)


2/4
-- Aufgabe 2 
-- a)
-- you should identify capital using the primary key of city(code, province, name) (-1) if you do that at the beginning at SELECT count(name) it is a really easy query
CREATE ASSERTION Assert1 (
  CHECK (
    X >= (
       SELECT COUNT(Name)
       FROM City C1
       WHERE Population < (
           SELECT biggestPop
           FROM (
             SELECT Country, MAX(Population) AS biggestPop
             FROM City
             GROUP BY Country)
           WHERE Country = C1.Country)
         AND Name IN (
           SELECT Capital
           FROM Country))
  )
)

-- b)
-- then X = 42 (-1)
/* Ab einem Wert von 243 ist die Bedingung erfüllt */


3/3
-- Aufgabe 3
CREATE TABLE Z1 (
K1 CHAR(2),
K2 CHAR(2),
PRIMARY KEY (K1) );

CREATE TABLE Z2 (
K2 CHAR(2),
K1 CHAR(2),
PRIMARY KEY (K2) );

-- Inserts, Z1:
INSERT INTO Z1 (K1, K2) VALUES ('1', '2');
INSERT INTO Z1 (K1, K2) VALUES ('2', '3');
INSERT INTO Z1 (K1, K2) VALUES ('4', '1');
INSERT INTO Z1 (K1, K2) VALUES ('3', '5');
INSERT INTO Z1 (K1, K2) VALUES ('5', '2');
INSERT INTO Z1 (K1, K2) VALUES ('6', '6');

-- Inserts, Z2:
INSERT INTO Z2 (K1, K2) VALUES ('1', '3');
INSERT INTO Z2 (K1, K2) VALUES ('2', '5');
INSERT INTO Z2 (K1, K2) VALUES ('4', '6');
INSERT INTO Z2 (K1, K2) VALUES ('3', '2');
INSERT INTO Z2 (K1, K2) VALUES ('5', '1');
INSERT INTO Z2 (K1, K2) VALUES ('6', '4');
 

ALTER TABLE Z1 ADD CONSTRAINT fk_z1
FOREIGN KEY (K2) REFERENCES Z2(K2) ON DELETE CASCADE;
ALTER TABLE Z2 ADD CONSTRAINT fk_z2
FOREIGN KEY (K1) REFERENCES Z1(K1) ON DELETE CASCADE;

DELETE FROM Z1 WHERE K1 = '1';

4.5/6
-- Aufgabe 4
-- a)
-- WHEN NOT EXISTS (
--    SELECT * FROM T1
--    WHERE k1 = :Alt.k1) is not necessary and makes the triggers not executable, if you write the trigger without it, they work(-1) (be careful after the DELETE line you need a ;) 

CREATE TRIGGER fk1_t2
  AFTER DELETE ON T1
  REFERENCING OLD AS Alt
  FOR EACH ROW
  WHEN NOT EXISTS (
    SELECT * FROM T1
    WHERE k1 = :Alt.k1)
  BEGIN
    DELETE FROM T2 WHERE k1 = :Alt.k1
  END;
  
CREATE TRIGGER fk1_t3
  AFTER DELETE ON T1
  REFERENCING OLD AS Alt
  FOR EACH ROW
    WHEN NOT EXISTS (
    SELECT * FROM T1
    WHERE k1 = :Alt.k1)
  BEGIN
    DELETE FROM T3 WHERE k1 = :Alt.k1
  END;
  
CREATE TRIGGER fk1_t4
  AFTER DELETE ON T2
  REFERENCING OLD AS Alt
  FOR EACH ROW
    WHEN NOT EXISTS (
    SELECT * FROM T2
    WHERE k2 = :Alt.k2)
  BEGIN
    DELETE FROM T4 WHERE k2 = :Alt.k2
  END;
  
CREATE TRIGGER fk2_t4
  AFTER DELETE ON T3
  REFERENCING OLD AS Alt
  FOR EACH ROW
    WHEN NOT EXISTS (
    SELECT * FROM T3
    WHERE k3 = :Alt.k3)
  BEGIN
    UPDATE T4
    SET T4.k3 = NULL
    WHERE T4.k3 = :Alt.k3
  END;

-- b)

-- here the first 3 triggers remain unchanged
-- for trigger 4 also the WHEN does not work that way, if you create a variable after FOR EACH ROW
--(DECLARE X NUMBER) and after the BEGIN statement you store the count of your WHEN clause into it (without = 1) After that you can check if X > 0 and then raise an application error (-0.5)
CREATE TRIGGER fk1_t2
  BEFORE DELETE ON T1
  REFERENCING OLD AS Alt
  FOR EACH ROW
  WHEN ( ( SELECT COUNT(*)
    FROM T1 WHERE k1 = :Alt.k1) = 1)
  BEGIN
    DELETE FROM T2 WHERE k1 = :Alt.k1
  END;
  
CREATE TRIGGER fk1_t3
  BEFORE DELETE ON T1
  REFERENCING OLD AS Alt
  FOR EACH ROW
  WHEN ( ( SELECT COUNT(*)
    FROM T1 WHERE k1 = :Alt.k1) = 1)
  BEGIN
    DELETE FROM T3 WHERE k1 = :Alt.k1
  END;
  
CREATE TRIGGER fk1_t4
  BEFORE DELETE ON T2
  REFERENCING OLD AS Alt
  FOR EACH ROW
    WHEN ( ( SELECT COUNT(*)
    FROM T2 WHERE k2 = :Alt.k2) = 1)
  BEGIN
    DELETE FROM T4 WHERE k2 = :Alt.k2
  END;
  
CREATE TRIGGER fk2_t4
  BEFORE DELETE ON T3
  REFERENCING OLD AS Alt
  FOR EACH ROW
    WHEN ( ( SELECT COUNT(*)
    FROM T3 WHERE k3 = :Alt.k3) = 1)
  BEGIN
    RAISE_APPLICATION_ERROR(-2001, 'Deleting not allowed')
  END;
  
