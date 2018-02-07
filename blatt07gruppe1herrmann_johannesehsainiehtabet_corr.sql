-- Aufgabe 2:
2/2
SELECT C.name
FROM country  C JOIN (
  SELECT DISTINCT country
  FROM Language L
  WHERE NOT EXISTS (
    (SELECT name
      FROM Language
      WHERE country = 'us')
    MINUS
    (SELECT name
      FROM Language
      WHERE country = L.country))
    AND NOT EXISTS (
      (SELECT name
        FROM Language
        WHERE country = L.country)
      MINUS
      (SELECT name
        FROM Language
        WHERE country = 'us')))
  ON C.code = country;

