SELECT
    product_name_us,
    product_desc_us,
    product_name_ru,
    product_desc_ru,
    warranty,
    SUM(quantity_on_hand)
FROM
    (
        SELECT
            pdus.translated_name   AS product_name_us,
            ( CASE
                WHEN ( length(pdus.translated_description) <= 30 ) THEN pdus.translated_description
                WHEN ( length(pdus.translated_description) > 30 ) THEN ( substr(pdus.translated_description, 1, 30)
                                                                         || '...' )
            END ) AS product_desc_us,
            pdru.translated_name   AS product_name_ru,
            ( CASE
                WHEN ( length(pdru.translated_description) <= 30 ) THEN pdru.translated_description
                WHEN ( length(pdru.translated_description) > 30 ) THEN ( substr(pdru.translated_description, 1, 30)
                                                                         || '...' )
            END ) AS product_desc_ru,
            ( CASE
                WHEN ( EXTRACT(YEAR FROM warranty_period) = 0 )
                     AND ( EXTRACT(MONTH FROM warranty_period) = 0 ) THEN 'No warranty'
                WHEN ( EXTRACT(YEAR FROM warranty_period) != 0 )
                     AND ( EXTRACT(MONTH FROM warranty_period) != 0 ) THEN EXTRACT(YEAR FROM warranty_period)
                                                                           || ' years and '
                                                                           || EXTRACT(MONTH FROM warranty_period)
                                                                           || ' months'
                WHEN ( EXTRACT(YEAR FROM warranty_period) = 0 )
                     AND ( EXTRACT(MONTH FROM warranty_period) != 0 ) THEN EXTRACT(MONTH FROM warranty_period)
                                                                           || ' months'
                WHEN ( EXTRACT(YEAR FROM warranty_period) != 0 )
                     AND ( EXTRACT(MONTH FROM warranty_period) = 0 ) THEN EXTRACT(YEAR FROM warranty_period)
                                                                          || ' years '
            END ) AS warranty,
            quantity_on_hand
        FROM
            inventories i
            JOIN product_information pi ON i.product_id = pi.product_id
            JOIN product_descriptions pdus ON i.product_id = pdus.product_id
                                              AND pdus.language_id = 'US'
            JOIN product_descriptions pdru ON i.product_id = pdru.product_id
                                              AND pdru.language_id = 'RU'
        WHERE
            pdus.translated_name LIKE '%Monitor%'
    )
GROUP BY
    product_name_us,
    product_desc_us,
    product_name_ru,
    product_desc_ru,
    warranty
HAVING
    SUM(quantity_on_hand) < 1000
ORDER BY
    warranty DESC,
    product_name_us ASC;