--   GROUP 6 -----------

create database project;
use project;

-- 0) Union of Fact Internet sales and Fact internet sales new

create table sales__sheet as
select  *  from factinternetsales
union
select  *  from fact_internet_sales_new;

-- 1) Lookup the productname from the Product sheet to Sales sheet.

select * from sales_sheet;
select * from dimproduct;


SELECT S.*, P.EnglishProductName
FROM  sales__sheet AS S JOIN DimProduct AS P
ON S.ProductKey = P.ProductKey;



-- 2) Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet.

select * from dimcustomer;

SELECT S.*, P.`Unit price` AS UnitPrice, C.CustomerFullName
FROM sales_sheet AS S
LEFT JOIN dimcustomer AS C ON S.CustomerKey = C.CustomerKey
LEFT JOIN dimproduct AS P ON S.ProductKey = P.ProductKey;

-- 3) calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)
-- 3) A,B,C
SELECT *,
    STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(OrderDatekey, '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(OrderDatekey, '%Y%m%d')) AS MonthNumber,
    MONTHNAME(STR_TO_DATE(OrderDatekey, '%Y%m%d')) AS MonthFullName
from sales_sheet;

-- 3D)
SELECT *, STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,
    CASE 
        WHEN MONTH(OrderDateKey) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(OrderDateKey) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(OrderDateKey) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(OrderDateKey) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter
FROM sales_sheet;

-- 3E)
SELECT *,STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,

    CONCAT(YEAR(OrderDateKey), '-', UPPER(DATE_FORMAT(OrderDateKey, '%b'))) AS YearMonth

FROM sales_sheet;

-- F,G)
SELECT *,STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,
    DAYOFWEEK(OrderDateKey) AS WeekdayNo,
    DAYNAME(OrderDateKey) AS WeekdayName
    from sales_sheet;
    
-- H) 
SELECT *, STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,
CASE 
        WHEN MONTH(OrderDateKey) >= 4 THEN MONTH(OrderDateKey) - 3
        ELSE MONTH(OrderDateKey) + 9
    END AS FinancialMonthNo
    from sales_sheet;
    
    -- I)
  SELECT *, STR_TO_DATE(OrderDatekey, '%Y%m%d') AS OrderDate,
   CASE
        WHEN MONTH(OrderDateKey) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(OrderDateKey) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(OrderDateKey) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM sales_sheet;


-- 4) Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)

SELECT *,
    (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS Sales_Amount
FROM sales_sheet ;


-- 5)  Calculate the Productioncost uning the columns(unit cost ,order quantity)

SELECT *, (ProductStandardCost * OrderQuantity) AS Production_Cost
FROM sales_sheet ;

-- 6)  Calculate the profit.

SELECT *, (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct))  - (ProductStandardCost * OrderQuantity) AS Profit
FROM sales_sheet ;


-- 8) yearwise Sales
SELECT 
    YEAR(OrderDatekey) AS SalesYear,
    SUM(SalesAmount) AS TotalSales
FROM Sales__sheet
GROUP BY YEAR(OrderDatekey)
ORDER BY SalesYear;

-- 9) Monthwise sales
SELECT 
    month(OrderDatekey) AS SalesMonth,
    SUM(SalesAmount) AS TotalSales
FROM Sales__sheet
GROUP BY month(OrderDatekey)
ORDER BY SalesMonth;

-- 10) Quaterwise sales
SELECT 
    YEAR(OrderDatekey) AS SalesYear,
    QUARTER(OrderDatekey) AS SalesQuarter,
    SUM(SalesAmount) AS TotalSales
FROM Sales__sheet
GROUP BY YEAR(OrderDatekey), QUARTER(OrderDatekey)
ORDER BY SalesYear, SalesQuarter;





