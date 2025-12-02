use clinic_management;

-- 1. Find the revenue we got from each sales channel in a given year 
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year 
SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


-- 3 . Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year 
WITH rev AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
exp AS (
    SELECT
        MONTH(datetime) AS month,
        SUM(amount) AS expenses
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    COALESCE(rev.month, exp.month) AS month,
    COALESCE(revenue, 0) AS revenue,
    COALESCE(expenses, 0) AS expenses,
    (COALESCE(revenue, 0) - COALESCE(expenses, 0)) AS profit,
    CASE 
        WHEN COALESCE(revenue, 0) - COALESCE(expenses, 0) > 0 
        THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM rev
FULL JOIN exp ON rev.month = exp.month
ORDER BY month;

-- 4. For each city find the most profitable clinic for a given month 
WITH revenue AS (
    SELECT 
        cid,
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, month
),
expense AS (
    SELECT 
        cid,
        MONTH(datetime) AS month,
        SUM(amount) AS expenses
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, month
),
profit_table AS (
    SELECT 
        c.cid,
        c.city,
        r.month,
        COALESCE(r.revenue, 0) - COALESCE(e.expenses, 0) AS profit
    FROM clinics c
    LEFT JOIN revenue r ON c.cid = r.cid
    LEFT JOIN expense e ON c.cid = e.cid AND r.month = e.month
)
SELECT 
    city,
    cid AS most_profitable_clinic,
    month,
    profit
FROM (
    SELECT 
        *,
        RANK() OVER (PARTITION BY city, month ORDER BY profit DESC) AS rnk
    FROM profit_table
) x
WHERE rnk = 1;

-- 5. For each state find the second least profitable clinic for a given month 
WITH revenue AS (
    SELECT 
        cid,
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, month
),
expense AS (
    SELECT 
        cid,
        MONTH(datetime) AS month,
        SUM(amount) AS expenses
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY cid, month
),
profit_calc AS (
    SELECT 
        c.cid,
        c.state,
        r.month,
        COALESCE(r.revenue,0) - COALESCE(e.expenses,0) AS profit
    FROM clinics c
    LEFT JOIN revenue r ON c.cid = r.cid
    LEFT JOIN expense e ON c.cid = e.cid AND r.month = e.month
),
ranked AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY state, month ORDER BY profit ASC) AS rnk
    FROM profit_calc
)
SELECT 
    state,
    cid AS second_least_profitable_clinic,
    month,
    profit
FROM ranked
WHERE rnk = 2;

