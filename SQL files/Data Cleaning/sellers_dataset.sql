SELECT * FROM brazil_ecommerce_dataset.sellers_dataset;

UPDATE sellers_dataset
SET seller_id = TRIM(seller_id);

SELECT *
FROM sellers_dataset
WHERE seller_id = '' OR seller_id IS NULL;
#There are no missing seller_id

SELECT COUNT(DISTINCT seller_id) AS count
FROM sellers_dataset
GROUP BY seller_id
HAVING count > 1
ORDER BY seller_id ASC;
#There are no duplicate seller_id

UPDATE sellers_dataset
SET seller_zip_code_prefix = TRIM(seller_zip_code_prefix);

SELECT *
FROM sellers_dataset
WHERE seller_zip_code_prefix = '' OR  seller_zip_code_prefix IS NULL;
#There are no missing seller_zip_code_prefix

UPDATE sellers_dataset
SET seller_city = TRIM(seller_city);

SELECT *
FROM sellers_dataset
WHERE seller_city = '' OR seller_city IS NULL;
#There is no missing seller city

SELECT COUNT(DISTINCT seller_city)
FROM sellers_dataset;

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

UPDATE sellers_dataset
SET seller_city = 'angra dos reis'
WHERE seller_city = 'angra dos reis rj';

SELECT *
FROM sellers_dataset 
WHERE seller_city IN ('balneario camboriu', 'balenario camboriu');

UPDATE sellers_dataset
SET seller_city = 'balneario camboriu'
WHERE seller_city = 'balenario camboriu';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%barbacena%');

UPDATE sellers_dataset
SET seller_city = 'barbacena'
WHERE seller_city = 'barbacena/ minas gerais';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('belo%');

UPDATE sellers_dataset
SET seller_city = 'belo horizonte'
WHERE seller_city = 'belo horizont';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%brasilia%');

UPDATE sellers_dataset
SET seller_city = 'brasilia'
WHERE seller_city = 'brasilia df';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%carapicuiba%');

UPDATE sellers_dataset
SET seller_city = 'carapicuiba'
WHERE seller_city = 'carapicuiba / sao paulo';

SELECT * 
FROM sellers_dataset
WHERE seller_city LIKE ('%cariacica%');

UPDATE sellers_dataset
SET seller_city = 'cariacica'
WHERE seller_city = 'cariacica / es';

SELECT *
FROM sellers_dataset
WHERE seller_city IN ('cascavel', 'cascavael');

UPDATE sellers_dataset
SET seller_city = 'cascavel'
WHERE seller_city = 'cascavael';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE 'castro%';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%ferraz%');

UPDATE sellers_dataset
SET seller_city = 'ferraz de vasconcelos'
WHERE seller_city = 'ferraz de  vasconcelos';

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

SELECT *
FROM sellers_dataset
WHERE  seller_city LIKE ('%jacarei%');

UPDATE sellers_dataset
SET seller_city = 'jacarei'
WHERE seller_city = 'jacarei / sao paulo';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%lages%');

UPDATE sellers_dataset 
SET seller_city = 'lages'
WHERE seller_city = 'lages - sc';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('maua%');

UPDATE sellers_dataset
SET seller_city = 'maua'
WHERE seller_city = 'maua/sao paulo';

SELECT * 
FROM sellers_dataset
WHERE seller_city LIKE ('%mogi das%');

UPDATE sellers_dataset 
SET seller_city = 'mogi das cruzes'
WHERE seller_city = 'mogi das cruses' OR seller_city = 'mogi das cruzes / sp';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%novo hamburgo%');

UPDATE sellers_dataset
SET seller_city = 'novo hamburgo'
WHERE seller_city = 'novo hamburgo, rio grande do sul, brasil';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%parana%');

UPDATE sellers_dataset
SET seller_city = 'maringa' 
WHERE seller_city = 'parana' AND seller_zip_code_prefix = 87083;

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%pinhais%');

UPDATE sellers_dataset
SET seller_city = 'pinhais' 
WHERE seller_city = 'pinhais/pr';

UPDATE sellers_dataset
SET seller_state = 'PR'
WHERE seller_state = 'SP' AND (seller_city IN ('pinhais', 'sao jose dos pinhais'));

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%ribeirao pr%');

UPDATE sellers_dataset
SET seller_city = 'ribeirao preto'
WHERE seller_city IN ('ribeirao pretp', 'ribeirao preto / sao paulo', 'riberao preto');

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('rio de%');

UPDATE sellers_dataset
SET seller_state = 'RJ'
WHERE seller_city = 'rio de janeiro' AND (seller_state IN ('SP','RN'));

UPDATE sellers_dataset
SET seller_city = 'rio de janeiro' 
WHERE seller_city IN ('rio de janeiro io de janeiro',
					'rio de janeiro / rio de janeiro', 
                    'rio de janeiro, rio de janeiro, brasil');
                    
SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('rio de janeiro%');

UPDATE sellers_dataset
SET seller_city = 'rio de janeiro' 
WHERE seller_zip_code_prefix = 22050;

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

UPDATE sellers_dataset
SET seller_city = 'santa barbara dOeste'
WHERE seller_city = 'santa barbara d oeste';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%santa barbara%');

UPDATE sellers_dataset
SET seller_city = 'santa barbara dOeste'
WHERE seller_city = "santa barbara d'oeste";

