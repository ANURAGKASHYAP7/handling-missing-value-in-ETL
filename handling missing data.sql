create database missing_data;
use missing_data;
/* Q1. What are the most common reasons for missing data in ETL pipelines?
Missing data in ETL pipelines occurs due to several reasons:
1. Data Entry Errors: Users may leave some fields empty while entering data.
2. System Errors: Technical problems may cause data loss during processing or transfer.
3. API Failures: APIs may fail to return some required information.
4. Data Integration Issues: Combining data from multiple sources may result in missing values.
5. Optional Fields: Users may skip filling optional information
Q2. Why is blindly deleting rows with missing values considered a bad practice in ETL?
Answer:
Blindly deleting rows with missing values is considered a bad practice because:
1. Loss of Valuable Data: Other columns may contain useful information even if one value is missing.
2. Reduced Dataset Size: Deleting rows reduces the number of records available for analysis.
3. Biased Results: Removing records with missing values may affect the accuracy of analysis and produce misleading results.

Q3. Explain the difference between Listwise Deletion and Column Deletion.
1. Listwise Deletion
Use it when:
- Only a small number of rows contain missing values.
- The remaining data is sufficient for analysis.
- Removing those rows will not significantly affect the results.
2. Column Deletion
Use it when:
- A column contains a very high percentage of missing values.
- That column is not important for analysis.
- Removing it will not affect the objective of the project.
Q4 – Final Answer (Notebook Notes)
Question: Why is median imputation preferred over mean imputation for skewed data such as income?

Answer:

Median imputation is preferred over mean imputation for skewed data because:
1. Median is less affected by extremely high or low values (outliers).
2. Mean can change significantly due to extreme values.
3. Median represents the central value more accurately in skewed datasets.

Q5. What is Forward Fill and in what type of dataset is it most useful?
Answer:
Forward Fill is a missing data handling technique in which missing values are replaced with the previous available value.
It is most useful in time-series datasets, such as:
- Stock market data
- Weather records
- Daily sales reports
- Sensor readings
Q6. Why should flagging missing values be done before imputation in an ETL workflow?
Flagging missing values should be done before imputation because:
1. It preserves information about which values were originally missing.
2. It helps identify records that contained missing data.
3. It allows analysts to track missing data even after replacing it with estimated values.
4. It helps improve data quality monitoring and analysis.
Q7. Consider a scenario where income is missing for many customers. How can this missingness itself provide business insights?
Missing income data can provide useful business insights because:
1. Customer Privacy: Customers may not want to share their income due to privacy concerns.
2. Customer Behaviour: Customers may skip income fields because they do not trust the platform.
3. Customer Segmentation: Businesses can identify which customer groups are more likely to leave income information blank.
*/
CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50),
    Monthly_Sales DECIMAL(10,2),
    Income DECIMAL(10,2),
    Region VARCHAR(30)
);
INSERT INTO customers
(Customer_ID, Name, City, Monthly_Sales, Income, Region)
VALUES
(101, 'Rahul Mehta', 'Mumbai', 12000, 65000, 'West'),
(102, 'Anjali Rao', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh Iyer', 'Chennai', 15000, 72000, 'South'),
(104, 'Neha Singh', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit Verma', 'Pune', 18000, 58000, NULL),
(106, 'Karan Shah', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja Das', 'Kolkata', 14000, NULL, 'East'),
(108, 'Riya Kapoor', 'Jaipur', 16000, 69000, 'North');
SELECT * FROM customers;
/*Q8. Listwise Deletion 

Remove all rows where Region is missing.

Tasks:

Identify affected rows

Show the dataset after deletion

Mention how many records were lost
*/
SELECT *
FROM customers
WHERE Region IS NULL;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM customers
WHERE Region IS NULL;
SELECT *
FROM customers;

#  ans q8(c)Conclusion: A total of 1 record was lost after applying Listwise Deletion.
/*Q9. Imputation 

Handle missing values in Monthly_Sales using:

Forward Fill

Tasks:

Apply forward fill

Show before vs after values

Explain why forward fill is suitable here */
INSERT INTO customers
VALUES (105, 'Amit Verma', 'Pune', 18000, 58000, NULL);
SELECT Customer_ID, Monthly_Sales
FROM customers
ORDER BY Customer_ID;
SELECT
    Customer_ID,
    Monthly_Sales AS Before_Fill,
    MAX(Monthly_Sales) OVER (
        ORDER BY Customer_ID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS After_Fill
FROM customers
ORDER BY Customer_ID;
/*Q10. Flagging Missing Data

Create a flag column for missing Income.

Tasks:

Create Income_Missing_Flag (0 = present, 1 = missing)

Show updated dataset

Count how many customers have missing income */

#ans 
ALTER TABLE customers
ADD Income_Missing_Flag INT;
update customers
set Income_Missing_Flag = 
	case
        when Income IS NULL then 1
        ELSE 0
	end;
    SELECT * FROM customers;
    SELECT COUNT(*) AS Missing_Income_Customers
FROM customers
WHERE Income_Missing_Flag = 1;
