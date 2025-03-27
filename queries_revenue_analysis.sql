-- Clean Data and ensure no missing data
SELECT *
FROM resident_details rd
JOIN payments py
	USING(ApartmentID)
WHERE Total IS NOT NULL
	AND Date IS NOT NULL
ORDER BY ApartmentID;

-- Revenue Analysis {Revenue by each Apartment Bills Payments}
SELECT 
	rd.ApartmentID,
    rd.Full_Name,
    rd.Block,
    py.Bill,
    SUM(Total) Total_Revenue
FROM resident_details rd
JOIN payments py
	USING(ApartmentID)
GROUP BY rd.ApartmentID, rd.Full_Name, rd.Block, py.Bill
ORDER BY rd.ApartmentID;

-- Total Revenue Collected Monthly
SELECT 
	DATE_FORMAT(Date, '%Y-%m') AS Month,
	SUM(Total) AS Total_Revenue
FROM payments
GROUP BY month
ORDER BY month;

-- Top 5 Highest Paying Residents
SELECT 
	Full_Name,
    ApartmentID,
    rd.Block,
    SUM(Total) AS Total_Payment
FROM resident_details rd
JOIN payments
	USING(ApartmentID)
GROUP BY rd.Full_Name, rd.ApartmentID,rd.Block
ORDER BY Total_Payment DESC
LIMIT 5;

-- Get Payment by status (Low recharge, Average recharge, Top recharge & Premium recharge)
SELECT 
	ApartmentID,
    Full_Name,
    Bill,
    Date,
    Total,
    CASE    WHEN Total < 30000 THEN 'Low Recharge'
			WHEN Total < 50000 THEN 'Average Recharge'
            WHEN Total < 100000 THEN 'High Recharge'
		ELSE 'Premium Recharge'
	END AS 'Payment Status'
FROM payments p
JOIN resident_details rd
	USING(ApartmentID)
WHERE Bill = 'Electricity Recharge'
ORDER BY Date;
