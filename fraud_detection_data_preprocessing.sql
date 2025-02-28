CREATE DATABASE fraud_detection;

CREATE TABLE fraud_detection_dataset (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Transaction_Amount DECIMAL(10,2),
    Transaction_Type VARCHAR(50),
    Location VARCHAR(50),
    Device_Used VARCHAR(20),
    Time_of_Transaction DATETIME,
    Fraudulent TINYINT
);

-- -----------DATA PREPROCESSING-------------------
select *
from fraud_detection_dataset;

-- CHECKING FOR NULL VALUES
select *
from fraud_detection_dataset
where Transaction_ID IS NULL OR 
      Customer_ID IS NULL OR 
      Transaction_Amount IS NULL OR 
      Transaction_Type IS NULL OR 
      Location IS NULL OR 
      Device_Used IS NULL OR 
      Time_of_Transaction IS NULL OR 
      Fraudulent IS NULL;

-- CHECKING FOR MISSING VALUE
select *
from fraud_detection_dataset
where Transaction_ID LIKE " " OR 
      Customer_ID LIKE " " OR 
      Transaction_Amount LIKE  " " OR 
      Transaction_Type LIKE  " " OR 
      Location LIKE  " " OR 
      Device_Used LIKE  " " OR 
      Time_of_Transaction LIKE  " " OR 
      Fraudulent LIKE " ";

-- CHECKING FOR DUPLICATE VALUES
select Transaction_ID, count(*)
from fraud_detection_dataset
group by Transaction_ID
having count(*) > 1;

-- CHECKING FOR INCONSISTENT VALUES
select Transaction_Amount
from fraud_detection_dataset
where Transaction_Amount < 0;



