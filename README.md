BUSINESS EXPLORATION: ANALYZING KEY FACTORS THROUGH SQL AND TABLEAU

INTRODUCTION

    I found a df named ‘Analyzing the Impact’ by the user Willian Oliveira Gibin in Kaggle. The df is described as Economic Conditions on Company Purchasing Decisions. 

    The df discusses the significance of utilizing practice datasets to understand the relationship between economic conditions and purchasing decisions. It describes a dataset comprising three main components: a dimension table of ten companies, a fact table documenting purchases, and economic condition data. These elements allow analysts to study how changes in the economy influence purchasing behavior across different industries. By examining historical purchasing patterns alongside economic indicators like inflation, interest rates, and GDP growth, analysts can identify correlations and make informed decisions about budgeting, financial planning, and risk management.

DATA CLEANING TASKS

    The data cleaning task has been simpler than expected since the CSV files came without nulls or duplicates. However, this task has helped me to understand the information contained in the 3 tables (Purchase, Economic, and Companies) to later build the following 4 additional tables and their connections.

    To start, I began with the cleaning of the Companies table, loading it into Pandas via Python. Since it was a small dataframe (10,5), visualization was straightforward. The changes made included replacing the original Locations (fake locations) with real cities in the United States for visualization purposes in Tableau using mapping. The next step was to create identifier columns for locations, company types, and employees, and then delete these three columns, leaving only the identifiers in the Companies table. These three deleted columns (locations, company types, and employees) will become the future location names, company types, and employee numbers in the future tables created: Locations, Type, and Employees, respectively.

    Subsequently, I repeated the same process for the Economic dataframe (7,5) with a similar size to Companies. The only cleaning challenge here was to modify the data type of the date column (format %y-%m-%d : %h-%min-%sec --> to format %y-%m-%d), resulting in a new column named 'day'. Then, we removed the information about hours, minutes, and seconds as it is irrelevant for the analysis. The rest of the variables are numeric and are in the appropriate format.

    Finally, there's the Purchases dataframe, which is the largest of all (100,000,5). The first thing I noticed is that the date column is in a different format than Economic, and I understand that this is the connection between tables. The change in this case is to convert it from (format %d-%m-%y --> to format %y-%m-%d), resulting in a new column named 'day'. Additionally, we have a company_id through which we understand the relationship with the Companies table, along with the numeric variables of quantity and revenue. The last column in question in the dataframe is 'product/category'. By using value_counts(), we see that the 100,000 operations are grouped into 25 categories. 

Subsequently, we create a mask to group them into 5 categories:

![alt text](Images/Data_Cleaning_Categories.png)

And thus, we conclude the cleaning phase.

CONNEXION TO SQL

    First, I established a connection with my MySQL database using the pymysql library in Python. I provided the connection details such as the host, user, password, and database name.

    Next, I created a database named “master" if it didn't already exist. Then, I created four tables within this database: 'category', 'type', 'employees', and 'locations'. The 'category' table stores information about product categories, 'type' about company types, 'employees' about the number of employees, and 'locations' about locations.

    Once the tables were created, I added foreign key constraints to establish relationships between them. For example, I ensured that the company ID in the 'companies' table is related to the company type in the 'type' table.

    After that, I used the pandas library to read CSV files containing data about purchases, economic conditions, and companies. I converted this data into pandas DataFrames and inserted them into the corresponding tables in my MySQL database.

    Finally, I committed the changes to the database and closed the connection. This process allowed me to transfer my data to a relational database and establish relationships between them, facilitating further data analysis.

METADATA

- Purchase Table: The purchases table is one of the three original tables; it indicates the main indicators of the purchase made by a company. Among them we find variables such as an id associated with the company making the purchase, quantity, revenue, the day of the purchase, and an indicator associated with the typology/category of the product. There is a sample of 100,000 purchases.


- Economic Table: The economic table is one of the three original tables; it indicates the main economic indicators related to a control date on which these economic indicators are updated. Among them, we find the unemployment rate, GDP value, CPI, 30-year mortgage rate, and the dates on which these economic indicators are effective. There are 7 columns for updating the dates.


