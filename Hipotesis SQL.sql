/* H1 Relación entre el tamaño de la empresa, la ubicación y sus ingresos*/

SELECT loc.locations_name,
       emp.employees_num,
       AVG(p.revenue) AS avg_revenue
FROM locations loc
JOIN companies c ON loc.locations_id = c.location_id
JOIN employees emp ON c.employees_id = emp.employees_id
JOIN purchases p ON c.company_id = p.company_id
WHERE p.day IN (SELECT MAX(day) FROM purchases)
GROUP BY loc.locations_name, emp.employees_num;

/*H2 Relación entre el desempleo y las compras realizadas por empresas privadas*/

SELECT p.day AS purchase_day,
       AVG(p.revenue) AS avg_revenue,
       e.unemployment_rate AS avg_unemployment_rate
FROM purchases p
JOIN economic e ON p.day = e.day
JOIN companies c ON p.company_id = c.company_id
JOIN type t ON c.companytype_id = t.company_type_id
WHERE t.company_type = 'private'
GROUP BY p.day, e.unemployment_rate
ORDER BY p.day;

/* H3 Comparación del ingreso promedio por categoría de productos*/

SELECT cat.category_name,
       COUNT(revenue) AS operation_count,
       AVG(p.revenue) AS avg_revenue
FROM purchases p
JOIN category cat ON p.category_id = cat.category_id
GROUP BY cat.category_name;

/*H4 Tendencia del ingreso promedio a lo largo del tiempo*/

SELECT DATE_FORMAT(p.day, '%Y-%m') AS purchase_month,
       COUNT(revenue) AS transaction_count,
       AVG(p.revenue) AS avg_revenue,
       AVG(e.cpi) AS avg_cpi
FROM purchases p
JOIN economic e ON DATE_FORMAT(p.day, '%Y-%m') = DATE_FORMAT(e.day, '%Y-%m')
GROUP BY DATE_FORMAT(p.day, '%Y-%m')
ORDER BY purchase_month;