UPDATE sellers_dataset
SET seller_city = 'santa barbara dOeste'
WHERE seller_zip_code_prefix = 13450 AND seller_city LIKE ('santa barbara%');

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('santo andre%');

UPDATE sellers_dataset
SET seller_city = 'santo andre'
WHERE seller_city = 'santo andre/sao paulo';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%jose dos pinhais%');

UPDATE sellers_dataset
SET seller_city = 'sao jose dos pinhais'
WHERE seller_city LIKE ('sao  jose dos pinhais');

UPDATE sellers_dataset 
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao  paulo';

UPDATE sellers_dataset
SET seller_city = 'sao  bernardo do campo'
WHERE seller_city = 'sao bernardo do capo';

UPDATE sellers_dataset
SET seller_city = 'sao bernardo do campo'
WHERE seller_city = 'sao  bernardo do campo';

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

UPDATE sellers_dataset
SET seller_city = 'sao jose do rio preto'
WHERE seller_city = 'sao jose do rio pret';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('sao jose dos pi%');

UPDATE sellers_dataset
SET seller_city = 'sao jose dos pinhais'
WHERE seller_city = 'sao jose dos pinhas';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('sao miguel%');

UPDATE sellers_dataset
SET seller_city = 'sao miguel do Oeste'
WHERE seller_zip_code_prefix = 89900 AND seller_city LIKE ('sao miguel d%');

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('sao pa%');

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao pauo' AND seller_zip_code_prefix = 2051;

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao paulo / sao paulo' AND seller_zip_code_prefix = 3407;

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao paulo - sp' AND seller_zip_code_prefix = 5353;

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao paulo-sp';

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

SELECT *
FROM sellers_dataset
WHERE seller_city IN ('sao paluo', 'sao paulop', 'sao paulo sp', 'sao paulo -sp','sao paulo');
 
UPDATE sellers_dataset
SET  seller_city = 'sao paulo'
WHERE seller_city = 'sao paluo' AND seller_zip_code_prefix = 8050;

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_zip_code_prefix = 4557 AND seller_city LIKE ('%o paulo');

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_city = 'sao paulo sp' AND seller_zip_code_prefix = 1207;

UPDATE sellers_dataset
SET seller_city = 'sao paulo' 
WHERE seller_city = 'sao paulop' AND seller_zip_code_prefix = 3581;

UPDATE sellers_dataset
SET seller_city = 'sao paulo'
WHERE seller_zip_code_prefix IN (4130, 4007);

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('sbc%');

UPDATE sellers_dataset
SET seller_city = 'sbc'
WHERE seller_city = 'sbc/sp';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('sp%');

UPDATE sellers_dataset
SET seller_city = 'sp'
WHERE seller_city = 'sp / sp';

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('%ao da serra');

UPDATE sellers_dataset
SET seller_city = 'taboao da serra'
WHERE seller_city = 'tabao da serra';

SELECT seller_city, COUNT(DISTINCT seller_city) AS count, COUNT(seller_city) AS total
FROM sellers_dataset
GROUP BY seller_city
ORDER BY seller_city ASC;

SELECT *
FROM sellers_dataset
WHERE seller_city LIKE ('vendas%');

UPDATE sellers_dataset
SET seller_city = 'maringa'
WHERE seller_city LIKE ('vendas%');

UPDATE sellers_dataset
SET seller_state = TRIM(seller_state);

SELECT * 
FROM sellers_dataset
WHERE seller_state = '' OR seller_state IS NULL;
#There is no missing seller state

SELECT *
FROM sellers_dataset;

SELECT COUNT(DISTINCT seller_city)
FROM sellers_dataset;
#There are 567 distinct selle cities


SELECT COUNT(DISTINCT seller_state)
FROM sellers_dataset;
#There are distinct 23 seller states

SELECT DISTINCT seller_city , seller_state
FROM sellers_dataset
ORDER BY seller_state ASC, seller_city;

SELECT seller_city, seller_state
FROM sellers_dataset
WHERE seller_state = 'RJ'
ORDER BY seller_city ASC;

UPDATE sellers_dataset
SET seller_city = 'rio de janeiro'
WHERE seller_city = '04482255' OR seller_zip_code_prefix = 22790;

SELECT * 
FROM sellers_dataset
WHERE seller_state = 'RJ'
ORDER BY seller_city ASC
LIMIT 20;

SELECT * 
FROM sellers_dataset;

DELIMITER $$

CREATE FUNCTION INITCAP(input VARCHAR(255)) 
RETURNS VARCHAR(255) 
DETERMINISTIC
BEGIN
    DECLARE len INT;
    DECLARE i INT;
    DECLARE char_str CHAR(1);
    DECLARE out_str VARCHAR(255);

    SET len = CHAR_LENGTH(input);
    SET out_str = LOWER(input);
    SET i = 1;

    WHILE i <= len DO
        IF i = 1 OR SUBSTRING(out_str, i - 1, 1) = ' ' THEN
            SET out_str = CONCAT(
                SUBSTRING(out_str, 1, i - 1),
                UPPER(SUBSTRING(out_str, i, 1)),
                SUBSTRING(out_str, i + 1)
            );
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN out_str;
END$$

DELIMITER ;

UPDATE sellers_dataset
SET seller_city = INITCAP(seller_city);

SELECT *
FROM sellers_dataset;