- Companies Table: The companies table is one of the three original tables; it provides information about the companies that make purchases. There are 10 companies. In the table, we find the id associated with the company making the purchase, the name of the company, an id associated with the type of the company, an id associated with the size of the company based on its number of employees, and an id associated with the location of the company.

- Category Table: The category table is one of the four tables created additionally; it provides information about the typology/category of the product subject to the purchase. It is related to the purchases table through a category id (ranging from 1 to 5) that gives us information about the name of the category. It is grouped into 5 major categories: Electronics and Technology, Home and Kitchen, Fashion and Accessories, Entertainment and Leisure, and Supplies and Others. Each of them includes subcategories (25 in total) that have been grouped in the data cleaning phase.

- Type Table: The type table is one of the four tables created additionally; it provides information about the type of company making the purchase. It is related to the companies table through a company type id (ranging from 1 to 3) that gives us information about the name of the company type. It is grouped into 3 categories: public, private, and non-profit companies. Since there are 3 groups in the original dataset, there was no need for sub-grouping or cleaning functions.

- Employees Table: The employees table is one of the four tables created additionally; it provides information about the size of the companies making purchases based on their number of employees. It is related to the companies table through an id of the number of employees (ranging from 1 to 4) that gives us the number of employees per company. It is grouped into 4 categories: 10 employees, 100 employees, 500 employees, and 1000 employees.

- Locations Table: The locations table is one of the four tables created additionally; it provides information about the location of the companies making purchases based on the name of the city where they are located. It is related to the companies table through a location id (ranging from 1 to 10) that tells us the name of the city where each company is located. It is grouped into 10 American cities. The actual data consisted of invented cities; in the cleaning phase, I decided to include real city names to make it more representative, especially in the visualization phase for spatially locating the company locations.

EER MASTER DIAGRAM

![alt text](Images/EER_Master_Diagram.png)

HYPOTHESIS 1

    The initial hypothesis of my analysis was to explore the relationship between average income and the Consumer Price Index (CPI) in cities with different levels of cost of living. However, upon observing the data, I found that the CPI was constant for all cities. This suggests that there was no significant variation in the CPI between different locations.
    Since the CPI did not vary between cities, we could not use it to differentiate between cities with different costs of living. Consequently, I had to adjust my analysis strategy and opt to directly compare average incomes between companies located in high and low-cost-of-living cities.

Relationship between Company Size, Location, and Revenue:

    I believe there could be a correlation between the size of a company, its location, and its revenue. My hypothesis is that the number of employees in a company and its geographical location might influence the average revenue it generates. I anticipate that certain locations and company sizes may be associated with different revenue levels.

![alt text](Images/H1_Query.png)

- Relevant Data Selection: The query selects location names, the number of employees, and the average revenue from the most recent purchases.

- Table Joining: The locations, companies, employees, and purchases tables are joined using JOIN clauses to relate location information, company size, and purchase data.

- Filtering by Most Recent Date: The subquery in the WHERE clause, SELECT MAX(day) FROM purchases, filters purchases to include only those that occurred on the most recent date. This is done to analyze the most updated data.

- Group by: The results are grouped by location name and the number of employees to calculate the average revenue for each combination of location and company size.

![alt text](Images/H1_Output.png)

    CONCLUSIONS

    - Income Variation According to Company Size:
    There are significant differences in average income among different company size categories. Companies with 1000 employees show higher incomes compared to smaller companies.
    
    - Income Disparities by Location:
    Variations in average income are observed among different locations. Houston leads with the highest average incomes, followed by Chicago and Miami, while New York and Las Vegas have the lowest.
    
    - Influence of Company Size and Location Combination:
    The combination of company size and location influences average income. For example, companies with 1000 employees in Houston show significantly higher incomes than the same companies in other locations.

HYPOTHESIS 2

Relationship between Unemployment and Purchases Made by Private Companies:

    I have used this code to investigate the relationship between the unemployment rate and purchases made by private companies over a given period of time. My initial hypothesis was that we might find an inverse relationship between unemployment and the volume of purchases by private companies. In other words, I expected that an increase in unemployment would be associated with a decrease in spending by private companies, as unemployment could negatively affect consumers' spending capacity and, consequently, influence companies' purchasing decisions.

