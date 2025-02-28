-- ------------DATA ANALYSIS-------------------
-- 	Q1. What percentage of transactions in the dataset are fraudulent
select count(*) as total_transactions,
		sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset;

/* Out of 10,000 transactions, 222 were fraudulent, resulting in a 2.22% fraud rate. 
While relatively low, it still poses a financial risk, 
requiring further analysis to detect patterns and prevent fraud.
*/

-- Q2. Which transaction types have the highest fraud rates?
select Transaction_Type, 
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by Transaction_Type
order by fraud_rate desc;

/* Online Purchases have the highest fraud rate (2.47%), 
followed by ATM Withdrawals (2.40%). Bank Transfers (2.07%) and POS Payments (1.94%) a
re less affected. Strengthening security 
for Online Purchases and ATM Withdrawals can help reduce fraud. 
*/

-- Q3. Which locations have the highest fraud rates?
select Location, 
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by Location
order by fraud_rate desc;

/* New York (2.83%) and Chicago (2.55%) have the highest fraud rates, 
while San Francisco (1.64%) has the lowest. 
Strengthening fraud detection in high-risk locations can help reduce fraud.
*/

-- Q4. Which devices are most commonly used in fraudulent transactions?
select Device_Used, 
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by Device_Used
order by fraud_rate desc;

/* Desktops have the highest fraud rate (2.47%), 
followed by Tablets (2.27%) and Mobiles (1.91%). 
Fraud prevention should focus more on desktop transactions.
*/

-- Q5. At what time do fraudulent transactions occur most frequently?
select hour(Time_of_Transaction) as fraud_hour,
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by fraud_hour
order by fraud_rate desc;

/* Fraud is highest at 14:00 (3.33%), followed by 1:00, 5:00, 7:00, and 17:00 (2.86%). 
Fraud prevention efforts should focus on these peak hours.
*/

-- Q6. Which customers have the highest number of fraudulent transactions?
select Customer_ID,
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by Customer_ID
having fraudulent_transaction > 1
order by fraud_rate desc
limit 5;

/* Customer 1243 has the highest fraud rate (100.00%), 
followed by 2773 (66.67%) and 4136 (40.00%). 
These customers may require further investigation to identify potential fraudulent behavior.
*/

/*  Q7. Which customers made multiple transactions 
within a short time frame, indicating possible fraud? */

select Customer_ID,
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction
from fraud_detection_dataset
where 
	Time_of_Transaction between date_sub(Time_of_Transaction, interval 5 minute)
    and Time_of_Transaction
group by Customer_ID
having total_transaction > 2
order by fraudulent_transaction desc, total_transaction desc;

/* Several customers made multiple quick transactions. 2573, 1870, 4136, 3349, and 2773 
had the most fraudulent transactions (2 each). Rapid transactions may indicate fraud, 
so monitoring these customers and applying stricter rules can help prevent risks.
*/

-- Q8. Do high-value transactions have a higher likelihood of fraud?
select 
	case
		when Transaction_Amount < 100 then 'Low'
        when Transaction_Amount between 100 and 1000 then 'Medium'
        when Transaction_Amount between 1000 and 5000 then 'High'
        else 'Very High'
        end as amount_category,
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate 
from fraud_detection_dataset
group by amount_category
order by fraud_rate desc;

/* Low-value transactions (3.54% fraud rate) are riskier despite being fewer. 
High-value transactions (2.22% fraud rate) have more fraud cases, while medium-value ones 
have the lowest fraud rate (2.08%). 
Fraudsters may test small transactions before bigger fraud.
*/

-- Q9. Can we identify customers who meet multiple fraud risk factors? 

select Customer_ID,
		count(*) as total_transaction,
        sum(Fraudulent) as fraudulent_transaction,
        round((sum(Fraudulent)/count(*)) * 100, 2) as fraud_rate,
        avg(Transaction_Amount) as avg_transaction
from fraud_detection_dataset
where Customer_ID in (
	select Customer_ID
    from fraud_detection_dataset
    where Fraudulent = 1
    group by Customer_ID
    having count(*) > 1 )
    group by Customer_ID
    having fraud_rate > 20
    order by fraudulent_transaction desc, fraud_rate desc;

/* Customer 1243 has a 100% fraud rate, meaning all their transactions were fraudulent. 
Customers 2773, 4136, 3349, 1870, and 2573 also show high fraud rates (28.57% - 66.67%). 
These high-risk customers should be closely monitored for potential fraud prevention.
*/

/* Q10. Which customers made fraudulent transactions in multiple locations, 
suggesting possible account takeover or fraud rings? */

with fraud_location as (
	select Customer_ID,
    count(distinct Location) as unique_loc,
    sum(Fraudulent) as fraudulent_transactions
    from fraud_detection_dataset
    where Fraudulent = 1
    group by Customer_ID
    )
  SELECT 
    Customer_ID,
    unique_loc,
    fraudulent_transactions
FROM fraud_location
WHERE unique_loc > 1
ORDER BY fraudulent_transactions DESC, unique_loc DESC;  
 
 /* Customers 1870, 2573, 2773, and 3349 committed fraud in two different locations, 
 indicating possible account takeovers or fraud rings.
 Monitoring location-based transactions can help detect suspicious activity.
 */

-- ------------------------END OF REPORT-----------------------------------------------


