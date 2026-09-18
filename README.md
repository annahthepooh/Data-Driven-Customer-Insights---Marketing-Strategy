<p align="center">
  <img src="./Assets/DDCIMS.png" alt="Project Banner" width="100%">
</p>

# Data Driven Customer Insights & Marketing Strategies

## Project Overview

This project analyzes customer and commercial performance within the Brazilian Olist e-commerce marketplace to identify opportunities for customer retention, customer experience improvement and targeted growth.

Using MySQL and Power BI, I analyzed customer behavior, product and seller performance, delivery performance, reviews and purchasing patterns. 

The analysis was then translated into data-driven marketing strategies designed to answer a key business question:

How can an e-commerce business use customer and sales data to improve retention, customer experience and revenue growth?


## Business Problem

Although Olist generated approximately $14M in revenue from 99K orders, the analysis identified a significant customer retention opportunity.

The business needed to understand:

Which customers are most valuable and which are at risk of being inactive?
Which product categories generate the most orders and revenue?
Which sellers generate strong revenue but have customer retention or experience issues?
How do delivery performance and customer reviews relate to seller performance?
Which products and sellers represent opportunities for targeted growth?
What marketing strategies can improve retention, customer experience and revenue?

## Project Objectives

The main objectives of this project were to:

1. Analyze overall sales and customer performance.
2. Identify customer retention opportunities using RFM segmentation.
3. Evaluate product and seller performance.
4. Identify customer experience problems using delivery and review data.
5. Identify sellers with opportunities with customer retention.
6. Translate analytical findings into practical marketing strategies.
7. Build an interactive Power BI dashboard to communicate the findings. 


## Dataset

The analysis uses the Brazillian Olist E-commerce dataset containing information about orders done through the E-commerce marketplace.

The dataset includes multiple tables covering : 
  1. Customers
  2. Orders
  3. Order Items
  4. Products
  5. Products Categories
  6. Products Categories Translation
  7. Sellers
  8. Reviews
  9. Payment

The data was imported into MySQL, cleaned, transformed, analyzed and then connected to Power BI for visualization.

## Tools & technology

  1. MySQL - Data Cleaning, Transformation & Analysis
  2. SQL - Business Analysis & Customer Segmentation
  3. Power BI - Dashboard Development & Visualization
  4. DAX - Calculated Measures & KPI
  5. GitHub - Project documentation & version control


## Data Cleaning & Preparation

The raw Olist data required preparation before analysis.
Key data preparation activities included:

 1. Importing datasets into MySQL.
 2. Cleaning & transforming the raw datasets.
 3. Handling missing values.
 4. Using appropriate JOINS across the different tables.
 5. Standardizing product category information.
 5. Handling NULL prices.
 6. Creating calculated fields for delivery performance.
 7. Calculating customer level RFM metrics.
 8. Creating seller & product performance classifications.
 9. Preparing analytical datasets for Power BI.


The cleaned data was then used to conduct business analysis.


## SQL Analysis
The analysis was structured around 4 major business areas:

 1. ### Sales & Product Performance
    Analyzed :
     - Total Revenue
     - Total Orders
     - Revenue by Product Category
     - Orders by product Category
     - Monthly Revenue Trends
     - Product & Seller Performance
   
  2. ### Customer Retention
     Used RFM analysis to segment customers based on :
     - Recency - How recently they purchased
     - Frequency - How often they purchased
     - Monetary Value - How much they spent
    
  Customer Segments included:
     - Champions
     - Loyal Customers
     - New Buyers
     - About to Sleep 
     - Lost 
     - Cannot Lose Them
     - Regular Spontaneous Customers

  3. ### Seller & Customer Experience

     Seller Performance was evaluated using:
      - Revenue
      - Order Volume
      - Delivery Performance
      - Average Review Score
      - Bad reviews percentage

     Sellers were classified based on combinations of revenue, delivery performance & customer reviews.
    
  3. ### Customer & marketing Opportunities

      The Analysis was used to identify:
       - High value customers requiring retention
       - Inactive customers requiring reactivation
       - High Revenue Sellers with one-time customers
       - Sellers with delivery & review problems
       - Products and sellers with strong customer experience and low sales volume
    
  ## Key Findings
  ### High Sales Volume but Low Customer Repeat Rate
  
  The market rate genarated approximately:
####KPI	####Result
Total Revenue	$14M
Total Orders	99K
Total Customers	96K
Repeat Customers	3K
Repeat Customer Rate	3.12%
Average Order Value	$136.73

Only 3.12% of customers were identified as repeat customers while approximately 96.88% were one-time customers.
This indicates a significant opportunity to focus on retention, reactivation and post-purchase marketing.


### Customer Segmentation Reveals Different Retention Opportunities

RFM analysis showed that customers have substantially different purchasing behaviors and value.

The largest customer segment was Regular Spontaneous Customers while Lost Customers represented a smaller customer group but contributed a disproportionately large share of revenue.
This indicates that customer count alone does not explain customer value.
Different segments therefore require different marketing approaches rather than a single retention campaign.


### Product Categories Drive Different Levels of Demand

Order and revenue analysis showed differences in product-category performance.
Categories including Bed/Bath/Table, Health/Beauty, Sports/Leisure, and Computers/Accessories generated substantial order volumes.
Revenue performance also varied considerably across categories, creating opportunities for:

 - Cross-selling
 - Category-specific promotions
 - Product recommendations
 - Customer segmentation
 - Targeted campaigns
   