![alt text](Images/H2_Query.png)

- I used an SQL query to calculate the average revenue generated by purchases made by private companies on each day, and included the corresponding unemployment rate for that day. I grouped the results by day and by unemployment rate to examine any patterns or trends in the data. 

- Additionally, I ordered the results by day to gain a chronological view of the relationship between unemployment and revenue generated by purchases made by private companies.

![alt text](Images/H2_Output.png)

    CONCLUSIONS
    
    - Revenue Stability: Overall, the average revenues of private companies show a relative stability over time, with minor fluctuations and no clear upward or downward trend.
    
    - Impact of Unemployment Rate: There is no clear correlation between the unemployment rate and the average revenues of private companies. Even during periods of high unemployment rate, average revenues do not show a significant decline.
    
    - Economic Resilience of Private Companies: The results suggest that private companies may be relatively resilient to changes in the unemployment rate. Despite economic volatility, they maintain a certain level of stability in their revenues over time.

HYPOTHESIS 3

Comparison of Average Revenue by Product Category:

    The main hypothesis behind this analysis is to investigate whether there are significant differences in the average revenue generated by different product categories. The purpose is to better understand the performance of each product category in terms of revenue.

![alt text](Images/H3_Query.png)

- I used an SQL query to calculate the average revenue and the total number of operations for each product category. The query is based on purchase data (from the "purchases" table) and product categories (from the "category" table). 

- I performed a JOIN between these two tables to relate purchases to their respective categories.

- I grouped the results by product category name using the GROUP BY clause, allowing us to calculate summary statistics for each category.

![alt text](Images/H3_Output.png)

    CONCLUSIONS

    - Sales volume and average revenue: "Electronics and Technology" leads in sales volume with 28,105 transactions, followed by "Fashion and Accessories" with 20,055 transactions. However, the categories "Fashion and Accessories" and "Home and Kitchen" show a slightly higher average revenue per transaction. This suggests that, although "Electronics and Technology" has a higher sales volume, the other categories might have products with higher average prices.
    
    -  Relationship between sales volume and average revenue: "Electronics and Technology" shows a high sales volume with comparable average revenue to other categories, indicating strong demand in this sector. On the other hand, "Entertainment and Leisure" has a slightly lower average revenue despite significant sales volume, indicating that products in this category tend to be less expensive.

HYPOTHESIS 4

Trend of average revenue over time:

    I used this code to investigate the trend of average revenue over time and its relationship with the Consumer Price Index (CPI). The initial hypothesis is that there might be a relationship between fluctuations in the CPI, reflecting changes in the prices of goods and services, and the average revenue generated by transactions made in that time period.

![alt text](Images/H4_Query.png)

- To test this hypothesis, I selected the average revenue and CPI for each month, using the DATE_FORMAT function to group the data by month and year. Then, I calculated the average revenue and CPI for each period and ordered them chronologically to analyze any patterns or trends over time.

- This approach will allow us to identify any correlation between average revenue and changes in the CPI over time.

![alt text](Images/H4_Output.png)

    CONCLUSIONS

    - Stability of transaction volume: Over the months, the number of transactions remains relatively stable, showing no significant changes despite fluctuations in the CPI and average revenue.
    
    - Inverse relationship between average revenue and CPI: We continue to observe an inverse trend between the CPI and average revenue. As the CPI increases, average revenue tends to decrease, suggesting that the rise in the cost of living may negatively influence average revenue.
    
    - Relative stability of revenue: Despite changes in the CPI, average revenue remains at similar levels throughout the months. This indicates some stability in revenue, despite economic fluctuations represented by the CPI.

CONCLUSIONS

This project has given me a clear insight into how to apply different SQL queries in real-world business scenarios. I've been able to see how factors such as company size and location directly impact their success.

The most important thing I've learned is the significance of data analysis for making informed decisions. Using both SQL and Tableau, I've been able to identify key trends and relationships, which has helped me better understand what drives business performance.

