
USE magist123;
-- 2.1. In relation to the products:
-- What categories of tech products does Magist have?
SELECT p.product_category_name,
t.product_category_name_english,
COUNT(*) As product_count
FROM  products AS p
JOIN product_category_name_translation As t
ON p.product_category_name =t.product_category_name
WHERE 
    p.product_category_name IN (
        'eletronicos',
        'informatica_acessorios',
        'telefonia',
        'telefonia_fixa',
        'pcs',
        'pc_gamer',
        'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe',
        'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis',
        'eletrodomesticos',
        'eletrodomesticos_2'
    )
GROUP BY 
    p.product_category_name, t.product_category_name_english
ORDER BY 
    product_count DESC;
    
-- How many products of these tech categories have been sold (within the time window of the database snapshot)? 

 SELECT TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp))
     FROM orders; 
--- What percentage does that represent from the overall number of products sold?
SELECT 
   
            ROUND((tech.tech_product_sold /total.total_count) * 100, 2)  AS tech_sales_percentage
FROM 
-- -- Count of tech product sales
(SELECT  COUNT(*)  AS tech_product_sold
FROM  order_items AS o
JOIN products As p
ON o.product_id =p.product_id
WHERE 
p.product_category_name IN (
        'eletronicos',
        'informatica_acessorios',
        'telefonia',
        'telefonia_fixa',
        'pcs',
        'pc_gamer',
        'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe',
        'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis',
        'eletrodomesticos',
        'eletrodomesticos_2'
    )) AS tech, 
    
        -- Count of ALL product sales    
    (SELECT COUNT(*) AS total_count
        FROM order_items) AS total;
        
-- What’s the average price of the products being sold?
SELECT AVG (price) AS average_product_price
FROM order_items;
 
 -- Are expensive tech products popular? *
 -- counted tech products max and avg price
 SELECT MAX(price) AS max_price, AVG(price) AS avg_price
 FROM order_items o
 JOIN 
    products p ON o.product_id = p.product_id
 WHERE 
p.product_category_name IN (
        'eletronicos',
        'informatica_acessorios',
        'telefonia',
        'telefonia_fixa',
        'pcs',
        'pc_gamer',
        'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe',
        'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis',
        'eletrodomesticos',
        'eletrodomesticos_2'
    );
   -- count expensive price of tech products 
SELECT COUNT(*) AS expensive_product
 FROM order_items o
 JOIN 
    products p ON o.product_id = p.product_id
 WHERE 
p.product_category_name IN (
        'eletronicos',
        'informatica_acessorios',
        'telefonia',
        'telefonia_fixa',
        'pcs',
        'pc_gamer',
        'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe',
        'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis',
        'eletrodomesticos',
        'eletrodomesticos_2'
    ) AND o.price > 500 ;
    
   /* 1. CASE WHEN oi.price > 500 THEN 1 ELSE 0 END
This checks if each product’s price is greater than 500.

If true → adds 1

If false → adds 0

So, SUM(...) counts how many items had a price > 500.

2. COUNT(*)
Counts all products sold.

3. SUM(...) / COUNT(*)
Divides the count of expensive items by the total number of items.

Gives a decimal (like 0.23 for 23%).

4. 100.0 * (...)
Converts the ratio into a percentage.*/
   
   SELECT 
   100.0 * SUM(CASE WHEN oi.price > 500 THEN 1 ELSE 0 END) / COUNT(*) AS expensive_percentage
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    p.product_category_name IN (
        'eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2'
    );

-- 2.2. In relation to the sellers:
-- How many months of data are included in the magist database?
SELECT 
    COUNT(DISTINCT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')) AS total_months
FROM orders;

-- How many sellers are there? 
SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;


--- How many Tech sellers are there? 
SELECT COUNT(DISTINCT seller_id) AS tech_sellers
FROM order_items  o
JOIN products p ON o.product_id = p.product_id
WHERE 
    p.product_category_name IN (
        'eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2');

--- another codes by other logic
SELECT COUNT(DISTINCT seller_id) FROM sellers s
LEFT JOIN order_items oi USING (seller_id) 
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pcnt USING (product_category_name)
WHERE pcnt.product_category_name_english IN ('eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2');

-- What percentage of overall sellers are Tech sellers?
SELECT 100* tech.tech_sellers/total.total_sellers AS tech_seller_percentage
FROM  
(SELECT COUNT(DISTINCT seller_id) AS tech_sellers
FROM order_items  o
JOIN products p ON o.product_id = p.product_id
WHERE 
    p.product_category_name IN (
        'eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2')) AS tech
        JOIN (SELECT COUNT(DISTINCT seller_id) AS total_sellers FROM sellers) AS total; 

--- What is the total amount earned by all sellers? 
SELECT SUM(price) seller_amount_earned
FROM order_items; -- also another way you can do 
SELECT 
    seller_id,
    SUM(price)  AS seller_total_earned
FROM 
    order_items
GROUP BY 
    seller_id
ORDER BY 
    seller_total_earned DESC;

-- What is the total amount earned by all Tech sellers?
SELECT SUM(price) tech_seller_amount_earned
FROM order_items o 
JOIN products p ON o.product_id = p.product_id
WHERE  p.product_category_name IN (
        'eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2');
--- Can you work out the average monthly income of all sellers? 

    SELECT 
    SUM(price) / COUNT(DISTINCT CONCAT(YEAR(order_approved_at), '-', MONTH(order_approved_at))) AS avg_monthly_income_all
FROM 
    order_items oi
JOIN 
    orders o ON oi.order_id = o.order_id
WHERE 
    o.order_status = 'delivered'; 


--- Can you work out the average monthly income of Tech sellers?
SELECT
SUM(price) / COUNT(DISTINCT CONCAT(YEAR(order_approved_at), '-', MONTH(order_approved_at))) AS tech_avg_monthly
FROM 
    order_items oi
JOIN 
    orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id =p.product_id
WHERE  
    p.product_category_name IN (
        'eletronicos', 'informatica_acessorios', 'telefonia', 'telefonia_fixa',
        'pcs', 'pc_gamer', 'tablets_impressao_imagem',
        'portateis_casa_forno_e_cafe', 'portateis_cozinha_e_preparadores_de_alimentos',
        'eletroportateis', 'eletrodomesticos', 'eletrodomesticos_2'
    ) AND o.order_status = 'delivered'; 


--- 2.3. In relation to the delivery time:
--- What’s the average time between the order being placed and the product being delivered?
SELECT 
   AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_delivered_customer_date)) / 24 AS avg_delivery_days
FROM 
    orders
WHERE 
    order_delivered_customer_date IS NOT NULL;
    
    --- other way
    SELECT 
    ROUND(AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_delivered_customer_date)) / 24, 2) AS avg_delivery_days
FROM 
    orders
WHERE 
    order_delivered_customer_date IS NOT NULL;
    
-- How many orders are delivered on time vs orders delivered with a delay?    
SELECT 
CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
 
--- Is there any pattern for delayed orders, e.g. big products being delayed more often?

SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS order_count,
    SUM(CASE WHEN p.product_weight_g > 3000 THEN 1 ELSE 0 END) AS big_products,
    ROUND(SUM(CASE WHEN p.product_weight_g > 3000 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS big_product_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

--- other way
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS order_count,
    SUM(CASE WHEN p.product_weight_g < 3000 THEN 1 ELSE 0 END) AS small_products,
    ROUND(SUM(CASE WHEN p.product_weight_g < 3000 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS small_product_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
