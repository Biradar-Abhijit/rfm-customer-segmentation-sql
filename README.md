RFM Customer Segmentation in Pure SQL
Customer segmentation project using Recency, Frequency and Monetary (RFM) analysis on the Online Retail II dataset.

Business Question
Who are the Champions, Potential Loyalists, At Risk, Needs Attention, Hibernating and Lost customers, and how should each group be handled?

Dataset
Online Retail II from the UCI Machine Learning Repository.

Source: https://archive.ics.uci.edu/dataset/502/online+retail+ii

Original combined data: 1,067,371 transaction rows
Clean transaction rows used for RFM: 805,549

Data Cleaning
Excluded:

Cancelled invoices where Invoice starts with C
Quantity <= 0
Price <= 0
Missing Customer_ID
Sales value = Quantity × Price

RFM Methodology
Recency: Days since the customer's most recent purchase.

Frequency: Number of distinct invoices for each customer.

Monetary: Total customer spending based on Quantity × Price.

Each dimension was scored from 1 to 5 using NTILE(5). Recency was reversed so that more recent customers receive higher scores. The three scores were combined into an RFM code such as 555, 451 or 121.

Customer Segments
Segment	Customers	Revenue	Revenue Share
Champions	1,346	1,221,933.29	68.87%
Potential Loyalists	755	2,069,210.35	11.66%
At Risk	203	970,135.35	5.47%
Loyal Customers	718	812,241.28	4.58%
Needs Attention	504	592,850.13	3.34%
Lost Customers	1,782	585,228.52	3.30%
Hibernating	282	380,346.66	2.14%
New Customers	288	114,086.58	0.64%
Key Findings
Champions account for 68.87% of the calculated revenue share.
Potential Loyalists contribute 11.66% of revenue share.
At Risk customers contribute 5.47% of revenue share.
Lost Customers are the largest segment by customer count with 1,782 customers, while their revenue share is 3.30%.
RFM demonstrates why customer count and revenue contribution should be analyzed together.
Retention Actions
Segment	Action
Champions	VIP rewards, early access and loyalty benefits
Loyal Customers	Loyalty rewards and personalized cross-selling
Potential Loyalists	Product recommendations and loyalty incentives
New Customers	Welcome offers and second-purchase campaigns
At Risk	Targeted win-back campaigns
Needs Attention	Re-engagement campaigns
Hibernating	Low-cost reactivation campaigns
Lost Customers	Final win-back campaign with controlled marketing spend
Power BI Dashboard
The dashboard includes:

Total Customers: 5.878K
Total Revenue: 17.74M
Average Customer Revenue: 3.02K
At Risk Customers: 203
Customer Count by Segment
Revenue by Customer Segment
Revenue Share by Segment
RFM calculations and segmentation logic were performed in SQL. Power BI was used for visualization.

SQL Techniques
Data cleaning
TRY_CONVERT
DATEDIFF
COUNT(DISTINCT)
CASE WHEN
NTILE(5)
Window functions
Aggregations
Revenue-share calculation
SQL Views
Reusable view: dbo.vw_RFM_Customer_Segmentation

Project Structure
Project_04_RFM_Customer_Segmentation/
├── Data/
│   └── README.md
├── SQL/
│   └── rfm_customer_segmentation.sql
├── Findings/
│   └── RFM_Customer_Findings.md
├── PowerBI/
│   ├── RFM_Customer_Segmentation.pbix
│   └── RFM_Customer_Segmentation_Dashboard.png
└── README.md
Tools
SQL Server / SSMS, Power BI, GitHub, Online Retail II
