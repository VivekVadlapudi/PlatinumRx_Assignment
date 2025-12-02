-- Query 1 
SELECT 
    b.user_id,
    b.room_no,
    b.booking_date
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) t ON b.user_id = t.user_id AND b.booking_date = t.last_booking;

-- Query 2
SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 
  AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

-- Query 3
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

-- Query4
WITH monthly_items AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        bc.item_id,
        SUM(bc.item_quantity) AS total_quantity
    FROM booking_commercials bc
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY month, bc.item_id
),
ranking AS (
    SELECT 
        month,
        item_id,
        total_quantity,
        RANK() OVER (PARTITION BY month ORDER BY total_quantity DESC) AS rnk_desc,
        RANK() OVER (PARTITION BY month ORDER BY total_quantity ASC) AS rnk_asc
    FROM monthly_items
)
SELECT 
    month,
    item_id AS most_ordered_item
FROM ranking
WHERE rnk_desc = 1

UNION ALL

SELECT 
    month,
    item_id AS least_ordered_item
FROM ranking
WHERE rnk_asc = 1;

-- Query 5  
WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        MONTH(bc.bill_date) AS month,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, month, b.user_id
),
ranking AS (
    SELECT 
        month,
        user_id,
        bill_id,
        bill_amount,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS rnk
    FROM bill_totals
)
SELECT 
    month,
    user_id,
    bill_id,
    bill_amount
FROM ranking
WHERE rnk = 2;
