/* Aufgabe 2a:
1/2
     Hier fehlt die GROUP BY Klausel. Diese wird benötigt,
     da die MAX() Funktion verwendet wird. Korrekt wäre: */
-- hier ist der fehler, dass bei dem attribut nicht ein einzelnes ergebnis selektiert wird, wie das bei der aggregatsfunktion der Fall ist (-0.5)
SELECT MAX(area), code
FROM Country
GROUP BY code
-- Die obenstehende Anfrage würde schon von SQl korrekt interpretiert.
-- Mit der folgenden Zeile bekommt man den Inhalt sinnvoll präsentiert.
ORDER BY MAX(area) DESC;

/* Aufgabe 2b:
     Das Attribut nach dem gruppiert wird (Country.code) passt
     nicht zu dem Attribut das selektiert wird (Country.name) */
--es muss aber auf jeden fall nach code guppiert werden, da das der primary key der Tabelle ist, wenn man name hinzufügt ändert das dann nichts. (GROUP BY name, code) (-0.5)
SELECT Country.name, COUNT(*) AS anzahl
FROM Country JOIN City ON Country.code = City.country
GROUP BY Country.name
ORDER BY anzahl DESC;

--3
5.5/6
-- Aufgabe 3a:
SELECT continent, AVG(gdp * (percentage / 100)) AS average
FROM Encompasses JOIN Economy ON Encompasses.country = Economy.country
GROUP BY continent
ORDER BY average DESC;

-- Aufgabe 3b:
--auch hier wird der primary key in der group by benötigt (-0.5)
SELECT country.name, city.province, COUNT(city.province) AS CityNumber, AVG(city.population) AS AveragePopulation
FROM country JOIN city ON country.code = city.country
HAVING COUNT(City.province) >= 30
GROUP BY city.province, country.name
ORDER BY Country.name ASC, AVG(City.population) DESC;

-- Aufgabe 4:
2/3
--in der nested query sucht ihr die länderfläche der länder die min 10 mio einwohner haben, C1.code != c2.code ist hier also falsch. (-1)
SELECT name, area -- Umbennen?
FROM Country C1
WHERE area < ALL
(SELECT area
  FROM Country C2
  WHERE C1.code != C2.code AND C2.population >= 10000000)
ORDER BY area DESC;

--5
5/5
-- Aufgabe 5a:
SELECT DISTINCT country.name
FROM Country JOIN City ON country.code = city.country
WHERE city.name LIKE 'Victoria'
ORDER BY country.name ASC;

-- Aufgabe 5b:
SELECT country.name
FROM Country
WHERE code IN (
  SELECT city.country
  FROM City
  WHERE name LIKE 'Victoria')
ORDER BY name ASC;

-- Aufgabe 5c:
SELECT c1.name AS CountryName
FROM Country c1
WHERE 'Victoria' IN (
  SELECT c2.name
  FROM City c2
  WHERE c1.code = c2.country)
ORDER BY c1.name ASC;

