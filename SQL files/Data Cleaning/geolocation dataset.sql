SELECT * FROM brazil_ecommerce_dataset.geolocation_dataset;

DESCRIBE geolocation_dataset;

UPDATE geolocation_dataset
SET geolocation_lat = REGEXP_REPLACE(geolocation_lat, '[^0-9.-]', '');   

UPDATE geolocation_dataset
SET geolocation_lng = REGEXP_REPLACE(geolocation_lng, '[^0-9.-]', '');
 
ALTER TABLE geolocation_dataset	
MODIFY COLUMN geolocation_lat DECIMAL(10,6);

ALTER TABLE geolocation_dataset
MODIFY COLUMN geolocation_lng DECIMAL(10,6);

UPDATE geolocation_dataset
SET geolocation_zip_code_prefix = TRIM(geolocation_zip_code_prefix);

SELECT *
FROM geolocation_dataset
WHERE geolocation_zip_code_prefix = '' OR geolocation_zip_code_prefix IS NULL;
#There are no missing zip codes

SELECT COUNT(DISTINCT geolocation_zip_code_prefix)  AS zip_count,
	geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
FROM geolocation_dataset
GROUP BY geolocation_zip_code_prefix,
		geolocation_city,
        geolocation_state
HAVING zip_count >1
ORDER BY zip_count DESC;
#There are no duplicate zip_codes

UPDATE geolocation_dataset
SET geolocation_lat = TRIM(geolocation_lat);

SELECT *
FROM geolocation_dataset
WHERE geolocation_lat = '' OR geolocation_lat IS NULL;
#There are no missing latitudes

UPDATE geolocation_dataset
SET geolocation_lng = TRIM(geolocation_lng);

SELECT *
FROM geolocation_dataset
WHERE geolocation_lng = '' OR geolocation_lng IS NULL;
#There are no missing longitudes

UPDATE geolocation_dataset
SET geolocation_city = TRIM(geolocation_city);

SELECT *
FROM geolocation_dataset
WHERE geolocation_city = '' OR geolocation_city IS NULL;
#There are no missing cities

SELECT DISTINCT geolocation_city
FROM geolocation_dataset
ORDER BY geolocation_city ASC;

UPDATE geolocation_dataset
SET geolocation_city = 'arraial do cabo'
WHERE geolocation_city LIKE ('%arraial do cabo');

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('%cidade');

UPDATE geolocation_dataset
SET geolocation_city = 'curitiba'
WHERE geolocation_city LIKE ('%cidade');

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('%teresopolis');

SELECT DISTINCT geolocation_city
FROM geolocation_dataset
WHERE geolocation_city LIKE ('%teres%');

UPDATE geolocation_dataset
SET geolocation_city = 'teresopolis'
WHERE geolocation_city = 'teresópolis';

UPDATE geolocation_dataset
SET geolocation_city = 'teresopolis'
WHERE geolocation_city LIKE ('%teresopolis');

SELECT DISTINCT geolocation_city
FROM geolocation_dataset
ORDER BY geolocation_city ASC;

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('%centenario');

UPDATE geolocation_dataset
SET geolocation_city = 'quarto centenario'
WHERE geolocation_city LIKE ('4_ centenario');

UPDATE geolocation_dataset
SET geolocation_city = 'quarto centenario'
WHERE geolocation_city LIKE ('4__ centenario');

UPDATE geolocation_dataset
SET geolocation_city = 'quarto centenario'
WHERE geolocation_city = 'quarto centenário';

SELECT DISTINCT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('agua branc%');

UPDATE geolocation_dataset
SET geolocation_city = 'agua branca'
WHERE geolocation_city = 'água branca';

UPDATE geolocation_dataset
SET geolocation_city = 'agua branca alagoas'
WHERE geolocation_city = 'agua branca' AND geolocation_state = 'AL';

UPDATE geolocation_dataset
SET geolocation_city = 'agua branca paraiba'
WHERE geolocation_city = 'agua branca' AND geolocation_state = 'PB';

UPDATE geolocation_dataset
SET geolocation_city = 'agua branca piaui'
WHERE geolocation_city = 'agua branca' AND geolocation_state = 'PI';

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('agud%');

SELECT *
FROM geolocation_dataset 
WHERE geolocation_city LIKE ('alexa%');

UPDATE geolocation_dataset
SET geolocation_city = 'alexania'
WHERE geolocation_city LIKE ('alex_nia') AND geolocation_state = 'GO' ;

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('alta floresta d%');

UPDATE geolocation_dataset
SET geolocation_city = 'alta floresta dOeste'
WHERE geolocation_city LIKE ('alta floresta d%');

SELECT DISTINCT geolocation_city
FROM geolocation_dataset
ORDER BY geolocation_city ASC;

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('antune%');

UPDATE geolocation_dataset
SET geolocation_city = 'antunes'
WHERE geolocation_city = 'antunes (igaratinga)';

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('aparecida d_oeste');

UPDATE geolocation_dataset
SET geolocation_city = 'aparecida dOeste'
WHERE geolocation_city LIKE ('aparecida d_oeste') AND geolocation_state = 'SP';

SELECT *
FROM geolocation_dataset 
WHERE geolocation_city LIKE ('aragua%');

UPDATE geolocation_dataset
SET geolocation_city = 'araguaina'
WHERE geolocation_city LIKE ('aragua_na');

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('arraial d_ajuda');

UPDATE geolocation_dataset
SET geolocation_city = 'arraial dAjuda'
WHERE geolocation_city LIKE ('arraial d_ajuda');

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('bacax%');

UPDATE geolocation_dataset
SET geolocation_city = 'bacaxa'
WHERE geolocation_city LIKE ('bacax%');

SELECT *
FROM geolocation_dataset
WHERE geolocation_city = 'belo horizonta';

UPDATE geolocation_dataset
SET geolocation_city = 'belo horizonte'
WHERE geolocation_city = 'belo horizonta';

SELECT *
FROM geolocation_dataset
WHERE geolocation_city IN ('biritiba mirim', 'biritiba-mirim');

UPDATE geolocation_dataset
SET geolocation_city = 'biritiba mirim'
WHERE geolocation_city = 'biritiba-mirim';

SELECT *
FROM geolocation_dataset
WHERE geolocation_city LIKE ('california da barr%');

UPDATE geolocation_dataset	
SET geolocation_city = 'california da barra'
WHERE geolocation_city = 'california da barra (barra do pirai)' OR geolocation_city LIKE ('calif_rnia da barra') ;

SELECT *
FROM geolocation_dataset
ORDER BY geolocation_zip_code_prefix ASC;

