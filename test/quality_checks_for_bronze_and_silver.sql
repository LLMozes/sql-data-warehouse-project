/*
==============================================================================
Quality Checks
==============================================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'bronnze' and 'silver' schemas. It includes checks for:

    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.

==============================================================================
*/


------------------------------------------- bronze.crm_cust_info QUALITY CEHCK--------------------------------

--	Check for Nulls or Dupplicates in Primary key
--	Exceptation: No result

SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL


--  Check for unwanted spaces 
--	Exceptation: No result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT *
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


--  Check the consistency of values in low cardinality columns like gender,marital status
-- Data standardization & Cosistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

-- in our data Warehouse, we aim to store clear and meaningful vallues rather than using abbreviated term
-- and we use the default n/a for missing values.
-- F - Female
-- M - Male 
-- NULL - n/a
-- M - Married
-- S - Single

------------------------------------------- silver.crm_cust_info QUALITY CEHCK--------------------------------

-- When we transfer the cleaned and transformed data into the silver layer. 
-- We can Re-run the quality check queries from the bronze layer to verify the quality of data in the silver layer. 
-- So lets change the previous quality checks queries table.
 
SELECT *
FROM silver.crm_cust_info

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

------------------------------------------- bronze.crm_prd_info QUALITY CEHCK--------------------------------

--	Check for Dupplicates in Primary key
--	Exceptation: No result
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL



--  Check for unwanted spaces 
--	Exceptation: No result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm = TRIM(prd_nm)


--	Check for Nulls or Negative Numbers
--	Exceptation: No result
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


SELECT * FROM bronze.crm_prd_info

SELECT * FROM bronze.erp_px_cat_g1v2

-- Data standardization & Cosistency
SELECT distinct prd_line
FROM bronze.crm_prd_info

--	Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


------------------------------------------- silver.crm_prd_info QUALITY CEHCK--------------------------------

--	Check for Dupplicates in Primary key
--	Exceptation: No result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL



--  Check for unwanted spaces 
--	Exceptation: No result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)


--	Check for Nulls or Negative Numbers
--	Exceptation: No result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


SELECT * FROM silver.crm_prd_info

SELECT * FROM silver.erp_px_cat_g1v2

-- Data standardization & Cosistency
SELECT distinct prd_line
FROM silver.crm_prd_info

--	Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT *
FROM silver.crm_prd_info


------------------------------------------- bronze.crm_sales_details QUALITY CEHCK--------------------------------

-- Check for invaid Dates 
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt < 0 

SELECT NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 

SELECT NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) !=8

SELECT
  NULLIF(sls_order_dt, 0)       
FROM bronze.crm_sales_details
WHERE  sls_order_dt <= 0        
   OR  LEN(sls_order_dt) != 8  
   OR  sls_order_dt > 20500101  
   OR  sls_order_dt < 19000101; 

SELECT
 NULLIF(sls_ship_dt, 0)  sls_ship_dt     
FROM bronze.crm_sales_details
WHERE  sls_ship_dt <= 0        
   OR  LEN(sls_ship_dt) != 8  
   OR  sls_ship_dt > 20500101  
   OR  sls_ship_dt < 19000101; 


-- Check for invalid Date orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;



-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales must equal Quantity * Price
-- >> Values must not be NULL, zero, or negative.

SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price   
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


------------------------------------------- silver.crm_sales_details QUALITY CEHCK--------------------------------

-- Check for invaid Dates 



-- Check for invalid Date orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;



SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price   
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


SELECT * FROM silver.crm_sales_details



------------------------------------------- bronze.erp_cust_az12 QUALITY CEHCK--------------------------------


-- We have to standardize the keys
-- Because we have some 'NAS' incorrect prefix and this way we dont have matches beetween the two tables

SELECT
cid,
--CASE
--    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
--    ELSE cid
--END AS cid, 
       [bdate]
       [gen]
 FROM bronze.erp_cust_az12 
 WHERE cid NOT IN 
(SELECT distinct cst_key FROM silver.crm_cust_info)

-- Check for Out -of - Range Dates
Select distinct bdate
FROM bronze.erp_cust_az12 
WHERE bdate < '1924-01-01' and bdate > GETDATE()


-- Data standardization & Cosistency
SELECT distinct gen
FROM bronze.erp_cust_az12

-- solution:
SELECT distinct gen,
CASE 
    WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'MALE'
    ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12


------------------------------------------- silver.erp_cust_az12 QUALITY CEHCK--------------------------------


SELECT
cid,
--CASE
--    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
--    ELSE cid
--END AS cid, 
       [bdate]
       [gen]
 FROM silver.erp_cust_az12 
 WHERE cid NOT IN 
(SELECT distinct cst_key FROM silver.crm_cust_info)

-- Check for Out -of - Range Dates
Select distinct bdate
FROM silver.erp_cust_az12  
WHERE bdate < '1924-01-01' OR bdate > GETDATE()


-- Data standardization & Cosistency
SELECT distinct gen
FROM silver.erp_cust_az12 

Select *
FROM silver.erp_cust_az12 
