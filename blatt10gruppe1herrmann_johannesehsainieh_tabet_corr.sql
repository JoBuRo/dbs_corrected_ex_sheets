2/2
CREATE OR REPLACE VIEW
CITY_LAT_LON ( NAME , COUNTRY , PROVINCE , POPULATION , LAT , LON ) AS
SELECT name , country , province , population ,
CAST ( TRUNC ( latitude ) AS NUMBER (3) ) ,
CAST ( TRUNC ( longitude ) AS NUMBER (3) )
FROM City ;

SELECT ci. country , lat , lon , SUM ( population ), COUNT (*)
FROM City_Lat_Lon ci , is_member
WHERE ci. country = is_member . country AND is_member . organization = 'OPEC'
GROUP BY GROUPING SETS ((ci.country, lat, lon), (ci.country, lat), (ci.country), ())
ORDER BY ci. country , lat , lon ;
