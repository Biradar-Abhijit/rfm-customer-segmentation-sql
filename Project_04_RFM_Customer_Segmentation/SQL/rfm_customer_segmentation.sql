SELECT COUNT(*) AS Total_Rows
FROM dbo.online_retail_II_combined;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Invoice) AS Unique_Invoices,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    MIN(InvoiceDate) AS First_Date,
    MAX(InvoiceDate) AS Last_Date,
    MIN(Quantity) AS Min_Quantity,
    MAX(Quantity) AS Max_Quantity,
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price
FROM dbo.online_retail_II_combined;

SELECT
    SUM(CASE WHEN Invoice LIKE 'C%' THEN 1 ELSE 0 END) AS Cancelled_Invoices,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS Non_Positive_Quantity,
    SUM(CASE WHEN Price <= 0 THEN 1 ELSE 0 END) AS Non_Positive_Price,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_ID,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate
FROM dbo.online_retail_II_combined;

SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    TRY_CONVERT(INT, Customer_ID) AS Customer_ID,
    Country,
    CAST(Quantity * Price AS DECIMAL(18,2)) AS SalesAmount
INTO dbo.RFM_Clean
FROM dbo.online_retail_II_combined
WHERE Invoice NOT LIKE 'C%'
  AND Quantity > 0
  AND Price > 0
  AND Customer_ID IS NOT NULL;

  SELECT COUNT(*) AS Clean_Rows
FROM dbo.RFM_Clean;


SELECT
    Customer_ID,
    DATEDIFF(DAY, MAX(InvoiceDate), (SELECT MAX(InvoiceDate) FROM dbo.RFM_Clean)) AS Recency,
    COUNT(DISTINCT Invoice) AS Frequency,
    CAST(SUM(SalesAmount) AS DECIMAL(18,2)) AS Monetary
INTO dbo.RFM_Scores
FROM dbo.RFM_Clean
GROUP BY Customer_ID;

SELECT TOP 20 *
FROM dbo.RFM_Scores
ORDER BY Monetary DESC;

SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary,

    6 - NTILE(5) OVER (ORDER BY Recency ASC) AS R_Score,

    NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,

    NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score

INTO dbo.RFM_Scored
FROM dbo.RFM_Scores;

SELECT TOP 20 *
FROM dbo.RFM_Scored
ORDER BY M_Score DESC, F_Score DESC, R_Score DESC;

SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Code
INTO dbo.RFM_Final
FROM dbo.RFM_Scored;


SELECT TOP 20 *
FROM dbo.RFM_Final
ORDER BY R_Score DESC, F_Score DESC, M_Score DESC;

SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    RFM_Code,

    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4
            THEN 'Champions'

        WHEN R_Score >= 4 AND F_Score >= 3
            THEN 'Loyal Customers'

        WHEN R_Score >= 4 AND F_Score <= 2
            THEN 'New Customers'

        WHEN R_Score = 3 AND F_Score >= 3
            THEN 'Potential Loyalists'

        WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4
            THEN 'At Risk'

        WHEN R_Score <= 2 AND F_Score >= 3
            THEN 'Needs Attention'

        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score >= 3
            THEN 'Hibernating'

        ELSE 'Lost Customers'
    END AS Customer_Segment

INTO dbo.RFM_Segments
FROM dbo.RFM_Final;4


SELECT
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    CAST(SUM(Monetary) AS DECIMAL(18,2)) AS Revenue
FROM dbo.RFM_Segments
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

SELECT
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    CAST(SUM(Monetary) AS DECIMAL(18,2)) AS Revenue,
    CAST(
        100.0 * SUM(Monetary) /
        SUM(SUM(Monetary)) OVER ()
        AS DECIMAL(10,2)
    ) AS Revenue_Share_Percent
FROM dbo.RFM_Segments
GROUP BY Customer_Segment
ORDER BY Revenue DESC;


CREATE VIEW dbo.vw_RFM_Customer_Segmentation
AS
SELECT
    Customer_ID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    RFM_Code,
    Customer_Segment
FROM dbo.RFM_Segments;

SELECT TOP 20 *
FROM dbo.vw_RFM_Customer_Segmentation;


SELECT
    Customer_Segment,
    CASE
        WHEN Customer_Segment = 'Champions'
            THEN 'Reward and retain with VIP offers, early access and loyalty benefits.'

        WHEN Customer_Segment = 'Loyal Customers'
            THEN 'Increase retention with loyalty rewards and personalized cross-sell offers.'

        WHEN Customer_Segment = 'Potential Loyalists'
            THEN 'Encourage repeat purchases with targeted recommendations and loyalty incentives.'

        WHEN Customer_Segment = 'New Customers'
            THEN 'Build a second purchase quickly with welcome offers and product recommendations.'

        WHEN Customer_Segment = 'At Risk'
            THEN 'Launch targeted win-back campaigns with personalized offers.'

        WHEN Customer_Segment = 'Needs Attention'
            THEN 'Use re-engagement campaigns to encourage another purchase.'

        WHEN Customer_Segment = 'Hibernating'
            THEN 'Use low-cost reactivation campaigns and limited-time offers.'

        WHEN Customer_Segment = 'Lost Customers'
            THEN 'Run a final win-back campaign and avoid excessive marketing spend if they remain inactive.'
    END AS Recommended_Action
FROM dbo.vw_RFM_Customer_Segmentation
GROUP BY Customer_Segment;