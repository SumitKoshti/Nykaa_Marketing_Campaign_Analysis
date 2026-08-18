CREATE DATABASE IF NOT EXISTS nykaa_db;

USE nykaa_db;


-- DROP TABLE campaigns;

CREATE TABLE campaigns
(Campaign_ID VARCHAR(50) NOT NULL,
Campaign_Type VARCHAR(50),
Target_Audience VARCHAR(50),
Channel_Used VARCHAR(50),
Duration INT,
Impressions INT,
Clicks INT,
Leads INT,
Conversions INT,
Acquisition_Cost DECIMAL(10,2),
Revenue INT,
Engagement_Score DECIMAL(10,2),
ROI DECIMAL(10,2),
Date VARCHAR(50),
Festive_Season VARCHAR(50),
CTR DECIMAL(10,2),
CPC DECIMAL(10,2),
CPA DECIMAL(10,2),
AOV INT,
Bounce_Rate DECIMAL(10,2),
Time_On_Page_Sec DECIMAL(10,2)
);

DESCRIBE campaigns;
DESCRIBE campaigns;

SELECT Campaign_type, COUNT(*) AS Total_Records FROM campaigns
group by campAIGN_tYpe
ORDER BY Total_Records DESC;

SELECT SUM(Revenue) AS Total FROM campaigns;
                                                  
SELECT SUM(Acquisition_Cost) FROM campaigns;												
                                                          -- AS-HOC ANALYSIS --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- PERFORMANCE ANALYSIS --

-- Q1. Find the revenue by campaign types
SELECT Campaign_Type, CONCAT(ROUND(SUM(Revenue)/1000000,2),"M") AS Total_Revenue
FROM campaigns
GROUP BY Campaign_Type
ORDER BY Total_Revenue DESC;

-- Q2. Which campaign type generates the highest revenue
SELECT Campaign_Type, CONCAT(ROUND(SUM(Revenue)/1000000,2),"M") AS Total_Revenue
FROM campaigns
GROUP BY Campaign_Type
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Q3. Which campaign type has the highest ROI?
SELECT Campaign_Type, ROUND(AVG(ROI)*100,2) AS Avg_ROI
FROM campaigns
GROUP BY Campaign_type
ORDER BY Avg_ROI DESC
LIMIT 1;

-- Q4. Which campaign type has the highest CTR?
SELECT Campaign_Type,
	   ROUND(
			SUM(Clicks)*100.0/ SUM(Impressions),
            2) AS CTR_Percent
FROM campaigns
GROUP BY Campaign_Type
ORDER BY CTR_Percent DESC
LIMIT 1;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNNEL ANALYSIS

-- Q1. Which channel generates the highest conversions?
SELECT Channel_Used, ROUND(SUM(Conversions),0) AS Total_Conversions
FROM campaigns
GROUP BY Channel_Used
ORDER BY SUM(Conversions) DESC             -- Do not use Alias when we use Format in SELECT statment because it converts vales into String and sort lexicographical instead of numerical sorting
LIMIT 1;

-- Q2. Conversion Rate by channel
SELECT Channel_Used,
	   ROUND(SUM(Conversions)*100.0/
	   SUM(Leads),2) AS Conversion_Rate
FROM campaigns
GROUP BY Channel_Used
ORDER BY Conversion_Rate DESC;


-- Q3 Which channel loses the most users in the funnel?
SELECT
	Channel_Used,
    SUM(Leads) AS Total_Leads,
    SUM(Conversions) AS Total_Conversions,
	ROUND(
	((SUM(Leads) - SUM(Conversions))/SUM(Leads))*100,2
    ) AS Conversion_lost_rate
FROM campaigns
GROUP BY Channel_Used
ORDER BY Conversion_lost_rate DESC
LIMIT 1;

-- Q4. Lead generation rate by channel
SELECT Channel_Used, 
	   ROUND(
			SUM(Leads)*100.0/
            SUM(Clicks),2) AS Lead_Generation_Rate
FROM campaigns
GROUP BY Channel_Used
ORDER BY Lead_Generation_Rate DESC;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COST ANALYSIS --

-- Q1. Which campaign has the lowest CPA?
SELECT Campaign_Type, ROUND(AVG(CPA),2) AS Average_CPA
FROM campaigns
GROUP BY Campaign_Type
ORDER BY AVG(CPA) ASC
LIMIT 1;

-- Q2. Which channel has the lowest CPC?
SELECT Channel_Used, ROUND(AVG(CPC),2) AS Average_CPC
FROM campaigns
GROUP BY Channel_Used
ORDER BY AVG(CPC) ASC
LIMIT 1;

