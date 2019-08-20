select EMPLOYEE_LEVEL, sum (COUNT_EMPLOYEES) as COUNT_EMPLOYEES_2
from
(
SELECT
warehouse_name AS WAREHOUSE_NAME,    
(upper(dep.department_name) || ' (' || dep.department_id || '-' || substr(loc.postal_code, 0, 3) || ')') as DEPARTMENT,    
            ( CASE
                WHEN ( ( to_number(TO_CHAR(SYSDATE, 'YYYY'), '99999999') ) - ( to_number(TO_CHAR(hire_date, 'YYYY'), '99999999') ) ) BETWEEN
                1 AND 16 THEN 'middle level'
                WHEN ( ( to_number(TO_CHAR(SYSDATE, 'YYYY'), '99999999') ) - ( to_number(TO_CHAR(hire_date, 'YYYY'), '99999999') ) ) BETWEEN
                17 AND 22 THEN 'senion level'
                ELSE 'expert level'
            END ) AS EMPLOYEE_LEVEL,
count (*) AS COUNT_EMPLOYEES
FROM
oe.warehouses war
JOIN hr.departments dep ON war.location_id = dep.location_id
JOIN hr.locations loc ON loc.location_id = dep.location_id
JOIN hr.employees emp ON emp.department_id = dep.department_id
WHERE war.warehouse_name != loc.city
GROUP BY war.warehouse_name, dep.department_name, dep.department_id, loc.postal_code,
 CASE
                WHEN ( ( to_number(TO_CHAR(SYSDATE, 'YYYY'), '99999999') ) - ( to_number(TO_CHAR(hire_date, 'YYYY'), '99999999') ) ) BETWEEN
                1 AND 16 THEN 'middle level'
                WHEN ( ( to_number(TO_CHAR(SYSDATE, 'YYYY'), '99999999') ) - ( to_number(TO_CHAR(hire_date, 'YYYY'), '99999999') ) ) BETWEEN
                17 AND 22 THEN 'senion level'
                ELSE 'expert level'
            END
)
group by EMPLOYEE_LEVEL