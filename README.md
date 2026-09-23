# RFM Customer Segmentation using SQL & Power BI

Customer segmentation project using **Recency, Frequency and Monetary (RFM) analysis** on the **Online Retail II** dataset.

## 🎯 Business Question

Who are the **Champions, Potential Loyalists, At Risk, Needs Attention, Hibernating, New and Lost Customers**, and how should each customer group be handled?

## 📊 Dataset

**Dataset:** Online Retail II  
**Source:** UCI Machine Learning Repository

[Online Retail II Dataset](https://archive.ics.uci.edu/dataset/502/online+retail+ii)

- Original transaction rows: **1,067,371**
- Clean transaction rows used for RFM: **805,549**

## 🧹 Data Cleaning

The following records were excluded:

- Cancelled invoices where Invoice starts with `C`
- Quantity ≤ 0
- Price ≤ 0
- Missing Customer ID

Sales value was calculated as:

`Sales Amount = Quantity × Price`

## 🔢 RFM Methodology

### Recency
Number of days since the customer's most recent purchase.

### Frequency
Number of distinct invoices for each customer.

### Monetary
Total customer spending based on:

`Quantity × Price`

Each RFM dimension was scored from **1 to 5 using NTILE(5)**.

Recency scoring was reversed so that customers with more recent purchases received higher scores.

The three scores were combined into an RFM code such as:

`555`, `451`, `121`

## 👥 Customer Segments

| Segment | Customers | Revenue | Revenue Share |
|---|---:|---:|---:|
| Champions | 1,346 | 1,221,933.29 | 68.87% |
| Potential Loyalists | 755 | 2,069,210.35 | 11.66% |
| At Risk | 203 | 970,135.35 | 5.47% |
| Loyal Customers | 718 | 812,241.28 | 4.58% |
| Needs Attention | 504 | 592,850.13 | 3.34% |
| Lost Customers | 1,782 | 585,228.52 | 3.30% |
| Hibernating | 282 | 380,346.66 | 2.14% |
| New Customers | 288 | 114,086.58 | 0.64% |

## 🔍 Key Findings

- **5,878 active customers** were segmented.
- Champions accounted for **68.87% of revenue share**.
- Potential Loyalists contributed **11.66% of revenue share**.
- **203 customers** were identified as At Risk.
- Lost Customers were the largest segment by customer count with **1,782 customers**.
- Lost Customers contributed **3.30% of revenue share**.
- Customer count and revenue contribution provide different views of customer value.

## 🎯 Retention Actions

| Segment | Suggested Action |
|---|---|
| Champions | VIP rewards, early access and loyalty benefits |
| Loyal Customers | Loyalty rewards and personalized cross-selling |
| Potential Loyalists | Product recommendations and loyalty incentives |
| New Customers | Welcome offers and second-purchase campaigns |
| At Risk | Targeted win-back campaigns |
| Needs Attention | Re-engagement campaigns |
| Hibernating | Low-cost reactivation campaigns |
| Lost Customers | Final win-back campaign with controlled marketing spend |

## 📈 Power BI Dashboard

The Power BI dashboard includes:

- Total Customers: **5.878K**
- Total Revenue: **17.74M**
- Average Customer Revenue: **3.02K**
- At Risk Customers: **203**
- Customer Count by Segment
- Revenue by Customer Segment
- Revenue Share by Segment

RFM calculations and customer segmentation were performed in **SQL**, while **Power BI** was used for visualization and reporting.

## 🛠️ SQL Techniques

- Data Cleaning
- `TRY_CONVERT`
- `DATEDIFF`
- `COUNT(DISTINCT)`
- `CASE WHEN`
- `NTILE(5)`
- Window Functions
- Aggregations
- Revenue Share Calculation
- SQL Views

Reusable view:

`dbo.vw_RFM_Customer_Segmentation`

## 📁 Project Structure

```text
Project_04_RFM_Customer_Segmentation/
│
├── Data/
│   └── README.md
│
├── SQL/
│   └── rfm_customer_segmentation.sql
│
├── Findings/
│   └── RFM_Customer_Findings.txt
│
├── PowerBI/
│   └── RFM_Customer_Segmentation.pbix
│
├── Screenshot/
│   └── RFM_Customer_Segmentation_Dashboard.png
│
└── README.md