-- Q3. Which campaign type spends the most money?
SELECT Campaign_Type, CONCAT(ROUND(SUM(Acquisition_Cost)/1000000,2),"M") AS Total_Money_Spend
FROM campaigns
GROUP BY Campaign_Type
ORDER BY SUM(Acquisition_Cost) DESC
LIMIT 1;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AUDIENCE ANALYSIS

-- Q1. Which audience generates highest revenue?
SELECT Target_Audience, CONCAT(ROUND(SUM(Revenue)/1000000,2),"M") AS Total_Revenue
FROM campaigns
GROUP BY Target_Audience
ORDER BY SUM(Revenue) DESC
LIMIT 1;

SELECT Target_Audience, CONCAT(ROUND(SUM(Revenue)/1000000,2),"M") AS Total_Revenue
FROM campaigns
GROUP BY Target_Audience
ORDER BY SUM(Revenue) DESC

-- Q2. Which audience has highest engagement?
SELECT Target_Audience, ROUND(AVG(Engagement_Score),2) AS Avg_Engagement_Score
FROM campaigns
GROUP BY Target_Audience
ORDER BY Avg(Engagement_Score) DESC
LIMIT 1;

-- Q3. Which audience gives best ROI?
SELECT Target_Audience, CONCAT(AVG(ROI)*100, "%") AS Avg_ROI
FROM campaigns
GROUP BY Target_Audience
ORDER BY AVG(ROI) DESC
LIMIT 1;

-- Q4. Which audience converts best?
SELECT Target_Audience, ROUND(AVG(Conversions),2) AS "Avg_Conversions"
FROM campaigns
GROUP BY Target_Audience
ORDER BY AVG(Conversions) DESC;

-- Q5. Which audience is most cost-efficient to acquire?          -- CPA Data is widespread and Right-skewed, need to check outliers
SELECT Target_Audience, ROUND(AVG(CPA),2) AS "Avg_Cost_Per_Aquisition"
FROM campaigns
GROUP BY Target_Audience
ORDER BY AVG(CPA)
LIMIT 1;

-- Q5. Conversion rate by audience
SELECT Target_Audience,
		ROUND(
			SUM(Conversions)*100.0 / SUM(Leads)
            ,2) AS Conversion_Rate_Percent
FROM Campaigns
GROUP BY Target_Audience
ORDER BY Conversion_Rate_Percent DESC;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Festive Analysis --
-- Q1. Festive vs Non-Festive Revenue
SELECT Festive_Season, CONCAT(ROUND(SUM(Revenue)/1000000,2),"M") as Total_Revenue
FROM campaigns
GROUP BY Festive_Season
ORDER BY SUM(Revenue) DESC;

-- We have 10 months non-festive months and 4 festive months
SELECT
    Festive_Season,
    ROUND(AVG(Revenue),2) AS Avg_Revenue,
    ROUND(AVG(Conversions),2) AS Avg_Conversions,
    ROUND(AVG(ROI)*100,2) AS Avg_ROI_Percent
FROM campaigns
GROUP BY Festive_Season;

-- Q2.Festive vs Non-Festive ROI 
SELECT Festive_Season, ROUND(AVG(ROI)*100,2) AS Average_ROI_Percent
FROM campaigns
GROUP BY Festive_Season
ORDER BY Average_ROI_Percent DESC;

-- Q3 Monthly Revenue Trend
DESCRIBE campaigns;

SELECT
    DATE_FORMAT(
        STR_TO_DATE(`Date`,'%m/%d/%Y'),
        '%Y-%m'
    ) AS Revenue_Month,
    ROUND(SUM(Revenue),2) AS Total_Revenue
FROM campaigns
GROUP BY Revenue_Month
ORDER BY Revenue_Month;


-- Q4. Monthly Conversion Trend
SELECT
    DATE_FORMAT(
        STR_TO_DATE(`Date`,'%m/%d/%Y'),
        '%Y-%m'
    ) AS Revenue_Month,
    ROUND(SUM(Conversions),2) AS Total_Conversions
FROM campaigns
GROUP BY Revenue_Month
ORDER BY Revenue_Month;

-- Q5. Monthly Avg. AOV 
SELECT
	DATE_FORMAT(
		STR_TO_DATE(`Date`, '%m/%d/%Y'), '%Y-%m'
        ) AS AOV_Month,
        ROUND(avg(AOV),2) AS Average_AOV
FROM campaigns
GROUP BY AOV_Month
ORDER BY Average_AOV DESC;