### High-Revenue Sellers Can Still Have Retention Problems

The seller analysis identified sellers that generate significant revenue while also having a high proportion of one-time customers.
This creates an opportunity to introduce seller-specific retention campaigns rather than relying only on marketplace-wide campaigns.

Potential tactics include:

- Post-purchase follow-ups
- Product recommendations
- Related-product campaigns
- Personalized offers
- Repeat-purchase incentives
  

### Delivery and Reviews Affect Customer Experience

Seller segmentation revealed that some high-revenue sellers combine poor delivery performance with poor customer reviews.
These sellers represent a customer-experience risk because revenue performance alone does not guarantee customer satisfaction.

Other sellers showed combinations such as:

 - High revenue + good delivery + poor reviews
 - High revenue + poor delivery + good reviews
 - High revenue + poor delivery + poor reviews
 - Good delivery + good reviews but lower revenue

This allowed customer experience and growth strategies to be targeted according to the specific problem identified.



## Power BI Dashboard

The analysis was transformed into an interactive Power BI dashboard consisting of four sections.

1. ### Executive Overview

Provides an overview of:

 - Revenue
 - Orders
 - Customers
 - Repeat customer rate
 - Average order value
 - Revenue trends
 - Orders by product category
 - Revenue by product category
   
2. ### Customer & Retention

Focuses on customer behavior and retention including:

 - Customer KPIs
 - One-time vs repeat customers
 - RFM revenue contribution
 - RFM customer distribution
 - Average order value

3. ### Seller & Customer Experience

Examines:

 - Seller performance
 - Revenue contribution by seller performance segment
 - Product/seller performance
 - Customer reviews
 - Poor-review rates
 - Delivery performance
   
4. ### Marketing Strategy

Translates the analytical findings into practical marketing actions focused on:

 - Customer retention and reactivation
 - High-value customer protection
 - Seller-specific retention
 - Customer experience recovery
 - Targeted growth

## Marketing Strategies

The analysis was translated into five strategic areas.

1. ### Customer Retention & Reactivation

#### Insight:
The high proportion of one-time customers and inactive RFM segments creates a significant retention opportunity.

#### Action:
Use personalized follow-ups, product recommendations and targeted reactivation offers.

#### KPIs:
Repeat purchase rate
Retention rate


2. ### Protect High-Value Customers

#### Insight:
RFM segmentation identifies customers with higher purchasing value who should receive targeted retention efforts.

#### Action:
Loyalty rewards
Early access
Personalized offers
Referral incentives

#### KPIs:
Customer lifetime value
Repeat purchase frequency


3. ### Seller-Specific Retention

#### Insight:
Some high-revenue sellers have a high proportion of one-time customers.

#### Action:
Develop post-purchase campaigns around these sellers including related-product recommendations and repeat-purchase incentives.

#### KPIs:
Repeat customers per seller
Revenue per customer


4. ### Customer Experience Recovery

#### Insight:
Some high-revenue sellers combine poor delivery performance with poor customer reviews.

#### Action:
Improve delivery reliability and investigate the causes of negative customer feedback.

#### KPIs:
Bad review percentage
On-time delivery percentage


5. ### Targeted Growth

#### Insight:
Some products and sellers demonstrate good customer experience but lower sales volume.

#### Action:
Use targeted promotions, cross-selling and relevant customer campaigns to increase demand.

#### KPIs:
Revenue
Orders
Average order value


## Recommendations

Based on the analysis, the following actions could support commercial growth:

1. ### Build a structured customer retention program
Prioritize repeat-purchase campaigns because the analysis identified a large one-time customer base.

2. ### Use RFM segmentation for personalized marketing
Different customer segments should receive different campaigns based on their purchasing behavior and value.

3. ### Develop seller-level retention campaigns
High-revenue sellers with large numbers of one-time customers can be targeted with seller-specific post-purchase campaigns.

4. ### Address customer experience problems
Sellers with poor delivery performance and negative reviews should be investigated before being targeted for aggressive growth campaigns.

5. ### Promote products based on performance and customer experience
Products and sellers with good reviews and delivery performance but lower sales volume can be considered for targeted promotional campaigns.

6. ### Track marketing performance through measurable KPIs
Campaigns should be evaluated using metrics such as:

 - Repeat purchase rate
 - Retention rate
 - Customer lifetime value
 - Revenue per customer
 - Average order value
 - Review score
 - On-time delivery rate
   
   
## Skills Demonstrated
### Data Analysis
 - MySQL
 - SQL
 - Data Analytics
 - Data cleaning
 - Data transformation
 - Exploratory data analysis
 - Customer segmentation
 - RFM analysis


### Business performance analysis
 - Business & Marketing Analytics
 - Customer retention analysis
 - Customer experience analysis
 - Seller performance analysis
 - Marketing segmentation
 - Campaign strategy
 - KPI development
 - Data-driven recommendations


### Data Visualization
  - Power BI
  - DAX
  - KPI dashboards
  - Interactive visualizations
  - Business storytelling
  - Business Thinking

    

## Dashboard Preview

Power BI dashboard :
<p align="center">
  <img src="./Assets/Executive Overview.png" alt="" width="100%">
</p>

<p align="center">
  <img src="./Assets/Customer & Retention.png" alt="" width="100%">
</p>

<p align="center">
  <img src="./Assets/Seller & Customer Experience .png" alt="" width="100%">
</p>

<p align="center">
  <img src="./Assets/Marketing Strategy.png" alt="" width="100%">
</p>
